---
title: Composio
type: entity
categoria: ferramenta
tags: [ai-agents, integração, api, automação]
created: 2026-04-14
updated: 2026-05-19
---

# Composio

Camada de integração que dá "mãos" a agentes LLM — conecta o agente a 250+ APIs e ferramentas reais com auth gerenciado.

## Papel no stack de AI Agents

```
Claude (inteligência) → Composio (execução) → APIs do mundo real
```

Claude gera a lógica. Composio faz as chamadas de API acontecerem de verdade.

## O que resolve

Sem Composio, construir um bot requer:
- Chaves de API separadas para cada serviço
- Fluxos de autenticação por serviço
- Gestão de rate limits e erros
- Rebuild quando uma API muda

Com Composio: uma única camada de integração cobre tudo.

## APIs disponíveis (exemplos)

- Binance (preços BTC/ETH em tempo real)
- API Ninjas (crypto, indicadores econômicos, juros)
- API-Sports (2.000+ competições, scores ao vivo, lesões, escalações)
- Telegram, Slack, Discord (notificações)
- Google Sheets, Notion (logging de trades)

## Impacto em velocidade

> "Build a bot that monitors NFL injuries, compares to Polymarket odds, and alerts via Telegram" — de 3 semanas para lançamento no mesmo dia.

## Ver também

- [[03-RESOURCES/concepts/agent-systems/ai-agents-negocios\|AI Agents para Negócios]]
- [[03-RESOURCES/entities/Polymarket\|Polymarket]]
- [[03-RESOURCES/sources/financial-trading/polymarket-infrastructure-business|Fonte: guia de infraestrutura Polymarket]]
- [[03-RESOURCES/sources/financial-trading/polymarket-1m-year-claude-bot]] — playbook expandido com mais nichos e exemplos
