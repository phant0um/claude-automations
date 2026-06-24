---
title: "CUDA From Scratch: How to Write Code for the GPU and Why It Is a Scarce Skill"
type: source
source: Clippings/CUDA From Scratch How to Write Code for the GPU and Why It Is a Scarce Skill.md
created: 2026-06-19
ingested: 2026-06-21
tags: [cuda, gpu, parallel-computing, source, score-B]
---

## Tese central
CUDA é different way of thinking about computation — não optimization da mesma approach. GPU = stadium de schoolkids que só sabem add mas são 10000 e contam all at once. CPU = genius mathematician. GPU ganha onde mesma operation aplica a huge data independentemente; perde onde steps dependem uns dos outros. Senior CUDA engineer: $150-225K.

## Key insights
- "It is not about syntax, it is that a brain trained on sequential code has to rewire itself for parallel"
- Kernel = função escrita uma vez, GPU lança em thousands of threads simultaneamente
- AI roda em GPUs porque training/inference = matrix multiplication = millions of independent ops

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-ml-foundations]]