---
title: "Goodbye RAG! AI Knowledge Bases Need SAG — Fast and Accurate"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - source
  - ai-agents
  - rag
  - sag
  - knowledge-base
  - multi-hop-reasoning
  - sql
  - retrieval
---

author: [[@aikangarooking]]
source: https://x.com/aikangarooking/status/2069325659105861926
published: 2026-06-23

original_title: "再见RAG！AI知识库还得是SAG，又快又准～"

## Central Thesis

Traditional RAG is a black box for tuning — you don't know what changing a parameter will break ("press the gourd and the scoop pops up"). More critically, traditional RAG fails at **multi-hop reasoning** — connecting clues across multiple documents that share no literal or semantic overlap. SAG (SQL-Retrieval Augmented Generation with Query-Time Dynamic Hyperedges), a newly open-sourced architecture from Zleap, solves this by converting documents into "event-entity" index cards stored in a SQL database, then using SQL JOINs at query time to dynamically assemble local relationship networks. This replaces GraphRAG's expensive offline knowledge graph construction with query-time SQL dynamic activation — achieving 80.04% Recall@5 on MuSiQue (vs HippoRAG 2's 65.13%), being model-agnostic, fully explainable, and deployable at 500M+ records with sub-second latency.

## Key Arguments

### The Problem: RAG is a Black Box and Fails at Multi-Hop Reasoning

**Tuning is a black box.** You lower the filter score → retrieve more information but introduce noise. Press one thing, another pops up. A six-person team spent six months tuning a knowledge base to acceptable accuracy — not because they lacked ability, but because traditional RAG tuning is inherently opaque and fuzzy.

**Multi-hop reasoning fails.** Example:
- Document 1: "In 2023, Company A fully acquired Company B."
- Document 2: "Zhang San was appointed CTO of Company A."
- Document 3: "In 2024, Zhang San left and joined the Pangu Large Model project."

Question: "The company that acquired Company B — where did its CTO go?"

Traditional vector/hybrid retrieval finds Doc 1 and Doc 2 (keywords "acquired," "B company," "CTO" match). It will **never** find Doc 3, because Doc 3 contains none of those words — literal and semantic overlap is zero. The chain breaks. Answer: "Sorry, no relevant content found."

Meeting minutes and similar enterprise scenarios are full of these multi-hop retrieval needs.

### Why Not GraphRAG?

GraphRAG is too heavy:
- Requires massive LLM calls before ingestion to extract triples (who-did what-to whom)
- Builds entire corpus knowledge graph offline
- Index cost alone can burn tens of thousands of RMB for a medium dataset
- Any new file may require rebuilding relationships — maintenance cost is very high

### SAG: The Third Path

SAG doesn't build a global relationship graph. On document upload, it uses AI to distill each document fragment into an **"event card"** (recording what happened) and extract **entities** (company names, person names, project names). These are stored in a SQL database and vector store.

At query time, SQL JOINs dynamically pull out events sharing common entities, forming a local relationship network in real time — chaining multi-hop clues.

**How SAG handles the example:**
1. SAG does vector semantic search (like normal RAG) — finds most semantically relevant passages
2. Simultaneously extracts entities "Company B" and "CTO" from the question, queries SQL for events involving these entities → hits Doc 1 and Doc 2
3. **Critical step SAG does that RAG can't:** scans the hit documents (1 and 2), discovers a **new entity "Zhang San"** — a name that never appeared in the original question but is the connection point between the two documents
4. Database automatically triggers second-round query: "which events involve Zhang San" → hits Doc 3
5. All three documents in hand + vector search results → LLM assembles final answer

Normal RAG stops after vector search (finds Doc 1 and 2 but never discovers "Zhang San" as a new clue to follow). SAG adds the entity-association chain on top of vector search — mining new clues from found content and continuing to search, making multi-hop reasoning deterministic rather than luck-based.

### SAG vs FastGPT Hybrid Retrieval

FastGPT's "full-text + vector + reranking" is the mature industrial standard RAG. For single-document Q&A, it's sufficient and fast. The difference is the SQL part — SAG's multi-hop reasoning is stronger. For cross-document logical chaining, FastGPT (essentially flat similarity matching) hits its physical limit; SAG's SQL structure backs it up.

### Key Advantages of SAG

**Explainability:** Traditional RAG retrieval is a black box — you might only know "similarity insufficient." SAG's retrieval chain is fully traceable SQL call records: what entities the LLM extracted → which synonym expansions hit → which SQL path was traversed. Engineers can locate and fix breakages at a glance. This is revolutionary for tuning — traditional RAG tuning is like "alchemy" (change chunk size, change vector model, change reranker threshold — fix one, break another). SAG tuning is like "finding and fixing bugs" — check logs, find the specific problem point, fix it. Cuts 80% of blind-groping time.

**Ingestion logic transformation:** Traditional RAG spends enormous time on chunking (500 chars? 1000? overlap?). If chunking splits "Zhang San responsible for Project A" and "500M budget" into different chunks, the chain breaks. SAG front-loads this: before ingestion, AI distills content into complete "event cards" — one event per card, no chunking concerns. Ingested data is complete, retrieval accuracy is naturally higher.

**Model-agnostic:** Ablation study — researchers deliberately replaced SAG's vector model with a weak open-source model. Other advanced RAG solutions' accuracy dropped ~10%; SAG barely changed (still ~80%). Because SAG's primary clue-finding force is deterministic SQL entity association, not fuzzy vector distance. This matters for enterprise jargon — vector models don't know your company's internal terms, but as long as the entity is in SQL, it can be found without fine-tuning the vector model.

### Benchmark Results

SAG evaluated on three multi-hop reasoning standard datasets (HotpotQA, 2WikiMultiHop, MuSiQue):
- **MuSiQue Recall@5: 80.04%** (vs HippoRAG 2's 65.13% — ~15 percentage points higher)
- MuSiQue is the hardest: requires up to 4-hop combinational reasoning, no skipping intermediate steps —公认 "hell difficulty" for RAG

HippoRAG 2 (inspired by neuroscience's "hippocampal indexing theory") combines knowledge graphs with Personalized PageRank for multi-hop reasoning. But it also requires offline pre-built knowledge graph — depends on static global relationships. SAG pushes graph construction to query time, using SQL dynamic activation, avoiding global graph rebuild and maintenance overhead.

**Production:** SAG deployed in ~500M record production environment, online retrieval latency stays sub-second. Regular RAG OOMs or degrades at millions of records. SAG set new SOTA.

**Local deployment:** docker-compose available (author used Codex for one-click deployment). Tested with synthetic data — hit rate higher than expected.

### Practical Implementation: SAG + FastGPT

SAG is primarily a retrieval architecture. Building a complete knowledge base product from scratch requires: frontend, permissions, document parsing engine, deployment — large engineering effort, high risk of unfinished project for budget-constrained projects.

FastGPT offers mature conversation UI, permissions, WeChat/Feishu integration — instantly meets "usability" requirements.

**Recommended approach:** Use SAG as the knowledge base implementation on top of FastGPT. Reuse FastGPT's engineering maturity while SAG solves "chunk fragmentation" and "structured retrieval." Tuning becomes faster and easier.

Simplest integration: SAG as MCP tool, smoothly connected to FastGPT. Also connectable via MCP to Codex, Claude Code, and other local agents.

### RAG's Evolution Path

Pure vector retrieval → hybrid retrieval → GraphRAG (knowledge graph) → SAG (query-time SQL dynamic hyperedges, moving graph construction from offline to query time, using SQL relational database as dynamic organization layer).

Each step seems to add complexity, but SAG feels like a return to fundamentals. SQL relational databases have been used for decades — stable, explainable, maintainable. Bringing them into retrieval architecture actually lowers engineering difficulty. And for many enterprises, dev teams write SQL daily — integration is smooth.

**Innovation isn't always inventing something new — sometimes it's recombining proven tools in the right place.**

### SAG as Agent's Data Foundation

Agents often do multi-hop reasoning work: query A, use A's conclusion to decide to query B, each step's output is the next step's input. This is exactly what SAG solves.

Traditional RAG gives Agents "roughly relevant passages." SAG gives more deterministic structured events and entities — ready to reason with, without mining from similar text. Lower hallucination probability. And with precise, efficient queries, local small models can perform better.

## Key Insights

- **Multi-hop reasoning is the Achilles heel of traditional RAG.** Vector search finds documents with literal/semantic overlap but can't discover connection entities (e.g., "Zhang San") that never appear in the original question but link documents together.
- **SAG's key innovation: query-time dynamic SQL JOINs replace offline knowledge graph construction.** No expensive pre-building, no rebuilding on new files — relationships are assembled at the moment of query.
- **Explainability is revolutionary for tuning.** Traditional RAG tuning is alchemy; SAG tuning is debugging with traceable SQL logs. Cuts 80% of blind-groping time.
- **Event cards front-load the chunking problem.** AI distills complete events before ingestion — no chunk size concerns, no broken chains from bad splits.
- **Model-agnostic by design.** SAG's primary retrieval force is deterministic SQL entity association, not fuzzy vector distance. A weak vector model barely affects accuracy (~80% vs ~10% drop for competitors). Critical for enterprise jargon.
- **SAG set SOTA on MuSiQue: 80.04% Recall@5** (vs HippoRAG 2's 65.13%), deployed at 500M+ records with sub-second latency.
- **SAG + FastGPT is the practical path.** SAG as MCP tool on top of FastGPT's mature engineering — best of both worlds.
- **Agents need SAG as data foundation.** Multi-hop reasoning is what agents do. SAG gives structured, deterministic events and entities instead of "roughly relevant passages" — lower hallucination, better local model performance.
- **Innovation = recombining proven tools in the right place.** SQL is decades-old, stable, explainable. Bringing it into retrieval architecture is返璞归真 — a return to fundamentals that lowers engineering difficulty.

## Minha Síntese

Este artigo ressoa diretamente com meu trabalho no vault-michel. A limitação de RAG tradicional em multi-hop reasoning é exatamente o problema que enfrento quando preciso conectar conceitos espalhados por múltiplas source pages — a busca por similaridade semântica não encontra conexões que dependem de entidades compartilhadas mas não de palavras compartilhadas. A ideia de SAG de extrair "event cards" com entidades e usar SQL JOINs em query time é elegante porque transforma um problema fuzzy (encontrar relações semânticas) em um problema determinístico (SQL joins em entidades nomeadas).

A explicabilidade é o ponto que mais me interessa: poder ver exatamente qual entidade foi extraída, qual sinonímia expandiu, qual caminho SQL foi percorrido — isso é debug, não alquimia. Para um vault onde a qualidade da interconexão é fundamental, ter um mecanismo de retrieval rastreável é transformacional.

A recomendação prática de usar SAG como MCP tool sobre FastGPT é o caminho mais sensato — FastGPT resolve a camada de produto (UI, permissões, integrações) e SAG resolve a camada de retrieval. Para o contexto do vault, onde já uso Obsidian + Claude Code, a integração via MCP parece natural.

O ponto final sobre SAG como "data foundation for Agents" é o mais provocativo: se agents fazem multi-hop reasoning por natureza (query A → use A → query B), então SAG não é apenas uma alternativa ao RAG, é a infraestrutura necessária para que agents operem com precisão sobre bases de conhecimento privadas.

## Related Concepts

- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/ai-agents/agent-memory-architecture]]
- [[03-RESOURCES/concepts/ai-agents/mcp-server-pattern]]
- [[03-RESOURCES/concepts/pkm-obsidian/company-brain]]