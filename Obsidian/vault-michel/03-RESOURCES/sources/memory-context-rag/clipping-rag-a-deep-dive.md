---
title: "RAG - A Deep Dive"
type: source
source_type: article
author: "Neo Kim / Eric Roby"
created: 2026-05-06
tags: [rag, retrieval, embeddings, production]
triagem_score: 8
---

Comprehensive RAG architecture: offline ingestion + online retrieval pipelines, embeddings, chunking strategies, hybrid search, agentic RAG. Production deployment patterns and failure modes.

## Source

Ingested from: `clippings/RAG - A Deep Dive.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Architecture Overview

RAG (Retrieval-Augmented Generation) splits into two pipelines that operate independently:

**Offline Ingestion Pipeline**
1. Source documents collected (PDFs, web pages, databases, codebases)
2. Chunked into segments (fixed-size, semantic, or recursive strategies)
3. Embedded into vector representations
4. Stored in a vector database with metadata filters

**Online Retrieval Pipeline**
1. User query arrives
2. Query embedded using the same embedding model as ingestion
3. Nearest-neighbor search in vector DB returns top-K chunks
4. Retrieved chunks injected into prompt as context
5. LLM generates response grounded in retrieved content

## Chunking Strategies

Chunking quality is the single largest variable in RAG retrieval accuracy. Main approaches:

| Strategy | Mechanism | Best for |
|----------|-----------|---------|
| Fixed-size | Split every N tokens with overlap | Simple docs, uniform structure |
| Semantic | Split at paragraph/section boundaries | Articles, documentation |
| Recursive | Hierarchically try smaller splits | Code, mixed-format content |
| Sentence-window | Store small sentences, retrieve with surrounding context | Q&A, precise retrieval |
| Parent-document | Index small chunks, return full parent | Long docs needing coherence |

Overlap (10–15% of chunk size) prevents context loss at boundaries. Too large = reduced retrieval precision; too small = broken context.

## Embedding Models

Embedding quality directly determines retrieval quality. Key considerations:

- **Dimension size:** larger embeddings (1536–3072 dims) capture more semantic nuance but cost more storage and query time
- **Domain fit:** a general-purpose embedding trained on web text underperforms on legal, medical, or code-heavy corpora
- **Late interaction models (ColBERT):** compute token-level interactions at query time — higher accuracy, higher latency
- **Instruction-tuned embeddings (E5, BGE):** prepend task instruction to query for better alignment

## Hybrid Search

Pure vector search fails on exact matches (product IDs, proper nouns, version numbers). Hybrid search combines:

- **Dense retrieval:** vector similarity (semantic match)
- **Sparse retrieval:** BM25/TF-IDF (keyword match)
- **Reciprocal Rank Fusion (RRF):** merges ranked results from both without needing score normalization

Hybrid typically outperforms either alone by 5–15% on mixed-query benchmarks.

## Agentic RAG

Agentic RAG replaces the single-query retrieval step with an iterative loop:

1. Agent reads original query
2. Decides what sub-information it needs
3. Formulates targeted retrieval queries
4. Retrieves and reads chunks
5. Decides if additional retrieval is needed (HyDE, step-back prompting, etc.)
6. Synthesizes final answer

This handles multi-hop questions where the answer requires combining information from disparate documents. Cost: 3–10x more tokens and latency than single-pass RAG.

## Production Failure Modes

| Failure | Cause | Fix |
|---------|-------|-----|
| Stale retrieval | Embeddings not updated after document edits | Incremental re-indexing pipeline |
| Retrieved-but-ignored | Context window too crowded, model ignores late chunks | Reranking; lost-in-the-middle mitigation |
| Query-embedding mismatch | Query phrased differently from document language | Query rewriting; hypothetical document embedding (HyDE) |
| Wrong chunk returned | Chunk lacks enough context to be standalone | Sentence-window or parent-doc retrieval |
| Hallucination despite retrieval | Model ignores grounding, falls back to training | RAG-specific fine-tuning; citation enforcement |

## RAG vs Alternative Approaches

The core RAG trade-off against alternatives:

- **Full context (no retrieval):** no retrieval overhead, but scales poorly; 1M-token contexts cost ~$15 per call with Opus
- **Fine-tuning:** bakes knowledge into weights; fails on time-sensitive or proprietary data that changes
- **Grep/agentic search:** outperforms RAG in coding contexts where code structure is navigable (see [[03-RESOURCES/sources/memory-context-rag/grep-vs-embeddings-coding-agents]])
- **Knowledge graphs:** better for structured relational knowledge; poor on unstructured text

## Vault Relevance

This vault does not use a vector DB. The `04-SYSTEM/wiki/hot.md` hot-cache pattern is a hand-curated approximation of retrieval — the most frequently needed concepts are pre-loaded rather than retrieved dynamically. For the vault's scale (~120+ sources), grep + structured wikilinks outperforms embedding-based retrieval, consistent with the findings in [[03-RESOURCES/sources/memory-context-rag/grep-vs-embeddings-coding-agents]].

## Related

- [[03-RESOURCES/concepts/retrieval-augmented-generation]]
- [[03-RESOURCES/sources/memory-context-rag/grep-vs-embeddings-coding-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]]

## Por que chunking é a variável mais subestimada em implementações de RAG

A maioria das implementações de RAG passa pouco tempo no chunking e muito tempo otimizando modelos de embedding ou parâmetros de busca. Isso é um erro de prioridade. Um embedding perfeito de um chunk ruim (que divide uma explicação no meio, ou inclui conteúdo de dois tópicos distintos) ainda produirá recuperação de baixa qualidade — porque o chunk não representa uma unidade semântica coerente.

A estratégia parent-document é a mais robusta para a maioria dos casos: indexar chunks pequenos para precisão de recuperação, mas retornar o documento pai completo quando um chunk é recuperado. Isso preserva contexto sem sacrificar precision. O custo é maior quantidade de tokens no contexto por recuperação — um trade-off que se justifica para documentos onde coerência local é crítica (papers, contratos, código).

## Reranking como camada intermediária obrigatória

A recuperação por nearest-neighbor retorna os top-K chunks mais similares à query. Mas "mais similar" não é o mesmo que "mais útil" — chunks podem ser semanticamente próximos mas não conter a informação necessária para responder a query. Reranking usa um modelo cross-encoder para puntuar a relevância de cada chunk recuperado em relação à query específica, em vez de comparar embeddings individualmente.

Cross-encoders são mais lentos do que comparação de embeddings (não podem ser pré-computados) mas são significativamente mais precisos. O padrão de produção é retrieve(top-K=50) → rerank(top-K=5) → inject. Isso combina a escala do nearest-neighbor com a precisão do cross-encoder.

## Agentic RAG: quando usar e quando evitar

Agentic RAG é justificado apenas para queries genuinamente multi-hop — onde a resposta exige combinar informação de múltiplos documentos que não estariam no mesmo top-K de uma busca única. Para queries factuais simples ou queries que exigem síntese de uma única fonte, Agentic RAG adiciona latência e tokens sem benefício.

O teste empírico é simples: se single-pass RAG falha consistentemente em um tipo de query, e a análise de falha mostra que a informação necessária está em múltiplos documentos sem sobreposição temática suficiente para recuperação simultânea, Agentic RAG é justificado. Se o problema é qualidade de chunking ou embedding (a informação relevante existe mas não é recuperada), Agentic RAG não resolve — apenas aumenta o custo da busca ruim.

## Custo de full-context vs RAG em escala

A afirmação de que contextos de 1M tokens custam ~$15 por call com Opus estabelece o piso de custo para alternativas sem recuperação. Para knowledge bases de centenas de documentos (~500-1000 tokens por chunk × 1000 chunks = 500K-1M tokens), RAG com top-K=5 injeta 2.5-5K tokens por query — uma redução de 200-400x no custo de contexto. Em produção com milhares de queries diárias, essa diferença é a que determina viabilidade econômica do sistema.
