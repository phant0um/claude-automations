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

## Evidências
- **[2026-06-24]** According to Gartner, the average Global Fortune 500 enterprise will have over 150,000 AI agents in  — [[aws-genaiic-partner-agent-factory-new-ai-agents-now-in-aws-marketplace]]
- **[2026-06-24]** Introducing Flounder: An Autonomous White-Hat Security Auditor. — [[flounder-an-autonomous-white-hat-security-auditor]]
- **[2026-06-24]** Quanyan Zhu Department of Electrical and Computer Engineering, New York University Tandon School of  — [[ai-tokenomics-the-economics-of-tokens-computation-and-pricing-in-foundation-models]]
- **[2026-06-24]** ## Cybersecurity Skills Router / Reverse-Engineering Skill Routing Pack. — [[authorized-penetration-testing-security-research-skill-router-pack-ai-powered-routing-on-demand-toolchain-bootstrapping-self-evolving-knowledge-base-supports-claude-code-kiro-cursor-cline-and-other-ai-coding-clients-ai]]
- **[2026-06-24]** If you run a clinic or hospital network, you already know the cost of missed appointments. — [[build-a-healthcare-appointment-agent-with-amazon-nova-2-sonic]]
- **[2026-06-24]** Loka transformed customer voice interactions by building a conversational AI agent with Amazon Nova  — [[how-loka-built-a-natural-low-latency-voice-agent-with-amazon-nova-2-sonic]]
