---
title: "Sparser, Faster, Lighter Transformer Language Models (TwELL)"
type: source
source: "Clippings/Sparser, Faster, Lighter Transformer Language Models.md"
author: "Sakana AI + NVIDIA"
published: 2026-05-08
created: 2026-06-22
ingested: 2026-06-22
tags: [llm-theory, sparse-models, gpu-kernels, inference-optimization, sakana-ai]
score: B
---

## Tese Central

Como fazer LLMs mais rápidos e leves? Não force o GPU a adaptar-se à sparsity. Reshape a sparsity para fit o GPU. TwELL (Tile-wise ELLPACK) é um novo sparse packing format que dynamically routes 99% de tokens sparse por fast path, com dense backup matrix como safety valve para tokens raros heavy.

## Pontos-Chave

1. **Paradoxo**: fazer modelo fazer menos math frequentemente faz rodar mais lento. Unstructured sparsity introduz irregular memory access, e GPUs são built para predictable dense blocks. >95% de neurons em FF layers ficam silent mas hardware pune por isso.
2. **TwELL format**: reshape sparsity para fit GPU em vez de forçar GPU adaptar-se. Dynamic routing: 99% sparse tokens por fast path, dense backup matrix para rare heavy tokens.
3. **Custom CUDA kernels**: fuse múltiplos sparse matmuls para maximizar throughput. Compress TwELL para hybrid representation que minimiza activation sizes.
4. **Resultados**: >20% speedups em billion-parameter scales, higher savings em peak memory e energy. Benchmark em sparse LLMs reais.
5. **ICML 2026**: paper aceito, open-source code no GitHub. Colaboração Sakana AI + NVIDIA.
6. **Brain analogy**: cérebro humano é efficient porque ativa só neurons needed. LLMs naturally tentam fazer isso mas hardware punishes. TwELL resolve o hardware mismatch.

## Conceitos

- Sparse vs dense matmul em GPUs
- TwELL (Tile-wise ELLPACK) sparse packing format
- Hybrid representation: fast path para sparse + dense backup para heavy
- GPU kernel fusion para sparse matmuls

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]]