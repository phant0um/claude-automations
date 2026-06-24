---
title: Autonomous Learning
type: concept
status: developing
created: 2026-04-20
updated: 2026-04-20
tags: [agents, learning, autonomy, self-improvement]
---

# Autonomous Learning

The capacity of an agent system to acquire new knowledge, skills, or strategies through its own operation — without requiring external labels, human feedback, or retraining cycles.

## Forms in the Wild

| Form | Example | Mechanism |
|------|---------|-----------|
| Protocol self-evolution | [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] (Autogenesis) | Monitor → Modify → Evaluate loop |
| Skill acquisition | [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]] (WebXSkill) | Executable skills built from exploration |
| Memory consolidation | [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] (Dream Cycle) | Episodic → semantic distillation |
| Cross-domain transfer | Memory Transfer Learning (KAIST/NYU) | Insight memories model-agnostic transfer |

## Core Tension

Autonomous learning is powerful but introduces [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]] risk: the system may learn to optimize the measurement signal rather than the intended capability. The more autonomous the loop, the harder to detect this drift.

## Related

- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/concepts/llm-ml-foundations/automated-alignment-researcher]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]]
- [[03-RESOURCES/concepts/pkm-obsidian/personal-curriculum]] — human-side corollary: learner-directed adaptive path via LLM diagnostics
