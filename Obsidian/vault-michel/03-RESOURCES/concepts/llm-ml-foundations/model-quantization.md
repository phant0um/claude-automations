---
title: Model Quantization
type: concept
status: developing
created: 2026-05-01
updated: 2026-05-01
tags:
  - llm
  - optimization
  - deployment
---

## Definition

**Quantization** reduces the precision of model weights and activations, reducing memory footprint and computational cost while maintaining acceptable quality.

## Precision Levels

| Format | Bits | Range | Use Case |
|--------|------|-------|----------|
| FP32 (float32) | 32 | ±3.4e±38 | Training, baseline |
| BF16 (bfloat16) | 16 | ±3.4e±38 | Training, inference baseline |
| FP16 (float16) | 16 | ±65k | Inference, memory-constrained |
| **FP8** | 8 | ±240 | Inference, production |
| **INT8** | 8 | -128 to +127 | Inference, integer hardware |
| **NVFP4** | 4 | Adaptive | Pre-training (novel) |
| **INT4** | 4 | -8 to +7 | Extreme compression |

## NVFP4 (NVIDIA FP4)

**Introduced in Nemotron 3 Super:**

- **Adaptive exponent field** maintains dynamic range across token sequence
- **First stable 4-bit pre-training** at 120B scale (demonstrated viability)
- **Benefit:** 8× memory reduction vs FP32
- **Trade-off:** Slight quality loss, but recoverable with careful hyperparameters
- **Production:** Available for inference on B200+ GPUs

## Quantization Process

1. **Post-training quantization (PTQ):** Apply to already-trained model
   - Simpler, 1-2 hour process
   - Quality loss 2-5%

2. **Quantization-aware training (QAT):** Simulate quantization during training
   - Better quality (loss <1%)
   - Requires retraining

3. **Low-precision pre-training:** Train from scratch in lower precision
   - NVFP4 achieves this
   - Difficult to stabilize (solved in Nemotron 3 Super)

## Impact on Inference

| Technique | Memory | Throughput | Quality Loss |
|-----------|--------|-----------|--------------|
| FP32 → BF16 | 2× | 1.5-2× | 0% |
| BF16 → FP8 | 2× | 1.5-2× | 0-1% |
| BF16 → INT4 | 4× | 2-4× | 2-5% |
| NVFP4 | 8× | 2-4× | 1-2% |

## Nemotron 3 Super Checkpoints

- **NVFP4 quantized:** 8× reduction, production-ready
- **FP8 quantized:** Standard 8-bit, universal hardware support
- **BF16 post-trained:** Reference quality baseline
- **BF16 base:** Foundation for fine-tuning

## Related Concepts

[[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]] · [[03-RESOURCES/concepts/model-compression]]

---

**Sources:** [[03-RESOURCES/sources/ml-research-papers/nemotron-3-super-hybrid-mamba-attention-moe]]
