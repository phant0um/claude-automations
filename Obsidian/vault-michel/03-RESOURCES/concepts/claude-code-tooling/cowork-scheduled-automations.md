---
title: Cowork Scheduled Automations
type: concept
status: developing
tags: [claude-cowork, automation, scheduling, productivity, background-tasks]
created: 2026-05-01
updated: 2026-05-01
---

# Cowork Scheduled Automations

Automações agendadas são o mecanismo do [[03-RESOURCES/entities/Claude-Cowork]] para executar tasks recorrentes sem intervenção humana — via `/schedule` para triggers temporais ou `/loop` para polling em sessão.

> [!key-insight] Princípio central
> Agende o entediante primeiro. Inbox triage + status report + week-ahead brief não são glamorosos. São a fundação. Quando rodam automaticamente, você tem horas por semana para trabalho que só você pode fazer.

## Como funciona

```
/schedule> Every weekday 7:30am: triage Gmail, summarize calendar, 
           save to /Daily/[date].md
```

**Diferença crítica por plano:**
- **Pro:** executa apenas enquanto Cowork está aberto
- **Max:** executa em background mesmo com laptop fechado

`/loop` é o primo mais leve — faz polling em intervalo dentro da sessão atual, para quando a sessão encerra.

---

## As 8 automações canônicas

### Tier Beginner — configurar esta semana

**#46 — Daily 7am Inbox Processor** *(a primeira que todos devem configurar)*

```
Schedule: Daily weekdays 7:00am
Task: Triage Gmail. Categorize unread. Draft responses for routine emails. 
      Flag urgent. Save summary to /Daily/inbox-[date].md
Output: /Daily/inbox-[date].md
```

Acorda com inbox já triada todo dia. ROI: paga o plano $20/mês na primeira semana.

---

**#47 — Sunday Week-Ahead Brief**

```
Schedule: Sunday 6:00pm
Task: Pull next week's calendar. For every meeting, attach relevant prep docs 
      from Drive. Flag meetings with no context. Generate 1-page brief with 
      priorities, prep gaps, outstanding action items.
Output: /Weekly/brief-[date].md
```

Entra na segunda já informado. Elimina o "calendar Tetris" de domingo.

---

### Tier Intermediate — semana 2–3

**#48 — Daily Metric Snapshot**

```
Schedule: Daily 8:00am
Task: Pull yesterday's metrics from Mixpanel, Stripe, database. 
      Calculate WoW and MoM deltas. Flag anything outside expected ranges. 
      Post summary to #metrics Slack channel.
Output: /Metrics/[date].md + Slack post
```

Substitui o standup diário de métricas.

---

**#49 — Weekly Content Recycler**

```
Schedule: Friday 5:00pm
Task: Read every article published this week. Generate per article: 
      8 standalone tweets, 2 LinkedIn posts, 3 short-form video scripts, 
      1 newsletter teaser.
Output: /Content/recycled/[week]/
```

1 artigo → 14 ativos de distribuição, automaticamente.

---

### Tier Pro — mês 2

**#50 — Monthly Competitor Scan**

```
Schedule: 1st of every month
Task: Search news, ProductHunt, Crunchbase, X for updates on [3 competitors]. 
      Track pricing changes, product launches, hiring, funding. 
      Compare to last month.
Output: /Intelligence/[month].md
```

Inteligência competitiva estratégica no piloto automático.

---

**#51 — Quarterly OKR Self-Review**

```
Schedule: 1st day of each quarter
Task: Read all Q[X] OKRs. Pull progress from Notion, Linear, Drive. 
      For each OKR: completion %, blockers, Q[X+1] recommendations.
Output: /OKRs/Q[X]-review.md
```

Substitui o consultor de OKR. Review escreve-se sozinho.

---

### Tier Elite — mês 3+

**#52 — Annual Highlights Compiler**

```
Schedule: December 28
Task: Read every weekly status doc, quarterly review, and shipped feature 
      from the year. Identify 10 highest-impact moves. Generate year-end wrap 
      for performance review + social + personal reflection.
Output: /Annual/[year].md
```

O ano termina com o highlight reel já pronto.

---

**#53 — Birthday & Relationship Maintenance**

```
Schedule: Weekly Sunday 4:00pm
Task: Look up everyone in contacts with birthday or work anniversary in 
      next 14 days. Draft personal message based on our last conversation.
Output: /Relationships/[week].md (para revisar e enviar)
```

O soft skill mais difícil, automatizado. Você ainda aprova antes de enviar.

---

## Off-Peak Scheduling — 2x Throughput (item 59)

> [!important] Feature de março 2026 — maioria não conhece
> A Anthropic dobrou os limites de uso off-peak em março 2026. Agendar automações pesadas para noites e fins de semana = 2x throughput no mesmo plano.

**Implicação prática:** #50 (competitor scan) e #52 (annual compiler) são candidatos perfeitos para off-peak — pesados, não urgentes, outputs salvos em arquivo.

---

## Estrutura de outputs recomendada

```
/Daily/
  inbox-2026-05-01.md
  inbox-2026-05-02.md
/Weekly/
  brief-2026-04-28.md
/Metrics/
  2026-05-01.md
/Content/
  recycled/
    week-2026-04-28/
/Intelligence/
  2026-05.md
/OKRs/
  Q2-2026-review.md
/Annual/
  2026.md
/Relationships/
  week-2026-04-28.md
```

Todos os outputs são markdown — editáveis no Obsidian, versionáveis em git.

---

## Connector Workflows relacionados (Section 4)

As automações acima ganham poder quando combinadas com connectors:

| Automação | Connectors envolvidos |
|-----------|----------------------|
| Inbox processor | Gmail |
| Week-ahead brief | Google Calendar + Drive |
| Metric snapshot | Mixpanel + Stripe + Slack |
| Content recycler | (local files) |
| Competitor scan | News + ProductHunt + Crunchbase + X |
| OKR review | Notion + Linear + Drive |

Para workflows de connector mais complexos (multi-source weekly status, GitHub PR auto-review, Stripe reconciliation), ver [[03-RESOURCES/sources/claude-code-cowork/claude-cowork-60-commands-workflows]] Section 4.

---

## Relação com o vault de Michel

Este vault já usa o princípio de automação agendada via [[03-RESOURCES/concepts/pkm-obsidian/life-operating-system]]. A estrutura `/Daily/[date].md` do item #46 é análoga ao padrão de hot cache deste vault (`04-SYSTEM/wiki/hot.md`).

Próximo passo natural: implementar #46 (inbox triage) + #47 (week-ahead brief) como foundation.

---

## Fontes

- [[03-RESOURCES/sources/claude-code-cowork/claude-cowork-60-commands-workflows]] — fonte primária, items 46–53
- [[03-RESOURCES/concepts/claude-code-tooling/cowork-slash-commands]] — `/schedule` e `/loop` (os comandos que habilitam isto)
- [[03-RESOURCES/concepts/pkm-obsidian/life-operating-system]] — Life OS como paradigma complementar
- [[03-RESOURCES/entities/Claude-Cowork]] — o produto
