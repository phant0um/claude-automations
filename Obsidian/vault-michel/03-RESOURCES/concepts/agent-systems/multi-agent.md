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

## Evidências
- **[2026-06-24]** According to Gartner, the average Global Fortune 500 enterprise will have over 150,000 AI agents in  — [[aws-genaiic-partner-agent-factory-new-ai-agents-now-in-aws-marketplace]]
- **[2026-06-24]** Heng Ping 1,*, Arijit Bhattacharjee 2, Peiyu Zhang 1, Shixuan Li 1, Wei Yang 1,. — [[rem-moa-reasoning-memory-sustains-mixture-of-agents-scaling]]
- **[2026-06-24]** Bingnan Xiao, Chenhao Yang, Wei Ni,, Xin Wang,, and Tony Q. — [[agentic-ai-for-bilevel-long-term-optimization-of-policy-driven-physical-layer-systems]]
- **[2026-06-24]** In late 2023, a mid-sized systematic fund in Chicago - managing roughly $2. — [[how-quants-use-llm-agents-to-mine-alpha-from-unstructured-data-the-complete-rag-framework]]
