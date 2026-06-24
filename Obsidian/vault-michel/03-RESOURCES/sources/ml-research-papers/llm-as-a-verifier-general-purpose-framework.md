---
title: "LLM-as-a-Verifier: A General-Purpose Verification Framework"
type: source
created: 2026-04-19
updated: 2026-04-19
tags: [llm-verification, test-time-scaling, reward-model, trajectory-scoring, swe-bench, terminal-bench]
triagem_score: 9
---

# LLM-as-a-Verifier: A General-Purpose Verification Framework

**Source:** `.raw/articles/LLM-as-a-Verifier A General-Purpose Verification Framework.md`
**Type:** Technical framework / open-source repo
**Key model:** Gemini (via Vertex AI) with logprob extraction

## Summary

LLM-as-a-Verifier is a general-purpose verification framework that replaces the coarse single-score output of [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]] with a probabilistic reward signal built from three orthogonal scaling axes: **scoring granularity**, **repeated verifications**, and **criteria decomposition**.

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

## The Three Scaling Axes in Detail

### 1. Scoring Granularity (G)

Instead of asking the LLM to output a binary PASS/FAIL or a coarse 1-5 score, the verifier asks it to pick from G score tokens (e.g., "1", "2", ..., "20" for G=20). The key is that logprobs over these tokens carry richer information than the argmax. A trajectory that gets 0.6 probability on "18" and 0.4 on "19" is being treated very differently from one that gets 0.99 probability on "2" — even if both argmax to their respective scores.

Higher G means finer-grained measurement of the verifier's uncertainty, at the cost of slightly more output tokens.

### 2. Repeated Verifications (K)

Running the same verifier K times with temperature > 0 and averaging the scores reduces variance. The LLM verifier is not deterministic — the same trajectory might score 17/20 on one call and 15/20 on another due to sampling noise. K=4 repeated verifications (the default) significantly reduces this noise without K=10's cost.

The averaging happens at the logprob level, not the score level: `(1/K) Σ_k Σ_g p_θ(v_g | t, c, τ_k) · ϕ(v_g)`.

### 3. Criteria Decomposition (C)

Instead of one holistic evaluation, the verifier evaluates against C independent criteria simultaneously. For a coding task, criteria might be: (1) does it solve the stated problem, (2) is it efficient, (3) is it readable. The model evaluates each criterion independently and scores are averaged.

Decomposition forces the verifier to think about each dimension explicitly rather than collapsing everything into one judgment — the same reason rubrics improve human grading.

## The Tournament Selection Mechanism

Round-robin tournament is an important design choice. The naive alternative — score all trajectories and pick the highest — is vulnerable to verifier bias: if the verifier systematically overestimates trajectories that look a certain way (e.g., longer, more verbose), the top score will consistently come from that class regardless of actual quality.

The tournament is more robust because each trajectory must beat others pairwise. A trajectory that looks impressive but fails under specific comparisons is eliminated. The tournament finds the trajectory that wins most consistently across comparisons, not the one with the most extreme single score.

## Why LLM-as-a-Judge Falls Short

LLM-as-a-Judge collapses the full scoring distribution to a single discrete label at inference time. If the model assigns 0.51 probability to "PASS" and 0.49 to "FAIL", the output is "PASS" — indistinguishable from a trajectory where the model assigns 0.99 probability to "PASS". LLM-as-a-Verifier preserves this distinction by operating on the full probability distribution, not just the argmax.

This matters most in borderline cases — which are exactly the cases where trajectory selection is most consequential. On clearly good or clearly bad trajectories, both approaches agree. The verifier's advantage is in the margin.

## Practical Cost Analysis

Default invocation (`--granularity 20 --n-verifications 4 --criteria 3`) means 12 LLM calls per trajectory (4 verifications × 3 criteria). For Bo5 (5 candidate trajectories), that's 60 verifier calls. At small model costs (gpt-4o-mini class), this is tractable. At larger model costs, the compute budget becomes a real constraint — which is why the framework parameterizes G, K, C independently, allowing cost-conscious configurations.

The SOTA results show that even partial scaling (not maxing all three axes) delivers significant gains over the baseline pass@1.

## Connections to Test-Time Scaling

LLM-as-a-Verifier is specifically designed as a trajectory reward model for test-time compute scaling. The workflow:
1. Generate N candidate trajectories (sampling, beam search, or diverse agents)
2. Run LLM-as-a-Verifier on all N trajectories
3. Select the winner from the tournament
4. Return that trajectory as the final output

This is the "best-of-N" paradigm with a better selection mechanism. The verifier is what makes test-time scaling useful — without reliable selection, generating more candidates provides diminishing returns.

## Limitations

- Requires model logprob access (available via Vertex AI for Gemini, not available from all providers)
- 12 LLM calls per trajectory is expensive at frontier model pricing
- Verifier quality bounded by the underlying model's judgment capabilities — if the model cannot distinguish good from bad trajectories for a domain, G/K/C tuning cannot fix it
- Tournament assumes trajectories can be compared pairwise — fails for tasks with incomparable success criteria

## Connections

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]] — concept page
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]] — framework used as trajectory reward model for TTS
- [[03-RESOURCES/entities/Terminal-Bench-2]] — benchmark
- [[03-RESOURCES/entities/SWE-Bench-Verified]] — benchmark
