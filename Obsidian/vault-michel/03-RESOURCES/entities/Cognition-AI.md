---
title: Cognition AI
type: entity
subtype: organization
created: 2026-04-24
updated: 2026-04-24
tags: [ai-company, multi-agent, devin, windsurf]
---

# Cognition AI

**Website:** [cognition.ai](https://cognition.ai)
**Produtos principais:** [[03-RESOURCES/entities/Devin]] · Windsurf

## Descrição

Empresa de AI responsável pelo Devin (software engineering agent) e pelo Windsurf (editor de código AI-first).

## Pesquisa e Publicações Relevantes

- [Don't Build Multi-Agents](https://cognition.ai/blog/dont-build-multi-agents) — argumento original contra swarms
- [Multi-Agents: What's Actually Working](https://cognition.ai/blog/multi-agents-whats-actually-working) → [[03-RESOURCES/sources/ai-agents-harness/multi-agents-whats-actually-working]]
- SWE-1.5 / SWE-1.6 — modelos sub-frontier de software engineering; SWE-1.6 atinge Opus-4.5 level no SWE-bench

## Modelos

| Modelo | Velocidade | Nível | Nota |
|--------|-----------|-------|------|
| SWE-1.5 | 950 tok/sec | sub-frontier | gap muito amplo vs Sonnet 4.5 |
| SWE-1.6 | — | ~Opus-4.5 level (SWE-bench) | fecha parte do gap; smart friend começa a funcionar |

## Produtos e Capabilities (2026)

- **Auto-Triage:** triage automático de issues sem interação humana (2026)
- **Devin Review:** code review que fecha o loop via autofixes até diff ficar clean
- **Autonomous Testing (test mode):** Devin planeja, executa, anota e retorna artefatos (screenshots rotulados + test video com chapters + lista de assertions). Billing: 1/5 do custo normal. Mais sessões são agora triggered assincronamente do que interativamente.

## Fontes

- [[03-RESOURCES/sources/ai-agents-harness/verifying-agentic-development-at-scale-devin]] — end-to-end testing em VM cloud; test plans, testing skills, model routing

## Pessoas

- [[03-RESOURCES/entities/Walden-Yan]] — pesquisador, publicou posts sobre multi-agent
