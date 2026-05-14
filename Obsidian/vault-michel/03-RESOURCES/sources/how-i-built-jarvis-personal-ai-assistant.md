---
title: "How I Built Jarvis: A Personal AI Assistant With Claude Code"
type: source
author: Sid Bharath
published: 2026-01-21
ingested: 2026-04-18
url: https://sidbharath.com/blog/
raw: .raw/articles/how-i-built-jarvis-personal-ai-assistant-claude-code-2026-04-18.md
tags: [claude-code, personal-assistant, automation, workflow, no-code, gmail, calendar, crm]
---

# How I Built Jarvis: A Personal AI Assistant With Claude Code

**Autor:** [[03-RESOURCES/entities/Sid-Bharath]] | Jan 21, 2026 | 20 min read

## Tese central

Sid Bharath construiu "Jarvis" — um life operating system completo — usando apenas Claude Code em conversas em linguagem natural. Zero linhas de código escritas por ele.

Claude Code não é uma ferramenta de developer. É um **AI agent com acesso ao computador**. A diferença com ChatGPT: ChatGPT tem integrações pré-construídas; Claude Code é uma blank slate que constrói ferramentas customizadas sob demanda.

## O que Jarvis faz

Três domínios integrados:

**Daily operations:** planeja o dia (calendário + tasks + email), faz triagem de email com rascunhos de resposta, rastreia hábitos.

**Project management:** rastreia múltiplos clientes com contexto por projeto (CLAUDE.md por pasta), faz follow-up automático de contatos sem resposta.

**Life management:** fitness, saúde, relacionamentos, weekly reviews, CRM pessoal de contatos.

## Insight chave: All Your Work is Code

Toda tarefa administrativa repetitiva é uma série de chamadas de API e operações de arquivo. O usuário nunca precisou entender qual API estava sendo chamada — apenas descreveu o resultado desejado.

**Pergunta de ouro:** "Am I doing the same thing I did last week, just with different data?" Se sim, pode ser automatizado.

## Jornada de construção (8 semanas)

| Semana | Adição | Método |
|--------|--------|--------|
| 1 | Task tracking via `tasks.md` | Prompt descritivo simples |
| 2 | Gmail integration (OAuth) | Claude guiou setup Google Cloud |
| 3 | Google Calendar integration | Reutilizou credenciais existentes |
| 4 | Daily planning workflow `/plan-day` | Custom command combinando tudo |
| 5-6 | Personal CRM via `contacts.md` | Auto-atualizado por emails e reuniões |
| 7-8 | Life Beyond Work (fitness, saúde, relacionamentos) | Extended daily plan |

## Estrutura final do sistema

```
jarvis/
├── CONTEXT.md           # identidade e preferências
├── daily/               # planos diários datados
├── projects/            # cliente-a/, cliente-b/, personal/
│   └── client-a/
│       └── CLAUDE.md    # contexto do projeto
├── contacts/            # clients.md, network.md, personal.md
├── tracking/            # habits.md, fitness.md, goals.md
├── workflows/           # plan-day.md, email-triage.md, etc.
└── scripts/             # auto-gerado pelo Claude (Python)
```

Scripts na pasta `scripts/` foram escritos e são mantidos pelo Claude. O autor declara: "I don't fully understand everything in the `scripts/` folder. Claude wrote it, Claude maintains it."

## Mental shift fundamental

Da AI como **research assistant** (responde perguntas, você faz o trabalho) para AI como **executive assistant** (age em seu nome, gerencia agenda, cuida da correspondência, faz follow-up).

Pergunta certa: "O que eu delegaria a um assistente humano se tivesse um?" — isso é a roadmap do Jarvis.

## Conexões no vault

- [[03-RESOURCES/concepts/claude-folder-anatomy]] — uso de CLAUDE.md por projeto (pasta `projects/client-a/CLAUDE.md`)
- [[03-RESOURCES/concepts/claude-hooks]] — workflows como commands salvos; padrão similar ao hook UserPromptSubmit
- [[03-RESOURCES/concepts/context-engineering]] — CONTEXT.md como identity file; contexto rico elimina necessidade de explicar cada vez
- [[03-RESOURCES/concepts/life-operating-system]] — **conceito novo** introduzido por este artigo
- [[03-RESOURCES/entities/Claude Code]] — ferramenta base de toda a arquitetura Jarvis
- [[03-RESOURCES/concepts/second-brain]] — complementa Ryan Wiggins (QMD+hooks) com abordagem focada em life management
- [[03-RESOURCES/concepts/claude-agent-harness-architecture]] — Jarvis é implementação prática do harness pattern sem código manual

## Custos

- Claude Pro: $20/mês
- Claude Max: $100-200/mês para uso intenso
- Google Cloud APIs: gratuitas em volumes pessoais típicos
