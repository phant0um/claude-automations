---
title: "Claude Code 101 — Official Anthropic Course"
type: source
source_type: official-course
author: Anthropic
ingested_at: 2026-04-20
tags: [claude-code, anthropic, agentic-loop, mcp, hooks, subagents, workflow, context-window]
triagem_score: 9
---

# Claude Code 101 — Official Anthropic Course

Curso oficial da Anthropic cobrindo fundamentos, instalação, workflow e recursos avançados do Claude Code.

## Estrutura do Documento

1. O que é Claude Code
2. Como o Claude Code funciona (Agentic Loop)
3. Instalação (Terminal, VS Code, JetBrains, Desktop, Web)
4. Primeiro prompt — modos de permissão
5. Workflow Explore → Plan → Code → Commit (EPCC)
6. Gerenciamento de contexto
7. Code review com subagents
8. O arquivo CLAUDE.md
9. Subagents
10. MCP (Model Context Protocol)
11. Hooks

---

## O que é Claude Code

**Definição:** Ferramenta de coding agêntica que lê codebase, edita arquivos, roda comandos e se integra com ferramentas externas.

**Diferencial vs Claude.ai:** Acesso direto a arquivos, terminal e codebase — age por conta própria, sem copiar/colar.

**Disponível em:** terminal, VS Code, JetBrains, Claude Desktop, web (claude.ai/code).

---

## Como Funciona — The Agentic Loop

1. Você entra um prompt
2. Claude reúne contexto (interação com o modelo → texto ou tool call)
3. Executa ação (editar arquivo, rodar comando)
4. Verifica resultados vs objetivo
5. Se completo → finaliza. Se não → loop até completar.

**Componentes principais:**
- **Context window:** memória de trabalho — conversa, conteúdo de arquivos, outputs de comandos
- **Tools:** permitem executar código, buscar web, ler arquivos — determinam *quando* agir
- **Permissions:** Default (pede permissão), Auto-accept (edições automáticas, comandos pedem), Plan Mode (só leitura)

---

## Instalação

| Plataforma | Método | Observação |
|-----------|--------|-----------|
| macOS/Linux/WSL | `curl` | Auto-updates |
| macOS (alternativo) | `brew install` | Sem auto-update |
| Windows PowerShell | `Invoke-RestMethod` | — |
| Windows CMD | `curl` | — |
| Windows | `winget` | Sem auto-update |
| VS Code | Extension "Claude Code" (Anthropic) | Command palette: Ctrl/Cmd+Shift+P |
| JetBrains | Plugin do Marketplace | Pane lateral com terminal experience |
| Desktop | Toggle "Code" no Claude Desktop | Cloud environment support |
| Web | claude.ai/code | Limitado a GitHub repos |

**Recomendação:** Terminal para cutting edge (features chegam primeiro). IDEs para experiência integrada. Desktop para rodar em background. Web para projetos remotos via GitHub.

---

## Primeiro Prompt

**Shift + Tab** cicla entre modos:
- **Approval mode:** pede permissão em cada edição/comando
- **Auto-accept mode:** edições automáticas, comandos pedem permissão
- **Plan Mode:** ferramentas somente-leitura; análise + plano antes de qualquer código

### Plan Mode

Analisa codebase, faz buscas web, retorna plano detalhado. Ideal para:
- Implementações multi-step complexas
- Code review seguro
- Qualquer mudança ampla antes de escrever código

---

## Workflow EPCC — Explore → Plan → Code → Commit

O workflow central recomendado pelo curso oficial.

### Explore
Plan Mode + prompt de contexto. Claude lê arquivos relevantes sem editar nada.

### Plan
Claude retorna plano de ação. Momento certo para course-correct — antes de qualquer código.

> Dica: subagent de exploração disponível fora do Plan Mode para summaries sem intenção de mudança.

### Code
Aceitar plano → Claude executa. Tips:
- Definir **success criteria** explícito
- Adicionar ferramentas (ex: Claude in Chrome para UI testing)
- Incluir **test suite** como fonte de verdade contínua

### Commit
1. Rodar subagent **code reviewer** (contexto fresh, sem bias da sessão)
2. Gerar commit message via Claude
3. Repetir ciclo

---

## Gerenciamento de Contexto

**Context window = memória de trabalho.** Cada prompt, leitura de arquivo, tool call, resultado — tudo consome espaço.

### Compaction automática
Quando o limite se aproxima, o Claude Code compacta automaticamente — sumariza detalhes importantes, remove tool call results desnecessários. Pode perder detalhes.

### Comandos manuais

| Comando | Uso |
|---------|-----|
| `/compact` | Compacta sessão atual mantendo memória |
| `/clear` | Apaga tudo, começa do zero |
| `/context` | Mostra tamanho atual, categorias e gráfico |

### Regra prática
- `/compact` → continuando feature atual que atingiu limite
- `/clear` → iniciando feature nova (evitar bias do contexto anterior)

### Tips para economizar contexto
1. **Seja específico:** prompt vago = Claude explora mais = mais context consumido
2. **Gerencie MCP servers:** cada server carrega tool definitions no contexto — desative os não usados
3. **Use subagents:** contexto próprio isolado; retornam apenas summary ao agente principal

---

## Code Review

### Subagent reviewer
- Contexto fresh = zero bias da sessão de codificação
- Restringir a **read-only tools** (revisar, não editar)
- Commitar configuração do reviewer no repo

