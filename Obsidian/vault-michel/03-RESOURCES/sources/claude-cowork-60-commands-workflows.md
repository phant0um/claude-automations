---
title: "60 Claude Cowork Commands, Skills, and Workflows That Most Users Don't Know"
type: source
source_url: "https://x.com/heynavtoor/status/2049804650904498501"
author: "@heynavtoor"
published: 2026-04-30
created: 2026-05-01
tags: [claude-cowork, slash-commands, skills, automations, workflows, productivity]
---

# 60 Claude Cowork Commands, Skills, and Workflows

**Autor:** [@heynavtoor](https://x.com/heynavtoor) — 4 months of daily Cowork use as full OS  
**Publicado:** 2026-04-30 | **Formato:** Thread X (Twitter)

> Cowork is not a chatbot with file access. It is an autonomous operating system.

## Top 3 de maior alavancagem

| # | Feature | Por que importa |
|---|---------|-----------------|
| 8 | `/plan` | Prevents token disasters on complex tasks. Single most important command. |
| 31 | Custom Skills folder (`~/skills`) | Turns Cowork into your personal AI. Doubles usage frequency. |
| 46 | Daily 7am inbox automation | Pays for the entire $20/month plan in week one. |

## Estrutura do conteúdo

O artigo cobre **6 camadas** do Cowork que a maioria dos usuários nunca toca:

1. Slash commands (1–12)
2. Custom skills (13–24)
3. File system power moves (25–33)
4. Connector workflows (34–45)
5. Scheduled automations (46–53)
6. Pro patterns / elite moves (54–60)

---

## Section 1: Slash Commands (1–12)

Ver página canônica: [[03-RESOURCES/concepts/cowork-slash-commands]]

| # | Comando | Nível | Função |
|---|---------|-------|--------|
| 1 | `/schedule` | Beginner | Background tasks; Max plan roda sem laptop aberto |
| 2 | `/loop` | Beginner | Poll em intervalo dentro da sessão |
| 3 | `/plan` | Beginner | Step-by-step antes de executar — sempre usar com 3+ arquivos |
| 4 | `/compact` | Beginner | Comprime contexto; 40–60% savings; roda antes de erros, não depois |
| 5 | `/clear` | Beginner | Reset nuclear; sem saudade de thread longa poluída |
| 6 | `/resume` | Intermediate | Retoma conversa anterior; par com /rename |
| 7 | `/rename` | Intermediate | Auto-renomeia thread por conteúdo; sidebar fica searchable |
| 8 | `/cost` | Intermediate | Custo estimado de tokens antes de executar |
| 9 | `/memory` | Intermediate | Mostra arquivos e contexto carregados; diagnóstico de comportamento estranho |
| 10 | `/doctor` | Intermediate | Lista apps conectados, skills carregadas, permissões |
| 11 | `/voice` | Pro | Push-to-talk; Espaço para gravar; mix com typing |
| 12 | `/agents` | Pro | Sub-agente especializado por projeto/repo |

---

## Section 2: Custom Skills (13–24)

Ver página canônica: [[03-RESOURCES/concepts/claude-skills]]

Pasta `~/skills` com subpastas por skill; cada uma tem `SKILL.md`. Cowork auto-descobre e usa quando o request bate. Marketplace: 2.300+ skills gratuitas.

| # | Skill | Nível | O que substitui |
|---|-------|-------|-----------------|
| 13 | Brand voice | Beginner | Tom genérico Claude → sua voz específica |
| 14 | Email triage | Beginner | Regras pessoais de urgência/arquivo |
| 15 | Meeting transcript | Beginner | Decisões, action items, owners, deadlines |
| 16 | PDF report generator | Beginner | Relatórios branded com capa e TOC |
| 17 | Code review | Intermediate | Style guide da equipe, automático |
| 18 | Customer support response | Intermediate | Respostas no tom da equipe; 4h/semana |
| 19 | Proposal generator | Intermediate | Brief → proposta em 10min vs 3h |
| 20 | Investor update | Pro | KPIs + narrativa + estrutura; 2h→15min |
| 21 | Contract review | Pro | Flags termos, deadlines, auto-renewals, liability |
| 22 | Hiring screen | Pro | Resume × JD → assessment estruturado |
| 23 | Stakeholder communication | Elite | 1 input → 4 versões (50w/200w/500w/blog) |
| 24 | Pricing skill | Elite | 3 tiers com rationale; SaaS pre-launch |

**Skill stacking (item 56):** Combinar brand-voice + email-triage + meeting-notes em um único task → função que ninguém mais tem.

---

## Section 3: File System Power Moves (25–33)

| # | Move | Nível | Output |
|---|------|-------|--------|
| 25 | Screenshot library organizer | Beginner | OCR + categorize + rename |
| 26 | Smart attachment processor | Beginner | Legal/Finance/Misc por sender |
| 27 | Code repo cleanup | Intermediate | Dead branches, unused deps, archived |
| 28 | PDF metadata extractor | Intermediate | CSV index; title/authors/abstract/findings |
| 29 | Photo library curator | Intermediate | Blurry/duplicate detection; composition heuristic |
| 30 | Voice note to article pipeline | Pro | Transcripts → 1.500-word articles em brand voice |
| 31 | Custom skill folder setup | Pro | `~/skills/brand-voice/`, `email-triage/`, etc. |
| 32 | Git history miner | Pro | 90 dias → self-review de engenharia |
| 33 | Backup audit with intelligence | Elite | Documents vs backup; flagra deleções suspeitas |

---

## Section 4: Connector Workflows (34–45)

| # | Workflow | Nível | Conectores |
|---|---------|-------|-----------|
| 34 | Calendar conflict resolver | Beginner | Google Calendar |
| 35 | Slack thread to executive brief | Beginner | Slack |
| 36 | Gmail to CRM logger | Intermediate | Gmail + HubSpot |
| 37 | Drive to data warehouse | Intermediate | Google Sheets + BigQuery |
| 38 | Notion to Linear ticket | Intermediate | Notion PRD + Linear |
| 39 | Multi-source weekly status | Pro | Salesforce + Mixpanel + Intercom + GitHub |
| 40 | Cross-platform meeting prep | Pro | Gmail + Drive + Slack + Linear |
| 41 | Salesforce pipeline hygiene | Pro | Salesforce |
| 42 | GitHub PR auto-review | Pro | GitHub + code-review skill |
| 43 | Stripe to bookkeeping reconciliation | Elite | Stripe + Google Sheets |
| 44 | Customer churn early warning | Elite | Intercom + Mixpanel + Stripe |
| 45 | Investor pipeline tracker | Elite | Gmail (6 months) → CRM-style view |

---

## Section 5: Scheduled Automations (46–53)

Ver página canônica: [[03-RESOURCES/concepts/cowork-scheduled-automations]]

| # | Task | Schedule | Output |
|---|------|----------|--------|
| 46 | Daily inbox processor | Weekday 7am | `/Daily/inbox-[date].md` |
| 47 | Sunday week-ahead brief | Sunday 6pm | `/Weekly/brief-[date].md` |
| 48 | Daily metric snapshot | Daily 8am | `/Metrics/[date].md` + Slack post |
| 49 | Weekly content recycler | Friday 5pm | 8 tweets + 2 LinkedIn + 3 scripts + 1 newsletter per article |
| 50 | Monthly competitor scan | 1st of month | `/Intelligence/[month].md` |
| 51 | Quarterly OKR self-review | Q first day | `/OKRs/Q[X]-review.md` |
| 52 | Annual highlights compiler | Dec 28 | `/Annual/[year].md` |
| 53 | Birthday/relationship maintenance | Sunday 4pm | Drafts personal messages for 14-day window |

---

## Section 6: Pro Patterns / Elite Moves (54–60)

| # | Pattern | Nível | Mecanismo |
|---|---------|-------|-----------|
| 54 | Sub-agent parallelization | Pro | 3 sub-agents paralelos; só outputs voltam ao main thread |
| 55 | Connector chains | Pro | 4 tools, 1 prompt, 1 deliverable |
| 56 | Skill stacking | Pro | Múltiplas skills compostas em uma task |
| 57 | Plan mode for token discipline | Pro | /plan mostra budget upfront; ajusta scope antes de executar |
| 58 | `.claude/` folder convention | Elite | commands/skills/agents/CLAUDE.md por projeto; carrega automaticamente |
| 59 | Off-peak scheduling | Elite | 2x throughput; Anthropic dobrou limites off-peak em março 2026 |
| 60 | Persistent Dispatch threads | Elite | Thread sobrevive entre devices; context/memory/skill state preservados |

---

## 5 Pro Tips

1. **Tratar Cowork como funcionário júnior**, não search box — contexto + exemplos + critérios de aceite
2. **Construir skill library no mês 1**, não conforme necessidade — 4h de setup → centenas de horas economizadas
3. **`/plan` é seguro gratuito** — 3 segundos de custo, folder corruption de custo de pular
4. **Agendar o entediante primeiro** — inbox triage + status report + week-ahead brief = horas livres/semana
5. **`.claude/` folder é o novo CV** — hiring managers em 2026 verificam antes do LinkedIn

## Progression Path

| Nível | Prazo | Ação |
|-------|-------|------|
| Beginner | Esta semana | 5 comandos da Section 1, diariamente |
| Intermediate | 3 semanas | `/skills` folder, 3 custom skills, 7am + Sunday automations |
| Pro | Mês 2 | Connector chains, weekly automations multi-tool, `/agents` |
| Elite | Mês 3+ | `.claude/` em todo projeto, Dispatch, off-peak, skill stacking |

## Conexões no vault

- [[03-RESOURCES/concepts/cowork-slash-commands]] — referência completa dos 12 comandos
- [[03-RESOURCES/concepts/cowork-scheduled-automations]] — automações agendadas com exemplos
- [[03-RESOURCES/concepts/claude-skills]] — SKILL.md format; marketplace; stacking
- [[03-RESOURCES/entities/Claude-Cowork]] — entidade: o produto em si
- [[03-RESOURCES/concepts/claude-cowork-plugins]] — relação plugins vs skills no Cowork
- [[03-RESOURCES/concepts/life-operating-system]] — Cowork como Life OS completo
- [[03-RESOURCES/concepts/claude-folder-anatomy]] — `.claude/` folder convention (item 58)
- [[03-RESOURCES/concepts/context-window]] — `/compact` e `/clear` para gestão de contexto
- [[03-RESOURCES/concepts/subagent-spawning]] — parallelização via `/agents` (item 54)
