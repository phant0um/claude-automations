---
title: Vault Impact Kanban
type: kanban
created: 2026-06-18
updated: 2026-06-22
tags: [kanban, vault-impact, tracking]
---

# Vault Impact Kanban

Tracking de melhorias identificadas pelo pipeline diário (F3.3 Vault Impact).
Itens "alta" prioridade são automaticamente adicionados aqui pelo report-agent.
Status é auto-resolvido quando a skill/agent é criada.

**Princípio**: F3.3 sem tracking é write-only. Kanban fecha o loop.

---

## Pendente

| Data       | Tipo       | Nome                                                                                                                                                                                  | Status   | Esforço | Fonte                                                                           |
| ---------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------- | ------------------------------------------------------------------------------- |
| 2026-06-21 | Concept    | `agent-harness-composability` — harness do Nexus avaliado contra modelo de 13-15 responsabilidades substituíveis (não monolito)                                                       | done     | dias    | [[03-RESOURCES/sources/how-to-build-your-own-agent-harness]]                    |
| 2026-06-21 | Skill      | `verifier-independence-check` — checklist p/ garantir que verificador (humano ou agente) fica fora do alcance de edição do que está sendo avaliado (meta-padrão 5+ fontes desta leva) | done     | horas   | [[03-RESOURCES/sources/your-agent-is-trying-to-beat-the-verifier-not-the-task]] |
| 2026-06-22 | Concept    | revisar [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]] contra framing "sucessor do prompt engineering" (8 sources convergentes na mesma semana)                    | done     | horas   | [[06-GENERATED/relatorios/2026-06-22-relatorio-semanal]]                        |
| 2026-06-22 | Concept    | `agent-oversight-layers` — unir OpenSigil, IFC, MosaicLeaks em concept de oversight de agentes (enriquecido em `agent-security` em vez de novo concept)                                | done     | horas   | [[06-GENERATED/relatorios/2026-06-22-relatorio-semanal-run2]]                   |
| 2026-06-22 | Concept    | atualizar `loop-engineering-patterns` com 12 novas sources (Foundry, OpenEnv, Pi LoopFlows)                                                                                           | done     | horas   | [[06-GENERATED/relatorios/2026-06-22-relatorio-semanal-run2]]                   |
| 2026-06-22 | Connection | orphan rate 68% nos 97 novos — acionar connection-finder                                                                                                                              | done     | dias    | [[06-GENERATED/connections/connections-2026-06-22-run2]]                   |

