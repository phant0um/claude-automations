---
title: "The 10 Claude Code Agents Nobody Told You to Build"
type: source
source_file: Clippings/The 10 Claude Code agents nobody told you to build..md
origin: post no X
author: "@zodchiii"
published: 2026-05-12
ingested: 2026-05-14
tags: [claude-code, agents, slash-commands, hooks, agent-sdk, automation, solo-founder]
triagem_score: 7
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

## Anatomia de um agent local vs hospedado

**Agent local (slash command):**
```markdown
<!-- .claude/commands/pr-reviewer.md -->
# PR Reviewer

Analyze the current git diff. Flag:
1. Logic bugs and edge cases not covered by tests
2. Hardcoded secrets or exposed credentials
3. Missing test coverage for new functions
4. Style inconsistencies with the codebase

Output: bullet list sorted by severity (critical → minor). Time limit: 90 seconds.
```

**Agent hospedado (Claude Agent SDK):**
Requer: `agent.json` (schedule/webhook config), função handler, variáveis de ambiente com credenciais para APIs externas. A complexidade é maior, mas permite integrações contínuas — o Bug Hunter que monitora Sentry a cada 5 minutos não pode ser um slash command local.

## Por que começar com PR Reviewer + Inbox Triage

**PR Reviewer:** O momento de revisão é imediato e o valor é mensurável (bugs capturados antes de merge). Não requer integrações externas — só git. Latência de 90 segundos é aceitável porque substitui o tempo que o dev levaria para revisar manualmente.

**Inbox Triage:** Email é o maior consumidor de atenção passiva de qualquer fundador. Mesmo que o agente produza apenas os 4 buckets (ação imediata / aguardando / FYI / arquivo) sem rascunhos, já elimina o custo cognitivo de triagem manual toda manhã.

## Riscos e contramedidas por categoria

| Categoria de agent | Risco principal | Contramedida |
|---|---|---|
| PR Reviewer | Falso positivo bloqueando merge | Output como sugestão, não bloqueio automático |
| Test Generator | Testes triviais sem valor real | Especificar casos obrigatórios no prompt (edge, failure) |
| Bug Hunter | Duplicate PRs para o mesmo bug | Checar Issues abertas antes de criar PR |
| Daily Standup | Context insuficiente → update vago | Incluir window de 48h no GitHub/Linear query |
| Cold Outreach | Tom incorreto, scraping de dados privados | Human review antes de enviar; só dados públicos |
| Inbox Triage | Classificação errada de email urgente | Bucket "ação imediata" conservative — falsos positivos aceitáveis |

## Custo real de infraestrutura

Os 5 agents locais: custo zero além dos tokens Claude. Os 5 hospedados via Teamly: $29-$179/mês dependendo do tier. Alternativa DIY com Claude Agent SDK em servidor próprio: ~$20-50/mês de compute + tokens. Para a maioria dos founders, Teamly elimina o custo de devops do self-hosting.

## Padrão de escalonamento

O insight do autor — "adicionar um por semana" — é deliberado. Cada agent hospedado requer calibração: o Cold Outreach que parece ótimo na demo pode ter tom errado para o ICP real, ou o Inbox Triage pode classificar mal emails de investidores. Uma semana por agent permite detectar e corrigir antes de adicionar o próximo. Em 10 semanas, a operação está calibrada em vez de quebrada em 10 lugares ao mesmo tempo.

## Relevância para o vault

O vault já usa o padrão de agents locais via `.claude/agents/` e skills via `~/.claude/skills/`. Os equivalentes vault dos 10 agents de zodchiii:
- PR Reviewer → **verify** (quality gate antes de commit)
- Doc Writer → **wiki-ingest** (documentação automática pós-ingestão)
- Refactor Tracker → **hill** (melhoria contínua do vault)
- Daily Standup → **ingest-report** (síntese semanal de Clippings)
- Content Repurposer → **autoresearch** (expansão de conceitos)

O vault não tem equivalentes para agents de outreach/email — escopo diferente. Mas o padrão de trigger + job description + output é idêntico.

## Conexões

- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — hooks como triggers de agents
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — 10 agents em paralelo
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — cada agent tem contexto focado
- [[03-RESOURCES/entities/Claude Code]] — plataforma base
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — .claude/commands/ e .claude/hooks/
- [[03-RESOURCES/sources/ai-agents-harness/7-claude-sub-agents-200k-team-heynavtoor]] — perspectiva complementar sobre sub-agents como substitutos de roles
