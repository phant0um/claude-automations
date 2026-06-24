---
title: "60 Claude Cowork Commands You Didn't Know Existed"
type: source-summary
source_type: social-media-thread
author: "@heynavtoor"
published: 2026-04-30
created: 2026-05-01
tags: [claude-cowork, commands, automation, workflows, productivity]
triagem_score: 7
---

# 60 Claude Cowork Commands You Didn't Know Existed

**Author:** @heynavtoor
**Signal:** Exhaustive Cowork command reference — slash commands, custom skills, file system ops, connector workflows, scheduled automations.

## Command Categories

### Core Slash Commands (15)
- `/plan` — enter plan mode; Claude reasons before executing
- `/schedule <task> at <time>` — cron-style automation
- `/loop <n> times` — repeat task with variation
- `/if <condition> then <action>` — conditional execution
- `/parallel <task1> | <task2>` — concurrent execution
- `/memory set <key> <value>` — persistent storage
- `/memory get <key>` — retrieve stored value
- `/memory list` — show all stored keys
- `/compact` — compress context, keep summaries
- `/clear` — wipe context window
- `/skills` — list loaded skills
- `/skill load <name>` — activate a skill
- `/export <format>` — export conversation output
- `/share` — generate shareable link
- `/status` — show active connectors + usage

### File System Commands (10)
- `/read <path>` — read local file into context
- `/write <content> to <path>` — write output to file
- `/append <content> to <path>` — append to existing
- `/move <source> to <dest>` — move/rename files
- `/delete <path>` — delete file (with confirmation)
- `/list <dir>` — list directory contents
- `/search <pattern> in <dir>` — grep-style search
- `/diff <file1> <file2>` — compare files
- `/sync <local> with <remote>` — sync folders
- `/watch <path> then <action>` — file watcher + trigger

### Connector Workflows (12)
- `/gmail search <query>` — search email
- `/gmail draft <to> <subject>` — create draft
- `/calendar today` — today's schedule
- `/calendar add <event>` — create event
- `/drive find <query>` — search Drive
- `/slack read <channel>` — read messages
- `/slack post <channel> <msg>` — post message
- `/notion read <page>` — read Notion page
- `/notion create <title>` — create page
- `/github issues <repo>` — list issues
- `/github pr <repo>` — list PRs
- `/sheets read <id> <range>` — read spreadsheet data

### Custom Skills (8)
- `/skill create <name>` — scaffold new skill file
- `/skill edit <name>` — open skill in editor
- `/skill test <name>` — test skill with sample
- `/skill publish` — push to team library
- `/skill import <url>` — import from URL
- `/skill chain <a> | <b>` — pipe skill output to next
- `/skill loop <name> for each <list>` — batch execution
- `/skill if-fail <fallback>` — error handling

### Scheduled Automations (8)
- `/daily at 9am <task>` — daily trigger
- `/weekly on monday <task>` — weekly trigger
- `/on email from <addr> do <task>` — email trigger
- `/on slack msg in <channel> do <task>` — Slack trigger
- `/on file change <path> do <task>` — file change trigger
- `/on calendar event <name> do <task>` — calendar trigger
- `/on form submit <id> do <task>` — form trigger
- `/cancel <automation-id>` — stop automation

### Pro Patterns (7)
- Templates with `{{variable}}` substitution
- Multi-step pipelines: `step1 | step2 | step3`
- Conditional branching: `if success then X else Y`
- Loop with accumulator: collect results across iterations
- Error recovery: automatic retry with backoff
- Context preservation: `/memory` across sessions
- Parallel connectors: query multiple sources simultaneously

## Key Insight
Cowork transforms Claude from chat to **operating system**. Commands compose — `/schedule` + `/parallel` + `/slack post` = autonomous daily briefing with no human touch.

## Por que composabilidade é o insight central, não a lista de comandos

A lista de 60 comandos tem valor prático imediato, mas o insight arquitetural mais importante é mencionado na última linha: **comandos compõem**. `/schedule` + `/parallel` + `/slack post` = briefing diário autônomo.