### Skill `/commit-push-pr`
Faz commit + push + PR creation em um passo. Se Slack MCP configurado com canais no CLAUDE.md → posta link do PR automaticamente.

### Session linking `--from-pr`
```
claude --from-pr <PR_NUMBER>
```
Retoma trabalho de um PR exatamente onde parou.

---

## O Arquivo CLAUDE.md

**Problema resolvido:** sem CLAUDE.md, Claude começa do zero em cada sessão — re-explora, faz suposições.

**Solução:** arquivo `.md` na raiz do projeto lido automaticamente a cada sessão. Conteúdo é appendado ao prompt.

### Exemplo de CLAUDE.md
```markdown
# Project
Next.js 15, App Router, Tailwind, Drizzle ORM

# Commands
- Dev: `pnpm dev`
- Tests: `pnpm test`
- Lint: `pnpm lint`

# Code Style
- 2-space indentation
- Named exports
- API routes em app/api/
- Server actions > API routes
```

### Hierarquia
| Nível | Localização | Escopo |
|-------|------------|--------|
| Projeto | Raiz do projeto | Compartilhado com time |
| Usuário | Pasta de configuração | Apenas você; todos os projetos |

### Tips
- **Salvar correções em memória:** se corrigi Claude mais de uma vez, pedir para salvar a regra no CLAUDE.md
- **Referenciar docs:** `@README.md` dentro do CLAUDE.md
- **Começar sem CLAUDE.md:** identificar onde você sempre course-corrige → manter compacto e de alto sinal
- **`/init`:** gera CLAUDE.md automaticamente quando pronto

---

## Subagents

**Propósito:** delegar tarefas com contexto isolado → retornam apenas o resultado (summary).

**Benefício:** contexto do agente principal fica limpo; heavy lifting vai para subagent.

### Criando subagents
```
/agents
```
→ "Create new agent" → escolher escopo, propósito, ferramentas, cor.

Claude gera nome, descrição e prompt. A descrição define **quando** o subagent é chamado automaticamente.

### Customizações
- **Persistent memory:** subagent retém memória entre conversas (bom para uso consistente no mesmo projeto)
- **Preload skills:** carregar skills específicas no contexto do subagent

### Subagents são definidos em Markdown + YAML frontmatter
Escopo: projeto (`.claude/agents/`) ou usuário.

---

## MCP — Model Context Protocol

**Definição:** padrão aberto que conecta Claude Code a ferramentas e fontes de dados externas.

**Problema resolvido:** contexto vive fora do codebase — bases de dados, apps de produtividade, repositórios públicos.

### Tipos de MCP servers
| Tipo | Descrição |
|------|-----------|
| HTTP | Serviços remotos; hospedados pelo provider; conectam via rede |
| Stdio | Processos locais na máquina |

### Comandos
- `claude mcp add` — adiciona servidor
- `/mcp` (dentro de sessão) — ver conectados, checar status, desabilitar

### Escopos
1. **Local** — apenas projeto atual, apenas você
2. **User** — todos os seus projetos
3. **Project** — `.mcp.json` commitado no repo; time todo recebe automaticamente

### Context costs
- Tool definitions de MCP servers ficam no contexto mesmo sem uso
- Se MCP tools > 10% do context window → Claude Code muda para **tool search mode** (busca tools on-demand; menos confiável)
- Alternativa mais eficiente: CLI equivalente (ex: `gh` para GitHub) ou **Skills**

---

## Hooks

**Definição:** comandos que rodam em pontos específicos do lifecycle do Claude Code.

**Diferencial:** **determinísticos** — sempre rodam, sem exceção. CLAUDE.md instrui; hooks garantem.

### Eventos disponíveis
| Evento | Trigger |
|--------|---------|
| `PreToolUse` | Antes de tool call |
| `PostToolUse` | Após tool call completar |
| `UserPromptSubmit` | Ao submeter prompt, antes de processar |
| `Stop` | Quando Claude finaliza resposta |
| `Notification` | Quando Claude envia notificação |

### Configuração
Via `/hooks` dentro do Claude Code, ou editando `settings.json` diretamente.

### Exit codes (PreToolUse)
| Código | Comportamento |
|--------|--------------|
| 0 | Prosseguir normalmente |
| 2 | **Bloquear ação** — stderr enviado ao Claude para auto-correção |
| Outros | Erro não-bloqueante — mostrado ao usuário, não para execução |

### Casos de uso
- **Auto-formatting:** PostToolUse + matcher `"Edit|MultiEdit|Write"` → Prettier/gofmt/etc.
- **Compliance logging:** registrar todos os comandos executados
- **Bloqueio de operações perigosas:** PreToolUse → bloquear `rm -rf`, commits em main, modificações em produção
- **Notificações:** quando Claude finaliza task longa

### Compartilhamento com time
Hooks em `.claude/settings.json` (nível projeto) → commitados no repo → time todo recebe automaticamente. Usar `$CLAUDE_PROJECT_DIR` para referenciar scripts no projeto.

---

## Conceitos Relacionados

- [[03-RESOURCES/concepts/agent-systems/agentic-agents]] — o que é um AI agent; agentic loop
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] — gerenciamento de contexto; compaction; /compact; /clear
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — workflow EPCC completo
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — MCP em profundidade; tipos, escopos, context costs
- [[03-RESOURCES/entities/Claude Code]] — entidade principal; versões; uso neste vault
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — hooks em profundidade; exit codes; casos de uso
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — MCP como padrão aberto
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — contexto focado como substituto de iteração
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — padrões de coordenação entre agentes
