---
title: How I Built a Harness for My Agent Using Claude Code Leaks
type: source
source_file: .raw/articles/claude-code-agent-harness-architecture-2026-04-16.md
author: Rohit (@rohit4verse)
date_ingested: 2026-04-16
tags: [claude-code, ai-agents, agent-harness, arquitetura, typescript, infraestrutura]
---

# How I Built a Harness for My Agent Using Claude Code Leaks

Análise arquitetural de Rohit (@rohit4verse) do código-fonte vazado do Claude Code: 55 diretórios, 331 módulos TypeScript. O artigo extrai princípios de engenharia de produção de cada decisão arquitetural e os traduz em blueprint para qualquer harness de agente.

## Insight central: Quatro camadas, não três

A indústria ensina três camadas. Claude Code expõe uma quarta:

| Camada | O que é |
|---|---|
| 1. Model Weights | Inteligência congelada (API) |
| 2. Context | Input em runtime (prompts, histórico) |
| 3. Harness | Ambiente projetado do agente (tools, loops, error handling) |
| **4. Infrastructure** | **Multi-tenancy, RBAC, isolamento, persistência, coordenação distribuída** |

> [!key-insight] A camada 4 é onde produtos morrem
> Times que param na camada 3 constroem demos. Times que projetam a camada 4 constroem produtos. Claude Code é o primeiro sistema de agente visto que leva as quatro a sério.

Evidência empírica: SWE-agent (Princeton NLP) obteve 64% de melhoria relativa no SWE-bench mudando apenas o design da interface. Mesmo GPT-4, mesmas tarefas, só o ambiente mudou.

## O Loop do Agente: Async Generator

Núcleo em `query.ts` (1.729 linhas). Decisão mais importante: `async function*` em vez de `while(true)`.

```typescript
async function* query(...): AsyncGenerator<StreamEvent>
```

**Por que generator supera while loop:**

| Problema no while loop | Solução do generator |
|---|---|
| Sem streaming (tela em branco 10-30s) | Yields StreamEvent token por token |
| Cancelamento externo necessário | Caller para de chamar .next(); finally roda |
| Não composável (REPL ≠ sub-agentes ≠ testes) | Interface universal para dados em streaming |
| Sem backpressure (memória cresce ilimitada) | Pausa produção quando consumer para de puxar |
| Error recovery em try-catch externo | Recovery dentro do loop, por fase |

### Cinco fases por iteração

1. **Setup** — budgets de tool result, compaction, validação de tokens
2. **Model Invocation** — queryModelWithStreaming() via DI; 10 classes de erro; StreamingToolExecutor inicia execução mid-stream
3. **Error Recovery & Compaction** — prompt-too-long → compact+retry; max_output_tokens → escalate 32K→64K; estados de primeira classe
4. **Tool Execution** — tools restantes; resultados yield para UI; Haiku gera summaries async
5. **Continuation Decision** — stop_reason, maxTurns, hooks, abort signals

**Testabilidade:** Loop recebe dependências via `QueryDeps` interface. Injeta mock callModel → testa context overflow e falhas sem API real. Loop é máquina de estado pura com efeitos injetados.

## Execução de Tools: Concorrência Classificada

`toolOrchestration.ts` — partição por comportamento:

- **Read-only** (Glob, Grep, Read, WebFetch): concorrência, até 10 em paralelo → 2-5× speedup
- **State-mutating** (Bash com mutação, Edit, Write): serial → zero race conditions

**StreamingToolExecutor** inicia execução mid-stream. Para 3 tool calls: esconde 2-5 segundos de latência. Resultados retornam em ordem original mesmo se tool 2 termina antes de tool 1.

**Tool Result Budgeting:** Resultados acima de `maxResultSizeChars` persistem em disco; model recebe path + preview. `applyToolResultBudget()` roda antes de cada API call. Sem isso: contexto enche de ruído (cat de arquivo de 1MB).

## System Prompt É um Problema de Cache

`SYSTEM_PROMPT_DYNAMIC_BOUNDARY` divide em duas zonas:
- **Acima**: estático, idêntico para todos os usuários/sessões, ~80% do prompt, hit no prompt cache global
- **Abaixo**: memoized (uma vez por sessão) ou volatile (por turn, minimizado)

Contexto dinâmico (git status, CLAUDE.md, data atual) vai na **primeira mensagem do usuário** em `<system-reminder>`, NÃO no system prompt — assim o cache do system prompt não invalida a cada turn.

> Impacto em escala: $0.02/sessão vs $0.20/sessão.