- [x] **Atualizar rotina-audit-mensal step 1 (lista 7 rotinas desatualizada)** · fonte: rotina-audit-2026-06 · prazo: 2026-07-06 · dono: manual · criado: 2026-06-22
- [x] **x-thread-weekly sem Nexus gate — adicionar `## NEXUS GATE — Início`** · fonte: rotina-audit-2026-06 · prazo: 2026-07-06 · dono: manual · criado: 2026-06-22
- [x] **Mover manutencao-semanal + meta-coaching-semanal (stubs redirect) p/ 08-ARCHIVE** · fonte: rotina-audit-2026-06 · prazo: 2026-07-06 · dono: manual · criado: 2026-06-22
- [x] **metricas-ingest: completar Nexus gate (só tem bash check)** · fonte: rotina-audit-2026-06 · prazo: 2026-07-06 · dono: manual · criado: 2026-06-22
- [x] **kore.md + brainstorm.md stubs vazios — decidir desenvolver ou arquivar (+ typo "urainstorm")** · fonte: rotina-audit-2026-06 · prazo: 2026-07-06 · dono: @hill · criado: 2026-06-22
- [x] **Gerar probe suites adversariais (guard/hill/verify/extend/review/nexus) — bloqueia score-drift** · fonte: rotina-audit-2026-06 · prazo: 2026-07-06 · dono: @hill · criado: 2026-06-22
- [x] **2 skills órfãs (Von-Neumann, Fat-Skill-Thin-Harness) — integrar ou arquivar** · fonte: rotina-audit-2026-06 · prazo: 2026-07-06 · dono: manual · criado: 2026-06-22
- [x] **Rubric token-economy: adicionar tier por complexidade (rotinas leves vs pesadas)** · fonte: rotina-audit-2026-06 · prazo: 2026-07-06 · dono: manual · criado: 2026-06-22
- [ ] **Congelar reorgs estruturais em `04-SYSTEM/agents/` até 2026-07-05** · fonte: meta-coaching-2026-06-21 + revisao-semanal-2026-06-21 · prazo: 2026-07-05 · dono: manual · criado: 2026-06-22
- [x] **Criar concept: `agent-loop-pattern`** — 7 sources linkam, tema recorrente · fonte: pipeline-semanal-2026-06-23 · prazo: 2026-07-07 · dono: @hill · criado: 2026-06-23
- [x] **Criar concept: `beautiful-nonsense`** — 2 sources descrevem padrão (agent self-grading = output invalido) · fonte: pipeline-semanal-2026-06-23 · prazo: 2026-07-07 · dono: @hill · criado: 2026-06-23
- [x] **Criar concept: `prompt-debt`** — 1 source + tema recorrente, "fighting the weights" = tech debt da era AI · fonte: pipeline-semanal-2026-06-23 · prazo: 2026-07-07 · dono: @hill · criado: 2026-06-23
- [x] **Connection-finder: 40 wikilinks unresolved nas 18 novas source pages** — 24 concepts/entities criados, 134/134 links now resolved (99.3% → 100%) · fonte: pipeline-semanal-2026-06-23 F3.7 · prazo: 2026-07-07 · dono: connection-finder · criado: 2026-06-23
- [x] **Drift-check no momento do rename (`check-resolvable` antes de fechar sessão, não esperar pipeline-diario)** · fonte: meta-coaching-2026-06-21 · prazo: 2026-07-06 · dono: manual · criado: 2026-06-22
- [x] **Adicionar `model:` frontmatter aos 6 agentes reais sem campo** · fonte: revisao-semanal-2026-06-21 · prazo: 2026-07-06 · dono: @hill · criado: 2026-06-22
- [x] **Auditoria de duplicatas entre `03-RESOURCES/sources/` e `08-ARCHIVE/` (carry-over 2026-06-10)** · fonte: revisao-semanal-2026-06-21 · prazo: 2026-07-06 · dono: manual · criado: 2026-06-22
- [x] **Criar golden examples de source pages Score A para few-shot do ingest-agent** · fonte: pipeline-semanal-2026-06-22 (6x-faster-migration) · prazo: 2026-07-06 · dono: manual · criado: 2026-06-22
- [x] **Criar concept "constraint-driven innovation" (escassez como motor de inovação)** · fonte: pipeline-semanal-2026-06-22 (Intel Moore's Law) · prazo: 2026-07-06 · dono: manual · criado: 2026-06-22

---

## Em Progresso

| Data | Tipo | Nome | Status | Esforço | Fonte |
|------|------|------|--------|---------|-------|
| _(itens que estão sendo trabalhados — status mudado manualmente)_ | | | | | |

---

## Done

| Data       | Tipo    | Nome                                                                                                   | Status | Esforço | Fonte                                                         |
| ---------- | ------- | ------------------------------------------------------------------------------------------------------ | ------ | ------- | ------------------------------------------------------------- |
| 2026-06-19 | Concept | compressão tool-output (token-economy) — reconciliado contradição Headroom + técnica densificação promovida | done   | horas   | [[03-RESOURCES/sources/hermes-search-files-densification-pr]] |
| 2026-06-19 | Skill   | auditar economia líquida do RTK (`rtk gain --history`) — 0.5% adoção real, retrabalho infla economia por-chamada, 19.9% teórico | done   | horas   | [[03-RESOURCES/sources/inspect-at-scale-ramp-coding-agent]]   |

---

## Stale (> 30 dias pendente)

Itens pendentes há mais de 30 dias são flagados para Nexus decidir:
criar ou descartar.| 2026-06-23 | Concept: agent-runtime-security | pendente | 2h | [[2026-06-23-relatorio-semanal-run2]] |
| 2026-06-23 | Concept: loop-engineering-maturity | pendente | 2h | [[2026-06-23-relatorio-semanal-run2]] |
| 2026-06-23 | Concept: speculative-decoding-patterns | pendente | 2h | [[2026-06-23-relatorio-semanal-run2]] |
| 2026-06-23 | Concept: llm-as-judge-audit | pendente | 1h | [[2026-06-23-relatorio-semanal-run2]] |

## 2026-06-28 — F3.3 Vault Impact (concluído)

| Data | Tipo | Nome | Status | Esforço | Fonte |
|------|------|------|--------|---------|-------|
| 2026-06-28 | Concept | `loop-engineering` (formalizar como 4-layer stack) — [[03-RESOURCES/concepts/agent-systems/agent-loops]] atualizado | done | 2h | [[03-RESOURCES/sources/ai-agents/loop-engineering-ieee-field-study]] |
| 2026-06-28 | Concept | `progressive-disclosure` (como princípio de context) — [[03-RESOURCES/concepts/agent-systems/progressive-disclosure]] criado | done | 1h | [[03-RESOURCES/sources/ai-agents/harnesses-everything-optimize-yours]] |
| 2026-06-28 | Concept | `generator-evaluator-split` (adversarial pattern) — [[03-RESOURCES/concepts/agent-systems/generator-evaluator-split]] criado | done | 1h | [[03-RESOURCES/sources/ai-agents/loop-engineering-ieee-field-study]] |
| 2026-06-28 | Skill | `evaporation-reconcile` (manifest reconciliation para 51 files evaporadas) — [[04-SYSTEM/skills/core/evaporation-reconcile]] criado | done | 2h | triagem |
| 2026-06-28 | Hook | `context-budget-alert` (alerta quando CLAUDE.md > 40% window) — [[04-SYSTEM/wiki/hooks-candidate-context-budget]] criado | done | 3h | [[03-RESOURCES/sources/ai-agents/prompt-engineering-dead-context-engineering]] |

## 2026-06-28 — Consolidation Backlog (pending)
- [ ] [pendente] **Agent Harness** — Consolidate Agent Harness insights — 26 new sources this batch
- [ ] [pendente] **Code Review** — Consolidate Code Review insights — 151 new sources this batch
- [ ] [pendente] **Agent Memory** — Consolidate Agent Memory insights — 72 new sources this batch
- [ ] [pendente] **Loop Engineering** — Consolidate Loop Engineering insights — 39 new sources this batch
- [ ] [pendente] **Evaluation** — Consolidate Evaluation insights — 27 new sources this batch
- [ ] [pendente] **Claude Code** — Consolidate Claude Code insights — 69 new sources this batch
- [ ] [pendente] **Reinforcement Learning** — Consolidate Reinforcement Learning insights — 24 new sources this batch
- [ ] [pendente] **LLM Theory** — Consolidate LLM Theory insights — 42 new sources this batch
- [ ] [pendente] **Security** — Consolidate Security insights — 13 new sources this batch
- [ ] [pendente] **Fine-tuning** — Consolidate Fine-tuning insights — 34 new sources this batch
- [ ] [pendente] **Trading/Quant** — Consolidate Trading/Quant insights — 10 new sources this batch
