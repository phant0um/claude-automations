---
title: Horizon Length
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags: [concept, long-horizon, rl, agent-training, horizon-length]
---

# Horizon Length

The number of action steps an agent must take to complete a task. Formalised in Kim et al. (2026) with three distinct quantities:

| Term | Symbol | Definition |
|------|--------|-----------|
| Goal distance | $d(s_0, g)$ | Minimum atomic actions under optimal policy $\pi^*$ |
| Interaction budget | $H_{\max}$ | Max steps allowed by the environment |
| Effective horizon | $h_\pi(s_0, g)$ | Actual steps a policy $\pi$ takes to succeed |

Relation: $d(s_0, g) \leq h_\pi(s_0, g) \leq H_{\max}$

## Why Horizon Length Matters for Training

Horizon length is an **independent training bottleneck** — distinct from reasoning complexity. Even when the solving logic of a task is constant across instances, increasing the required action sequence length alone causes:

1. **Exponential exploration difficulty:** probability of discovering a correct trajectory decays exponentially with horizon.
2. **Credit assignment degradation:** sparse end-of-episode rewards must propagate across many steps, producing high-variance gradients.
3. **Negative advantage diffusion:** failed trajectories assign negative advantage to all steps; under REINFORCE, this spreads probability mass across ~10^5 vocabulary tokens, injecting noise across the policy. See [[03-RESOURCES/concepts/llm-ml-foundations/credit-assignment]].

## Empirical Evidence

Kim et al. (2026) trained Qwen3-1.7B on Sudoku tasks partitioned into L1–L7 by goal distance (11–45 empty cells). RL training is stable on L1–L2 (11–20 cells) but collapses catastrophically on L3–L4 (21–30 cells). Collapse is **model-scale-agnostic** (same on 4B), **optimizer-agnostic** (same on GRPO), and **environment-agnostic** (same on Rush Hour and WebShop).

## METR Time Horizon Benchmark

Separate from the RL-training bottleneck above, METR measures a different "horizon" — the **wall-clock human-expert time** for software engineering tasks AI can complete:

- March 2025: task horizon doubles every **7 months**
- Post-2023 data: doubling may have accelerated to every **4 months**
- A rapid break (much faster doubling) = early warning of recursive self-improvement

This is a proxy for [[03-RESOURCES/concepts/llm-ml-foundations/recursive-self-improvement]] risk, not the same concept as horizon length in RL training.

## Related Concepts

- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-reduction]] — the primary fix for RL training bottleneck
- [[03-RESOURCES/concepts/llm-ml-foundations/credit-assignment]] — the mechanism behind the bottleneck
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — RL framework where this bottleneck appears
- [[03-RESOURCES/concepts/llm-ml-foundations/recursive-self-improvement]] — the RSI threat METR tracks
- [[03-RESOURCES/entities/METR]] — org maintaining the time horizon benchmark
- [[03-RESOURCES/sources/ml-research-papers/training-llms-long-horizon-tasks-empirical-study]] — source paper
