---
title: Claude Code — Arquitetura de Agent Harness
type: concept
status: developing
updated: 2026-04-16
tags: [claude-code, ai-agents, arquitetura, harness, infraestrutura, typescript]
---

# Claude Code — Arquitetura de Agent Harness

Blueprint de engenharia extraído do código-fonte do Claude Code (55 diretórios, 331 módulos TypeScript). Cada padrão documentado aqui é uma decisão de produção validada — não teoria de conferência.

## As Quatro Camadas

```
1. Model Weights    — inteligência congelada (API call)
2. Context          — input em runtime
3. Harness          — ambiente projetado do agente
4. Infrastructure   — multi-tenancy, RBAC, isolamento, persistência, coordenação
```

> [!key-insight] A indústria ignora a camada 4
> A camada 4 é onde produtos morrem. Times que param na camada 3 constroem demos. Retrofitting de infraestrutura é uma ordem de magnitude mais difícil que projetar para ela.

## Padrão 1: Async Generator para o Loop do Agente

**Não use:** `while(true) { result = await callModel(); }`

**Use:** `async function* agentLoop(): AsyncGenerator<StreamEvent>`

Propriedades que o generator entrega nativamente:

| Propriedade | Como o generator entrega |
|---|---|
| Streaming | Yields tokens à medida que chegam |
| Cancelamento | Caller para de chamar .next(); cleanup no finally |
| Composabilidade | REPL, sub-agentes e testes consomem o mesmo query() |
| Backpressure | Pausa produção quando consumer para de puxar |
| Error recovery | Dentro do loop por fase, não em try-catch externo |

### Cinco Fases por Iteração

```
Phase 1: Setup          → budgets, compaction checks, token validation
Phase 2: Model Call     → streaming + StreamingToolExecutor mid-stream
Phase 3: Error/Compact  → first-class states (not edge cases)
Phase 4: Tool Execution → remaining tools + Haiku summaries async
Phase 5: Continue?      → stop_reason + maxTurns + hooks + abort
```

### Testabilidade: Dependency Injection

```typescript
interface QueryDeps {
  callModel: (messages) => AsyncGenerator<StreamEvent>
}
// Injeta mock → testa sem API real
```

## Padrão 2: Classificação de Concorrência por Tool

Classifique cada tool na definição, não na hora da execução:

```
read-only  → Glob, Grep, Read, WebFetch → concorrente (até 10 em paralelo)
mutating   → Edit, Write, Bash(mutação) → serial
```

**StreamingToolExecutor**: inicia execução antes do modelo terminar. Ferramenta 1 começa enquanto modelo ainda gera ferramentas 2 e 3. Latência escondida: 2-5 segundos por turn com múltiplas tools.

**Tool Result Budgeting**: resultados acima do limite vão para disco. Model recebe path + preview. Roda `applyToolResultBudget()` antes de cada API call. Crítico para sobreviver a `cat` em arquivos grandes.

## Padrão 3: System Prompt Como Problema de Cache

```
[ESTÁTICO — ~80% do prompt — cache global]
...instruções e contexto estável...
SYSTEM_PROMPT_DYNAMIC_BOUNDARY
[DINÂMICO — memoized ou volatile por turn]
```

Contexto variável (git status, data, CLAUDE.md) → **primeira mensagem do usuário** em `<system-reminder>`. Nunca no system prompt. Cada mudança no system prompt invalida o cache para tudo depois dela.

**Impacto:** $0.02/sessão vs $0.20/sessão em escala.

## Padrão 4: Hierarquia de Instrução (RBAC para Agentes)

```
Enterprise  /etc/claude-code/CLAUDE.md   → políticas da org (MDM)
Project     .claude/CLAUDE.md            → convenções do projeto
User        ~/.claude/CLAUDE.md          → preferências pessoais
Local       CLAUDE.local.md             → privado (fora do VCS)
```

Superior sobrescreve inferior. `@include` para composição. Este é um sistema de multi-tenancy para comportamento de agente, não uma feature de customização.

## Padrão 5: Compaction Hierárquica (Mais Barata Primeiro)

```
1. Microcompact  → cada turn; zero model calls; deduplicação de tool results
2. Snip Compact  → remove início; preserva "protected tail"; zero model calls
3. Auto Compact  → threshold cruzado; uma model call de summarização
4. Context Collapse → sessões longas; multi-fase; feature-flagged
```

