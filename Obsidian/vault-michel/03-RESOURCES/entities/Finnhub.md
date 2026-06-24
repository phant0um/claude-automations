---
title: Finnhub
type: entity
created: 2026-04-24
updated: 2026-04-24
tags: [api, market-data, fintech, stock-market]
---

# Finnhub

**URL:** [finnhub.io](https://finnhub.io)
**API Base:** `https://finnhub.io/api/v1`

## O que é

API de dados de mercado financeiro. Fornece símbolos de ações, perfis de empresas, preços e notícias de mercado. Tier gratuito suportado, mas dados em tempo real podem exigir plano pago.

## Uso no OpenStock

- Stock search e company profiles
- Market news
- Configurado via `NEXT_PUBLIC_FINNHUB_API_KEY` (exposto ao browser) e `FINNHUB_BASE_URL`
- Free tier pode retornar quotes com delay; respeitar rate limits e termos de uso

## Conexões

- [[03-RESOURCES/sources/financial-trading/openstock-open-source-stock-market-app]] — principal consumidor documentado
- [[03-RESOURCES/entities/TradingView-MCP]] — complementar (charts/widgets vs dados brutos)
