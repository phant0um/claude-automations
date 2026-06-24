---
title: "How I Built Jarvis: A Personal AI Assistant With Claude Code"
type: source
author: Sid Bharath
published: 2026-01-21
ingested: 2026-04-18
url: https://sidbharath.com/blog/
raw: .raw/articles/how-i-built-jarvis-personal-ai-assistant-claude-code-2026-04-18.md
tags: [claude-code, personal-assistant, automation, workflow, no-code, gmail, calendar, crm]
triagem_score: 7
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

- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — uso de CLAUDE.md por projeto (pasta `projects/client-a/CLAUDE.md`)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — workflows como commands salvos; padrão similar ao hook UserPromptSubmit
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — CONTEXT.md como identity file; contexto rico elimina necessidade de explicar cada vez
- [[03-RESOURCES/concepts/pkm-obsidian/life-operating-system]] — **conceito novo** introduzido por este artigo
- [[03-RESOURCES/entities/Claude Code]] — ferramenta base de toda a arquitetura Jarvis
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — complementa Ryan Wiggins (QMD+hooks) com abordagem focada em life management
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — Jarvis é implementação prática do harness pattern sem código manual

## Por que "zero linhas de código escritas" importa como argumento

Sid Bharath declara explicitamente que não escreveu código — Claude Code escreveu e mantém todos os scripts. Isso não é detalhe de implementação; é tese central do artigo.

O argumento: a barreira para automação pessoal sempre foi "você precisa saber programar". Claude Code elimina essa barreira porque o gap não é mais "criar ferramentas" — é "descrever o que a ferramenta deve fazer". Qualquer pessoa que consegue descrever um workflow repetitivo em linguagem natural consegue automatizá-lo via Claude Code.

O limite prático do argumento: Claude Code ainda requer que você saiba o suficiente para dar feedback sobre o que os scripts fazem. Quando o script de Gmail retorna erro, você precisa entender o suficiente para dizer "está dando erro 403 no OAuth" — não escrever o fix, mas articular o problema. O zero-code não significa zero-entendimento.

## A "Pergunta de Ouro" — critério de automação

"Am I doing the same thing I did last week, just with different data?" é um critério operacional para decidir *o que* automatizar, não *como*. A lógica:

Se a estrutura da tarefa é sempre a mesma (mesma sequência de ações, mesma lógica de decisão) e só os dados variam (datas, nomes, valores), então a tarefa é uma função paramétrica. Funções paramétricas podem ser automatizadas — o agente recebe os parâmetros e executa a função.

Tarefas que *não* atendem esse critério: decisões que requerem julgamento contextual novo a cada vez, trabalho criativo onde a variação é o valor, relacionamentos que exigem presença humana genuína. Esses domínios não devem ser automatizados.

## Estrutura de CLAUDE.md por projeto — padrão escalável

O detalhe de `projects/client-a/CLAUDE.md` é o padrão mais valioso do artigo para replicação. Ao invés de um único arquivo de contexto global, cada cliente ou projeto tem seu próprio contexto:

```
jarvis/
├── CONTEXT.md           # identidade global (quem sou, regras gerais)
├── projects/
│   ├── client-a/
│   │   └── CLAUDE.md    # contexto do cliente A (histórico, tom, regras específicas)
│   └── client-b/
│       └── CLAUDE.md    # contexto do cliente B
```

Quando Sid abre uma sessão sobre o cliente A, o Claude lê `CONTEXT.md` (quem é Sid) + `client-a/CLAUDE.md` (quem é o cliente A, histórico das interações, preferências). O contexto é preciso sem ser genérico.

Para o vault-michel, isso mapeia em `02-AREAS/fiap/CLAUDE.md` (contexto específico do curso FIAP), `02-AREAS/concurso/CLAUDE.md` (regras específicas de preparação), etc.

## O shift mental: research assistant → executive assistant

A distinção do artigo captura o salto de paradigma em uso de AI:

**Research assistant** (ChatGPT típico): você faz uma pergunta, o AI responde. Você lê a resposta, decide o que fazer, faz o trabalho. O AI amplia seu conhecimento mas não reduz seu workload operacional.

**Executive assistant** (Jarvis / Claude Code): você define o resultado desejado, o AI executa as ações necessárias para chegar lá — consulta calendário, rascunha emails, atualiza registros, faz follow-up. Você revisa e aprova; o AI faz.

A pergunta que operacionaliza esse shift: "O que eu delegaria a um assistente humano se tivesse um?" — não "O que eu perguntaria a um expert?". A resposta define o roadmap de automação.

## Aplicação para o vault-michel

O padrão Jarvis tem implementação direta no vault via Nexus:

- `daily/` → `05-DAILY/` (diários datados)
- `CONTEXT.md` → `04-SYSTEM/AGENTS.md` + `CLAUDE.md`
- `contacts/` → `03-RESOURCES/entities/` (entidades de pessoas)
- `tracking/` → `05-DAILY/` (hábitos e objetivos rastreados nas notas diárias)
- `workflows/` → `04-SYSTEM/skills/` (workflows como skills chamáveis)

A diferença: Jarvis é implementado como projeto Claude Code com scripts Python. O vault-michel é implementado como vault Obsidian com claude-obsidian plugin. Mesma arquitetura conceitual, tecnologias diferentes.

## Custos

- Claude Pro: $20/mês
- Claude Max: $100-200/mês para uso intenso
- Google Cloud APIs: gratuitas em volumes pessoais típicos
