---
title: "LightRAG: Simple and Fast Retrieval-Augmented Generation (HKUDS/EMNLP2025)"
type: source
created: 2026-05-28
ingested: 2026-05-28
tags: [rag, lightrag, knowledge-graph, retrieval, emnlp, graph-rag, llm-retrieval]
source_url: "https://github.com/HKUDS/LightRAG"
author: "HKUDS Lab"
published: 2024-10
---

# LightRAG: Simple and Fast Retrieval-Augmented Generation

## Tese Central

LightRAG supera NaiveRAG, RQ-RAG, HyDE e GraphRAG em comprehensiveness, diversity e empowerment usando dual-level retrieval (local + global) sobre um knowledge graph construído por LLM — resultado publicado em EMNLP 2025, repositório com >13K estrelas.

## Key Insights

- **Arquitetura dual-level:** indexação produz knowledge graph de entidades e relações extraídas pelo LLM; queries usam retrieval em dois níveis — local (entidades específicas) e global (temas transversais).
- **Requisitos de LLM:** mínimo 32B parâmetros, contexto 32K–64K; modelos de reasoning não recomendados na fase de indexação (mais lentos, piores na extração de entidades); modelos mais fortes na query que na indexação.
- **Embeddings obrigatórios:** `BAAI/bge-m3` ou `text-embedding-3-large`; embedding model deve ser fixo antes de indexar — mudança requer reconstrução das tabelas vetoriais.
- **Performance vs GraphRAG:** LightRAG supera GraphRAG em Diversity (77.2% vs 22.8% em Agriculture) e empata/perde levemente em Comprehensiveness em domínio "Mix". GraphRAG ainda competitivo em Comprehensiveness em alguns domínios.
- **Stack 2026:** Merge com RagAnything (multimodal — PDF, imagens, tabelas, fórmulas via MinerU/Docling); 4 estratégias de chunking (Fix, Recursive, Vector, Paragraph); integração com OpenSearch, PostgreSQL, MongoDB, Neo4j; suporte RAGAS para eval e Langfuse para tracing.
- **Role-specific LLM config:** 4 papéis distintos (EXTRACT, QUERY, KEYWORDS, VLM) com configurações independentes de LLM — permite modelo barato para extração, modelo forte para query.
- **Deploy:** `uv tool install "lightrag-hku[api]"` ou Docker Compose; wizard de setup interativo via `make env-base`.

## Implicações para o Vault

- Alternativa concreta ao RAG vetorial simples para o vault quando escalar além de 500K tokens.
- Dual-level retrieval resolve exatamente o problema descrito em `clipping-why-karpathys-second-brain-breaks-at-agent-scale`.
- Integração possível via Obsidian local API + LightRAG Server (Ollama compatible interface).

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/vector-search]] — LightRAG combina vector search com graph traversal
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — alternativa de retrieval em escala
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/clipping-why-karpathys-second-brain-breaks-at-agent-scale-how-mercury]]
