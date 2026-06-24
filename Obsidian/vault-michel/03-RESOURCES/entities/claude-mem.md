---
title: claude-mem
type: entity
category: tool
updated: 2026-04-16
tags: [claude-code, memory, context, sqlite, vector-db]
created: 2026-05-31
---

# claude-mem

Ferramenta que resolve a perda de contexto entre sessões do [[03-RESOURCES/entities/Claude Code]]. Captura automaticamente decisões, bugs resolvidos e padrões via hooks de ciclo de vida.

## Instalação

```bash
npx claude-mem install
```

Requisitos: Node.js 18+, Claude Code mais recente, Bun (auto-instalado), uv (auto-instalado), SQLite 3.

## Como funciona

- 5 hooks de ciclo de vida capturam automaticamente o contexto relevante
- Armazenamento: SQLite local + Chroma vector DB
- Busca híbrida semântica
- Interface web em `localhost:37777`

## Workflow de busca (token-eficiente)

1. `search` → índice compacto com IDs (~50-100 tokens/resultado)
2. `timeline` → contexto cronológico ao redor dos resultados interessantes
3. `get_observations` → detalhes completos apenas dos IDs filtrados

## Privacidade

Tag `<private>` no conteúdo exclui esse trecho do armazenamento.

## Relação com Agent Memory Architecture

claude-mem é uma implementação da Layer 2 (markdown files) + busca semântica (Layer 3) do [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]. Limitação identificada no artigo "Build Agents that never forget": ao longo de semanas de uso, fatos mais antigos escorregam silenciosamente conforme o contexto acumula e é compactado. Para multi-hop queries, considerar [[03-RESOURCES/entities/Cognee]] (graph-vector híbrido).

## Fontes

- [[03-RESOURCES/sources/misc-low-confidence/claude-knowledge-digest-abril-2026]]
- [[03-RESOURCES/sources/memory-context-rag/build-agents-that-never-forget]] (referenciado como limitação)
