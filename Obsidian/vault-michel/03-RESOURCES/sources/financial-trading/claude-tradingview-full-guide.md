---
title: "How to Connect Claude to TradingView (FULL GUIDE)"
type: source
source_file: .raw/articles/How to Connect Claude to TradingView (FULL GUIDE).md
author: Miles Deutscher (@milesdeutscher)
ingested: 2026-04-17
tags: [tradingview, claude, mcp, trading, finance, technical-analysis, pine-script, automation]
triagem_score: 5
---

# How to Connect Claude to TradingView (FULL GUIDE)

**Autor:** [Miles Deutscher (@milesdeutscher)](https://x.com/milesdeutscher)  
**Crédito técnico:** [@Tradesdontlie](https://x.com/Tradesdontlie)  
**Repo MCP:** [github.com/tradesdontlie/tradingview-mcp](https://github.com/tradesdontlie/tradingview-mcp)

> [!summary]
> Setup para conectar Claude Code ao TradingView Desktop via MCP (Model Context Protocol), dando ao Claude acesso aos dados reais dos gráficos em tempo real — não screenshots, mas os valores subjacentes, como o console de um developer lê uma webpage.

## Como Funciona

TradingView não tem API pública. A solução é um **TradingView MCP** que expõe os dados internos do app desktop via debug port. Claude lê os valores reais (não imagens), podendo analisar e agir sobre eles.

> [!info]
> MCPs (Model Context Protocol) permitem que LLMs acessem data streams externos. Claude não precisa "adivinhar" o que está num screenshot — lê os dados diretamente.

## Requisitos

- Claude Code instalado
- Node.js 18+
- TradingView Desktop (tradingview.com/desktop)
- Subscription pago do TradingView (dados real-time)

## Setup em 2 Passos

**Passo 1 — Instalar o MCP:**
```
"Install the TradingView MCP server. Clone and explore 
https://github.com/tradesdontlie/tradingview-mcp, run npm install, 
add to my MCP config at ~/.claude/.mcp.json, and launch TradingView 
with the debug port."
```

**Passo 2 — Health Check:**
```
"Use tv_health_check to confirm TradingView is connected."
```

## Casos de Uso Reais

| Use Case | Exemplo de Prompt |
|---|---|
| Live Price Data | "Overlay live price of $BTC vs $SOL — which is outperforming today?" |
| Market Research | "Take a screenshot of SP500. Give me a detailed research report." |
| Source Indicators | "Source the best indicators for volume, 100D MA, volatility index." |
| Technical Analysis + Drawing | "Conduct TA on Bitcoin. Draw what you see on my charts." |
| Price Alerts | "Set alerts for $BTC above $75K, SP500 ATH, and dip opportunities in watchlist." |
| Backtesting | Use Replay Mode via Claude |
| Pine Script | Custom indicator development |

## Observações Práticas (do autor)

> [!warning]
> - É necessário "babysit" Claude em cada ação — pode ser mais lento que fazer manualmente para tarefas simples
> - Alguns prompts levam 10+ minutos
> - Consome tokens Claude — usar para tarefas de alta alavancagem (estratégias, Pine Scripts), não para mudar timeframe

## Tip Avançado

Combinar com **Claude Dispatch/Remote Control/Scheduled Tasks** para:
- Escanear watchlist toda manhã autonomamente
- Relatório de alertas disparados overnight
- Acesso remoto ao TradingView MCP on-the-go

## Relações no Vault

- [[03-RESOURCES/entities/Claude Code]] — client MCP
- [[03-RESOURCES/entities/TradingView-MCP]] — nova entidade, repo @Tradesdontlie
- [[03-RESOURCES/entities/Miles-Deutscher]] — autor
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — protocolo base
- [[03-RESOURCES/concepts/finance-trading/prediction-markets]] — contexto de mercados financeiros
