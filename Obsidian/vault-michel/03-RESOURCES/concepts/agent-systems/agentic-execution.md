---
title: "Agentic Execution"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, execution]
status: developing
---

# Agentic Execution

An LLM taking multi-step autonomous actions in a real environment — reading, planning, acting, and iterating until a goal is complete.

## O que é / What it is

Agentic execution is what happens when an LLM is given tools and a goal, then **loops autonomously** through perception → reasoning → action → observation until done or blocked. The key distinction from chat: the model is the driver, not the passenger.

## Como funciona

**Read-Plan-Act loop:**
1. **Observe** — read environment state (files, APIs, tool outputs)
2. **Plan** — reason about the next action (may use CoT or structured plan)
3. **Act** — call a tool, write a file, run a command
4. **Observe result** — parse output, update internal state
5. **Repeat** until goal satisfied or abort condition met

**Checkpointing:** Long runs save intermediate state so execution can resume after failure without starting over.

## Padrões / Patterns

- **Reversible vs irreversible actions:** Prefer reversible (read, draft) before irreversible (delete, send, push). Gate irreversible ops with [[03-RESOURCES/concepts/human-in-the-loop]] checkpoints.
- **Action budget:** Cap tool calls per run to contain runaway loops.
- **Abort on ambiguity:** If the next action is unclear, surface to user rather than guess.
- **State serialization:** Write partial results to disk so context window pressure doesn't erase progress.

## Por que importa

Every Claude Code session is agentic execution. Understanding the loop helps diagnose where agents get stuck (bad observation parsing, replanning failures, irreversible action regret) and design better scaffolds.

## Related
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/ai-agents]]
- [[03-RESOURCES/concepts/multi-step-planning]]
- [[03-RESOURCES/concepts/sequential-deliberation]]
- [[03-RESOURCES/concepts/human-in-the-loop]]
- [[03-RESOURCES/concepts/long-horizon-agents]]
- [[03-RESOURCES/concepts/agent-security]]
