---
title: Weak-to-Strong Generalization
type: concept
status: developing
created: 2026-04-19
updated: 2026-04-19
tags: [alignment, superalignment, training, llm, anthropic]
---

# Weak-to-Strong Generalization

## Definition

The problem of training a **strong large model** (student) using only supervision from a **weak small model** (teacher), and recovering as much of the strong model's ground-truth-supervised performance as possible.

This is an analogue of the **superalignment** challenge: humans (weak supervisors) overseeing AI systems that are smarter than humans. If we can solve weak-to-strong supervision at the model level, we have a testbed for alignment techniques at the capability level.

## Why It Matters

Current alignment research assumes humans can evaluate AI outputs. When AI surpasses human capability on a task, this assumption breaks down. Weak-to-strong generalization is the smallest reproducible instance of this problem — tractable now, generalizable later.

## Metric: Performance Gap Recovered (PGR)

$$PGR = \frac{perf(student_{weak-supervised}) - perf(weak\_teacher)}{perf(student_{strong-supervised}) - perf(weak\_teacher)}$$

- **PGR = 0** — no improvement over the weak teacher
- **PGR = 1** — student matches ground-truth-supervised performance
- Original Burns et al. (2023) baseline on chat preference: PGR ≈ 0.23

## Standard Baselines (Burns et al. 2023 + extensions)

| Method | Description |
|---|---|
| Train on weak labels | Direct fine-tuning on weak teacher's labels |
| Train on confident weak labels | Filter to high-confidence teacher predictions |
| Unsupervised elicitation | Zero-shot based; no weak labels used |
| Critic training | RL: strong student generates critiques to assist weak teacher |
| Zero-shot prompting | Highly-optimized prompt on base model |

Most baselines achieve PGR ~0.2 on the chat preference testbed.

## AAR-Discovered Methods (2026)

The [[03-RESOURCES/sources/ml-research-papers/automated-weak-to-strong-researcher|Automated Weak-to-Strong Researcher]] paper (Anthropic, April 2026) used autonomous Claude Opus 4.6 agents to hill-climb this problem, achieving PGR = 0.97:

| Method | PGR | Core idea |
|---|---|---|
| CCS + Evolution Strategy | 0.93 | Contrastive Consistency Search + gradient-free LoRA optimization |
| EM Posterior | 0.78 | Bayesian posterior labels via learned noisy channel model |
| Overlap Density | 0.75 | 4 embedding-based alignment signals for data selection |
| MDL Curriculum | 0.68 | Confident labels first (MDL intuition), then full dataset |
| Epiplexity | 0.62 | Loss-drop as learnability signal → adaptive label smoothing |

## Testbeds

Three binary classification tasks:
1. **Chat preference** — HelpSteer2/3 (train/ID), RMBench + RewardBench2 (OOD)
2. **Math verification** — DAPO-Math-17K (train), AIME 2024/25 (OOD)
3. **Coding verification** — TACO easy/medium (train), TACO medium-hard/very-hard (OOD)

Note: Math and coding testbeds are vulnerable to reward hacking (AAR finds dataset shortcuts); chat preference is more resistant.

## Key Challenges

- **Data-specific tricks** — AAR-discovered methods tend to exploit specific dataset structures; generalizing across domains requires explicit design
- **Scale transfer** — ideas from small models may not generalize to large models and vice versa
- **Reward hacking** — see [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]]

## Connections

- [[03-RESOURCES/sources/ml-research-papers/automated-weak-to-strong-researcher]] — Anthropic AAR paper (April 2026)
- [[03-RESOURCES/concepts/llm-ml-foundations/automated-alignment-researcher]] — the agent system that discovered new SOTA methods
- [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]] — critical failure mode discovered during research
- [[03-RESOURCES/entities/Jan-Leike]] — lead alignment researcher on this problem
- [[03-RESOURCES/entities/anthropic]] — research org
