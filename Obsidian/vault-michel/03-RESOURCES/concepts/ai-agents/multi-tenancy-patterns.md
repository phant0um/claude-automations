---
title: Multi-tenancy Patterns
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, multi-tenancy, architecture, isolation]
---

# Multi-tenancy Patterns

Patterns para servir múltiplos tenants com shared infrastructure e isolamento.

## Pool model

- Shared infrastructure, isolated tenants
- Cada tenant tem dados e contexto isolados
- Sem duplicação de infraestrutura

## Aplicação no vault

O vault é "silo" por área (FIAP, concurso, finance, AI agents). Pool model poderia otimizar shared infrastructure mantendo isolamento. Model-router é uma forma de multi-tenancy.

## Evidências

- [[03-RESOURCES/sources/articles/pool-model-multi-tenancy-bedrock-agentcore]] — Healthcare AI agents servindo múltiplas clínicas

## Links

- [[04-SYSTEM/agents/nexus-agent-system/model-router]]
- [[03-RESOURCES/sources/ai-agents/new-in-amazon-bedrock-agentcore]]