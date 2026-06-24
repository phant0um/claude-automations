---
title: "DiffusionGemma: 4x Faster Text Generation"
type: source
source: "Clippings/DiffusionGemma 4x faster text generation.md"
author: "Brendan O'Donoghue (Google)"
published: 2026-06-10
created: 2026-06-22
ingested: 2026-06-22
tags: [llm-theory, diffusion-models, inference, gemma, google]
score: B
---

## Tese Central

DiffusionGemma é um modelo experimental open-source (Apache 2.0) de 26B MoE (3.8B ativos) que gera blocos inteiros de texto simultaneamente em vez de token-por-token, entregando até 4x faster text generation em GPUs. O trade-off: qualidade inferior ao Gemma 4 autoregressive standard, mas otimizado para workflows locais speed-critical.

## Pontos-Chave

1. **Arquitetura**: 26B total Mixture of Experts, ativa apenas 3.8B durante inference. Cabe em 18GB VRAM consumer GPU quando quantizado. Diffusion head novel projetada para maximizar speed.
2. **Bi-directional attention**: gera 256 tokens em paralelo por forward pass — cada token atende a todos os outros. Vantagem para non-linear domains: in-line editing, code infilling, amino acid sequences, mathematical graphs.
3. **Performance**: 1000+ tokens/segundo em H100, 700+ em RTX 5090. Shift do bottleneck de memory-bandwidth para compute.
4. **Self-correction**: modelo refina iterativamente seu próprio output, pode avaliar o bloco inteiro de uma vez para corrigir erros em real-time.
5. **Trade-off explícito**: qualidade inferior ao Gemma 4 standard. Recomendado para speed-critical local workflows, não para maximum quality production.
6. **Use case demonstrado**: Unsloth fine-tuned DiffusionGemma para Sudoku — task que modelos autoregressive struggle com porque cada token depende de future tokens.

## Conceitos

- Text diffusion vs autoregressive generation
- Bi-directional attention em text generation
- MoE (Mixture of Experts) com active vs total parameters
- Memory-bandwidth vs compute bottleneck shift
- Canvas de random placeholders → iterative refinement → final polish

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/diffusion-language-models]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
- [[03-RESOURCES/sources/llm-theory/diffusionblocks-training-neural-networks-one-block]]