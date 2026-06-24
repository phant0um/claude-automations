---
title: Semantic File System
type: concept
status: developing
created: 2026-05-05
updated: 2026-05-05
tags:
  - ai-agents
  - enterprise-ai
  - knowledge-graph
  - memory
  - company-brain
---

# Semantic File System

A semantic file system is a memory layer where **artifacts are not just blobs of text** — the relationships around an artifact matter as much as the artifact itself. It is the storage model required for durable [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]] in a [[03-RESOURCES/concepts/pkm-obsidian/company-brain]].

Coined in this context by [[03-RESOURCES/entities/Ashwin-Gopinath]]: [[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-2-factual-memory]]

## Definition

> "A memory layer where artifacts are not just blobs of text. The relationships around the artifact matter as much as the artifact itself."

Example relationship chain:
```
customer call → account → open issues → tickets → product areas → owners → decisions
```

Each node in the chain is an artifact. Each arrow is a typed relationship. Traversing the chain is what enables questions like "What should I know before picking up the billing integration?"

## What It Is More Than

- More than a knowledge graph pasted on top of documents
- More than markdown with metadata
- More than RAG / embedding-based retrieval

The **quality of relationships** determines the quality of memory.

## Why It's Needed

RAG retrieval fails when meaning has to persist across:
- Time (freshness, what's stale vs. current)
- Roles (permissions, who can see what)
- Ownership changes (who owns this now vs. when it was created)
- Contradictions (is this contradicted by something newer?)

A semantic file system tracks all of these as first-class properties of the relationship graph, not as metadata tags on flat documents.

## Relation to Knowledge Graphs

A knowledge graph tracks entities and their typed relations. A semantic file system is similar but scoped to organizational work artifacts — documents, tickets, calls, decisions, commits — and must additionally track:

- **Provenance** (creation, modification chain)
- **Permissions** (visibility per person/role)
- **Freshness signals** (last-verified, superseded-by)
- **Source-of-truth status** (working hypothesis vs. official policy)

## Interface Implications

> "The interface cannot only be chat. It should be mutable. It should show up inside the work itself."

A semantic file system enables a proactive interface that surfaces the right facts at the moment of work, not just in response to a search query.

## Comparison to Existing Wiki Concepts

| Concept | Relation |
|---------|----------|
| [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — graph-vector hybrid (Layer 4) | Closest technical analog; Company Brain adds permissions and provenance |
| [[03-RESOURCES/concepts/llm-ml-foundations/vector-search]] | Necessary but not sufficient; retrieves semantically similar fragments, not relationship traversal |
| [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] | Semantic file system is the retrieval substrate that context engineering draws from |

## Related

- [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]] — what the semantic file system stores
- [[03-RESOURCES/concepts/pkm-obsidian/company-brain]] — the system that uses it
- [[03-RESOURCES/entities/Cognee]] — open-source graph-vector hybrid (individual agent scale)
- [[03-RESOURCES/entities/Sentra-AI]] — building this at enterprise scale