**Regra:** nunca pule direto para summarização. Microcompact + snip resolvem a maioria dos casos sem custo.

**Protected tail:** mensagens recentes nunca compactadas. Agente mantém fidelidade total nos últimos N exchanges mesmo com contexto anterior comprimido.

## Padrão 6: Error Recovery Como Estado de Primeira Classe

Cada classe de erro tem recovery específica **dentro** do loop, não em try-catch externo:

```
429 Rate Limited     → Retry-After check → 30-min cooldown ou retry
529 Overloaded       → 3 consecutivos → switch de modelo
400 Context Overflow → parse tokens → recalcula budget → retry
401/403 Auth         → clear cache → force-refresh OAuth → retry
Network errors       → disable socket pooling → new connection
```

Backoff: `min(500ms × 2^attempt, 32s) + jitter`

Streaming layer: idle watchdog (90s), stall detection (30s gap), fallback para non-streaming quando streaming falha.

## Padrão 7: Sub-Agentes com Isolamento

**Git Worktree Isolation**: cada sub-agente → próprio branch (`worktree-<slug>`). Symlinks para `node_modules` — 5 agentes paralelos não precisam de 5 cópias das dependências.

**Coordenação distribuída**: disk-backed task list + file-based locking em `~/.claude/tasks/`. Backoff exponencial (30 retries, 5-100ms). High water mark evita reuso de task ID.

**Spawn backends**:
1. In-process (mais rápido, shared memory)
2. Tmux pane (visibilidade, isolamento de terminal)
3. Remote/CCR (isolamento total de máquina)

**Abort em cascata**: parent abort propaga para todos os filhos. Filhos não podem mutar estado do parent (no-op setter). File state cache clonado por sub-agente.

## Padrão 8: Extensão Sem Modificação de Código

| Mecanismo | Como funciona | Casos de uso |
|---|---|---|
| Skills | Markdown + YAML frontmatter; path-based discovery | Comandos reutilizáveis; ativam por tipo de arquivo |
| Hooks | Scripts externos; PreToolUse/PostToolUse/etc. | Guardrails, Slack, CI triggers |
| MCP | Protocolo padronizado; 5 transports | Databases, APIs internas, ferramentas externas |
| Plugins | Diretórios de skills+agents+hooks | Composição de capabilities |

Se usuários precisam forkar o código para customizar, a arquitetura tem uma lacuna.

## A UI Como Mecanismo de Confiança

Visibilidade → confiança → autonomia → trabalho útil.

UI mostra: model name, custo em USD, % de uso do context window, % de rate limit, streaming character-by-character, diffs com syntax highlighting, status tree de multi-agentes. Usuário que vê o que o agente faz dá mais autonomia. Mais autonomia = mais trabalho útil.

## Evidências
- **[2026-06-19]** Padrão "writer-vs-checker": o subagente mais valioso de qualquer harness é o que checa o trabalho do agente principal, porque um modelo revisando o próprio output é fácil demais consigo mesmo — [[03-RESOURCES/sources/ai-agents-harness/agent-harness-engineering-14-step-roadmap]]

## Ver também

- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — general harness theory (thin harness principle, AEvo ablation, 12 components)
- [[03-RESOURCES/sources/ai-agents-harness/claude-code-agent-harness-architecture]] — fonte completa com todos os detalhes
- [[03-RESOURCES/sources/ai-agents-harness/agent-development-kit-five-layers]] — ADK framing; camadas Skills/Hooks/Subagents/Plugins como kit de extensão sem modificação de código
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — Skills como mecanismo de extensão
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — aprofundamento do Padrão 3 (KV cache, 92% hit rate, 3 regras)
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — aprofundamento do Padrão 7 (sub-agentes)
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — princípio unificador dos Padrões 3, 5 e 7
- [[03-RESOURCES/concepts/agent-systems/resolver-pattern]] — camada de governança para systems com 40+ skills
- [[03-RESOURCES/entities/Claude Code]] — plataforma analisada
- [[03-RESOURCES/entities/SEI-Automation-Agent]] — aplicação: sub-agentes paralelos em produção
