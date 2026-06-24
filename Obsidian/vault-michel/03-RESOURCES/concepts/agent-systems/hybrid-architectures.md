---
title: Hybrid Architectures (Mamba-Attention)
type: concept
status: developing
created: 2026-05-01
updated: 2026-05-01
tags:
  - llm
  - architecture
  - sequence-modeling
---

## Definition

A **hybrid architecture** combines different layer types (e.g., Mamba + Attention) strategically to leverage the strengths of each:

- **Mamba layers:** O(N) linear complexity, high throughput, efficient long sequences
- **Attention layers:** O(N²) quadratic complexity, captures long-range dependencies and critical semantics

## Design Principle: Selective Attention

Rather than using attention everywhere (expensive) or nowhere (quality loss), hybrid models place:

1. **Attention at critical points:**
   - Early layers (semantic grounding)
   - Periodic global attention (long-range reasoning)
   - Final layers (output coherence)

2. **Mamba elsewhere:**
   - Fast sequential processing
   - Low memory footprint
   - Enables longer context windows

## Nemotron 3 Super Pattern

**88 layers, pattern: Mamba → Attention (strategic intervals)**

- 44 Mamba-2 layers (state dimension 128)
- 44 Attention layers (32 query heads, 2 KV heads)
- 2 MTP (Multi-Token Prediction) layers for speculative decoding

**Configuration rationale:**
- Mamba for efficiency + speed
- Attention for semantic coherence
- MTP for inference acceleration

## Benefits

1. **Throughput:** Mamba O(N) reduces per-token cost
2. **Context window:** Scales to 1M tokens without quadratic memory
3. **Quality:** Attention preserves benchmark performance
4. **Latency:** Lower per-token latency than dense models
5. **Cost:** Fewer total FLOPs while maintaining accuracy

## Inference Characteristics

| Aspect | Pure Attention | Pure Mamba | Hybrid |
|--------|---|---|---|
| Per-token FLOPs | Quadratic (O(N²)) | Linear (O(N)) | Linear (amortized) |
| Throughput | Moderate | High | High |
| Quality on benchmarks | Excellent | Good-to-excellent | Excellent |
| Long-context | Limited | Excellent | Excellent |

## Related Concepts

[[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]] · [[03-RESOURCES/concepts/llm-ml-foundations/speculative-decoding]] · [[03-RESOURCES/concepts/llm-ml-foundations/mixture-of-experts]]

---

**Sources:** [[03-RESOURCES/sources/ml-research-papers/nemotron-3-super-hybrid-mamba-attention-moe]]
