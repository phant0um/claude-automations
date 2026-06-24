---
title: "Agentic Engineering Levels"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Agentic Engineering Levels

A maturity spectrum from "LLM as function call" to "fully autonomous multi-agent system."

## O que é / What it is

Not all LLM integrations are agents. This taxonomy names the rungs of the ladder so teams can scope what they're actually building and what capabilities each level requires.

## Como funciona

| Level | Name | Capability | Example |
|-------|------|-----------|---------|
| 0 | Pure LLM | Stateless prompt → response | ChatGPT direct query |
| 1 | Tool-augmented | LLM calls 1 external tool | LLM + web search |
| 2 | Stateful agent | Maintains memory across turns | LLM + persistent context |
| 3 | Planning agent | Multi-step plan, self-corrects | ReAct loop with retry |
| 4 | Orchestrator | Manages sub-agents, delegates | Nexus → specialist agents |
| 5 | Autonomous system | Self-modifies goals, spawns agents, operates continuously | Full vault SO |

**What unlocks at each level:**
- L1 → external world access
- L2 → sessions, personalization
- L3 → complex task completion without hand-holding
- L4 → parallelism, specialization, cost routing
- L5 → self-improvement, open-ended operation

## Padrões / Patterns

Most production systems are L2–L3. L4 adds coordination overhead; only justified when parallelism or specialization provides clear gains. L5 requires robust guardrails (guard agent, invariant protection) or it drifts.

**Maturity signals:** You're at L4 when you have explicit orchestrator logic and inter-agent communication protocols. You're at L5 when agents can edit their own prompts or spawn new agents without human approval.

## Related
- [[03-RESOURCES/concepts/agent-systems/multi-agent-systems]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
