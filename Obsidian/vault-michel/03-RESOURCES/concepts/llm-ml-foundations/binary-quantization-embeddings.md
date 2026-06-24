---
title: Binary Quantization (Embeddings)
type: concept
status: developing
created: 2026-05-29
updated: 2026-05-29
tags: [rag, retrieval, vector-search, quantization, infrastructure, embeddings]
---

# Binary Quantization (Embeddings)

Técnica de compressão de vetores de embedding que substitui valores float32 por bits (positivo→1, negativo→0). Reduz uso de memória em ~32x e acelera drasticamente a busca por similaridade. Distingue-se de [[03-RESOURCES/concepts/llm-ml-foundations/model-quantization|model-quantization]] (que comprime pesos de modelos) — aqui o alvo são os vetores de embedding em sistemas RAG.

## O problema que resolve

Float32 embeddings são caros em *memória*, não apenas em geração:
- Uma única embedding pode consumir milhares de bytes
- Em datasets de milhões/bilhões de embeddings: problema crítico de infraestrutura
- Retrieval latency cresce com o tamanho do índice, degradando todo o produto AI

## Como funciona

```
Float32 original:     [0.182, -0.922, 0.442, -0.117, ...]
Binary quantization:  [    1,      0,     1,      0,  ...]
```

Positivo → 1, Negativo → 0. Toda a dimensão de precisão float é descartada em troca de representação ultra-leve.

## Ganhos

| Dimensão | Impacto |
|---|---|
| Uso de memória | ~32x menor |
| Velocidade de busca | Muito mais rápida (Hamming distance vs float comparison) |
| Cache performance (CPU) | Melhor cache locality com vetores menores |
| RAM usage | Reduzido drasticamente |
| Índices mais eficientes | Maior índice na mesma RAM |
| Concorrência | Mais requests simultâneos de agentes |

## Hamming distance como replacement para cosine similarity

Depois da compressão binária, a busca usa Hamming distance (número de bits diferentes) em vez de cosine similarity de floats. Operações de Hamming são otimizadas em hardware — isso muda a economia do search completamente.

## Trade-offs

- Perde precisão float — impacto em recall precisa ser medido por caso de uso
- Melhor para retrieval em larga escala onde velocidade > precisão marginal
- Comum combinar com reranking: binary retrieval para candidatos rápidos → reranker float para ranking final

## Onde está em uso (documentado)

- **Perplexity AI** — binary-like approaches em search infrastructure
- **Azure Cognitive Search** — vector search optimization
- "Many enterprise AI systems quietly rely on quantized retrieval layers"

## Relação com o bottleneck de RAG moderno

Binary quantization resolve o bottleneck de memória/velocidade, mas após resolvê-lo, o bottleneck se move para **orquestração**:
- Permission-aware retrieval (multi-tenant)
- Chunk freshness systems
- Routing entre múltiplas fontes
- Hybrid search (semântico + keyword)
- Metadata filtering e reranking

## Ver também

- [[03-RESOURCES/concepts/llm-ml-foundations/model-quantization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/vector-search]]
- [[03-RESOURCES/sources/memory-context-rag/rag-becoming-infrastructure]]
