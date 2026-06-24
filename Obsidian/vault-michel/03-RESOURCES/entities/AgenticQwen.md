---
title: AgenticQwen
type: entity
category: model-family
created: 2026-05-05
updated: 2026-05-05
tags: [entity, model, small-llm, tool-use, agentic, alibaba, qwen, open-source]
---

# AgenticQwen

Family of small agentic language models developed by [[03-RESOURCES/entities/Alibaba]], built on [[03-RESOURCES/entities/qwen|Qwen]] backbones and trained specifically for industrial-scale multi-step tool use and agentic reasoning.

**Paper:** [[03-RESOURCES/sources/ml-research-papers/clipping-agenticqwen-small-agentic-llm-dual-flywheels]]
**arxiv:** https://arxiv.org/html/2604.21590v1

## Model Variants

| Variant | Backbone | Parameters | Active params | Type |
|---------|----------|-----------|--------------|------|
| AgenticQwen-8B | Qwen3-8B | 8B | 8B | Dense |
| AgenticQwen-30B-A3B | Qwen3-30B-A3B | 30B | 3B | MoE |

The 30B-A3B is a Mixture-of-Experts model — despite larger total size, only 3B parameters activate per inference, making it competitive in latency with the 8B dense model.

## Training Method

- Multi-round GRPO-style RL
- Two tracks: [[03-RESOURCES/concepts/agent-systems/agentic-rl|reasoning RL]] + agentic RL
- [[03-RESOURCES/concepts/ai-strategy-org/dual-data-flywheel]] generates increasingly hard training tasks automatically
- [[03-RESOURCES/concepts/agent-systems/behavior-tree-expansion]] expands linear workflows into multi-branch decision trees
- ~100K total training samples; fully simulated environment (no proprietary APIs)
- Teacher/synthesizer/evaluator: Qwen3-235B

## Performance

### Public Benchmarks (TAU-2 + BFCL-V4 Multi-turn)

| Model | Avg |
|-------|-----|
| Qwen3-235B-A22B | 52.0 |
| AgenticQwen-30B-A3B | **50.2** |
| AgenticQwen-8B | **47.4** |
| Qwen3-30B-A3B (vanilla) | 36.2 |
| Qwen3-8B (vanilla) | 23.8 |

AgenticQwen-8B more than doubles its vanilla Qwen3-8B baseline.

### Industrial System (production deployment)

| Model | WebWalker | XBench | GAIA |
|-------|-----------|--------|------|
| Qwen3-235B | 59.5 | 48.0 | 48.5 |
| AgenticQwen-30B | 52.5 | 47.0 | 41.7 |
| AgenticQwen-8B | 50.0 | 46.0 | 41.7 |

AgenticQwen-30B is also ~105s faster per request than 235B (344s vs 449s on GAIA).

## Key Properties

- **Cost-efficient:** designed for high-frequency, standardized tool-use tasks where 235B models are overkill
- **Production-deployed:** integrated into an Alibaba cloud-product agent system (Manus-like) via capability-based routing
- **Generalizes:** despite <10K agentic search training samples, achieves strong results on search benchmarks
- **Open-source pipeline:** full data synthesis and training code open-sourced

## Limitations

- Long-context deep-search tasks remain hard (40K context limit for both variants)
- Potential model-family bias (Qwen3-235B used for synthesis, simulation, and evaluation)

## Related

- [[03-RESOURCES/entities/Alibaba]] — producer
- [[03-RESOURCES/entities/qwen]] — base model family
- [[03-RESOURCES/concepts/ai-strategy-org/dual-data-flywheel]] — training framework
- [[03-RESOURCES/concepts/agent-systems/behavior-tree-expansion]] — agentic data generation mechanism
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]] — RL methodology
- [[03-RESOURCES/sources/ml-research-papers/clipping-agenticqwen-small-agentic-llm-dual-flywheels]] — paper
