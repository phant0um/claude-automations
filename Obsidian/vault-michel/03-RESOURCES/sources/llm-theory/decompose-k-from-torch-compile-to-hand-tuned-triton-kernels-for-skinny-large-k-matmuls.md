---
title: "Decompose-K — From torch.compile to Hand-Tuned Triton Kernels"
type: source
source: Clippings/Decompose-K From torch.compile to Hand-Tuned Triton Kernels for Skinny Large‑K Matmuls.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ml-research, kernels, triton, optimization, gpu]
---
## Tese central
Decompose-K: técnica para otimizar matmuls skinny large-K — de torch.compile para hand-tuned Triton kernels.
## Key insights
- Skinny large-K matmuls: caso comum em LLMs que torch.compile não otimiza bem
- Triton kernels hand-tuned superam auto-compile em casos específicos
## Links
- [[03-RESOURCES/concepts/llm-ml-foundations]]
