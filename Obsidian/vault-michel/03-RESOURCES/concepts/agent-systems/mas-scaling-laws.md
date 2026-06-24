---
title: "MAS Scaling Laws"
type: concept
created: 2026-06-09
updated: 2026-06-09
tags: [concept, agent-systems, multi-agent, scaling, research]
status: developing
---

# MAS Scaling Laws

The empirically established relationship between agent count and performance in homogeneous multi-agent systems: performance does NOT scale monotonically — it follows a pattern of diminishing returns governed by a fundamental trade-off between collaborative synergy and coordination overhead.

## A Lei

For any sufficiently-capable homogeneous MAS (all agents share the same LLM), performance as a function of agent count n follows an **inverted-U curve**:

1. Performance initially rises (synergy dominates: diverse perspectives, mutual error correction)
2. Peaks at an optimal agent count n*
3. Declines beyond n* (coordination overhead dominates: information redundancy, conflicting reasoning paths, quadratic token growth)

This was established via the SIMAS framework (Fudan University, 2026) — a minimalist architecture that isolates sequential inter-agent communication as the core variable.

## Os 3 Pré-requisitos

Before the inverted-U even activates, three conditions must hold:

**1. Base model capability threshold**
Small models (7B/8B parameters) show monotonic performance degradation with every additional agent — the synergy phase never begins. Effective MAS requires a sufficiently capable base LLM (empirically: 70B+ range).

**2. Task-architecture fit**
Not all tasks benefit from multi-agent collaboration at all:
- Logical reasoning (algebra, formal logic): steep inverted-U, small optimal n, heavy penalty for excess agents
- Fact retrieval: flatter curve, partial recovery possible via knowledge diversity
- Mixed reasoning: complex non-monotonic patterns, domain-dependent
- Complex math (AIME level): CoT single-agent beats minimalist MAS — reasoning fragmentation is catastrophic

**3. Architectural design, not just agent count**
Minimalist multi-agent (pure sequential chat) cannot reliably beat single-agent CoT. Structured architectures (AutoGen GroupChat, Multi-Agent Debate with synthesis loops) CAN beat CoT. Adding agents without engineering the interaction structure just adds overhead.

## Mecanismo da Degradação

Performance degradation is caused by **coordination overhead**, NOT long-context failure:

- Token-padding experiments hold total context length fixed → inverted-U persists
- The failure is semantic: conflicting reasoning paths fragment coherent thought chains
- Social dynamics amplify the problem: agents sycophantically adopt swarm consensus ("Bystander Effect")
- Information redundancy: agents repeat prior answers with minor variations, adding noise

Token cost scales **quadratically** with n in sequential MAS architectures, compounding the overhead.

## Pseudo-Stability: a Diagnostic Trap

At high agent counts, output variance decreases. This looks like stability but is actually **pseudo-stability** — consistent failure, not robust collaboration. The system converges on wrong answers reliably.

U-shaped recovery is possible in fact-retrieval tasks (majority reiteration suppresses mid-scale noise) but this is a statistical artifact of pre-training bias, not genuine collaborative synthesis.

## Optimal n*

The optimal agent count varies by:
- Task type (reasoning vs. retrieval)
- Model architecture (Qwen2.5-72B peaks at n=2; Llama-3.1-70B peaks at n=4 for same tasks)
- Interaction topology (AutoGen delays decline; SIMAS hits ceiling faster)

Practical guidance: start with 2-4 agents for most tasks; benchmark before scaling further. The marginal cost of adding agents is quadratic; the marginal benefit is sublinear past n*.

## Implicações de Design

| Principle | Implication |
|-----------|-------------|
| Don't add agents by default | Measure first; coordination overhead is quadratic |
| Model selection is part of MAS design | Same agent count, different base model → different scaling curve |
| Reasoning tasks need synthesis mechanisms | Sequential chat fragments chains; need structured aggregation |
| Collective intelligence must be designed | It does NOT emerge automatically from agent plurality |
| Use CoT for complex single-thread reasoning | SIMAS fails catastrophically on AIME; CoT wins |

## Relacionado

- [[03-RESOURCES/sources/scaling-behavior-llm-multi-agent-systems]] — paper de origem (Fudan, 2026)
- [[03-RESOURCES/concepts/agent-systems/multi-agent-systems]] — arquiteturas e padrões gerais
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — orquestração e decomposição de tarefas
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — harness como variável independente do modelo
- [[03-RESOURCES/concepts/agent-systems/agent-observability]] — métricas para detectar coordination overhead
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]] — scaling em outra dimensão (compute per token)
