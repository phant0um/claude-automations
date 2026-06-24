---
title: Hierarchical Document Index
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags:
  - retrieval
  - document-structure
  - pageindex
  - tree-index
---

# Hierarchical Document Index

A tree-structured index over a document where each node represents a section with a title, page range, summary, and child nodes. Used as the retrieval substrate in [[03-RESOURCES/concepts/llm-ml-foundations/no-vector-retrieval]] systems.

## Construction (PageIndex Implementation)

1. PDF parsed per-page.
2. LLM detects TOC in first 20 pages.
3. Three fallback modes: TOC+pages → TOC-only → no-TOC.
4. `verify_toc()` runs LLM-based fuzzy matching; `fix_incorrect_toc_with_retries()` reattempts up to 3x.
5. Below 60% accuracy after all modes: raises `Processing failed`.
6. Nodes > 10 pages AND > 20k tokens are recursively split.

## Node Schema

```json
{
  "title": "Financial Stability",
  "node_id": "0006",
  "start_index": 21,
  "end_index": 22,
  "summary": "...",
  "nodes": [...]
}
```

## Why This Enables Vectorless Retrieval

The tree gives an LLM a compact structural map of the document. The LLM can reason "the answer is in section 3.2" without ever computing an embedding. See [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-retriever]].

## Related

- [[03-RESOURCES/concepts/llm-ml-foundations/no-vector-retrieval]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-retriever]]
- [[03-RESOURCES/entities/PageIndex]]
- [[03-RESOURCES/sources/memory-context-rag/pageindex-no-vectors-llm-reasoning-replaces-embeddings]]

## Evidências

- **[2026-06-21]** Notas morrem porque são capturadas num formato genérico que dificulta retrieval e ação. Um template específico para cada tipo de nota (não um template genérico universal) faz a decisão estrutural antes da captura, tornando a nota útil im... — [[500-obsidian-templates-that-turn-every-note-you-take-into-something-you-actually]]
