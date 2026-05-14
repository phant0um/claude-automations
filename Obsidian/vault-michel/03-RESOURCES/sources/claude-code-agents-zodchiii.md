---
title: "The 10 Claude Code Agents Nobody Told You to Build"
type: source
source_file: Clippings/The 10 Claude Code agents nobody told you to build..md
origin: post no X
author: "@zodchiii"
published: 2026-05-12
ingested: 2026-05-14
tags: [claude-code, agents, slash-commands, hooks, agent-sdk, automation, solo-founder]
---

# The 10 Claude Code Agents Nobody Told You to Build

> [!key-insight] Core insight
> Um Claude Code agent não é uma sessão de chat — é uma "job description + trigger + output". 10 agents especializados rodando em paralelo transformam um fundador solo em uma operação de shipping 3x mais rápida.

## Sections

### Mental Shift Fundamental

Agent = job description + trigger + output. Três locais onde vivem:

- **Slash commands** (`.claude/commands/<name>.md`): on-demand via terminal
- **Hooks** (`.claude/hooks/<event>.sh`): automáticos em eventos (PreToolUse, PostToolUse, git events)
- **Hosted scripts via Claude Agent SDK**: 24/7 em servidor, via schedules ou webhooks

### Os 10 Agents

| # | Agent | Tipo | Trigger | O que faz |
|---|-------|------|---------|-----------|
| 1 | PR Reviewer | Slash + GitHub hook | Antes de push | Lê diff; flags bugs, secrets, missing tests; 90s |
| 2 | Test Generator | Slash + pre-commit hook | Novo arquivo .ts/.py | 3-5 casos por função: happy path, edge, failure |
| 3 | Bug Hunter | Hosted (SDK) | Sentry poll 5min | Stacktrace → root cause → draft PR |
| 4 | Doc Writer | Post-merge hook | Merge em main | Atualiza README/docstrings/docs afetados |
| 5 | Refactor Tracker | Slash (semanal) | Manual (sexta) | Gera tabela de TODOs, FIXMEs, arquivos >500L |
| 6 | Daily Standup | Hosted (SDK) | 8h diário | GitHub + Linear + Calendar → 4 linhas por email/Telegram |
| 7 | Customer Feedback | Hosted (semanal) | Domingo 18h | Intercom + X + reviews → clusters por tema + frequência |
| 8 | Cold Outreach | Hosted (SDK) | CRM webhook (new lead) | Scrape + LinkedIn + posts → 4-line email personalizado |
| 9 | Content Repurposer | Slash | Manual | Long-form → 3 tweets + LinkedIn + Telegram + newsletter |
| 10 | Inbox Triage | Hosted (SDK) | A cada 30min | Gmail → 4 buckets + draft replies |

### 5 Locais vs 5 Hospedados

**5 locais (sem infra):** PR Reviewer, Test Generator, Doc Writer, Refactor Tracker, Content Repurposer

**5 precisam rodar 24/7:** Bug Hunter, Daily Standup, Cold Outreach, Customer Feedback, Inbox Triage

Opção de hospedagem citada: **Teamly** ($29-$179/mês; Claude Agent SDK; Pixel Department visual; OAuth integrado)

### Por Onde Começar

Não instalar todos os 10. Escolher os 2 que mais doem esta semana:
- **PR Reviewer** + **Inbox Triage** = win mais fácil para quase todos

Adicionar um por semana. Em 3 meses: operação de 10 agents como fundador solo.

## Conexões

- [[03-RESOURCES/concepts/claude-hooks]] — hooks como triggers de agents
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — 10 agents em paralelo
- [[03-RESOURCES/concepts/context-engineering]] — cada agent tem contexto focado
- [[03-RESOURCES/entities/Claude Code]] — plataforma base
- [[03-RESOURCES/concepts/claude-folder-anatomy]] — .claude/commands/ e .claude/hooks/
