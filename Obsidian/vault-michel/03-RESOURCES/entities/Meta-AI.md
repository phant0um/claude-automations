---
title: "Meta AI"
type: entity
entity_type: organization
created: 2026-05-14
updated: 2026-05-14
tags: [entity, org, meta, llm, pretraining, llama]
---

# Meta AI

Meta's AI research division. Responsible for the Llama model family and significant open research contributions across pretraining, post-training, and alignment.

## Key Research

- **Llama series**: Llama 2, Llama 3, Llama 3.1 — open-weight frontier models at various scales
- **Self-Improving Pretraining** (Tan et al., 2026): using post-trained models as rewriter + judge to improve pretraining quality, safety, and factuality at the data-generation stage — a θ-engineering loop applied earlier in training
- **RLVR/GRPO research**: contributions to reasoning via reinforcement learning on verifiable rewards

## Self-Improving Pretraining (2026)

Key result: a 1.4B model trained with Self-Improving Pretraining outperforms Llama-3.1 8B baseline on safety+quality benchmarks. Method replaces next-token prediction with RL-based sequence generation guided by a post-trained judge.

- 86.3% win rate in quality vs. standard pretraining baseline
- +36.2% relative factuality improvement
- +18.5% relative safety improvement

See [[03-RESOURCES/sources/ml-research-papers/self-improving-pretraining-meta]].

## Relations

- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — key research area
- [[03-RESOURCES/concepts/ai-strategy-org/c-theta-engineering]] — Self-Improving Pretraining is a θ-loop
- [[03-RESOURCES/concepts/llm-ml-foundations/weak-to-strong-generalization]] — using stronger post-trained models to supervise weaker policy models
