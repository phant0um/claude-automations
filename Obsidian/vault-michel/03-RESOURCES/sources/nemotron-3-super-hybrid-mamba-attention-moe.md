---
title: "Nemotron 3 Super: Open, Efficient Hybrid Mamba-Transformer for Agentic Reasoning"
type: research-paper
authors: NVIDIA
date_published: 2026-04-14
arxiv: "2604.12374v1"
license: CC BY 4.0
created: 2026-05-01
updated: 2026-05-01
tags:
  - llm
  - moe
  - hybrid-architecture
  - agentic-reasoning
  - inference-optimization
  - quantization
---

## Summary

Nemotron 3 Super is a 120B parameter (12B active) hybrid Mamba-Attention Mixture-of-Experts model from NVIDIA. It achieves state-of-the-art inference throughput (2.2-7.5× vs GPT-OSS-120B, Qwen3.5-122B) while maintaining competitive accuracy across benchmarks. Pre-trained on 25T tokens with emphasis on agentic capabilities (tool-use, long-horizon reasoning).

## Key Innovations

### 1. LatentMoE Architecture
- **Hardware-aware expert design** optimizing for both accuracy-per-FLOP and accuracy-per-parameter
- **Reduces memory bandwidth costs** in low-latency serving by decreasing hidden dimension `d` and expert FFN intermediate `m`
- **Reduces all-to-all communication overhead** in distributed throughput-oriented serving by controlling top-K and expert count `N`
- Preserves model quality by maintaining effective nonlinear budget `K·m`
- **5 design principles** derived from Pareto frontier analysis

### 2. Multi-Token Prediction (MTP)
- **Inference acceleration** through native speculative decoding
- Improves overall model quality alongside throughput gains
- 2 MTP layers with shared weights in architecture

### 3. Hybrid Mamba-Attention Pattern
- **88 layers** alternating Mamba and Attention operations strategically
- Mamba layers: low-latency sequence modeling (O(N) complexity)
- Attention layers: long-range dependency modeling + critical benchmarks
- Global attention at strategic points for semantic coherence

### 4. NVFP4 Pre-training
- **Stable low-precision pre-training** in 4-bit quantization
- First model to achieve this at scale (120B)
- Demonstrates viability of NVFP4 for large-scale LLM training

## Architecture Details

| Component | Value |
|-----------|-------|
| Total Parameters | 120.6B |
| Active Parameters | 12.7B (~12.1B excl. embeddings) |
| Total Layers | 88 |
| Model Dimension | 4096 |
| Total Experts per Layer | 512 |
| Top-K (Activated) | 22 |
| MoE Latent Size | 1024 |
| Context Length | 1M tokens |

**Sparse Selection:** Only 22/512 experts activate per token (4.3% sparsity), reducing compute while maintaining quality.

## Training Approach

### Pre-training
- **25 trillion tokens** across 2 phases:
  - Phase 1 (80%, 20T): Diversity and broad coverage
  - Phase 2 (20%, 5T): High-quality data + benchmark optimization
- Maintains fine-grained token distribution

### Post-training
- **Strong agentic emphasis:**
  - Scaled RL environments (breadth, volume, quality)
  - Large agentic training dataset
  - Substantial RL focus on multi-step tool-using behavior
- **Resilient RL infrastructure** for large-scale asynchronous training
- **Benchmark gains** across:
  - Software engineering (OpenHands)
  - Terminal use + bash commands
  - General tool use

### Quantization
- **NVFP4** (FP4 with adaptive exponents)
- **FP8 + KV-Cache** variant
- **BF16** base model
- Checkpoints open-sourced on HuggingFace

## Performance

### Throughput
- **2.2× higher** than GPT-OSS-120B (8k input, 64k output)
- **7.5× higher** than Qwen3.5-122B (same setting)
- Measured on B200 GPUs with vLLM + TRT-LLM

### Accuracy
- **Competitive** across benchmarks (comparable to GPT-OSS-120B, Qwen3.5-122B)
- **Better than base models** (GLM-4.5-Air-Base, Ling-flash-Base-2.0)
- Agentic benchmarks: substantial gains over Nemotron 3 Nano

## Open Releases

**Checkpoints (HuggingFace):**
- Nemotron 3 Super 120B-A12B NVFP4 (post-trained + quantized)
- Nemotron 3 Super 120B-A12B FP8 (post-trained + quantized)
- Nemotron 3 Super 120B-A12B BF16 (post-trained)
- Nemotron 3 Super 120B-A12B Base BF16 (base)
- Qwen3-Nemotron-235B-A22B-GenRM-2603 (for RLHF)

**Datasets (HuggingFace Collections):**
- Nemotron-Pretraining-Specialized-v1.1 (synthetic datasets for code, logic, economics)
- Nemotron-Super-Post-Training-Data (RL environments + SFT datasets for agentic capabilities)

**Code & Recipes:** GitHub NVIDIA-NeMo repository

## Implications for Agentic AI

1. **Efficiency at Scale:** 120B model achieves Qwen3.5 accuracy with 7.5× throughput — enables cost-effective agent deployment
2. **1M Context:** Supports long-horizon reasoning and multi-document analysis in agentic workflows
3. **Tool-Use Optimized:** Explicitly trained on multi-step tool chains — native strength in OpenHands, terminal, general tools
4. **Quantization Path:** NVFP4 demonstrates stable low-precision training; production deployments can use FP8/NVFP4
5. **Open Infrastructure:** Datasets + checkpoints + recipes enable reproducible, customizable agentic systems

## Related Concepts

[[04-SYSTEM/agents/agentic-reasoning]] · [[03-RESOURCES/concepts/mixture-of-experts]] · [[03-RESOURCES/concepts/inference-optimization]] · [[03-RESOURCES/concepts/hybrid-architectures]] · [[03-RESOURCES/concepts/speculative-decoding]] · [[03-RESOURCES/concepts/model-quantization]]

## References

- arXiv: 2604.12374v1 (April 14, 2026)
- License: CC BY 4.0
- Official repository: NVIDIA-NeMo/Nemotron
