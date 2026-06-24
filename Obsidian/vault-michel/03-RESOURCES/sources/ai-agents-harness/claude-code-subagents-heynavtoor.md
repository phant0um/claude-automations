---
title: "30 Claude Code Sub-Agents I Actually Use in 2026"
type: source
source: "https://x.com/heynavtoor/status/2050148589134045443"
author: "@heynavtoor"
published: 2026-05-01
created: 2026-05-01
tags: [claude-code, sub-agents, ai-agents, productivity, engineering, devops, sales, marketing, operations, finance, research]
triagem_score: 8
---

# 30 Claude Code Sub-Agents I Actually Use in 2026

**Fonte:** Thread de [@heynavtoor](https://x.com/heynavtoor/status/2050148589134045443) — 2026-05-01

**Contexto:** Autor rodou Claude Code como "full operating system" desde janeiro 2026. Construiu e testou mais de 100 sub-agentes. Este thread documenta os 30 melhores com YAML completo e system prompts funcionais.

---

## O que é um sub-agente (definição operacional)

Arquivo markdown em `.claude/agents/<name>.md`. YAML frontmatter no topo: `name`, `description`, `tools`, `model`. Abaixo do YAML: o system prompt. Cada sub-agente roda em **janela de contexto própria** com apenas as tools listadas. Claude Code auto-delega baseado na `description`. O main thread fica limpo.

---

## Catálogo Completo

### ENGINEERING

| # | Nome | Arquivo | Model | Trigger |
|---|------|---------|-------|---------|
| 1 | Code Review | `code-reviewer.md` | sonnet | Antes de git commit |
| 2 | Bug Hunter | `bug-hunter.md` | sonnet | Quando teste falha ou erro de prod |
| 3 | Git Bisect | `git-bisect.md` | sonnet | Regressão entre dois refs conhecidos |

**Code Reviewer:** foca em invariant violations, não estilo. Scores 1–5 em "silent breakage risk". Flag 4–5 com linha exata e repro de 1 linha.

**Bug Hunter:** walk the stack do frame mais profundo para cima. Para no frame onde o contrato foi violado. Fix em < 10 linhas + regression test.

**Git Bisect:** exige 3 inputs (good ref, bad ref, test command). Sempre `git bisect reset` ao final.

---

### DEVOPS

| # | Nome | Arquivo | Model | Trigger |
|---|------|---------|-------|---------|
| 4 | DB Migration Validator | `migration-validator.md` | opus | Antes de merge de migration |
| 5 | Secret Scanner | `secret-scanner.md` | haiku | Pre-commit hook |
| 6 | Cost Spike | `cost-spike.md` | opus | Bill >20% de alta no dia |

**Migration Validator:** classifica ops: additive/backfill/destructive/locking. Hard blockers definidos. Exige script de rollback ou retorna BLOCKED.

**Secret Scanner:** 3 regras em ordem: prefixos conhecidos, alta entropia em chaves suspeitas, headers de chave privada. Nunca loga o secret completo.

**Cost Spike:** compara 7 dias vs baseline de 28. Maior delta absoluto em $, não em %. Cross-referencia com deploys, crons, traffic.

---

### PRODUCT & DESIGN

| # | Nome | Arquivo | Model | Trigger |
|---|------|---------|-------|---------|
| 7 | Spec Writer | `spec-writer.md` | sonnet | Início de qualquer feature |
| 8 | Edge Case | `edge-cases.md` | sonnet | Após spec, antes de implementação |
| 9 | A/B Test Planner | `ab-test-planner.md` | opus | Quando quer testar uma mudança |

**Spec Writer:** força resposta a "o que o usuário faz diferente depois que isso sobe?" PRD em 800 palavras máx. Rejeita success metric de vaidade.

**Edge Case:** 15 edge cases por 15 eixos definidos. Score: probabilidade × severidade. Sorted.

**A/B Test Planner:** força hipótese no formato X/Y/Z/M. Sample size com z-test biproporção (80% power, 95% confiança). Stop-for-harm em 2σ de queda.

---

### SALES

| # | Nome | Arquivo | Model | Trigger |
|---|------|---------|-------|---------|
| 10 | Lead Researcher | `lead-researcher.md` | sonnet | 24h antes de reunião de sales |
| 11 | Cold Email | `cold-email.md` | sonnet | Novo prospect |
| 12 | Renewal Risk | `renewal-risk.md` | opus | 90 dias antes do renewal |

**Lead Researcher:** 5 buying signals nomeados (funding, exec hire, expansão, layoffs, tech change). Sem "founded in X" genérico.

**Cold Email:** 3 linhas exatas: observação específica / "we did this for someone like you" com número / soft ask de 15 min. Rejeita se linha 1 serve para qualquer empresa do setor.

**Renewal Risk:** 5 sinais ponderados: WAU trend 35% / feature depth 25% / ticket sentiment 15% / champion 15% / exec contact 10%.

---

### MARKETING

| # | Nome | Arquivo | Model | Trigger |
|---|------|---------|-------|---------|
| 13 | Hook Writer | `hook-writer.md` | sonnet | Antes de publicar em social |
| 14 | SEO Cluster | `seo-cluster.md` | sonnet | Início de sprint SEO |
| 15 | Content Audit | `content-audit.md` | opus | Trimestral |

**Hook Writer:** 20 hooks em 6 padrões (≥2 cada). Score em curiosity gap / especificidade / stop power. Bane "ultimate", "game-changing", "revolutionary".

**SEO Cluster:** 30–50 keywords. Tags de intent. Pillar + 5–8 clusters. URLs sugeridas. Volume mínimo: 50/mês (exceto bottom-funnel).

**Content Audit:** engagement por impressão, não absoluto. Clusters por features. Top 5 features com correlação ≥1.5σ.

---

### CUSTOMER SUPPORT

| # | Nome | Arquivo | Model | Trigger |
|---|------|---------|-------|---------|
| 16 | Ticket Triage | `ticket-triage.md` | haiku | Cada novo ticket |
| 17 | Bug Reproducer | `bug-reproducer.md` | opus | Quando engenharia não consegue reproduzir |
| 18 | Knowledge Gap | `knowledge-gap.md` | sonnet | Weekly cron |

**Ticket Triage:** urgência por 4 sinais ponderados. Taxonomia de 12 categorias max. Never auto-close. Triage only.

**Bug Reproducer:** 7 itens obrigatórios antes de escrever repro. Cada step deve ter botão/link/comando exato.

**Knowledge Gap:** gap = sem resposta no help center OU artigo existente mas cliente ainda abriu ticket (clarity gap). Títulos: "How to \<verb\> when \<condition\>".

---

### OPERATIONS

| # | Nome | Arquivo | Model | Trigger |
|---|------|---------|-------|---------|
| 19 | Inbox Hawk | `inbox-hawk.md` | sonnet | A cada 30 min durante horário de trabalho |
| 20 | Meeting Notes | `meeting-notes.md` | sonnet | Após reunião com transcript |
| 21 | OKR Health | `okr-health.md` | opus | Mid e end of quarter |

**Inbox Hawk:** 3 buckets hard: needs-you-today / needs-you-this-week / noise. Max 7 itens. Sem rascunhar replies.

**Meeting Notes:** só decisões, action items (com owner/ação/deadline), perguntas abertas. Cap 250 palavras.

**OKR Health:** expected progress = linha reta. ±10% = verde, 10–25% = amarelo, >25% = vermelho. Objetivo não é verde se um KR crítico é vermelho.

---

### FINANCE

| # | Nome | Arquivo | Model | Trigger |
|---|------|---------|-------|---------|
| 22 | Burn Rate | `burn-rate.md` | sonnet | Semanal |
| 23 | Cap Table | `cap-table.md` | opus | Antes de fechar rodada |
| 24 | Variance Analysis | `variance.md` | opus | Monthly close |

**Burn Rate:** projeção com seasonality do mês anterior, não flat. Flag >10% over ou >20% under. Top 3 line items por categoria.

**Cap Table:** ordem: pre-money → option pool top-up → investor shares → post-money. O gotcha: top-up dilui holders existentes. Sem resposta sobre pre vs post money do top-up = BLOCKED.

**Variance Analysis:** decompõe em 4: volume / price / timing / one-time. Os 4 devem somar ao total.

---

### RESEARCH

| # | Nome | Arquivo | Model | Trigger |
|---|------|---------|-------|---------|
| 25 | Source Verifier | `source-verifier.md` | sonnet | Antes de publicar conteúdo data-heavy |
| 26 | Counterargument | `counterargument.md` | opus | Antes de publicar POV forte |
| 27 | Methodology Critic | `methodology-critic.md` | opus | Antes de rodar ou citar estudo |

**Source Verifier:** verdicts: CONFIRMED / WEAKLY SUPPORTED / STALE (>3 anos) / UNFOUND. Nunca aceita stat de press release — rastreia metodologia original.

**Counterargument:** 5 ângulos: empírico / mecanismo / escopo / incentivo / histórico. Rejeita strawmen.

**Methodology Critic:** checklist: selection bias / survivorship / confounds / measurement / researcher degrees of freedom / external validity. Não valida como "strong" sem pre-registration.

---

### PERSONAL PRODUCTIVITY

| # | Nome | Arquivo | Model | Trigger |
|---|------|---------|-------|---------|
| 28 | Daily Plan | `daily-plan.md` | sonnet | 8h da manhã |
| 29 | Side Project Resurrector | `resurrector.md` | sonnet | Ao reabrir projeto parado |
| 30 | Decision Log | `decision-log.md` | haiku | A cada decisão não-trivial |

**Daily Plan:** 4 tarefas exatas: 1 must-ship / 1 collaboration / 1 admin / 1 learning (15 min max). Must-ship vai na janela de foco mais longa.

**Resurrector:** last 5 commits + README + TODO/FIXME + recent files + open branches. Reconstrói: intenção / bloqueio / re-entry mínimo (30 min). 3 próximos passos por momentum, não importância.

**Decision Log:** formato fixo: timestamp / questão / 2–3 opções com tradeoffs / escolha / raciocínio em 3 frases / condição de revisão. Salva em `.decisions/YYYY-MM-DD-slug.md`.

---

## Kits Recomendados por Persona

| Persona | 5 agentes iniciais |
|---|---|
| Solo founder | Lead Researcher, Cold Email, Inbox Hawk, Meeting Notes, Burn Rate |
| Engineer | Code Review, Bug Hunter, Git Bisect, DB Migration Validator, Secret Scanner |
| Marketer | Hook Writer, SEO Cluster, Content Audit, Ticket Triage, Daily Plan |

---

## Princípios Destilados

1. **Single purpose**: um agente faz UMA coisa. Chain quando necessário.
2. **Auto-delegation via description**: escreva a description para que Claude saiba quando usar.
3. **Model fitting**: haiku para triagem, sonnet para análise, opus para raciocínio pesado.
4. **Difficulty path**: Beginner → Intermediate (2 semanas) → Advanced (refinamento mensal).

---

## Conexões no vault

- [[03-RESOURCES/concepts/claude-code-subagents]] — página conceitual com framework completo
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — `.claude/agents/` como componente da estrutura
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]] — comportamento de spawning no Opus 4.7
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — padrões de orquestração e delegação
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — skills vs sub-agentes: diferenças e quando usar cada
- [[03-RESOURCES/entities/heynavtoor]] — autor da thread
