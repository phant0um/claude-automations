---
title: "Multi-Agent"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, multi-agent]
status: developing
---

# Multi-Agent

Redirect: multiple LLM agents collaborating to accomplish tasks beyond any single agent's reach.

→ Deep patterns at [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]].

## Por que multi-agent?

Three core motivations for adding agents:

1. **Context ceiling** — a single agent's context window is finite. Distribute the load across specialized agents with smaller, focused contexts.
2. **Specialization** — different agents optimized (via system prompt, tools, or model size) for their domain: one searches, one writes, one reviews.
3. **Parallelism** — independent subtasks run simultaneously, compressing wall-clock time dramatically.

## When NOT to go multi-agent

- Task fits in one context window → single agent is simpler and cheaper.
- Subtasks are tightly coupled (each depends on the last) → sequential single-agent may outperform coordination overhead.
- Latency is critical → orchestration round-trips add delay.

## Related
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/ai-agents]]
- [[03-RESOURCES/concepts/parallel-reasoning]]
