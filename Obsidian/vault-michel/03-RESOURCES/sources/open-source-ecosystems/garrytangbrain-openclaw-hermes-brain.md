---
title: "garrytan/gbrain: Garry's Opinionated OpenClaw/Hermes Agent Brain"
type: source
source: "Clippings/garrytangbrain Garry's Opinionated OpenClawHermes Agent Brain.md"
created: 2026-05-22
ingested: 2026-05-23
tags: [knowledge-graph, agent-brain, open-source, garry-tan, obsidian-style]
score: 8
---

## Tese central
GBrain: knowledge graph auto-wiring com hybrid search (vector + graph) para AI agents — construído por Garry Tan (CEO Y Combinator) para seus agentes reais. 146K+ pages, 24K+ people, 5K+ companies, 66 cron jobs autônomos. Benchmark: P@5 49.1%, R@5 97.9% — +31.4 pontos sobre variante sem graph.

## Argumentos principais
- Agent "smart but forgetful" → GBrain dá memória persistente auto-wiring
- Cada write de página: extrai entity references + cria typed links automaticamente (SEM LLM calls)
- Typed relationships: attended, works_at, invested_in, founded, advises
- Hybrid search: vector + graph → responde "who works at Acme AI?" que vector-only não consegue
- Zero LLM calls para wiring de links → eficiência de custo

## Key insights
- **Self-wiring knowledge graph**: nenhum agente externo necessário para criar links — acontece no write
- **ZeroEntropy default (v0.36.2.0)**: `zembed-1` (1280d Matryoshka) + `zerank-2` — 2.2× mais rápido, 2.6× mais barato que OpenAI
- **BrainBench**: P@5 49.1%, R@5 97.9% em corpus Opus 240 páginas
- **+31.4 pontos P@5** vs variante sem graph — graph retrieval é crítico para precisão
- Ingestão: meetings, emails, tweets, calls, ideias → entity enrichment automático overnight
- "Wake up smarter than when you went to bed" — sistema compound continuamente

## Exemplos e evidências
- 146,646 pages + 24,585 people + 5,339 companies em uso real
- 66 cron jobs autônomos rodando
- Benchmark: +31.4 P@5 vs no-graph; beats ripgrep-BM25 + vector-only RAG
- ZeroEntropy: 442ms vs OpenAI 973ms; $0.05/M vs $0.13/M

## Implicações para o vault
O vault opera com lógica similar (wikilinks como typed links manuais). GBrain é a versão programática do que o vault faz manualmente. Inspiração para: (1) automated entity extraction no ingest, (2) typed link taxonomy (attended/works_at/invested_in), (3) hybrid search no vault.

## Links
- [[03-RESOURCES/sources/open-source-ecosystems/garrytangstack-23-tools-ceo-qa]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/huytieu-cog-second-brain]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/entities/Garry Tan]]
