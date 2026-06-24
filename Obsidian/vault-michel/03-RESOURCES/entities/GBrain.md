---
title: "GBrain"
type: entity
category: tool
tags: [entity, tool, knowledge-graph, ai-memory, open-source]
created: 2026-05-31
updated: 2026-06-01
---

# GBrain

**GitHub:** github.com/garrytan/gbrain · por Garry Tan

Knowledge graph auto-wiring criado por Garry Tan (CEO Y Combinator) para memória persistente de agentes — extrai entity references e cria typed links automaticamente no write, sem LLM calls.

## Contribuições relevantes

- Self-wiring knowledge graph: cada write extrai entity references + cria typed links (SEM LLM calls)
- Typed relationships: attended, works_at, invested_in, founded, advises
- Hybrid search: vector + graph — responde "who works at Acme AI?" que vector-only não consegue
- Em produção: 146.646 páginas, 24.585 pessoas, 5.339 empresas, 66 cron jobs autônomos
- ZeroEntropy default: `zembed-1` (1280d) + `zerank-2` — 2.2× mais rápido, 2.6× mais barato que OpenAI

## Fontes no vault

- [[03-RESOURCES/sources/open-source-ecosystems/garrytangbrain-openclaw-hermes-brain]] — arquitetura, benchmark BrainBench, implementação
- Related: [[03-RESOURCES/entities/Garry Tan]]
