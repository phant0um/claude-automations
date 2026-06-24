---
title: "DiffusionBlocks — Training Neural Networks One Block at a Time"
type: source
source: Clippings/DiffusionBlocks Training Neural Networks One Block at a Time.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ml-research, training, diffusion, memory-efficiency, iclr-2026]
---

## Tese central

End-to-end backprop exige network inteira em memória — é o resource wall do AI training. DiffusionBlocks reinterpreta forward pass como diffusion denoising: cada block move representação um pouco mais perto do target. Treina um block isolado por vez, usa fração da memória, matcha end-to-end performance. Aceito no ICLR 2026.

## Argumentos principais

1. **Problema**: memory cresce linearmente com depth. Redes profundas exigem GPU memory que não escala
2. **Insight**: tratar forward pass como diffusion — cada block tem role de mover representação mais perto do target que o block anterior. Isto é precisamente o que diffusion model faz step by step
3. **Treinamento independente**: cada block otimiza próprio objetivo, treina independentemente. Só precisa memória para um block
4. **Validação**: 5 arquiteturas — ViT, DiT, Masked diffusion, Autoregressive transformers, Recurrent-depth transformers. Performance competitiva com end-to-end usando fração da memória
5. **Extensão natural**: recurrent-depth (Looped) transformers normalmente exigem BPTT caro. DiffusionBlocks elimina isto.

## Key insights

- Forward pass como diffusion denoising — reinterpretation teórica que habilita block-wise training
- Cada block = um step de denoising → objetivo local, não global
- Memory: O(1 block) vs O(depth) — não-linear, game-changer para models profundos
- Matcha performance end-to-end em 5 arquiteturas — não é trade-off, é free lunch
- Recurrent-depth transformers: BPTT eliminado, treinamento direto

## Exemplos e evidências

- Paper: arxiv.org/abs/2506.14202, ICLR 2026
- 5 arquiteturas validadas: ViT, DiT, Masked diffusion, Autoregressive, Recurrent-depth
- GitHub: SakanaAI/DiffusionBlocks

## Implicações para o vault

- **ML research core**: treinamento eficiente é foundation. DiffusionBlocks muda como pensamos sobre depth e memory.
- **Complementa**: [[03-RESOURCES/concepts/llm-ml-foundations]]

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations]]
- [[03-RESOURCES/entities/AI-Scientist-Sakana]]