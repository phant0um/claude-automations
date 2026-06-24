---
title: "Here's How I Built a Power Apps Code App with OpenClaw and Codex"
type: source
source: "Clippings/Here's How I Built a Power Apps Code App with OpenClaw and Codex.md"
created: 2026-06-23
updated: 2026-06-23
score: A
tags: [ai-agents, source-page, openclaw, codex, power-apps, prd-driven, agent-orchestration, context-layer, planning-execution]
---

## Tese Central

Over the weekend, o autor usou OpenClaw e Codex para construir e deployar um Power Apps Code App para um cliente. O app integra Operations, Finance, Supply Chain, Logistics, Marketing, Health and Safety, Field Technicians, Project Management, Technical Team, e leadership. A lição: processo e planejamento importam mais que o modelo escolhido. Não começou com código — começou com contexto.

## A Divisão: OpenClaw = Context Layer, Codex = Delivery Layer

### OpenClaw — Context Layer
- Orquestrador day-to-day do autor já tinha meses de contexto: spreadsheets, workflow notes, meeting/call transcripts, project history, source-system notes, rough process maps, pequenas decisões que normalmente somem
- **"Those months of context mattered more than any single prompt."**
- Usado para: primeira versão do data schema como JSON, entity relationship diagram em Mermaid, separação das major business areas e workflows
- "The hard part is agreeing on what the work actually is, where the data should live, who owns it, who can see it, and what 'done' means when multiple departments touch the same process."

### Codex (GPT-5.5 Extra High) — Delivery Layer
Primeira task não foi código — foi **design standards**:
- Site de referência + design-language docs do marketing team → design-standards Markdown file
- Usou Frontend Design plugin trazido do Claude Code
- Evitou o "generic admin dashboard look"

Depois adicionou: Power Platform MCP, Dataverse MCP, CLIs, Power Platform skills. Importante porque Power Apps Code Apps não são React apps genéricos — têm host behavior, connector models, Dataverse constraints, environment targeting, auth, deployment rules.

## O /plan Pass (maior alavancagem do weekend)

Codex leu: repo, reference exports, schema JSON, Mermaid ERD, design standard, Microsoft Learn docs. Objetivo: produzir **Project Requirements Document (PRD)** confiável.

O PRD cobriu:
- Product scope, source-of-truth rules, folder layout, route structure, app shell behavior, business-unit navigation, Dataverse ownership, access control, audit/revision history, archive behavior, delivery sequencing, v1 boundaries, roadmap boundaries, verification gates

## O Grilling Pass

Usou skill `grill-with-docs` de @mattpocockuk para questionar o plano:
- Rebuilding from reference artifacts ou migrating old source?
- Real source of truth para cada workflow?
- O que acontece quando PRD, schema JSON, e ERD drift?
- Quais routes são v1 vs placeholders?
- Onde Dataverse security enforce access vs UI só ajuda?
- O que requer explicit Power Platform approval?
- "That pass tightened the PRD before implementation started, which is exactly when you want to find the holes."

## Prompts Belong in Files

Hábito mais útil: salvar prompts como Markdown files. Não "bom prompt no chat, espero lembrar depois." Arquivos reais.
- Planning prompt salvo como .md
- Issue-generation prompt salvo como .md
- Implementation /goal prompt salvo como .md
- "The prompt becomes reviewable. It can be reused. It can be handed to another agent. It can be improved."

## PRD → Backlog → Build

1. PRD pronto → Codex gerou GitHub issues (cada issue: workflow intent, routes, files, Dataverse tables, dependencies, acceptance criteria, non-goals, verification steps, notes about what not to touch)
2. Issue = handoff unit — outro person ou agent pode pegar uma issue sem cavegar chat history do weekend
3. Implementation /goal prompt: pull repo state, pick next unblocked issue, create branch, make smallest useful PR, run named checks, open PR, fix failures, merge, sync main, move on

**Guardrails:**
- No production writes without approval
- No Dataverse mutation without target confirmation
- No role/team/group mapping changes without approval
- No secrets in fixtures/screenshots/logs/PRs
- No broad abstractions for imaginary futures

## O Build

- Shared shell primeiro: routes, business-unit switching, sidebar, mobile nav, search, alerts, help, theme switching, offline indicator, access-filtered navigation
- Data foundation: Dataverse schema metadata, generated Code Apps models/services, schema validator (PRD + JSON schema + Mermaid ERD alinhados)
- **89 tables, 1,148 columns, 156 relationships — nenhum criado manualmente. Codex via Dataverse MCP + Power Platform CLI.**
- Codex trabalhou em PR-sized slices: Marketing intake → home → resources → alerts → H&S → personalization → admin → Operations → chemical pricing → Finance ingestion → billing → vendor matching → profitability → inventory → Finance reporting → Technical Team → lab samples → ICP-to-SAT → Water → global search → release readiness
- Verificação matched work: schema validator, lint+build, Playwright, screenshots, deployment notes
- Final do segundo dia: implemented, merged, deployed
- Uma access-validation item ficou aberta (precisa validação em produção) — "not a failure, exactly what should be tracked"

## Por Que Funcionou

> "OpenClaw carried the business context. Codex turned that context into files, issues, PRs, checks, and deployment notes."

> "Could I have gotten a first screen faster by skipping the PRD, skipping the issue generation? Absolutely. Would I trust that for a real client system across multiple departments? No chance."

> "Not magic. Not vibes. Just better leverage, better context retention, and fewer dropped details while building real software."

## Key Insights

- Context layer (OpenClaw com meses de histórico) > single prompt — "months of context mattered more than any single prompt"
- Começar com design standards, não código — agente precisa saber o que "on brand" significa antes
- /plan pass = maior alavancagem: PRD que cobre tudo antes de implementar
- Grilling pass: questionar o PRD antes de implementar é quando você quer achar buracos
- Prompts como arquivos .md: reviewable, reusable, handable to another agent, improvable
- Issue = handoff unit — não depende de chat history que só uma pessoa entende
- Guardrails explícitos: "agents love building for imaginary futures if you let them. I do not."
- 89 tables/1148 columns/156 relationships criadas pelo agent via MCP — zero manual
- "Your process and planning is far more important than the model you choose."
- Verificação matched ao trabalho: schema validator para schema, Playwright para routes, screenshots para UI

## Links

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/agent-systems/coding-agents]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]]
- [[03-RESOURCES/sources/ai-agents/claude-code-codex-grok-long-task-workflow]]

## Minha Síntese

**O que muda:** Este caso real demonstra que a divisão entre context layer e delivery layer é prática, não teoria. OpenClaw carregou meses de contexto do cliente; Codex transformou isso em arquivos, issues, PRs. O pattern PRD → issues → PR-sized slices é um workflow completo de agentic development que funciona para sistemas reais (não demos). A ideia de que "prompts belong in files" alinha diretamente com a filosofia do vault.

**Conexão pessoal:** O vault-michel já implementa várias ideias deste artigo: prompts em arquivos (CLAUDE.md, AGENTS.md), handoff via arquivos não chat, guardrails explícitos. O pattern "PRD → backlog → PR-sized slices" é aplicável ao workflow de ingest do vault: Clipping → source page → issue → consolidation como slices. A grilling pass (questionar antes de executar) conecta com a verification thread do artigo sobre long-task workflow.

**Próximo passo:** Adotar o pattern "prompt como arquivo .md" mais sistematicamente no vault — salvar prompts de ingest, consolidação e review como skills ou templates em 04-SYSTEM/. Considerar adicionar um "grilling pass" ao workflow de consolidação de conceitos para validar antes de publicar.