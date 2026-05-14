---
title: "The Agent Development Kit — CLAUDE.md + Skills + Hooks + Subagents + Plugins"
type: source
source_type: clipping
hash: c98f112ed9088ae8de39feded05eafef
ingested: 2026-05-14
tags: [claude-code, agent-architecture, five-layers, CLAUDE.md, hooks, skills, subagents, plugins, adk]
---

# The Agent Development Kit

**5-layer architecture** for building production-grade agents with Claude Code. Each layer solves a class of problem that LLMs alone cannot solve.

## Layer 1 — CLAUDE.md (Memory Layer)

- **Root CLAUDE.md:** Architecture rules, naming conventions, test expectations, repository map.
- **Global vs Project:**
  - `~/.claude/CLAUDE.md` (Global) — always loaded, always active. The agent's "constitution".
  - `.claude/CLAUDE.md` (Project) — context specific to the current project.

## Layer 2 — Skills (Knowledge Layer)

- **Modular:** Context chunks loaded on demand, not always active.
- **Auto-invoked:** Claude matches skill descriptions to task type automatically.
- **Content:** Reference documents, specific scripts, templates.
- **Isolation tip:** Context fork executes the skill in an isolated subagent.

## Layer 3 — Hooks (Guardrails Layer)

- **Deterministic:** Not AI-based. Logical, like Git hooks.
- **Event flow:** Event fires → Matcher checks → Command runs.
- **Event types:**
  - `PreToolUse` — verification before tool use (e.g. auto-lint before Write)
  - `PostToolUse` — action after tool use
  - `SessionStart` — initial setup
  - `Stop` — teardown actions
  - `SubagentStop` — delegation control
- **Canonical examples:** Block `rm -rf`; send Slack notification on Stop.

## Layer 4 — Subagents (Delegation Layer)

- **Delegate-only pattern:** Keeps main context clean and focused.
- **Flow:** Send task (delegate) → receive only results.
- **Specialist roles:** `code-reviewer`, `test-runner`, `explorer`.
- **No recursion:** Subagents cannot spawn other subagents — prevents infinite loops.

## Layer 5 — Plugins (Distribution Layer)

- **npm-like packages** for agent capabilities.
- One install → entire team inherits the behavior.
- Bundles Skills + Agents + Hooks + Commands.

---

## See Also

- [[03-RESOURCES/concepts/claude-code-five-layer-architecture]] — concept page synthesizing all five-layer sources
- [[03-RESOURCES/sources/clipping-claude-code-five-layer-kit-brij-pandey]] — earlier five-layer framing by @LearnWithBrij
- [[03-RESOURCES/concepts/claude-hooks]] — Hook system in depth
- [[03-RESOURCES/concepts/claude-skills]] — Skills system in depth
- [[03-RESOURCES/concepts/subagent-spawning]] — Subagent mechanics
