---
title: No-Vector Retrieval
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags:
  - retrieval
  - no-vectors
  - rag-alternative
  - embeddings
---

# No-Vector Retrieval

Retrieval architecture that eliminates vector embeddings and cosine-similarity search. Instead of finding chunks whose embedding is geometrically close to the query embedding, the system uses structural or reasoning-based mechanisms to select relevant content.

## Core Critique of Vector RAG

Vector RAG optimizes for syntactic proximity: the nearest-neighbor chunk "looks like" the query, not necessarily "answers" the query. For long structured documents (annual reports, compliance binders, technical specs), this gap compounds.

## PageIndex as Primary Example

[[03-RESOURCES/entities/PageIndex]] builds a hierarchical tree from the document and delegates section selection to LLM reasoning. No embedding model, no vector store in the retrieval path. See [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-retriever]] and [[03-RESOURCES/concepts/pkm-obsidian/hierarchical-document-index]].

## Trade-offs

| Advantage | Limitation |
|---|---|
| No embedding model needed | Higher LLM API cost per query |
| Works on structured long docs | Fails on unstructured/scanned PDFs without OCR |
| Reasoning over document structure | Slower than ANN vector lookup |

## Related

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-retriever]]
- [[03-RESOURCES/concepts/pkm-obsidian/hierarchical-document-index]]
- [[03-RESOURCES/concepts/llm-ml-foundations/optical-context-retrieval]]
- [[03-RESOURCES/sources/memory-context-rag/pageindex-no-vectors-llm-reasoning-replaces-embeddings]]
