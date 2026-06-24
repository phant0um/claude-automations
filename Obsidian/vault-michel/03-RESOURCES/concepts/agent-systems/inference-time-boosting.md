---
title: "Inference-Time Boosting"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Inference-Time Boosting

Spending more compute at inference time — not training time — to improve output quality.

## O que é / What it is

The classical ML scaling law trades training compute for model quality. Inference-time boosting is the complementary trade: given a fixed model, spend more compute *when answering* to get better answers. This is why o1/o3 can outperform larger models on reasoning tasks despite having fewer parameters — they run longer at inference.

## Como funciona

**Key techniques:**

| Technique | Mechanism | Cost |
|-----------|-----------|------|
| **Best-of-N** | Generate N outputs, pick best via verifier | N× tokens |
| **Beam search** | Explore top-k partial outputs at each step | k× tokens |
| **Chain-of-thought (CoT)** | Explicit reasoning steps before answer | +reasoning tokens |
| **Extended thinking** | Model runs internal scratchpad (Claude's "thinking" mode) | Variable budget |
| **Self-consistency** | Sample multiple CoT paths, majority-vote final answer | N× tokens |
| **Generator-verifier loop** | Iterative refinement until verifier passes | retries × tokens |

**Test-time scaling:** The compute budget is set per-query. Hard problems get more thinking tokens; easy ones get fewer. Claude's extended thinking (`budget_tokens`) implements this.

## Padrões / Patterns

**When to use:** Complex reasoning (math, code, planning), high-stakes outputs (legal, medical), tasks where retries are cheap but mistakes are costly.

**When to skip:** High-volume, low-complexity tasks where latency/cost dominate (classification, summarization of short texts). Baseline model is usually sufficient.

**Vault application:** `heavy-think` skill in vault-michel enables extended thinking for complex agent decisions by explicitly allocating extra reasoning budget.

## Related
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/concepts/ai-strategy-org/inference-optimization]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
