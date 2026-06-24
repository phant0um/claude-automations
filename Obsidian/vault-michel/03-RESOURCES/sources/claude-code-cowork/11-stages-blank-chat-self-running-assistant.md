---
title: "How to Build a Claude Workflow: 11 Stages From Blank Chat to a Self-Running Assistant"
type: source
source: "[@rileywestreel](https://x.com/rileywestreel/status/2065472381737459802) — baseado em \"Building Effective Agents\" (Anthropic, dez/2024)"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

Um assistente útil não é um prompt melhor — é um **pipeline**: cadeia de
upgrades pequenos e "chatos" que transformam uma janela de chat num
processo que roda enquanto você dorme. Princípio: "start simple, compose
small patterns, add machinery only when it pays for itself."

## Argumentos principais

### As 11 etapas

| # | Etapa | O que muda | Quando usar |
|---|---|---|---|
| 1 | Blank chat, baseline | resolver à mão até output certo 3x seguidas | sempre — "se não fica limpo à mão, automação não salva" |
| 2 | Promover prompt → system prompt (API) | regras separadas dos dados; escolher tier de modelo (Haiku/Sonnet/Opus) deliberadamente | instruções se repetem entre requests |
| 3 | Forçar saída estruturada (`tool_choice`) | sem regex/parsing — JSON garantido via schema | outro sistema consome o output |
| 4 | 1 tool + agentic loop | `stop_reason == "tool_use"` → roda função → retorna resultado → repete | task precisa de dado live/side-effect |
| 5 | Compor tools: routing + chaining | Haiku classifica rota (refund/bug/sales); cada step alimenta o próximo | task tem estágios claros — workflow (paths definidos) ≠ agent (auto-dirigido) |
| 6 | Claude Agent SDK (`query()`) | SDK assume loop completo (planning, tools, retries, I/O) | >2-3 tool calls, ou reimplementando loop/retry à mão |
| 7 | Custom tools + hooks (guardrails) | `@tool` async function + `PreToolUse` hook que pode `deny` antes da execução | agente pode gastar dinheiro/deletar dados |
| 8 | Subagentes (orchestrator-workers) | `.claude/agents/*.md`, contexto isolado, retorna só summary | task se divide em subtasks independentes |
| 9 | MCP | 1 protocolo, qualquer servidor compatível (GitHub/Slack/Postgres) | agente precisa tocar sistema que já fala MCP |
| 10 | Memória + context management | arquivo lido no início/escrito no fim; memory tool + context editing (Anthropic: +39% em evals, -84% tokens em teste de 100 turns) | recall entre sessões, ou runs longos batem no limite de contexto |
| 11 | Headless + cron (`claude -p`) | roda sozinho, agendado, logs | task deve rodar no relógio/evento, não quando você lembrar |

### 6 erros comuns

1. Mega-prompt único → context rot. Fix: route → chain
2. Parsear texto livre com regex → quebra a cada resposta. Fix:
   `tool_choice` forçado
3. Dar todas as tools de uma vez → mais turns errados, blast radius maior.
   Fix: allowlist restrito
4. Loop sem stop valve → queima budget. Fix: `max_turns` + hooks
5. 1 agente gigante para task grande → context overflow. Fix:
   orchestrator + subagentes, cada um com seu contexto
6. Manter tudo em contexto "por segurança" → atinge limite, perde o fio.
   Fix: memory tool + context editing

## Implicações para o vault

O pipeline-diario v4.3 já implementa as etapas 5 (routing
triagem→ingest→report), 8 (subagentes wiki-ingest), 10 (manifest +
hot.md como memória), 11 (rotina agendada). Etapa 7 (hooks PreToolUse para
bloquear ações destrutivas) é exatamente o gap que
[[03-RESOURCES/sources/claude-code-skills/mattpocock-additional-skills-2026-06]]
(`git-guardrails-claude-code`) resolveria.

Ver também [[03-RESOURCES/sources/claude-code-cowork/teach-skill-matt-pocock]]
— mesmo autor de origem (Matt Pocock) para o gap de hooks PreToolUse citado
aqui.
