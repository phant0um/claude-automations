---
title: "Autogenesis: A Self-Evolving Agent Protocol"
type: source
created: 2026-04-20
updated: 2026-04-20
tags: [agents, self-evolution, protocol, arxiv, autonomous-learning]
status: ingested
arxiv_id: "2604.15034v1"
author: Wentao Zhang
license: CC BY 4.0
---

# Autogenesis: A Self-Evolving Agent Protocol

**Author:** Wentao Zhang
**arXiv:** [2604.15034v1](https://arxiv.org/abs/2604.15034v1)
**DOI:** https://doi.org/10.48550/arXiv.2604.15034
**License:** CC BY 4.0
**Raw file:** `.raw/articles/autogenesis-self-evolving-agent-protocol-2026-04-20.md`

## Overview

Autogenesis introduces a self-evolving agent protocol that enables autonomous agents to improve and adapt their own behavior over time without external supervision. The system removes the requirement for external feedback or retraining cycles — agents monitor themselves, identify weaknesses, modify their own protocols, and retain successful changes.

## Key Concepts

### Self-Evolving Agents
- Agents that modify and improve their own protocols and strategies autonomously
- No external feedback or retraining required
- Continuous improvement loops driven by internal performance monitoring

### Protocol Evolution
- Dynamic protocol adaptation at runtime
- Self-modification mechanisms acting on the agent's own operational rules
- Evaluate-and-retain loop: only successful modifications are kept

## Architecture

The system features:
- Autonomous self-improvement mechanisms (monitor → identify → modify → evaluate)
- Adaptive agent protocols that change without human intervention
- Evolution-driven learning as the primary improvement path (distinct from gradient-based fine-tuning)

## Methodology

1. Monitor own performance
2. Identify areas for improvement
3. Automatically modify protocols
4. Evaluate modifications and retain successful ones

## Benchmarks & Evaluation

- **LeetCode** — used for coding task evaluation of evolved agents
- **Anthropic Agent Skills framework** — used to assess agent skill acquisition post-evolution

## Research Impact

Autogenesis represents a shift toward:
- Autonomous agent improvement without human-in-the-loop
- Reduced need for human supervision in long-horizon tasks
- Self-directed optimization of agent behavior
- Emergent behavior in extended autonomous operation

## Related Wiki Pages

- [[03-RESOURCES/concepts/self-evolving-agents]] — core concept introduced by this paper
- [[03-RESOURCES/entities/Wentao-Zhang]] — author
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — protocol evolution applies within multi-agent systems
- [[03-RESOURCES/concepts/agent-memory-architecture]] — self-evolution may involve memory restructuring
- [[03-RESOURCES/concepts/automated-alignment-researcher]] — analogous autonomous self-improvement loops
- [[03-RESOURCES/concepts/web-agent-skill-learning]] — skill acquisition as a form of self-evolution
- [[03-RESOURCES/concepts/reward-hacking]] — risk present in self-evolving systems that optimize metrics autonomously
