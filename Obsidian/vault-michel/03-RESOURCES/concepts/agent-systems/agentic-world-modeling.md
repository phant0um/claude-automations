---
title: Agentic World Modeling
type: concept
status: developing
category: ai-agents
created: 2026-05-05
updated: 2026-05-05
tags:
  - world-models
  - agentic-ai
  - taxonomy
  - survey
---

# Agentic World Modeling

Agentic world modeling is the capacity of an AI agent to build and use internal **predictive models of environment dynamics** in service of decision-making. The term unifies previously fragmented communities (model-based RL, video generation, language agents, robotics, scientific AI) under a single capability-based framework.

> Source: [[03-RESOURCES/sources/ml-research-papers/agentic-world-modeling-survey-2026]] (arXiv 2604.22748v1)

---

## The "Levels × Laws" Taxonomy

The central contribution of the 2026 survey is a two-axis taxonomy:

| Axis | Dimension | Values |
|------|-----------|--------|
| **Capability** | What the model can do | L1 Predictor → L2 Simulator → L3 Evolver |
| **Governing laws** | What constraints must be satisfied | Physical, Digital, Social, Scientific |

These are **orthogonal axes**: any system can be described as occupying a cell in a 3×4 matrix.

### Capability Levels

See [[03-RESOURCES/concepts/llm-ml-foundations/world-model-l1-l2-l3]] for full detail.

- **L1 Predictor** — one-step transition operator; pattern matching
- **L2 Simulator** — multi-step action-conditioned rollout; counterfactual reasoning
- **L3 Evolver** — autonomous model revision from evidence; closes design–execute–observe–reflect loop

The levels are **runtime capability stages**, not static model classes. A deployed system may invoke L1 for fast reactive decisions, L2 when comparing action sequences, and L3 when systematic prediction failures demand model revision.

### Governing-Law Regimes

See [[03-RESOURCES/concepts/governing-law-regimes]] for full detail.

- **Physical world** — geometry, conservation laws, contact dynamics
- **Digital world** — program semantics, state machines, formal specs (mechanically verifiable)
- **Social world** — beliefs, goals, norms, Theory of Mind
- **Scientific world** — latent mechanisms, empirical observables, causal structure

---

## Why World Models Are Central for Agentic AI

Agents and world models are **mutually supportive**:
- Agents rely on world models to anticipate consequences → enables look-ahead planning and sample-efficient learning
- World models benefit from agent-generated experience → targeted trajectories improve accuracy in decision-critical regions

The bottleneck as AI moves from text generation to goal accomplishment is the ability to **model environment dynamics**.

---

## Harness Design as World Modeling

A key insight from Section 8: agent performance has evolved through three layers — prompt engineering → context engineering → **harness engineering** (tools, memory, feedback loops, inter-agent topology). The execution environment's transition dynamics IS a form of world modeling for software agents.

See [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] and [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]].

---

## Relationship to Existing Concepts

| Concept | Relationship |
|---------|-------------|
| [[03-RESOURCES/concepts/model-based-reinforcement-learning]] | L1/L2 in physical world; Dreamer, MuZero, TD-MPC2 |
| [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]] | Agentic world modeling provides the predictive substrate for agentic reasoning |
| [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] | Social world regime; multi-agent coordination shapes effective transition dynamics |
| [[03-RESOURCES/concepts/meta-world-modeling]] | Beyond L3: reasoning over space of possible transition functions |
| [[03-RESOURCES/concepts/agent-systems/agentic-agents]] | World models are one component of the full agentic stack |

---

## Key Representative Systems (2018–2026)

| System | Level | Regime |
|--------|-------|--------|
| DreamerV3 | L2 | Physical |
| MuZero | L2 | Physical |
| TD-MPC2 | L2 | Physical |
| CWM (32B, 65.8% SWE-bench) | L2 | Digital |
| Web World Models | L2 | Digital |
| Sotopia | L2 | Social |
| GraphCast/NeuralGCM | L2 | Scientific |
| CAMEO, A-Lab | L3 | Scientific |
| FunSearch, AlphaEvolve | L3 (partial) | Digital/Scientific |
| AI Scientist-v2 | L3 (partial) | Scientific |

## Evidências
- **[2026-06-19]** Ganhos de capacidade física em Project Fetch emergem de scaling geral, não de fine-tuning específico para robótica — [[03-RESOURCES/sources/project-fetch-phase-two]]
- **[2026-06-21]** Padrões de RL para agentes de terminal (GRPO-style) descartam o stream de feedback do ambiente (stdout, erros, logs) como sinal de treino, aplicando loss só em tokens de ação. ECHO (Environment Cross-entropy Hybrid Objective) adiciona um... — [[1-echo-turns-terminal-feedback-into-supervision-during-agent-rl]]
