---
title: LLM as Retriever
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags:
  - retrieval
  - llm-reasoning
  - rag-alternative
  - agentic-retrieval
---

# LLM as Retriever

Pattern where the LLM itself performs the retrieval decision — selecting which document sections to read — rather than a separate vector-similarity module. The LLM receives a structural representation (tree, outline, TOC) and emits node IDs or page ranges to fetch.

## Mechanism in PageIndex

1. LLM receives document tree via `get_document_structure()`.
2. LLM selects node IDs in a JSON response.
3. System fetches text for those nodes via `get_page_content()`.
4. LLM writes final answer from fetched content.

The retrieval step is a reasoning step, not a lookup step.

## Contrast with Vector RAG

In vector RAG, retrieval is a mathematical operation (ANN search on embeddings) that precedes any LLM call. In LLM-as-retriever, the LLM IS the retrieval function — trading vector-search latency for LLM-call cost.

## MCTS Extension

[[03-RESOURCES/entities/VectifyAI]]'s cloud service layers Monte Carlo Tree Search (value-function based) on top of LLM tree search, enabling deeper exploration of the document tree. The OSS [[03-RESOURCES/entities/PageIndex]] ships prompt-only tree search.

## Related

- [[03-RESOURCES/concepts/llm-ml-foundations/no-vector-retrieval]]
- [[03-RESOURCES/concepts/pkm-obsidian/hierarchical-document-index]]
- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]
- [[03-RESOURCES/sources/memory-context-rag/pageindex-no-vectors-llm-reasoning-replaces-embeddings]]
