---
title: PageIndex
type: entity
subtype: project
created: 2026-05-09
updated: 2026-05-09
tags:
  - pageindex
  - retrieval
  - rag-alternative
  - no-vectors
  - open-source
---

# PageIndex

Vectorless RAG framework by [[03-RESOURCES/entities/VectifyAI]]. Replaces embedding + vector-store retrieval with LLM reasoning over a hierarchical document tree.

- **Repo:** https://github.com/VectifyAI/PageIndex (+29k stars, MIT, ~2,579 lines Python)
- **Released:** April 1, 2025
- **Language:** Python
- **License:** MIT

## Architecture

Two-phase pipeline: (1) tree index construction from PDF, (2) reasoning-based retrieval via three agent tool functions. See [[03-RESOURCES/concepts/pkm-obsidian/hierarchical-document-index]] and [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-retriever]].

## Benchmark

Mafin 2.5 (PageIndex-powered financial QA) — 98.7% on FinanceBench full 10,231-question set, across GPT-4o and DeepSeek v3.

## Limitations

MCTS cloud-only; no OSS OCR; 3-retry TOC cap; no SECURITY.md.

## Source

[[03-RESOURCES/sources/memory-context-rag/pageindex-no-vectors-llm-reasoning-replaces-embeddings]]
