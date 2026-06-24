---
title: "The Agent Development Kit — CLAUDE.md + Skills + Hooks + Subagents + Plugins"
type: source
source_type: clipping
hash: c98f112ed9088ae8de39feded05eafef
ingested: 2026-05-14
tags: [claude-code, agent-architecture, five-layers, CLAUDE.md, hooks, skills, subagents, plugins, adk]
triagem_score: 9
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

## Why five layers, not one

A single large CLAUDE.md file that tries to cover everything — memory, knowledge, guardrails, delegation rules, and distribution — fails at scale. Rules become diluted, the file grows past 2000 tokens (becoming a per-turn cost rather than a benefit), and there's no way to load context selectively. The five-layer separation solves this by making each concern orthogonal: CLAUDE.md covers what's always active, skills cover what's loaded on demand, hooks cover what must be enforced deterministically, subagents handle isolation, and plugins handle distribution.

## Layer interaction patterns

The layers compose in specific ways that aren't obvious from the individual descriptions:

**Skills + Subagents:** A skill can be executed in an isolated subagent context (context fork). This means an expensive research skill — one that reads dozens of files and runs multiple queries — doesn't pollute the main agent's context. The subagent runs the skill, the main agent receives only the output.

**Hooks + CLAUDE.md:** Hooks enforce what CLAUDE.md requests deterministically. If CLAUDE.md says "never write to `/generated/` directly," a PreToolUse hook that blocks writes to that path is the implementation, not just the reminder. The combination creates policy (CLAUDE.md) + enforcement (hooks).

**Plugins + all layers:** A plugin is a bundle: it ships with its own skills, hooks, and agent definitions. Installing a plugin installs a complete capability — one `npm install`-style operation propagates to the entire team.

## Hook configuration example

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [{ "type": "command", "command": "npx eslint --stdin-filename $FILE" }]
      }
    ],
    "Stop": [
      {
        "hooks": [{ "type": "command", "command": "curl -s $SLACK_WEBHOOK -d '{\"text\":\"Session complete\"}'"}]
      }
    ]
  }
}
```

This pattern — lint before write, notify on stop — is reproducible without touching any prompt.

## Subagent anti-patterns

The "no recursion" constraint (subagents cannot spawn other subagents) exists to prevent unbounded delegation chains that exhaust context budgets silently. In practice, subagent depth > 2 is almost always a sign of wrong task decomposition, not a genuine need. The delegation pattern should be: main agent decomposes task → delegates discrete unit → receives result. If the delegated unit itself requires delegation, the main agent should handle that decomposition, not the subagent.

## Relationship to 12-Factor Agents

The five-layer ADK maps onto the 12-Factor framework: CLAUDE.md implements F2 (own your prompts) and F3 (own your context window); hooks implement F8 (own your control flow); the stateless subagent pattern implements F12 (stateless reducer); plugins implement F11 (trigger from anywhere). The ADK is the implementation, the 12-Factor principles are the rationale.

## See Also

- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-five-layer-architecture]] — concept page synthesizing all five-layer sources
- [[03-RESOURCES/sources/claude-code-skills/clipping-claude-code-five-layer-kit-brij-pandey]] — earlier five-layer framing by @LearnWithBrij
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — Hook system in depth
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — Skills system in depth
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]] — Subagent mechanics
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — concept page consolidado (inclui 12 componentes + taxonomia acadêmica)

## Complementar Acadêmico

- **Compiling Agentic Workflows into LLM Weights** (i14/Univ. Melbourne, 2026) — alternativa ao orchestration framework: distilação do workflow nos pesos de um modelo fino. Near-frontier quality a 100× menos custo. Resolve os 3 problemas do orchestration (context window, frontier model obrigatório, exposição de procedimentos proprietários).
  - Fonte: `Clippings/Compiling Agentic Workflows into LLM Weights Near-Frontier Quality at Two Orders of Magnitude Less Cost.md` (pendente ingest)
