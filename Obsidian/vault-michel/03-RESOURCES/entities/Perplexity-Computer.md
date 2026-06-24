---
title: Perplexity Computer
type: entity
category: produto
created: 2026-04-24
updated: 2026-04-24
tags: [perplexity, ai-agent, cloud, automation, multi-model]
---

# Perplexity Computer

**Tipo:** Agente cloud AI (produto da Perplexity)
**Acesso:** Perplexity Pro ($20/mês) ou Max ($200/mês)
**Interface:** Web/app; sem instalação local

## O que é

Agente digital que vive dentro da conta Perplexity. Recebe um objetivo, divide em subtarefas, rota cada subtarefa para o melhor dos 19 modelos AI disponíveis, e executa autonomamente em sandbox cloud isolado.

Diferente de um chatbot: age, não apenas responde. Conecta a 400+ ferramentas via OAuth, executa workflows multi-step, e pode rodar em schedule recorrente.

## Multi-Model Orchestration

O diferencial principal: 19 modelos com roteamento automático por subtarefa.
Ver: [[03-RESOURCES/concepts/agent-systems/multi-model-orchestration]]

Modelos usados: Claude Opus 4.7 (reasoning), GPT-5.2 (long context/search), Gemini (deep research), Grok (speed), Nano Banana (imagens), Veo 3.1 (vídeo).

## Connectors

400+ apps via OAuth (~30s de setup cada). Categorias principais:
- Produtividade: Gmail, Calendar, Drive, OneDrive, Box
- Comunicação: Slack, Teams
- PM: Notion, Asana, Jira, Linear, Confluence
- CRM: Salesforce, HubSpot
- Dev: GitHub, Vercel
- Data: Snowflake, PostgreSQL
- Custom: MCP server URLs

## Casos de uso documentados

- Market research com entrega em Google Sheets
- Análise de tweets + geração de novos em voz do usuário
- Análise de banco de dados Snowflake + envio de relatório por email
- Build de web app completo a partir de PRD
- Workflow semanal automatizado de prep de reuniões

## Limitações

- Sem live preview de código
- Connector reliability varia (Vercel OAuth expira; GitHub workarounds)
- Créditos queimam em tasks com retry loops
- Context não pode ser gerenciado manualmente

## Comparativo

| vs | Diferença |
|----|-----------|
| [[03-RESOURCES/entities/Claude-Cowork]] | Computer = cloud/zero-setup; Cowork = desktop/customização |
| [[03-RESOURCES/entities/OpenClaw]] | Computer = 400+ connectors fáceis; OpenClaw = self-hosted/full control |

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/perplexity-computer-masterclass-beginners]] — masterclass completo de [[03-RESOURCES/entities/Corey-Ganim]]
