---
title: "AI Agents"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, foundations]
status: developing
---

# AI Agents

An AI system that perceives its environment, maintains memory, pursues goals, and takes actions — not just generates text.

## O que é / What it is

An **AI agent** = LLM + perception + memory + action loop + goal. The LLM is the reasoning engine; the surrounding scaffold provides tools, state, and a feedback channel from the environment.

Distinction from a chatbot: a chatbot responds. An agent **acts, observes, and continues** until a goal condition is met or it gives up.

## Como funciona

**Agent loop:**
```
while goal_not_met:
    observation = perceive(environment)
    plan        = reason(observation, memory, goal)
    action      = select_tool(plan)
    result      = execute(action)
    memory.update(result)
```

**Environment types:**
- **Fully observable** — agent sees all relevant state (rare)
- **Partially observable** — agent must infer hidden state
- **Stochastic** — tool results non-deterministic
- **Multi-agent** — other agents in the same environment

## Padrões / Patterns

- **Reactive agents:** No explicit plan; act based on current observation. Fast but brittle for complex tasks.
- **Deliberative agents:** Maintain a world model, plan ahead. Slower but handles multi-step goals. See [[03-RESOURCES/concepts/world-model]].
- **Tool-equipped LLMs:** The 2023–2026 dominant pattern. LLM as reasoner; tools as actuators. Chain-of-thought enables deliberation inside the LLM itself.

**2024–2026 capability explosion:** SWE-bench scores went from ~3% (2023) to ~60%+ (2026). Time-horizon metrics (METR) show task length doubling every ~4 months.

## Por que importa

Every agent in Michel's vault — Nexus, guard, hill, subagent batch ingesters — is an AI agent. Understanding the agent loop clarifies where to put guardrails and where to allow autonomy.

## Related
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/agentic-execution]]
- [[03-RESOURCES/concepts/agent-orchestration]]
- [[03-RESOURCES/concepts/world-model]]
- [[03-RESOURCES/concepts/agentic-memory-taxonomy]]
- [[03-RESOURCES/concepts/long-horizon-agents]]
