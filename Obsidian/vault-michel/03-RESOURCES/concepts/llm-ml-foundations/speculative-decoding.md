---
title: Speculative Decoding (Multi-Token Prediction)
type: concept
status: developing
created: 2026-05-01
updated: 2026-05-01
tags:
  - llm
  - inference
  - acceleration
---

## Definition

**Speculative decoding** is an inference technique where the model generates multiple tokens per forward pass, then validates them, reducing total forward passes required.

## Traditional Decoding (Autoregressive)

```
Output: []
Step 1: Generate token 1 (1 forward pass)
Step 2: Generate token 2 (1 forward pass)
Step 3: Generate token 3 (1 forward pass)
Total: 3 tokens, 3 forward passes
```

## Speculative Decoding (Multi-Token Prediction)

```
Output: []
Step 1: Generate tokens 1-4 in one forward pass (MTP layer)
Step 2: Validate tokens 2-4 (1 additional pass)
Step 3: Continue
Total: 4 tokens, 2 forward passes (50% reduction)
```

## Implementation in Nemotron 3 Super

- **MTP layers:** 2 layers with shared weights
- **Architecture:** Dedicated multi-token prediction heads predict k next tokens simultaneously
- **Validation:** Proposed tokens verified against model likelihood

## Benefits

1. **Throughput increase:** 1.5-2× per typical configuration
2. **Quality improvement:** Predicting multiple tokens forces deeper reasoning
3. **Latency:** Same or lower (fewer round-trips to GPU)
4. **Compatibility:** Works with existing inference engines (vLLM, TRT-LLM)

## Trade-offs

| Aspect | Benefit | Cost |
|--------|---------|------|
| Throughput | +1.5-2× | Occasional backtrack (rare) |
| Quality | Improves | Minimal (better reasoning) |
| Memory | Same | Slight MTP head overhead |
| Complexity | Transparent | Requires MTP-aware decoding engine |

## Related Concepts

[[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]] · [[03-RESOURCES/concepts/agent-systems/hybrid-architectures]]

---

**Sources:** [[03-RESOURCES/sources/ml-research-papers/nemotron-3-super-hybrid-mamba-attention-moe]]
