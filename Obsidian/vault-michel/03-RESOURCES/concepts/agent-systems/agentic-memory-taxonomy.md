---
title: "Agentic Memory Taxonomy"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, memory]
status: developing
---

# Agentic Memory Taxonomy

A structured classification of the memory types available to an AI agent — from in-context scratch space to long-term external knowledge stores.

## O que é / What it is

Agent memory is not monolithic. Different memory types have different scopes, persistence, and access patterns. A taxonomy makes it possible to reason precisely about which memory to use for which purpose.

## The 4-Layer Taxonomy

| Layer | Also called | Scope | Persistence |
|-------|-------------|-------|-------------|
| Short-term | Working memory, in-context | Current context window | Session only |
| Long-term | External memory | Files, DBs, vector stores | Permanent |
| Episodic | Action memory | Past run logs, error history | Permanent |
| Semantic | Knowledge base | Facts, concepts, entities | Permanent |

## TsinghuaC3I Mapping (ST/LT/Experience)

An alternative mapping common in Chinese AI research literature:
- **Short-term (ST):** Current context + recent tool outputs
- **Long-term (LT):** External knowledge base
- **Experience:** Logged past runs, errors, corrections

## Vault Mapping

| Vault artifact | Memory type |
|---------------|-------------|
| `04-SYSTEM/wiki/hot.md` | Short-term (warm cache injected at session start) |
| `03-RESOURCES/sources/` | Long-term semantic memory |
| `04-SYSTEM/wiki/errors.md` | Episodic / action memory |
| `.raw/.manifest.json` | Episodic (what has been processed) |
| `~/.claude/projects/.../memory/` | Long-term agent memory (token-savior) |

## Por que importa

Knowing which memory type to use prevents context bloat (putting everything in ST) and knowledge loss (forgetting to persist to LT). The vault's hot.md optimization strategy, manifest pattern, and errors log are all deliberate choices in this taxonomy.

## Related
- [[03-RESOURCES/concepts/action-memory]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/ai-agents]]
- [[03-RESOURCES/concepts/long-horizon-agents]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
