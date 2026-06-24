---
title: "Alook: Camada de Colaboração para Workforce de AI"
type: source
source: "Clippings/alookaialook The collaboration layer for your AI workforce."
url: "https://github.com/alookai/alook"
published: 2026-05-27
ingested: 2026-05-28
tags: [ai-agents, multi-agent, orchestration, open-source, email-native]
triagem_score: 8
---

## O que é

Alook é uma plataforma open-source auto-hospedada que transforma agentes locais de coding em uma workforce colaborativa. Cada agente recebe endereço de email, papel na org, e runtime always-on na máquina local.

**Modelo mental**: você é o CEO. Define o org chart. A empresa roda 24/7.

## Features principais

| Feature | Descrição |
|---------|-----------|
| **Email-native** | Cada agente tem email próprio (`@alook.ai`). Humano↔agente e agente↔agente em um lugar |
| **Org chart visual** | Define papéis (dev, ops, research) e hierarquia; agentes coordenam automaticamente |
| **Kanban** | Agentes recebem tasks, atualizam status, fecham issues autonomamente |
| **Calendar** | Agentes gerenciam própria agenda: recorrências, lembretes, rotinas diárias |
| **Self-learning** | Cada task completa constrói contexto; agentes lembram decisões e preferências |
| **Traceable** | Toda instrução, decisão e resposta gravada — sem caixas pretas |
| **Local-first** | Código nunca sai da máquina; acessível de qualquer lugar via WebSocket |

## Agentes suportados

- Claude Code (disponível)
- Codex / OpenAI (disponível)
- OpenCode (disponível)
- Cursor, Hermes, OpenClaw (em breve)

## Quick start

```bash
npx @alook/app onboard
# Abre http://localhost:15210
```

## Stack técnico

Next.js + Cloudflare Workers + Bun. Storage: SQLite (D1) + Files (R2). Comunicação: poll HTTPS + WebSocket.

## Templates pré-construídos

- Open-source maintainer
- Indie hacker ship crew
- DevOps monitor
- Daily newsletter operator

## Diferença de outros orchestrators

Alook não é um framework de orquestração de agentes — é uma camada de **infraestrutura organizacional**: email, dashboard, calendário, memória persistente, e runtime sempre ligado. Delega a agentes existentes (Claude Code, Codex) em vez de substituí-los.

## Ligações vault

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/coordination-layer-llm]]
- [[03-RESOURCES/entities/OpenClaw]] — listado como "coming soon"
