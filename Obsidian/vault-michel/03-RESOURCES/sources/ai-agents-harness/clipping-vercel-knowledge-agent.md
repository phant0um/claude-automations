---
title: "vercel-labs/knowledge-agent-template"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, ai-agents, knowledge-base, file-search, rag-alternative, template, vercel]
score: 7
author: "Vercel Labs"
source_url: "https://github.com/vercel-labs/knowledge-agent-template"
domain: ai-agents-harness
---

# vercel-labs/knowledge-agent-template

Template open source para agentes baseados em file-system e knowledge base. Anti-RAG: sem embeddings, sem vector DB.

## Abordagem: File-Based Search

> "No vector database. No chunking pipeline. No embedding model."

Agentes usam `grep`, `find`, `cat` dentro de sandboxes isolados para buscar em todas as sources. Resultados determinísticos, explicáveis, instantâneos. Zero overhead de infraestrutura.

## Features

- **Multi-Platform**: um agente, vários destinos — web chat, GitHub Issues, Discord (+ Slack, Linear em breve)
- **Admin Panel**: usage stats, error logs, user management, source config, content sync
- **AI Admin Agent**: "What errors happened in the last 24h?" → usa tools internos (`query_stats`, `run_sql`, `chart`)
- **Complexity Router**: classifica query (trivial → complex) → rota para modelo certo automaticamente
- **Real-Time Tool Visualization**: UI mostra o que o agente está fazendo em tempo real (quais arquivos lê, comandos, tempos)
- **Sandbox Pool**: shared across users, startup < 100ms (pool pré-aquecido)

## Arquitetura

```
Sources (GitHub, YouTube, APIs) →
  File System (sandboxed) →
    Agent (grep/find/cat) →
      Smart Router →
        Response
```

## Por Que Anti-Embedding

- Embeddings introduzem degradação semântica
- Chunking choices afetam recall de forma não-previsível
- grep/cat = determinístico, auditável, sem cold start de vector index

## Relevância para o Vault

Filosofia alinhada com o vault-michel: file-system como knowledge base, search por grep/find, sem vector DB.

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-9-agentic-patterns]]
