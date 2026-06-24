---
title: "Sparser, Faster, Lighter Transformer Language Models"
type: source
source: Clippings/Sparser, Faster, Lighter Transformer Language Models.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ml-research, sparse-models, gpu-kernels, inference, icml-2026, sakana]
---

## Tese central

LLMs naturalmente têm >95% de neurons em feedforward layers silent por token, mas GPUs punem sparsity (irregular memory access). Sakana AI + NVIDIA construíram format "Hybrid" (TwELL) que reshape sparsity para fit GPU em vez de forçar GPU a adaptar a sparsity. ICML 2026.

## Argumentos principais

1. **Paradoxo**: modelo fazer menos math frequentemente roda mais devagar — unstructured sparsity = irregular memory access, GPUs built para dense blocks
2. **Solução**: reshape sparsity to fit GPU, não o contrário. TwELL format dinamically routes 99% de highly sparse patterns
3. **Open-source GPU kernels + data formats** para sparse transformer inference/training
4. **Colaboração NVIDIA**: kernels otimizados, não só teoria
5. **ICML 2026**: peer-reviewed

## Key insights

- "Don't force GPU to adapt to sparsity. Reshape sparsity to fit the GPU" — inversão de abordagem
- >95% neurons silent naturalmente — sparsity é como brain funciona, hardware que não acompanha
- TwELL: dynamic routing de sparse patterns para GPU-friendly format
- Open-source: code + kernels disponíveis

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/entities/AI-Scientist-Sakana]]