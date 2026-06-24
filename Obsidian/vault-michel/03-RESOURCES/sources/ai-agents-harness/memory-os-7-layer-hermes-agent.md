---
title: "ClaudioDrews/memory-os — 7-Layer Memory OS for Hermes Agent"
type: source
source: "Clippings/ClaudioDrewsmemory-os A 7-layer memory operating system for Hermes Agent — persistent memory with Qdrant, structured facts, fabric recall, auto-curated wiki, and surgical context injection. Runs locally, any LLM provider..md"
created: 2026-06-02
ingested: 2026-06-02
tags: [ai-agents, memory, hermes-agent, qdrant, vector-db, context-injection]
---

## Tese central
Memory OS é uma infraestrutura de memória de 7 camadas para o Hermes Agent que resolve o problema central de agentes: cada sessão começa do zero. Roda localmente (Docker + Qdrant + Redis), agnóstico a provider, com injeção cirúrgica de contexto.

## Argumentos principais
- Problema raiz: agente esquece entre sessões — repetição de contexto, perda de decisões importantes, fatos estruturados sem lugar
- 7 camadas em concerto: flat files → vector DB, com Ground Truth hierarchy explícita que instrui o agente a usar a memória injetada
- Injeção cirúrgica: só o contexto relevante ao momento é injetado — não a memória toda (economia de tokens)
- Wiki auto-curada: pipeline de knowledge que se organiza sozinho
- Sem vendor lock-in: funciona com qualquer LLM provider suportado pelo Hermes (OpenRouter, Anthropic, Ollama, etc.)
- Trust scoring para fatos estruturados — resolução de entidades com HRR + FTS5

## Arquitetura — 7 camadas
1. **WORKSPACE** (Layer 1): MEMORY.md, USER.md, CREATIVE.md — injetados no system prompt a cada turno
2. **SESSIONS** (Layer 2): state.db (SQLite + FTS5) — busca full-text em todo histórico de conversas
3. **STRUCTURED FACTS** (Layer 3): memory_store.db (SQLite + HRR + FTS5 + trust scoring) — fatos duráveis com resolução de entidades
4. **VECTOR SEMANTIC** (Layer 4, presumido): Qdrant — busca semântica cross-session
5. **FABRIC RECALL** (Layer 5): recall de padrões e hábitos
6. **WIKI PIPELINE** (Layer 6): wiki auto-curada — organização automática de conhecimento
7. **CONTEXT INJECTION** (Layer 7): coordenação cirúrgica — o que injetar, quando, quanto

## Key insights
- Ground Truth hierarchy é a peça crítica: sem ela, o agente recebe memória mas ignora
- Surgical injection > dump completo: injetar só o relevante = qualidade e economia de tokens
- SQLite + FTS5 para histórico + Qdrant para semântica: tier certo para cada tipo de busca
- Self-curating wiki: agente contribui de volta para o sistema — memória se melhora com uso
- Arquitetura local-first: nenhum dado sai da máquina, nenhum custo de memória recorrente

## Exemplos e evidências
- Requirements: Hermes Agent + Docker (Qdrant + Redis + ARQ Worker) + Python 3.11+
- Compatível com todos providers que Hermes suporta
- Problema documentado: "Repeating context at the start of every conversation" — dor validada em produção

## Implicações para o vault
- vault-michel já implementa princípios similares: hot.md (Layer 1), sessions/ (Layer 2), sources/ (Layer 3)
- Lacuna: vault não tem vector semantic search (Qdrant equivalente) — candidato a melhoria futura
- Surgical injection via hot.md + nexus gate já resolve Layer 7 de forma mais simples
- Conceito de self-curating wiki alinha com hill + extend no vault

## Links
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[04-SYSTEM/wiki/hot.md]]
