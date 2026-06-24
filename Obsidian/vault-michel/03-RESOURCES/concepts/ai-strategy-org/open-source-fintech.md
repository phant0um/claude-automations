---
title: Open-Source Fintech
type: concept
status: developing
created: 2026-04-24
updated: 2026-04-24
tags: [fintech, open-source, market-data, nextjs]
---

# Open-Source Fintech

## Definição

Ferramentas financeiras construídas como software livre — alternativas a plataformas pagas como Bloomberg Terminal, Yahoo Finance Pro, ou Robinhood. Democratizam acesso a dados de mercado e análise técnica.

## Por que importa

Plataformas profissionais cobram $20k–$24k/ano (Bloomberg). Open-source com dados de free tier (Finnhub, TradingView widgets) entrega 80% da funcionalidade sem custo.

## Stack Comum

- **Dados:** Finnhub (free tier com delay) · Alpha Vantage · Yahoo Finance API
- **Gráficos:** TradingView widgets (embeddable, gratuito) · lightweight-charts
- **Backend:** Next.js App Router · MongoDB · Prisma
- **Auth:** Better Auth · NextAuth · Clerk (free tier)
- **Automação:** Inngest · Trigger.dev · BullMQ

## Exemplos no Vault

| Projeto | Stack | Diferencial |
|---------|-------|-------------|
| [[03-RESOURCES/sources/financial-trading/openstock]] | Next.js 15 + MongoDB + Finnhub + TradingView | AI-personalized emails, sentiment insights via Adanos |
| [[03-RESOURCES/sources/financial-trading/claude-tradingview-full-guide]] | TradingView MCP + Claude | MCP para dados em tempo real |
| [[03-RESOURCES/sources/financial-trading/how-to-build-openclaw-ai-crypto-trading-agent]] | CoinGecko + SKILL.md | Trading agent com estratégias modulares |

## Limitações

- **Rate limits:** Free tiers do Finnhub limitam dados em tempo real; real-time requer plano pago
- **AGPL-3.0:** Projetos como OpenStock exigem que deployments públicos liberem o código-fonte
- **Não são corretoras:** Sem execução de ordens; dados podem ter delay conforme provedor

## Conexões

- [[03-RESOURCES/concepts/agent-systems/crypto-trading-agent]] — trading agent como extensão lógica
- [[03-RESOURCES/concepts/finance-trading/prediction-markets]] — mercados de predição como caso adjacente
- [[03-RESOURCES/entities/Open-Dev-Society]] — organização que mantém OpenStock
- [[03-RESOURCES/entities/TradingView-MCP]] — camada de dados em tempo real
- [[03-RESOURCES/entities/CoinGecko]] — dados cripto para trading agents
