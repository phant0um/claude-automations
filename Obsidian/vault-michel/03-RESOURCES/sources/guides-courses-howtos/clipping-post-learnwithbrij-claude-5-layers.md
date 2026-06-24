---
title: "Claude Code 5-Layer Architecture (Brij)"
type: source
source_type: social-media
author: "LearnWithBrij"
created: 2026-05-06
tags: [claude-code, architecture, skills, hooks]
triagem_score: 8
---

Claude Code 5-layer architecture: CLAUDE.md (memory), Skills (knowledge), Hooks (guardrails), Subagents (delegation), Plugins (distribution). No-recursion rule: subagents cannot spawn subagents.

## Source

Ingested from: `clippings/Post by @LearnWithBrij on X.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## The 5 Layers — Detailed Breakdown

### Layer 1: CLAUDE.md (Memory)

CLAUDE.md is the persistent memory layer — the only file Claude Code reads unconditionally at the start of every session. It defines project identity, conventions, workflow rules, and accumulated corrections. Without CLAUDE.md, each session starts blind. With a well-maintained CLAUDE.md, the agent inherits months of learned context in a single read.

Key mechanics:
- Cascades: `~/.claude/CLAUDE.md` (global) → `.claude/CLAUDE.md` (project-level) → sub-directory CLAUDE.md files
- Supports `@file.md` imports — breaking it into composable modules without blowing token budget at the top level
- ~200-line practical ceiling before compliance degrades (more rules = more ignored rules)
- The model treats it as a "soft contract" — ~80% compliance under normal conditions; hooks provide the other 20% via hard enforcement

### Layer 2: Skills (Knowledge)

Skills are `.md` files that encode reusable procedures, domain knowledge, or interaction patterns. They are not executed — they are *read* by the model and interpreted as instructions. The thin-harness philosophy: everything the model needs to know lives in skills, not hard-wired into orchestration infrastructure.

Key mechanics:
- Stored in `~/.claude/skills/` (global) or `.claude/skills/` (project-scoped)
- Progressive disclosure: skills can reference other skills via `@import` to avoid flooding context on every turn
- `$ARGUMENTS`, `$1`, `$2` allow parameterized skills — reusable with runtime inputs
- Skills loaded conditionally (triggered by keywords or explicit invocation) prevent context bloat

### Layer 3: Hooks (Guardrails)

Hooks are deterministic side-effects wired to Claude Code lifecycle events. They fire unconditionally — no model discretion. This makes hooks the layer for invariants: formatting, linting, audit logging, cost caps.

Hook event types:
- `PreToolUse` — intercept before any tool call
- `PostToolUse` — react after tool execution (most common: code formatting, validation)
- `UserPromptSubmit` — inject context on every user message
- `Stop` — actions on session end (summary generation, log writes)

Critical caveat: multiple plugins using the same hook type create cascade conflicts. A filesystem lock file (mutex pattern) prevents PostToolUse chain reactions that can triple per-edit token cost. See [[03-RESOURCES/sources/token-economy-cost/hook-fights-34-percent-token-waste]].

### Layer 4: Subagents (Delegation)

Subagents are isolated Claude instances spawned by the orchestrator to handle bounded subtasks. Each subagent runs in its own context — it cannot access the parent's conversation history unless explicitly passed. This isolation is both the feature and the constraint.

No-recursion rule: subagents cannot spawn their own subagents. Violation would create unbounded call trees with unpredictable token costs. The rule enforces a strict two-tier hierarchy: orchestrator → workers.

Delegation patterns:
- Task decomposition: orchestrator breaks work into parallel chunks, each chunk goes to one subagent
- Model routing: expensive orchestrator (Opus) delegates mechanical tasks to cheap subagents (Haiku)
- Context budget: subagents run separate context windows, protecting the main session from bloat

### Layer 5: Plugins (Distribution)

Plugins are installable bundles that package skills + hooks + subagent configurations + slash commands into a single distributable unit. They are the deployment and sharing mechanism for everything in layers 2–4.

Plugin structure:
```
my-plugin/
├── plugin.json       # Manifest
├── skills/           # Skill files
├── commands/         # Slash command definitions
└── .mcp.json         # External connector config
```

Anthropic ships 11 reference plugins (open source at `github.com/anthropics/knowledge-work-plugins`): Sales, Marketing, Legal, Finance, Customer Support, Product Management, Data Analysis, Enterprise Search, Biology Research, Productivity, and Plugin Create.

## Why the No-Recursion Rule Matters

The flat hierarchy (orchestrator → one level of subagents) is a deliberate safety and cost constraint. Recursive agent spawning produces exponential context growth and unpredictable tool call depth. Benchmarks in RecursiveMAS (arXiv:2604.25917) show that latent-space transfer between agents — rather than spawning new call trees — achieves +8.3% accuracy with far less overhead. The no-recursion rule trades theoretical power for predictable cost structure.

## Vault Relevance

The vault's own system mirrors this 5-layer design:
- `CLAUDE.md` cascade → project-level and global instructions
- `04-SYSTEM/agents/` → skills and subagent definitions for Nexus
- Hooks in `settings.json` → automated formatting, manifest updates
- Plugins → installed via Claude Cowork for specialized workflows

## Por que a hierarquia de camadas importa para debugging

Quando um agente Claude Code se comporta de forma inesperada, a hierarquia de cinco camadas fornece um framework de diagnóstico sistemático. A pergunta não é "o que está errado?" mas "em qual camada está o problema?":

- **Camada 1 (CLAUDE.md):** o comportamento é global ou específico de sessão? Se global, provavelmente CLAUDE.md tem instrução conflitante ou ausente.
- **Camada 2 (Skills):** a skill correta está sendo ativada? Verificar description e trigger phrases. Se a skill nunca dispara, o problema é no routing; se dispara demais, a description é ampla demais.
- **Camada 3 (Hooks):** o comportamento é determinístico e acontece sempre após um tipo específico de tool call? Provavelmente um hook com bug. Verificar cascata de hooks no mesmo evento.
- **Camada 4 (Subagents):** o problema aparece apenas em tarefas delegadas? Verificar o que é passado ao subagent — contexto insuficiente ou formato de output incorreto.
- **Camada 5 (Plugins):** o problema começou após instalar ou atualizar um plugin? Verificar conflito entre o hook do plugin e hooks existentes.

## A regra de não-recursão como constraint de custo

O no-recursion rule — subagents não podem spawnar subagents — pode parecer uma limitação arbitrária, mas é uma decisão de engenharia com justificativa de custo clara. Sem o constraint, uma tarefa delegada a um subagent que, por sua vez, delega a outros subagents cria árvores de call de profundidade indeterminada. Cada nível da árvore multiplica o custo de tokens pelo número de sub-delegações.

Em prática, a flat hierarchy forçada (orchestrator → workers, sem recursão) tem um efeito colateral positivo: força o orchestrator a decompor o problema em subtasks bem delimitadas antes de delegar, em vez de delegar um problema vago e deixar a decomposição para o subagent. Decomposição explícita no orchestrator é auditável; decomposição implícita em subagents é opaca.

## Plugins como unidade de distribuição organizacional

O modelo de plugin (skills + hooks + commands + MCP config em um bundle instalável) muda a unidade de distribuição de conhecimento de agente de "arquivo individual" para "capability bundle". Um time de legal que cria um plugin de contract review distribui não apenas as instruções, mas o contexto de ferramentas (quais MCPs usar), os guardrails (hooks de compliance), e os entry points (slash commands padronizados).

Isso é o que diferencia uma instalação de Claude Code de uma infraestrutura de equipe: plugins permitem que capacidades construídas por um time sejam consumidas por outros times sem setup manual, e atualizações são propagadas automaticamente quando o plugin é atualizado.

## Related

- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/sources/token-economy-cost/hook-fights-34-percent-token-waste]]
- [[03-RESOURCES/sources/claude-code-cowork/cowork-plugin-guide-coreyganim]]
- [[03-RESOURCES/entities/Claude Code]]
