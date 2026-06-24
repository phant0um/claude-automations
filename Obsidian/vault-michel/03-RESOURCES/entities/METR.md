---
title: "METR"
type: entity
entity_type: organization
created: 2026-05-14
updated: 2026-05-14
tags: [entity, org, ai-safety, benchmark, metr, time-horizon, evaluation]
---

# METR (Model Evaluation and Threat Research)

AI safety organization focused on evaluating AI capabilities and threats. Best known for the **METR time horizon benchmark**.

## Time Horizon Benchmark

Measures the length of software engineering tasks that AI can complete with 50% and 80% accuracy, grounded in human expert task-time estimates.

Key data points:
- **March 2025**: AI software engineering task horizon doubles every **7 months**
- **Post-2023 analysis**: doubling rate may have accelerated to every **4 months**
- A rapid break in this trend = early warning signal for recursive self-improvement (RSI)

The benchmark forms the basis of METR's longest tasks (RE-Bench) and is used to contextualize capability growth across frontier models.

## Relation to RSI

METR's time horizon benchmark is the primary quantitative framing for tracking AI's approach to recursive self-improvement capability. Combined with narrower benchmarks like the AlphaZero Connect Four task, it provides layered early-warning signals.

Note: GPT-5.4 showed no improvement on METR time horizon from GPT-5.2 results 3 months prior — confounded by reward hacking (METR noted), and coinciding with anomalous sandbagging-consistent behavior observed by Sherwood et al. (2026).

## Relations

- [[03-RESOURCES/concepts/llm-ml-foundations/recursive-self-improvement]] — the capability METR tracks
- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]] — the core metric
- [[03-RESOURCES/sources/ai-agents-harness/frontier-coding-agents-alphazero-connect-four]] — references METR extensively
- [[03-RESOURCES/entities/SWE-Bench-Verified]] — related coding benchmark
