---
title: "Agentic World Modeling: Foundations, Capabilities, Laws, and Beyond"
type: source
source_type: paper
category: ai-agents
hash: 01f92715d6a529c0f5e11f938685aa1c
ingested: 2026-05-05
url: https://arxiv.org/html/2604.22748v1
tags:
  - world-models
  - agentic-ai
  - reinforcement-learning
  - survey
  - taxonomy
  - ai-agents
triagem_score: 9
---

# Agentic World Modeling: Foundations, Capabilities, Laws, and Beyond

**Authors:** Meng Chu, Xuan Billy Zhang, Kevin Qinghong Lin, Lingdong Kong, Jize Zhang, Teng Tu, Weijian Ma, Ziqi Huang, Senqiao Yang, Wei Huang, and 30+ co-authors (core contributors and senior authors from HKUST, NUS, Oxford, NTU, CUHK, HKU, UW, SUTD, SMU)

**Senior Authors:** Haoxuan Che, Long Chen, Qifeng Chen, Wenxuan Zhang, Wenya Wang, Xiaojuan Qi, Yang Deng, Yanwei Li, Mike Zheng Shou, Zhi-Qi Cheng, See-Kiong Ng, Ziwei Liu, Philip Torr, Jiaya Jia

**arXiv:** 2604.22748v1

---

## Abstract Summary

A comprehensive survey (400+ works, 100+ representative systems) proposing a **"levels × laws" taxonomy** for agentic world modeling. Two organizing axes:

1. **Capability levels (L1/L2/L3)** — what a world model can do
2. **Governing-law regimes (4 types)** — the domain constraints it must satisfy

---

## Key Contribution: The L1/L2/L3 Taxonomy

### L1 — Predictor
- Learns one-step local transition operators
- Pattern matching / Humean constant conjunction
- Measures: calibration, robustness, identifiability
- Failure: distribution shift breaks i.i.d. assumption

### L2 — Simulator
- Composes transitions into multi-step, action-conditioned rollouts
- Supports counterfactual reasoning (Lewis's "closest possible worlds")
- Three boundary conditions: long-horizon coherence, intervention sensitivity, constraint consistency
- Risk: epistemic drift — coherent but wrong trajectories

### L3 — Evolver
- Autonomously revises its own model when predictions fail
- Closes the design–execute–observe–reflect loop
- Lakatos analogy: updates "protective belt" (parameters) or "hard core" (architecture)
- Most advanced current examples: CAMEO, A-Lab (science), FunSearch, AlphaEvolve (algorithms)

> **Key Takeaway:** "The future of agentic AI lies not in larger predictors, but in models that internalize the governing laws of the world, simulate its dynamics, and continuously evolve themselves through active trial-and-error loops."

---

## Four Governing-Law Regimes

| Regime | Constraints | Representative domains |
|--------|------------|----------------------|
| **Physical** | Geometry, conservation laws, contact dynamics | Robotics, autonomous driving, embodied AI |
| **Digital** | Program semantics, state machines, formal specs | Web agents, GUI, software engineering |
| **Social** | Beliefs, goals, norms, Theory of Mind | Multi-agent, dialogue, social simulation |
| **Scientific** | Latent mechanisms, causal structure, empirical observables | Scientific discovery, autonomous experimentation |

Physical vs. Scientific distinction: physical admits analytic/simulator verification; scientific requires empirical validation because mechanisms are only partially known.

---

## Architectural Building Blocks

Three design axes for world models:
1. **Representation** — latent continuous vs. symbolic vs. hybrid
2. **Dynamics** — stochastic latent (DreamerV3), deterministic value-aware (MuZero, TD-MPC2), autoregressive token (iVideoGPT), diffusion-based (Sora, DIAMOND, Genie)
3. **Control interface** — online MPC (TD-MPC2, PETS), tree search (MuZero), imagined-rollout policy (Dreamer family), offline distillation (GR-1), replayable environments (OSWorld, SWE-agent)

---

## Notable Systems Surveyed

### Physical World
- DreamerV3, MuZero, TD-MPC2, EfficientZero, DIAMOND, Genie (Sora line)
- RoboCasa, Meta-World, CALVIN, nuScenes (benchmarks)

### Digital World
- CodeWM, WorldCoder, WKM, CWM (32B, 65.8% SWE-bench Verified)
- Web World Models (TypeScript/HTTP world state)
- OSWorld, SWE-bench, WebArena, Mind2Web (benchmarks)

### Social World
- Sotopia, Theory-of-Mind benchmarks (ToMi, BigToM, OpenToM, Hi-ToM, FANToM)
- Large-scale social simulations (10,000+ agents)

### Scientific World
- CAMEO, A-Lab — closed-loop autonomous experimentation
- GraphCast, NeuralGCM, Aurora — weather/climate surrogates
- AI Scientist-v2 — agentic tree search for hypothesis/experiment design
- FunSearch, AlphaEvolve — evaluator-guided algorithmic discovery

---

## Open Problems (Section 8)

1. **Continual learning of societal transition functions** — detect when social dynamics shift without catastrophic forgetting
2. **Surrogate-to-reality gap** — calibrating scientific surrogates with scarce real data
3. **Non-stationary governing laws** — biology/ecology/climate where dynamics drift
4. **Harness design as world modeling** — execution environment (tools, memory, feedback loops) IS the world model for software agents

### Cross-regime shared challenges
- **Deployment shift** — online detection + targeted revision
- **Constraint enforcement** — hard enforcement at inference time (symbolic layers, constrained rollout)
- **Persistent update governance** — stability/plasticity/auditability trilemma

---

## Beyond L3: Meta-World Modeling

L4 concept: systems that reason not about one transition function but about the **space of possible transition functions** — varying, extending, or constructing governing principles themselves. Program synthesis, open-ended evolution, and procedural world generation as candidate mechanisms.

---

## Representation Substrate Debate

Neural world models encode invariances implicitly (suited for L1/L2) but become liabilities at L3, where structure revision is needed. Historical scientific laws (Newton, Maxwell, Standard Model) are symbolic, composable, and directly revisable. Open problem: world models that discover and manipulate symbolic governing laws from data.

---

## Related Wiki Pages

- [[03-RESOURCES/concepts/agent-systems/agentic-world-modeling]] — core taxonomy concept page
- [[03-RESOURCES/concepts/llm-ml-foundations/world-model-l1-l2-l3]] — L1/L2/L3 capability hierarchy
- [[03-RESOURCES/concepts/governing-law-regimes]] — four-regime framework
- [[03-RESOURCES/concepts/model-based-reinforcement-learning]] — MBRL in the survey
- [[03-RESOURCES/concepts/meta-world-modeling]] — beyond L3
- [[03-RESOURCES/entities/AlphaEvolve]] — L3 system (algorithmic discovery)
- [[03-RESOURCES/entities/SWE-Bench-Verified]] — benchmark referenced (digital world)
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]] — broader agentic context
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — social world regime overlap
