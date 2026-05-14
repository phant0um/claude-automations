---
title: "Coordination as an Architectural Layer for LLM-Based Multi-Agent Systems"
type: source
source_file: "clippings/Coordination as an Architectural Layer for LLM-Based Multi-Agent Systems An Information-Controlled Empirical Study on Prediction Markets.md"
author: "Maksym Nechepurenko, Pavel Shuvalov (Devnull FZCO, Dubai)"
ingested: 2026-05-09
tags: [multi-agent, coordination, llm, prediction-markets, murphy-decomposition, brier-score, empirical-study]
arxiv: "https://arxiv.org/abs/2605.03310"
---

# Coordination as an Architectural Layer for LLM-Based Multi-Agent Systems

**Authors:** Maksym Nechepurenko & Pavel Shuvalov — [[03-RESOURCES/entities/Devnull-FZCO]]  
**Testbed:** [[03-RESOURCES/entities/Polymarket]] via [[03-RESOURCES/entities/Foresight-Arena]] sandbox  
**Model used:** claude-opus-4-6 (n=100 binary markets, post-training-cutoff)

## Abstract

Multi-agent LLM systems fail in production at rates between 41–87%, with the majority of failures attributable to coordination defects rather than base-model capability. This paper argues coordination should be treated as a separable **architectural layer** — distinct from the information layer and agent layer — enabling falsifiable predictions about failure-mode signatures. An information-controlled experimental design is applied to five reference coordination configurations on Polymarket binary prediction markets, using the [[03-RESOURCES/concepts/murphy-decomposition|Murphy decomposition]] (Brier → UNC + REL − RES) to separate calibration error from discriminative power.

## Key Findings

### 1. Three-Layer Decomposition
The paper formalizes multi-agent systems as three layers:
- **Information layer** — tools, retrieved context, external sensors
- **Coordination layer C** — agent topology, authority distribution, synchronization, aggregation, termination, failure handling
- **Agent layer** — per-agent LLM call + role prompt

Holding information and agent layers fixed while varying only C is the methodological innovation. Total compute is treated as **endogenous** to each architecture (not held constant).

### 2. Five Reference Configurations and Predicted Signatures
| Config | Abbr | Centralization | Info sharing | Predicted REL | Predicted RES |
|---|---|---|---|---|---|
| Independent ensemble | IE | Low | None | Moderate | High |
| Peer-critique debate | PC | Low | Full | Improves over rounds | Declines over rounds |
| Orchestrator-specialist | OS | High | Via orchestrator | Low | Moderate |
| Sequential pipeline | SP | Medium | Upstream-only | Stage-1 dependent | Stage-1 dependent |
| Consensus alignment | CA | Low | Full + convergence | Very low | Very low |

### 3. Empirical Results (n=100, static information regime)
- **3 of 5 pre-specified Murphy-signature predictions upheld** in predicted direction
- **Pareto frontier** (cost–quality): Independent Ensemble (cost-sensitive) and Sequential Pipeline (quality-sensitive) dominate the other three
- Orchestrator-specialist and peer-critique-debate are **Pareto-dominated** — counter-intuitive given their popularity in frameworks
- Consensus alignment tracks market consensus → **negative Alpha** (failure visible only via Murphy, not Brier alone)
- Statistical separation: consensus alignment vs others has signal at 95% bootstrap; pairwise tests do not survive Bonferroni at n=100

### 4. Methodological Contribution: Information-Controlled Design
Prior multi-agent comparisons confound architectural effects with information access effects — a **non-identifiability theorem** (Baum et al. [^3]). Fix: identical LLM, identical tools, identical per-call token cap, identical prompt template. Only the coordination structure varies.

### 5. Connection to MAST Failure Taxonomy
- Peer-critique minority collapse → MAST FM-2.x (communication breakdown)
- Sequential pipeline false confidence → MAST FM-3.x (inadequate output checking)
- Consensus alignment midpoint anchoring → closest to FM-2.4 (state desynchronization)

## Released Artifacts
- Harness: [coordination-experiment](https://github.com/ForesightFlow/coordination-experiment) (tag: paper-v05)
- Traces dataset: [coordination-traces-100](https://github.com/ForesightFlow/datasets)
- Production agents: [foreflow-agents](https://github.com/ForesightFlow/foreflow-agents)

## Conexões

- [[03-RESOURCES/concepts/murphy-decomposition]] — scoring framework central to the methodology
- [[03-RESOURCES/concepts/coordination-layer-llm]] — main conceptual contribution of this paper
- [[03-RESOURCES/concepts/brier-score]] — proper scoring rule used for evaluation
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — existing wiki concept extended by this work
- [[03-RESOURCES/concepts/prediction-markets]] — testbed domain
- [[03-RESOURCES/entities/Polymarket]] — question source platform
- [[03-RESOURCES/entities/Foresight-Arena]] — sandbox + on-chain deployment channel
- [[03-RESOURCES/entities/Devnull-FZCO]] — authoring organization
