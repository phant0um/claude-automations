---
title: Foresight Arena
type: entity
categoria: platform
created: 2026-05-09
updated: 2026-05-19
tags: [prediction-markets, llm, benchmarking, on-chain, forecasting]
---

# Foresight Arena

Benchmark on-chain permissionless para agentes de forecasting, desenvolvido como companion ao paper de Nechepurenko & Shuvalov. Permite avaliação ao vivo de agentes LLM em mercados de eventos futuros reais.

## Características

- **Alpha Score** — métrica estritamente própria que mede vantagem sobre consenso de mercado; variância closed-form; análise de poder inclusa
- **Sandbox** — infraestrutura de teste sem gas costs (usada nos experimentos do paper com n=100 [[03-RESOURCES/entities/Polymarket]] markets)
- **On-chain production channel** — agentes do paper rodam ao vivo em Foresight Arena acumulando predições com web-search habilitado

## Relevância metodológica

O sandbox provê tooling idêntico ao benchmark on-chain (metadata de mercado, price history, web-search configurável) permitindo ablações em escala. O canal de produção serve como **replicação independente** dos resultados em regime de informação diferente (web-search vs. estático).

## Conexões

- [[03-RESOURCES/entities/Devnull-FZCO]]
- [[03-RESOURCES/entities/Polymarket]]
- [[03-RESOURCES/concepts/finance-trading/brier-score]]
- [[03-RESOURCES/concepts/learning-cognition/murphy-decomposition]]
- [[03-RESOURCES/sources/ai-agents-harness/coordination-architectural-layer-multi-agent-prediction-markets]]
