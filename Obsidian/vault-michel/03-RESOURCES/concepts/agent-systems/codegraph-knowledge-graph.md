---
title: "CodeGraph / Knowledge Graph for Code"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# CodeGraph / Knowledge Graph for Code

A graph of a codebase's symbols, dependencies, and call chains — built by Tree-sitter + LLM to enable semantic code navigation without reading every file.

## O que é / What it is

CodeGraph parses source code into a structured graph: functions, classes, and modules become nodes; imports, calls, and inheritance become edges. LLMs can then query the graph ("what calls `processPayment`?") instead of brute-force file reading, reducing token cost and improving accuracy.

## Como funciona

**Build pipeline:**
1. **Tree-sitter** parses source → AST per file
2. Symbol extractor identifies functions, classes, interfaces
3. Reference resolver links call sites to definitions
4. LLM adds semantic labels (what does this function do?)
5. Graph stored as JSON / sqlite with fast lookup

**Query patterns:**
- `get_dependents(symbol)` — what breaks if I change this?
- `get_call_chain(entry, target)` — how does execution reach this code?
- `find_symbol(name)` — where is this defined?
- `get_community(symbol)` — what cluster of related symbols?

**`/understand-knowledge` pattern:** Before editing, agent queries graph for impact radius. Prevents blind edits that break unseen callers.

## Padrões / Patterns

**Grafos que ensinam > grafos que impressionam:** A knowledge graph is only useful if it improves decisions. A pretty visualization that no agent queries is waste. The Karpathy standard: does the graph change what the agent does?

**Vault analog:** `hot.md` is a hand-curated knowledge graph for the vault — key pages, relationships, and hot concepts in a flat file. Same principle: reduce lookup cost for the most accessed nodes.

**Token savings:** A 500k-token codebase queried via graph costs ~1–2k tokens per question. Flat file search costs 50–100k tokens for the same answer.

## Related
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
