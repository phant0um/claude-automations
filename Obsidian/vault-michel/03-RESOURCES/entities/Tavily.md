---
title: Tavily
type: entity
category: tool
tags: [mcp, web-search, real-time, ai-ready-data]
created: 2026-05-31
updated: 2026-05-19
---

# Tavily

## O que é

Servidor MCP de **web search em tempo real** para Claude e outros LLMs. Diferente do Google (links azuis), Tavily retorna dados estruturados e limpos prontos para consumo por IA.

URL MCP: `https://mcp.tavily.com/sse`

## Capacidades
- Search da web com dados atuais (sem cutoff de treinamento)
- Extração estruturada de qualquer página
- Market research, competitive analysis, preços atuais, notícias recentes

## Instalação (Claude Desktop)
```json
{
  "mcpServers": {
    "tavily": {
      "type": "url",
      "url": "https://mcp.tavily.com/sse",
      "name": "tavily"
    }
  }
}
```
Setup: ~5 minutos. 1 API key. Reiniciar Claude Desktop.

## Por que é o primeiro MCP a instalar
- ROI imediato e visível: Claude passa a acessar informação atual
- Payoff imediato convence a instalar os demais MCPs

## Onde aparece no vault
- [[03-RESOURCES/sources/skills-prompting-mcp/mcp-servers-complete-guide-khairallah]] — primeiro dos 5 MCPs essenciais

## Conceito relacionado
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]

## Links externos
- https://tavily.com
- https://mcp.tavily.com
