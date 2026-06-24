---
title: TradingView MCP
type: entity
categoria: ferramenta
tags: [tradingview, mcp, trading, claude-code, technical-analysis]
created: 2026-05-31
updated: 2026-05-19
---

# TradingView MCP

## O que é

Servidor MCP (Model Context Protocol) que expõe os dados internos do TradingView Desktop para LLMs como Claude. Criado por [@Tradesdontlie](https://x.com/Tradesdontlie).

**Repo:** [github.com/tradesdontlie/tradingview-mcp](https://github.com/tradesdontlie/tradingview-mcp)

## Por que é Único

TradingView não tem API pública. O MCP usa o debug port do app desktop para expor dados reais — não screenshots, mas os valores subjacentes (preços, indicadores, ordem book). Claude lê os dados como um developer lendo o console de uma webpage.

## Capacidades

- Fetch de preços em tempo real
- Screenshot dos charts
- Adicionar/remover indicadores
- Desenhar linhas e anotações de TA
- Gerenciar price alerts
- Tab management
- Mudança de timeframe e symbol
- Replay Mode (backtesting)
- Pine Script development

## Setup

```
"Install the TradingView MCP server. Clone and explore 
https://github.com/tradesdontlie/tradingview-mcp, run npm install, 
add to my MCP config at ~/.claude/.mcp.json, and launch TradingView 
with the debug port."
```

Depois: `"Use tv_health_check to confirm TradingView is connected."`

## Requisitos

- Claude Code
- Node.js 18+
- TradingView Desktop
- Subscription pago (dados real-time)

## Onde aparece no vault

- [[03-RESOURCES/sources/financial-trading/claude-tradingview-full-guide]]
- [[03-RESOURCES/sources/skills-prompting-mcp/top-12-claude-mcps-complete-setup-guide]] — ranked #3 in @aiedge_ top-12 list (finance category)
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
