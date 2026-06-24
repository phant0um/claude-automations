---
title: Inngest
type: entity
created: 2026-04-24
updated: 2026-04-24
tags: [workflow, background-jobs, cron, ai-inference]
---

# Inngest

**URL:** [inngest.com](https://inngest.com) | Dashboard: [app.inngest.com](https://app.inngest.com)

## O que é

Plataforma de workflows e background jobs com suporte nativo a cron, eventos e AI inference. Permite orquestrar tarefas assíncronas sem gerenciar infraestrutura de filas.

## Uso no OpenStock

| Workflow | Trigger | Ação |
|---------|---------|------|
| Welcome email | `app/user.created` | Gemini gera email personalizado |
| Daily news summary | `cron 0 12 * * *` | Email com resumo de notícias por watchlist |

**Dev local:** `npx inngest-cli@latest dev`
**Variável:** `INNGEST_SIGNING_KEY` (obrigatório em produção/Vercel)

## Relevância para Agentes

Inngest funciona como orquestrador leve de workflows — equivalente a um scheduler + event bus. Pode ser usado para cadenciar ações agênticas sem polling manual.

## Conexões

- [[03-RESOURCES/sources/financial-trading/openstock-open-source-stock-market-app]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — padrão de eventos + cron = orchestration lite
