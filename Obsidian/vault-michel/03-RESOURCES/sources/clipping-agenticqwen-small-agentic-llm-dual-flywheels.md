---
title: "AgenticQwen: Training Small Agentic Language Models with Dual Data Flywheels for Industrial-Scale Tool Use"
type: source
source_type: paper
category: ai-agents
url: "https://arxiv.org/html/2604.21590v1"
authors:
  - Yuanjie Lyu
  - Chengyu Wang
  - Haonan Zheng
  - Yuanhao Yue
  - Junbing Yan
  - Ming Wang
  - Jun Huang
affiliation: Alibaba Group, Hangzhou, China
created: 2026-05-05
updated: 2026-05-05
tags: [source, paper, ai-agents, small-llm, tool-use, reinforcement-learning, agentic-rl, grpo, data-flywheel, qwen]
---

# AgenticQwen: Training Small Agentic Language Models with Dual Data Flywheels for Industrial-Scale Tool Use

**Source:** [arxiv.org/html/2604.21590v1](https://arxiv.org/html/2604.21590v1)
**Authors:** Yuanjie Lyu, Chengyu Wang et al. — [[03-RESOURCES/entities/Alibaba]]
**Model family:** [[03-RESOURCES/entities/AgenticQwen]]

## Core Claim

Small models (8B / 30B-A3B MoE) can close most of the performance gap with much larger models (235B) on industrial-scale tool use and multi-step agentic tasks, through multi-round GRPO-style RL combined with a dual data flywheel that automatically generates increasingly difficult training tasks.

## Problem Addressed

- Frontier agentic systems (Manus-like) depend on proprietary large models (GPT-5, Claude) → high API cost
- Even open-source large models (Qwen3-235B) are prohibitively expensive for millions-of-users production deployment
- Small open-source models with strong agentic capabilities are scarce
- RL alone saturates quickly: synthetic data becomes homogeneous → learning signal dies

## Methodology

### Two RL Tracks

| Track | Tasks | Reward |
|-------|-------|--------|
| **Reasoning RL** | Multi-step math, search (Omni, 2WikiMultiHopQA, HotpotQA) | Binary (final-answer correct?) |
| **Agentic RL** | Real-world workflows in mock environments (flight booking, data analytics) | 0–1 rubric over verifiable subgoals |

### Dual Data Flywheel

See [[03-RESOURCES/concepts/dual-data-flywheel]] for full detail.

**Reasoning flywheel** — generates harder problems from model failures:
1. Collect failure cases after each RL round
2. Self-instruct expansion (structural diversity) via Qwen3-235B
3. Persona injection (contextual diversity: geometry → physics measurement)
4. Multi-model consistency filtering: retain only if 3/3 runs agree

**Agentic flywheel** — expands linear workflows into behavior trees:
1. Phase 1: linear task init from SynthAgent data
2. Phase 2: behavior tree expansion (inject conditional branches)
3. Phase 3: branch-to-task inversion (each branch → standalone task + SOP)
4. Phase 4: adversarial mock-user intervention (trap paths to mislead agent)

See [[03-RESOURCES/concepts/behavior-tree-expansion]] for the tree mechanism.

### Training Setup

- Base model: Qwen3-8B and Qwen3-30B-A3B (MoE, 3B active parameters)
- Teacher/synthesizer/evaluator: Qwen3-235B throughout
- Policy optimizer: GRPO
- Total training data: ~100K samples
- Fully simulated environment (user + tools modeled by LLMs, no proprietary API needed)

## Results

### Public Benchmarks (TAU-2, BFCL-V4 Multi-turn)

| Model | Avg Score |
|-------|----------|
| Qwen3-235B-A22B | 52.0 |
| **AgenticQwen-30B-A3B** | **50.2** |
| **AgenticQwen-8B** | **47.4** |
| Qwen3-30B-A3B (vanilla) | 36.2 |
| Qwen3-8B (vanilla) | 23.8 |

AgenticQwen-8B more than doubles its vanilla counterpart; 30B-A3B nearly matches the 235B model.

### Industrial System (WebWalker, XBench, GAIA)

| Model | WW | XB | GAIA |
|-------|----|----|------|
| Qwen3-235B | 59.5 | 48.0 | 48.5 |
| AgenticQwen-30B | 52.5 | 47.0 | 41.7 |
| AgenticQwen-8B | 50.0 | 46.0 | 41.7 |

AgenticQwen-30B is also ~105s faster per request than 235B on GAIA (344s vs 449s).

### Flywheel Iteration

Steady gains from Round 0 → Round 3; performance approaches the 235B teacher model. Diminishing returns visible after Round 3.

## Key Concepts Introduced / Elaborated

- [[03-RESOURCES/concepts/dual-data-flywheel]] — the central framework (reasoning + agentic flywheels)
- [[03-RESOURCES/concepts/behavior-tree-expansion]] — agentic flywheel mechanism; linear paths → branching decision trees
- [[03-RESOURCES/concepts/agentic-rl]] — RL on long-horizon tool-use with rubric-based reward
- [[03-RESOURCES/concepts/post-training-llm]] — GRPO-style multi-round RL as post-training

## Entities

- [[03-RESOURCES/entities/AgenticQwen]] — the model family
- [[03-RESOURCES/entities/Alibaba]] — producing organization
- [[03-RESOURCES/entities/qwen]] — base model family

## Limitations

- Long-context tasks (deep search) still challenging for 8B/30B (40K context limit)
- Qwen3-235B used as synthesizer/simulator/evaluator → potential model-family bias
- Open-sources full pipeline to encourage cross-family validation
