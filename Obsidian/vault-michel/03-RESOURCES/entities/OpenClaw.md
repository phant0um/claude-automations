---
title: OpenClaw
type: entity
category: software / framework
tags: [crypto, trading-agents, open-source, ai-agent]
created: 2026-04-18
updated: 2026-05-19
---

# OpenClaw

> [!note] Disambiguação
> Este é o OpenClaw focado em **crypto trading**. Para o assistente AI pessoal multi-canal (`openclaw/openclaw`), ver [[03-RESOURCES/entities/OpenClaw-Assistant]].

Framework open-source de AI agent voltado para trading de criptomoedas. Permite definir estratégias de trading em linguagem natural e implantá-las em múltiplas fontes de dados e exchanges.

## Características principais

- **Linguagem natural para estratégias** — estratégias definidas via SKILL.md (mesmo padrão do ecossistema Claude/OpenClaw Skills)
- **Multi-agent com paralelismo** — orchestrator + sub-agents; hypothesis testing e paralelização nativas
- **Interface Telegram** — controlado em linguagem natural via Telegram bot (@BotFather para setup)
- **LLM-agnóstico** — suporta Claude, GPT, Gemini etc.; guia oficial usa Claude Sonnet 4.6
- **Paper trading mode** — simula trades sem dinheiro real; recomendado antes de live

## Instalação

```bash
# Linux/Mac
curl -fsSL https://openclaw.ai/install.sh | sh

# Windows
iwr -useb https://openclaw.ai/install.ps1 | iex
```

Requer Node.js v22+. URL de controle local: `http://127.0.0.1:18789/`. Linux: `openclaw tui` para CLI.

## Estrutura de workspace

```
~/.openclaw/workspace/
  config/strategies.yaml   # parâmetros das estratégias
  skills/                  # SKILL.md por estratégia
  credentials/.env         # API keys e wallet keys
  trade_data/              # orders.json, trades.json, portfolio.json
  TOOLS.md                 # paths e execution style para o agente
```

## Execution style (TOOLS.md)

O agente decide agenicamente se executa via CLI/curl ou delega a um Python script. Objetivo: melhores resultados de trading com consumo ótimo de tokens.

## Estratégias disponíveis (via CoinGecko)

1. Cross-exchange arbitrage (CGSimplePrice WebSocket)
2. On-chain token discovery (Pools Megafilter)
3. Copy trading (Top Token Traders — Analyst plan)
4. News-based sentiment trading (/news endpoint)
5. Backtesting on-demand (OHLCV histórico)

## Companion repo

`https://github.com/CyberPunkMetalHead/traderclaw-agentic-trading` — workspace completo pronto para configurar

## Segurança

- Instalar em máquina secundária / Raspberry Pi / VPS
- Nunca dar permissões de saque na exchange API key
- Restringir API access ao IP da máquina
- Usar wallet fresh com fundos limitados para onchain trading

## Relação com o vault

- Usa [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — cada estratégia é uma SKILL.md
- Implementa [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — orchestrator + sub-agents
- Data layer: [[03-RESOURCES/entities/CoinGecko]]

## Ver também

- [[03-RESOURCES/sources/financial-trading/how-to-build-openclaw-ai-crypto-trading-agent]]
- [[03-RESOURCES/concepts/agent-systems/crypto-trading-agent]]
