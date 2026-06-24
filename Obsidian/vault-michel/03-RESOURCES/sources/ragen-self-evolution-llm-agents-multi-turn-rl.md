---
title: "RAGEN: Understanding Self-Evolution in LLM Agents via Multi-Turn RL"
type: source
source: Clippings/RAGEN Understanding Self-Evolution in LLM Agents via Multi-Turn Reinforcement Learning.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, agentic-rl, self-evolution, source, score-B]
---

## Tese central

RAGEN introduz StarPO (State-Thinking-Actions-Reward Policy Optimization), framework para trajectory-level agent RL. Identifica Echo Trap — instabilidade recorrente onde agentes overfit a reasoning patterns localmente recompensados (reward variability collapse, entropy drop, gradient spikes). StarPO-S estabiliza com trajectory filtering, critic baselining, decoupled clipping.

## Argumentos principais

- **Echo Trap**: reward variability cliffs + gradient spikes em multi-turn RL. Agentes overfit a padrões localmente recompensados.
- **Rollout diversity matters**: diverse initial states, multiple responses per state, medium interaction granularity, high rollout frequency
- **Reasoning não emerge automaticamente**: sem fine-grained reasoning-aware rewards, agentes regressam a shallow strategies ou hallucinated thoughts
- **StarPO-S**: variability-based trajectory filtering + critic baselining + decoupled clipping

## Key insights

- Gradient stability é THE key to stable multi-turn RL training
- Reasoning format não garante reasoning behavior — modelos podem produzir hallucinated reasoning se rewards só refletem task success
- Rollout frequency e diversity shape self-evolution mais que algorithm tweaks

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]