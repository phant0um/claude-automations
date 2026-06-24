---
title: Agent Copilot Pattern
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, copilot, assistant, pattern]
---

# Agent Copilot Pattern

Construir copilotos conversacionais que combinam 3 capacidades: parsing de linguagem natural, busca semântica, e geração de summaries.

## As 3 capacidades

1. **NL query parsing**: extrair structured search parameters de linguagem natural
2. **Vector similarity search**: sobre domain-specific embeddings
3. **AI-generated summaries**: resumos dos resultados de busca

## Paralelo com ingest-agent

O ingest-agent segue o mesmo pattern: classifica (parse) → busca concepts (search) → gera source page (summarize).

## Evidências

- [[03-RESOURCES/sources/articles/protein-research-copilot-bedrock-agentcore]] — Protein research copilot com 3 capacidades integradas

## Links

- [[04-SYSTEM/agents/nexus-agent-system/ingest-agent]]
- [[03-RESOURCES/sources/ai-agents/new-in-amazon-bedrock-agentcore]]