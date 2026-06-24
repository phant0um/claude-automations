---
title: "RAG Architecture"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# RAG Architecture

Pipeline de componentes modulares que transforma documentos brutos em respostas fundamentadas — cada estágio tem trade-offs de qualidade e custo.

## O que é

A arquitetura RAG descreve os blocos funcionais necessários para construir um sistema de recuperação-augmented generation: desde a ingestão de documentos até a geração final da resposta.

## Como funciona

**Componentes do pipeline:**

| Componente | Função |
|---|---|
| Document Loader | Lê PDFs, HTMLs, .md, bancos de dados |
| Chunker | Divide documentos em segmentos indexáveis |
| Embedder | Converte chunks em vetores numéricos |
| Vector Store | Armazena e indexa embeddings para busca ANN |
| Retriever | Busca os k chunks mais similares à query |
| Reranker | Reordena chunks por relevância (cross-encoder) |
| Generator | LLM que sintetiza resposta com contexto recuperado |

**Estratégias de chunking:**
- _Fixed-size_: janela de N tokens com overlap. Simples, mas corta semântica.
- _Recursive_: divide por marcadores hierárquicos (parágrafo → frase). Padrão LangChain.
- _Semantic_: agrupa frases por similaridade de embedding. Maior custo, melhor coesão.

**Modelos de embedding:** `text-embedding-3-small` (OpenAI), `nomic-embed-text`, `bge-m3` (multilingual). Dimensão típica: 768–1536.

**Vector DBs:** Pinecone (managed, escalável), Qdrant (self-hosted, filtros ricos), Chroma (local/dev), pgvector (Postgres — sem infra extra).

## Por que importa

Escolhas de arquitetura têm impacto direto em recall (quantos chunks relevantes são recuperados) e precision (quantos recuperados são realmente úteis). Um chunker mal configurado destrói qualidade independente do LLM usado.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/rag]]
- [[03-RESOURCES/concepts/rag-patterns]]