Isso transforma o Cowork de ferramenta em plataforma. Cada comando individual tem utilidade limitada. Combinados em pipelines, criam automações que antes requeriam código.

Exemplos de composição que valem documentar:

```
/schedule daily at 8am
  /gmail search "from:cliente important"
  /parallel
    /calendar today
    /drive find "reunião"
  /slack post #daily "Briefing: {{outputs}}"
```

Isso é pseudocódigo, mas captura o padrão: trigger temporal (`/schedule`) → coleta paralela de dados (`/parallel` + conectores) → ação de saída (`/slack post`). Sem escrever código. Sem manter infraestrutura.

## `/plan` — o comando mais subestimado da lista

O `/plan` antes de qualquer operação complexa é o equivalente de pensamento antes de ação. Sem `/plan`, o Cowork tende a iniciar execução imediatamente, podendo fazer ações erradas antes que o usuário perceba.

Com `/plan`, o Claude apresenta uma sequência de passos proposta e aguarda aprovação. Isso é especialmente crítico em operações que envolvem:
- Escrita em sistemas externos (Gmail draft, Notion page, Slack message)
- Operações de arquivo (move, delete, append)
- Automações que vão rodar sem supervisão (`/schedule`)

O padrão recomendado: `/plan` → revisão humana → execução. Para tarefas simples e de baixo risco, `/plan` pode ser omitido.

## Diferença entre `/memory set/get` e Skills persistentes

O sistema de memória com `/memory set <key> <value>` é memória de sessão que persiste entre sessões no mesmo workspace Cowork. Serve para estado que muda frequentemente (status de projeto, último arquivo processado, configuração de task atual).

Skills persistentes (arquivos `.md` em `/SKILLS/`) são procedimentos estáveis que não mudam entre sessões — a definição de como executar uma tarefa, não o estado da tarefa.

**Analogia**: `/memory` é RAM persistente (dados de estado). Skills são ROM (procedimentos codificados). Os dois coexistem sem se sobrepor.

## Trigger-based automations — diferencial real do Cowork

As automações baseadas em trigger (eventos, não cron) são o que distingue o Cowork de simples agendamento:

- `/on email from <addr> do <task>` — reage a email específico
- `/on slack msg in <channel> do <task>` — processa mensagens em tempo real
- `/on file change <path> do <task>` — monitora pasta e age quando arquivo muda
- `/on calendar event <name> do <task>` — prepara material antes de reunião

Esses triggers transformam o Cowork em sistema reativo ao invés de apenas executivo. O agente não espera você pedir — age quando a condição é satisfeita.

Para este vault, a automação mais valiosa seria: `/on file change Clippings/ do wiki-ingest` — qualquer novo arquivo no feed do Readwise automaticamente passa pelo pipeline de ingestão.

## `/loop <n> times` — batch sem código

O `/loop` com número fixo de iterações é útil para processamento em batch de listas. Pattern típico:

```
/read fontes-pendentes.md
/loop 10 times
  wiki-ingest next item from fontes-pendentes.md
  /append "✓ done" to fontes-pendentes.md
```

A limitação: o estado entre iterações precisa estar explícito em arquivo (como `fontes-pendentes.md` acima). O loop não mantém estado interno entre iterações automaticamente.

## Comando `/compact` no contexto de sessões longas

O `/compact` é a versão manual da compactação automática de contexto. Em sessões longas (30+ mensagens, múltiplos arquivos lidos), o contexto fica cheio de informação redundante — leituras de arquivos que já foram processadas, planos que já foram executados, conversas de calibração que não são mais relevantes.

`/compact` produz um resumo do estado atual da sessão e descarta o histórico detalhado. O resultado: 5-10x menos tokens de contexto, com apenas informação relevante para continuar o trabalho.

Para sessões de ingestão longa (20+ fontes em sequência), aplicar `/compact` a cada 15-20 fontes é boa prática.

## Connections
- [[03-RESOURCES/entities/Claude-Cowork]] — product entity
- [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]] — plugin system
- [[03-RESOURCES/sources/30-claude-code-subagents-heynavtoor]] — same author, agent-side
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — `.claude/` structure
