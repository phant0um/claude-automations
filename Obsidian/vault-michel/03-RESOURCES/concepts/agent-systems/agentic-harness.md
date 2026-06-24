---
title: "Agentic Harness"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Agentic Harness

The runtime scaffolding that surrounds an LLM agent — the body and rulebook around the brain.

## O que é / What it is

A harness is everything except the model weights: the CLAUDE.md instructions, hooks, permission system, tool routing, memory backends, and session lifecycle. The model reasons; the harness acts, constrains, and persists.

**Model vs. harness:**
| Model | Harness |
|-------|---------|
| Reasoning, generation | Execution, persistence |
| Weights (static) | Config (live) |
| Chooses what to do | Controls what is allowed |
| Upgraded by Anthropic | Owned by the engineer |

## Como funciona

**Core harness components:**
- **CLAUDE.md** — always-on system prompt embedded in every turn
- **Hooks** — pre/post-tool triggers (e.g., `PostToolUse` → auto-format, audit log)
- **Permissions** — allowlist/blocklist for tool calls; what the agent can touch
- **Tool routing** — which MCP servers are mounted, what commands are exposed
- **Memory layer** — MEMORY.md, hot.md, `.claude/todo.md` for persistence across sessions
- **Skills** — pluggable `.md` files that inject reusable behavior

**Claude Code as canonical harness example:** CLAUDE.md = firmware, skills = plugins, hooks = middleware, permissions = ACL. The model (Sonnet/Opus) is swappable; the harness encodes the system's identity and rules.

## Thin harness philosophy

Fewer moving parts = more predictable behavior. Each added layer (hook, permission rule, skill) has a maintenance cost. The best harnesses encode invariants clearly and leave the rest to model judgment. Over-engineering the harness produces rigidity; under-engineering produces drift.

> Rule of thumb: if you're writing logic the model could reason itself, move it to a prompt. If you're encoding a hard constraint (security, cost, data integrity), make it a harness rule.

## Evidências
- **[2026-06-19]** Harness é só 4 coisas (modelo, ferramentas, permissões, contexto) vivendo em `.claude/`; 14 passos em 3 andares (harness → loop → sistema auto-melhorável) levam de um agente isolado a um sistema que compõe — [[03-RESOURCES/sources/ai-agents-harness/agent-harness-engineering-14-step-roadmap]]
- **[2026-06-19]** 7 skills cobrindo failure modes distintos (design, identidade, memória de repo, memória de operador, acesso externo, diagramas, meta-skill) compõem um harness Hermes "sério" — [[03-RESOURCES/sources/ai-agents-harness/7-skills-serious-hermes-agent]]

## Related
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- **[2026-06-24]** Default harness = agent loop + built-in tools (bash, read_file, write_file, glob, grep, web_fetch, web_search, todo,... — [[the-harness-eve-default]]
