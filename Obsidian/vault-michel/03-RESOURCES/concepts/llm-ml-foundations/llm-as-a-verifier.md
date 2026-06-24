---
title: LLM-as-a-Verifier
type: concept
status: developing
created: 2026-04-19
updated: 2026-04-19
tags: [verification, reward-model, test-time-scaling, trajectory-scoring, llm-evaluation]
---

# LLM-as-a-Verifier

A verification paradigm where an LLM evaluates agent trajectories by computing a **probabilistic reward** rather than producing a single score label.

## Core Idea

Instead of asking "is this output correct?" (binary), LLM-as-a-Verifier asks "across G score levels, C criteria, and K repeated checks, what is the expected reward of this trajectory?"

```
R(t,τ) = (1/CK) · Σ_c Σ_k Σ_g  p_θ(v_g | t, c, τ) · ϕ(v_g)
```

This integrates the **full probability distribution** over scoring tokens, preserving uncertainty information.

## Three Scaling Axes

| Axis | Parameter | Default |
|---|---|---|
| Scoring granularity | `--granularity` | 20 |
| Repeated verifications | `--n-verifications` | 4 |
| Criteria decomposition | `--criteria` | 3 |

More granularity + more verifications + more criteria = higher reliability, at the cost of more inference.

## Contrast with LLM-as-a-Judge

| | LLM-as-a-Judge | LLM-as-a-Verifier |
|---|---|---|
| Output | Single discrete label | Integrated probability distribution |
| Granularity | Low (pass/fail or 1-5) | High (up to G=20 levels) |
| Repeated runs | Rare | Native (K verifications) |
| Multi-criteria | Ad-hoc | Systematic decomposition |

## Selection via Tournament

To pick the best of N trajectories: run round-robin pairwise scoring, select the trajectory with the most wins. This is equivalent to a Condorcet-style selection.

## Use Case: Test-Time Scaling

Acts as a **trajectory reward model** — given multiple rollouts of an agent solving a task, selects the best one. SOTA on [[03-RESOURCES/entities/Terminal-Bench-2]] (86.4%) and [[03-RESOURCES/entities/SWE-Bench-Verified]] (77.8%).

## Implementation

- Requires Gemini (Vertex AI) for logprob access
- `scripts/verifier_core.py` — core scoring logic
- Results cached in `cache/` (JSON)

## Connections

- [[03-RESOURCES/sources/ml-research-papers/llm-as-a-verifier-general-purpose-framework]] — source page
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]] — primary use case
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — verifier fits as selector in multi-agent pipelines
- [[03-RESOURCES/concepts/learning-cognition/adaptive-thinking]] — Gemini logprobs used; same probabilistic reasoning family

## Evidências
- **[2026-06-19]** Para código, o council muda o juiz de "sintetizador de prosa" para "modelo que roda os testes e mantém o candidato cujo patch passa" — referee objetivo em vez de subjetivo — [[03-RESOURCES/sources/fable-intelligence-model-council]]
- **[2026-06-19]** Estratégia de gestão de risco por diff: revisão lógica linha-a-linha reservada para áreas de alto risco (auth/dados/dinheiro); código de baixo risco tratado como caixa-preta com verificação puramente empírica — [[03-RESOURCES/sources/fable-class-models-as-code-interpreters]]
