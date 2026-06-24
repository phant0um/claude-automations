---
title: CoinGecko
type: entity
category: API / data provider
tags: [crypto, data, api, trading]
created: 2026-04-18
updated: 2026-05-19
---

# CoinGecko

Principal API de dados cripto, usada como data layer em agentes de trading. Cobre o maior universo de ativos do mercado.

## Cobertura

- **30M+** tokens/ativos cripto
- **1.700+** exchanges (CEX e DEX)
- **250+** redes blockchain

## Dados disponíveis

- Preços real-time (REST + WebSocket streaming)
- OHLCV histórico (para backtesting)
- Onchain pool analytics (DEX pools, liquidity, volume)
- Trending tokens e top onchain traders
- Notícias de cripto (100+ fontes, 30+ idiomas, tagueadas por coin)
- Dados de detentores (holder distribution)

## Formas de integração

| Método | Quando usar |
|---|---|
| **CLI** (recomendado para agents) | Bulk data, backtesting, WebSocket streaming; mais token-efficient |
| **REST API** | Requisições pontuais, workflows customizados |
| **MCP server** | Integração com Claude Desktop / OpenClaw MCP mode |
| **x402 pay-per-use** | Paga por chamada em USDC (Base ou Solana); sem subscription |

**Regra:** para agentes de trading, CLI > MCP — suporta WebSocket nativo, output JSON estruturado, significativamente mais token-efficient para operações em bulk.

## Planos e endpoints exclusivos

| Plano | Endpoints extras |
|---|---|
| Demo (gratuito) | Endpoints básicos de preço e metadados |
| Analyst+ | Pools Megafilter, Top Token Traders, WebSocket sub-segundo |

## Endpoints chave para trading agents

```bash
# Preço real-time (WebSocket)
CGSimplePrice WebSocket  # benchmark agregado de todas as exchanges

# Onchain pools
GET /onchain/networks/{network}/pools/megafilter     # 25+ filtros de qualidade/segurança
GET /onchain/networks/{network}/pools/trending_pools
GET /onchain/networks/{network}/pools/new_pools

# Traders
GET /onchain/networks/{n}/tokens/{address}/top_traders

# OHLCV histórico
GET /coins/{coin_id}/market_chart?vs_currency=usd&days={days}

# Exchange tickers
GET /exchanges/{exchange_id}/tickers?coin_ids=<token>

# Notícias
GET /news
```

## CLI

```bash
# Instalar
curl -fsSL https://raw.githubusercontent.com/coingecko/coingecko-cli/main/install.sh | sh

# Autenticar
cg auth

# Instalar Skill completa para OpenClaw (80+ endpoints)
cg skill install
# instala em ~/.openclaw/workspace/skills/coingecko-api
```

## Ver também

- [[03-RESOURCES/entities/OpenClaw]] — framework de AI agent que usa CoinGecko como data layer
- [[03-RESOURCES/concepts/agent-systems/crypto-trading-agent]] — conceito central
- [[03-RESOURCES/sources/financial-trading/how-to-build-openclaw-ai-crypto-trading-agent]]
- [[03-RESOURCES/entities/TradingView-MCP]] — alternativa para dados de mercado (TradingView)
