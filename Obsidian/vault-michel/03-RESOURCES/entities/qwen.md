---
title: "qwen"
type: entity
category: model-family
created: 2026-05-01
updated: 2026-05-05
tags: [entity, model, llm, ai, alibaba]
---

# Qwen

LLM model family by [[03-RESOURCES/entities/Alibaba]] (Alibaba Group). Covers dense and MoE architectures across a range of scales.

## Notable Models

| Model | Parameters | Active | Type |
|-------|-----------|--------|------|
| Qwen3-8B | 8B | 8B | Dense |
| Qwen3-30B-A3B | 30B | 3B | MoE |
| Qwen3-32B | 32B | 32B | Dense |
| Qwen3-235B-A22B | 235B | 22B | MoE |

Qwen3-235B-A22B is used as teacher, synthesizer, and evaluator in the [[03-RESOURCES/entities/AgenticQwen]] training pipeline.

## Agentic Variants

- [[03-RESOURCES/entities/AgenticQwen]] — post-trained for industrial tool use via [[03-RESOURCES/concepts/ai-strategy-org/dual-data-flywheel]]

## Related

- [[03-RESOURCES/entities/Alibaba]] — producer
- [[03-RESOURCES/entities/AgenticQwen]] — agentic specialized family
- [[03-RESOURCES/sources/ml-research-papers/clipping-agenticqwen-small-agentic-llm-dual-flywheels]] — AgenticQwen paper