## Hierarquia CLAUDE.md: RBAC para Comportamento de Agente

```
/etc/claude-code/CLAUDE.md    → Enterprise (MDM, toda a org)
.claude/CLAUDE.md             → Project (convenções do maintainer)
~/.claude/CLAUDE.md           → User (preferências pessoais)
CLAUDE.local.md               → Developer (privado, fora do VCS)
```

Superior sobrescreve inferior. `@include` permite composição de arquivos externos.

## Quatro Estratégias de Compaction (Mais Barata Primeiro)

| Estratégia | Quando dispara | Custo |
|---|---|---|
| Microcompact | Cada turn, antes do API call | Zero (sem model call) |
| Snip Compact | Aproximando limite de tokens | Zero (remove do início, preserva "protected tail") |
| Auto Compact | Threshold cruzado + snip insuficiente | Uma model call separada |
| Context Collapse | Sessões de horas (feature flag) | Máximo (multi-fase: tool results → thinking → seções) |

**Protected tail:** mensagens recentes nunca são compactadas, mesmo durante compaction agressiva.

## Sistema de Permissões: Sete Estágios de Confiança

Pattern matching glob em nome do tool + input. Modos progressivos: `default` → `acceptEdits` → `bypassPermissions`.

Hooks como escape hatch: scripts externos recebem detalhes do tool call e retornam `{"decision": "approve"}` ou `{"decision": "block"}`. Sem modificações no código-fonte.

## Error Recovery: `withRetry.ts` (823 linhas)

Cada linha existe por causa de uma falha em produção:

| Erro | Estratégia |
|---|---|
| 429 Rate Limited | Retry-After <20s → retry; >20s → 30-min cooldown |
| 529 Overloaded | 3 consecutivos + fallback → switch de modelo |
| 400 Context Overflow | Parse de tokens; available = limit - input - 1000; floor 3k output |
| 401/403 Auth | Clear cache; force-refresh OAuth; retry |
| ECONNRESET/EPIPE | Desabilita socket pooling; retry com nova conexão |

Backoff: `min(500ms × 2^attempt, 32s) + jitter`. Streaming layer: idle watchdog (90s), stall detection (30s gap), fallback para non-streaming.

## Sub-Agentes e Isolamento

Cada sub-agente: instância independente do loop, contexto próprio, abort em cascata do pai, file state cache clonado.

**Git Worktree Isolation:** cada agente em seu próprio branch (`worktree-<slug>`). Symlinks para `node_modules` e `.cache` (5 agentes não precisam de 5 cópias das dependências).

**Três backends de spawn:** In-process (mais rápido), Tmux pane (visível), Remote (CCR, isolamento total).

**Coordenação:** disk-backed task list + file-based locking (`~/.claude/tasks/`). Backoff exponencial (30 retries, 5-100ms). High water mark evita reuso de ID.

## Quatro Mecanismos de Extensão (Zero Modificações de Código)

1. **Skills** — Markdown com YAML frontmatter; path-based discovery; 5 fontes
2. **Hooks** — 6 tipos; eventos: PreToolUse, PostToolUse, SessionStart, FileChanged, Stop
3. **MCP** — 5 transports; 3 níveis de config (enterprise/project/user)
4. **Plugins** — diretórios de skills + agents + hooks + config

Princípio: composição sobre modificação.

## Conexões com o vault

> [!key-insight] Conexão com Claude Skills
> A seção de Skills confirma o que [[03-RESOURCES/concepts/claude-skills]] documenta: YAML frontmatter, path-based discovery, cinco fontes. O artigo adiciona o detalhe de que o campo `paths: ["*.tsx"]` ativa a skill só quando o agente toca arquivos correspondentes — relevante para construir skills contextuais.

> [!key-insight] Conexão com SEI Automation Agent
> A arquitetura de sub-agentes com worktree isolation + task coordination é exatamente o padrão para o [[03-RESOURCES/entities/SEI-Automation-Agent]]: múltiplos agentes paralelos no mesmo repositório sem conflitos.

## Links internos

- [[03-RESOURCES/concepts/claude-agent-harness-architecture]] — conceito expandido
- [[03-RESOURCES/concepts/claude-skills]] — extensão por Skills; path-based discovery confirmado
- [[03-RESOURCES/entities/Claude Code]] — plataforma cuja arquitetura é analisada
- [[03-RESOURCES/entities/Rohit-rohit4verse]] — autor
- [[03-RESOURCES/entities/SEI-Automation-Agent]] — aplicação prática do padrão de sub-agentes
