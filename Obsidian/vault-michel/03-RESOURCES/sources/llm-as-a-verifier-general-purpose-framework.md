---
title: "LLM-as-a-Verifier: A General-Purpose Verification Framework"
type: source
created: 2026-04-19
updated: 2026-04-19
tags: [llm-verification, test-time-scaling, reward-model, trajectory-scoring, swe-bench, terminal-bench]
---

# LLM-as-a-Verifier: A General-Purpose Verification Framework

**Source:** `.raw/articles/LLM-as-a-Verifier A General-Purpose Verification Framework.md`
**Type:** Technical framework / open-source repo
**Key model:** Gemini (via Vertex AI) with logprob extraction

## Summary

LLM-as-a-Verifier is a general-purpose verification framework that replaces the coarse single-score output of [[03-RESOURCES/concepts/llm-as-a-judge]] with a probabilistic reward signal built from three orthogonal scaling axes: **scoring granularity**, **repeated verifications**, and **criteria decomposition**.

## SOTA Results

| Benchmark | Baseline (Pass@1) | LLM-as-a-Verifier | Oracle |
|---|---|---|---|
| Terminal-Bench 2 | 81.8% | **86.4%** | 89.9% (Bo5) |
| SWE-Bench Verified | 76.1% | **77.8%** | 84.4% (Bo3) |

Trajectory data: Forge + GPT-5.4 (Terminal-Bench 2) and mini-swe-agent + Claude-Opus-4.5 high reasoning (SWE-bench).

## The Reward Formula

```
R(t,τ) = (1/CK) · Σ_c Σ_k Σ_g  p_θ(v_g | t, c, τ) · ϕ(v_g)
```

- **C** = number of evaluation criteria
- **K** = number of repeated verifications
- **G** = granularity (number of score tokens)
- **p_θ(v_g | t, c, τ)** = model probability assigned to score token v_g
- **ϕ(v_g)** = scalar mapping of score token

Default invocation: `--granularity 20 --n-verifications 4 --criteria 3`

## Selection Mechanism

Round-robin tournament among N candidate trajectories: every pair (i,j) is scored independently; the trajectory with most wins is selected.

## Key Distinction vs LLM-as-a-Judge

LLM-as-a-Judge collapses the full scoring distribution into a single discrete label. LLM-as-a-Verifier **preserves the probability distribution** over score tokens and integrates it — capturing uncertainty and gradations that a hard label discards.

## Connections

- [[03-RESOURCES/concepts/llm-as-a-verifier]] — concept page
- [[03-RESOURCES/concepts/test-time-scaling]] — framework used as trajectory reward model for TTS
- [[03-RESOURCES/entities/Terminal-Bench-2]] — benchmark
- [[03-RESOURCES/entities/SWE-Bench-Verified]] — benchmark
