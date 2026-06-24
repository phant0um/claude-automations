---
title: "Why On-Policy Distillation Works and Naive Self-Distillation Doesn't"
type: source
source: Clippings/Why On-Policy Distillation Works and Naive Self-Distillation Doesn't.md
created: 2026-06-12
ingested: 2026-06-21
tags: [llm-ml, distillation, reinforcement-learning, source, score-B]
---

## Tese central
On-policy distillation = dense signal (token by token match com teacher), learn from far less compute que RL. Naive self-distillation (inject privileged info no prompt) falha: student names feedback first, reasons backward, aprende reasoning shape unconditionally → hallucination at inference (96-98% chemistry/tool-use), degraded reasoning (hedging tokens collapse 86→10), poor OOD (6-25 points below RL).

## Key insights
- "A dense training signal that points in the wrong direction" — naive self-distillation
- Hallucination: model refers to feedback it never received
- Hedging/backtracking tokens (wait, perhaps, actually) collapse — model stops self-examining
- Plain RL gives best overall model: strong in-distribution + intact OOD

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-ml-foundations]]
- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]