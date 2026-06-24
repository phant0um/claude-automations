---
title: "DiffusionBlocks: Training Neural Networks One Block at a Time"
type: source
source: "Clippings/DiffusionBlocks Training Neural Networks One Block at a Time.md"
author: "Sakana AI"
published: 2026-05-27
created: 2026-06-22
ingested: 2026-06-22
tags: [llm-theory, training, diffusion-models, memory-optimization, sakana-ai]
score: A
---

## Tese Central

Por mais de uma década assumimos que end-to-end backprop é a única forma de treinar redes profundas. DiffusionBlocks quebra essa suposição: trata o forward pass da rede como um modelo de difusão denoising um sinal, permitindo treinar cada bloco independentemente, reduzindo drasticamente a memória necessária enquanto matching end-to-end performance.

## Pontos-Chave

1. **Insight central**: cada bloco recebe a tarefa de mover a representação um pouco mais perto do target que o bloco anterior fez — isso é precisamente o que um modelo de difusão faz, step by step. Cada bloco otimiza apenas seu próprio objetivo e pode ser treinado independentemente.
2. **Memory reduction**: treinar um bloco de cada vez significa que só precisa memória para um bloco, não para a rede inteira. Crescimento de memória linear com profundidade é eliminado.
3. **Validação em 5 arquiteturas**: ViT, DiT, Masked diffusion, Autoregressive transformers, Recurrent-depth transformers. Em todas, performance competitive com end-to-end usando fraction da memória.
4. **Extensão para recurrent-depth (Looped) transformers**: replaces múltiplas iterações com single forward pass durante training, eliminando BPTT expense.
5. **ICLR 2026**: aceito como conference paper. Código open-source no GitHub.

## Conceitos

- Block-wise training via diffusion interpretation
- Forward pass reinterpretado como denoising process
- Memory-linear-with-depth problem e sua solução
- Recurrent-depth transformers sem BPTT

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/diffusion-language-models]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
- [[03-RESOURCES/sources/llm-theory/diffusiongemma-4x-faster-text-generation]]
- [[03-RESOURCES/sources/llm-theory/trinity-evolved-llm-coordinator]]