---
title: "Agent Platform That Builds Itself"
type: source
source_file: Clippings/Agent Platform That Builds Itself.md
origin: thread X
author: "@ashpreetbedi"
ingested: 2026-05-14
tags: [agent-platform, auto-improvement, agno, claude-code, devops, self-improving-software]
---

# Agent Platform That Builds Itself

> [!key-insight] Insight principal
> Uma plataforma de agents que o próprio Claude Code constrói, gerencia e melhora — 5 prompts cobrem todo o ciclo de vida do desenvolvimento de agents (Create/Improve/Extend/Hill Climb/Review).

## Content summary

### O que é uma agent platform

A plataforma de agents é o "OS" que roda seus agents: recebe requests, executa o loop do agent, faz streaming de respostas, gera logs, gerencia auth e isolamento entre agents.

### 5 partes da plataforma

| Parte | Responsabilidade |
|-------|-----------------|
| **Runtime** | loop do agent, streaming, storage, auth |
| **Storage** | sessões, memória, conhecimento, traces, histórico de evals (Postgres) |
| **Connectors** | ferramentas de conexão com sistemas externos via MCP/API/CLI |
| **Interfaces** | Slack, Discord, Telegram, UIs customizadas |
| **Infrastructure** | Docker local, Railway produção |

### 5 prompts do ciclo de vida

| Prompt | O que faz |
|--------|-----------|
| **Create** (`create-new-agent.md`) | Scaffolda novo agent: perguntas → busca Agno docs MCP → gera arquivo → registra em app/main.py → smoke-test. 5-10 min. |
| **Improve** (`improve-agent.md`) | Lê INSTRUCTIONS, deriva 8-12 probes (golden-path, edge cases, adversariais), testa via cURL, PASS/FAIL, edita, hot-reload, roda novamente. Zero input humano. |
| **Extend** (`extend-agent.md`) | Adiciona capability com guia humano; Agno docs MCP garante que toolkit research é grounded. |
| **Hill Climb** (`eval-and-improve.md`) | Roda suite de evals, diagnostica cada falha, corrige o que está no scope. Loop de 5 rounds max. |
| **Review** (`review-and-improve.md`) | Varre repo por drift docs/code/config. Corrige mecanicamente o que pode; flags o resto. |

### Por que agent platforms funcionam para auto-improvement

1. Cada ação é exposta como API (cURL/bash)
2. Dados colocalizados — sessões e traces no mesmo Postgres
3. Logs em tempo real via Docker — loop de feedback ~5s

### Infraestrutura

```bash
git clone https://github.com/agno-agi/agent-platform-railway.git
docker compose up -d --build
# UI: os.agno.com conectado a localhost:8000
# Deploy produção: ./scripts/railway/up.sh
```

## Conexões

- [[03-RESOURCES/concepts/multi-agent-orchestration]] — especialização de roles (runtime, QA, reviewer)
- [[03-RESOURCES/concepts/self-evolving-agents]] — pattern de auto-improvement via Hill Climb
- [[03-RESOURCES/concepts/agent-evaluation-production]] — evals como feedback loop
- [[03-RESOURCES/entities/Agno]] — framework subjacente (ver também Auto-Improving Software)
- [[03-RESOURCES/sources/auto-improving-software-ashpreetbedi]] — artigo companion com mais detalhe de design
