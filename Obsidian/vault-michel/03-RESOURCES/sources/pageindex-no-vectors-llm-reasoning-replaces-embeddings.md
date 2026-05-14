---
title: "+29k Stars, No Vectors: How PageIndex Replaces Embeddings With LLM Reasoning"
type: source
source_file: "clippings/+29k Stars, No Vectors How PageIndex Replaces Embeddings With LLM Reasoning 1.md"
author: "@AlphaSignalAI"
published: 2026-05-07
ingested: 2026-05-09
tags:
  - pageindex
  - retrieval
  - no-vectors
  - llm-reasoning
  - rag-alternative
  - embeddings
---

# +29k Stars, No Vectors: How PageIndex Replaces Embeddings With LLM Reasoning

## Thesis

[[03-RESOURCES/entities/PageIndex]] eliminates vector embeddings from document retrieval entirely. Instead of cosine-similarity nearest-neighbor lookup, it builds a hierarchical tree from a document and lets an LLM reason over the tree structure to select which pages contain the answer. [[03-RESOURCES/entities/VectifyAI]]'s benchmark system Mafin 2.5 — built on PageIndex — hits 98.7% on the full 10,231-question FinanceBench set.

## How PageIndex Works

### Phase 1 — Tree Index Construction

1. PDF parsed per-page via PyPDF2 or PyMuPDF.
2. LLM scans first 20 pages to detect a table of contents.
3. Three processing modes: TOC with page numbers → TOC without page numbers → no TOC.
4. `verify_toc()` runs LLM-based fuzzy title matching on every TOC item; `fix_incorrect_toc_with_retries()` reattempts up to 3 times.
5. If accuracy < 60%, system falls back to next mode; after all three fail, raises `Processing failed`.
6. Nodes > 10 pages AND > 20,000 tokens are recursively split with the same LLM extraction.

### Phase 2 — Reasoning-Based Retrieval

Three agent tool functions: `get_document()` (metadata), `get_document_structure()` (tree without text), `get_page_content()` (specific pages). The LLM receives the tree, selects node IDs in JSON, system fetches text, LLM writes the answer.

**MCTS gap:** Docs reference value-function Monte Carlo Tree Search. The open-source code ships only the LLM-prompt tree-search variant. MCTS is cloud-only.

## Comparison vs. Vector RAG

| Dimension | Vector RAG | PageIndex |
|---|---|---|
| Retrieval mechanism | Cosine similarity on embeddings | LLM reasoning over structural tree |
| Failure mode | Syntactic neighbors, not semantic answers | Tree construction failure on complex PDFs |
| Long-doc performance | Degrades on 600-page docs | Designed for structured long docs |
| Setup cost | Embedding model + vector store | LLM API calls at index + query time |
| MCTS | N/A | Cloud-only (OSS ships prompt-search only) |

PageIndex wins on: long structured documents (10-Ks, compliance binders, contracts). Loses on: latency-sensitive short-doc chat, scanned PDFs without OCR, tight API budgets.

## Current Limitations

- MCTS retrieval is cloud-only.
- No OCR — scanned PDFs need preprocessing.
- TOC verification capped at 3 retries; complex PDFs can hit the failure path.
- No SECURITY.md; 6 open security issues (LiteLLM supply-chain patched via `litellm==1.83.7`).
- 89.3% of 281 commits from 2 contributors — bus factor risk.

## AlphaSignal Verdict

"Worth Watching, not yet production-grade." Moves to Production Ready when: MCTS in OSS, SECURITY.md + external audit, team-published latency benchmark, OSS OCR parser.

## Conexoes

- [[03-RESOURCES/entities/PageIndex]] — the framework itself
- [[03-RESOURCES/entities/VectifyAI]] — org behind PageIndex
- [[03-RESOURCES/concepts/no-vector-retrieval]] — core architectural concept
- [[03-RESOURCES/concepts/llm-as-retriever]] — LLM doing retrieval reasoning instead of embedding lookup
- [[03-RESOURCES/concepts/hierarchical-document-index]] — the tree-building phase
- [[03-RESOURCES/concepts/optical-context-retrieval]] — adjacent retrieval concept in wiki
