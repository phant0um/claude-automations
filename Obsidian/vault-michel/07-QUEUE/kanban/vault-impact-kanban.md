---
title: Vault Impact Kanban
type: kanban
created: 2026-06-18
updated: 2026-06-28
tags: [kanban, vault-impact, tracking]
---

# Vault Impact Kanban

Tracking de melhorias identificadas pelo pipeline diário (F3.3 Vault Impact).
Itens "alta" prioridade são automaticamente adicionados aqui pelo report-agent.
Status é auto-resolvido quando a skill/agent é criada.

**Princípio**: F3.3 sem tracking é write-only. Kanban fecha o loop.

---

## Pendente

| Data       | Tipo       | Nome | Status | Esforço | Fonte |
| ---------- | ---------- | ---- | ------ | ------- | ----- |
| 2026-06-28 | Segurança | `.git` no home dir, não em `vault-michel/` — working tree expõe `.ssh`/credenciais. Dono: manual (human-gated). Prazo: 2026-07-12 | [ ] | dias | [[06-GENERATED/meta-coaching/2026-06-28-meta-coaching]] |
| 2026-06-28 | Processo | Squash F3.3 closures em 1 commit/ciclo — recorrente 2ª semana, piorou (3→5 commits). Dono: @hill. Prazo: 2026-07-12 | [ ] | horas | [[06-GENERATED/meta-coaching/2026-06-28-meta-coaching]] |
| 2026-06-28 | Drift | Contagem rotinas ativas: hot.md (2026-06-24) cita 16, real=15 — corrigir contagem. Dono: manual. Prazo: 2026-07-12 | [ ] | min | [[06-GENERATED/revisao-semanal/2026-06-28-revisao-semanal]] |
| 2026-06-28 | Concept | Dedup sweep 11 concepts "agent-memory-*" (overlap semântico). Dono: @hill (wiki-lint dedicada). Prazo: 2026-07-12 | [ ] | horas | [[06-GENERATED/meta-coaching/2026-06-28-meta-coaching]] |

- [x] **Atualizar rotina-audit-mensal step 1** · criado: 2026-06-22 · ✅ done
- [x] **x-thread-weekly sem Nexus gate** · criado: 2026-06-22 · ✅ done
- [x] **Mover manutenacao-semanal + meta-coaching-semanal p/ 08-ARCHIVE** · criado: 2026-06-22 · ✅ done
- [x] **metricas-ingest: completar Nexus gate** · criado: 2026-06-22 · ✅ done
- [x] **kore.md + brainstorm.md stubs vazios** · criado: 2026-06-22 · ✅ done
- [x] **Gerar probe suites adversariais** · criado: 2026-06-22 · ✅ done
- [x] **2 skills órfãs (Von-Neumann, Fat-Skill-Thin-Harness)** · criado: 2026-06-22 · ✅ done
- [x] **Rubric token-economy: tier por complexidade** · criado: 2026-06-22 · ✅ done
- [x] **Congelar reorgs estruturais até 2026-07-05** · criado: 2026-06-22 · ✅ done (freeze em vigor)
- [x] **Criar concept: agent-loop-pattern** · criado: 2026-06-23 · ✅ done
- [x] **Criar concept: beautiful-nonsense** · criado: 2026-06-23 · ✅ done
- [x] **Criar concept: prompt-debt** · criado: 2026-06-23 · ✅ done
- [x] **Connection-finder: 40 wikilinks unresolved** · criado: 2026-06-23 · ✅ done
- [x] **Drift-check no momento do rename** · criado: 2026-06-22 · ✅ done
- [x] **Adicionar model: frontmatter aos 6 agentes** · criado: 2026-06-22 · ✅ done
- [x] **Auditoria de duplicatas sources vs archive** · criado: 2026-06-22 · ✅ done
- [x] **Criar golden examples de source pages Score A** · criado: 2026-06-22 · ✅ done
- [x] **Criar concept constraint-driven innovation** · criado: 2026-06-22 · ✅ done

---

## Em Progresso

| Data | Tipo | Nome | Status | Esforço | Fonte |
|------|------|------|--------|---------|-------|
| _(nenhum item em progresso)_ | | | | | |

---

## Done

| Data       | Tipo    | Nome | Status | Esforço | Fonte |
| ---------- | ------- | ---- | ------ | ------- | ----- |
| 2026-06-19 | Concept | compressão tool-output (token-economy) | done | horas | [[03-RESOURCES/sources/hermes-search-files-densification-pr]] |
| 2026-06-19 | Skill | auditar economia líquida do RTK | done | horas | [[03-RESOURCES/sources/inspect-at-scale-ramp-coding-agent]] |
| 2026-06-21 | Concept | agent-harness-composability | done | dias | [[03-RESOURCES/sources/how-to-build-your-own-agent-harness]] |
| 2026-06-21 | Skill | verifier-independence-check | done | horas | [[03-RESOURCES/sources/your-agent-is-trying-to-beat-the-verifier-not-the-task]] |
| 2026-06-22 | Concept | loop-engineering-patterns review | done | horas | [[06-GENERATED/relatorios/2026-06-22-relatorio-semanal]] |
| 2026-06-22 | Concept | agent-oversight-layers | done | horas | [[06-GENERATED/relatorios/2026-06-22-relatorio-semanal-run2]] |
| 2026-06-22 | Concept | loop-engineering-patterns update (12 sources) | done | horas | [[06-GENERATED/relatorios/2026-06-22-relatorio-semanal-run2]] |
| 2026-06-22 | Connection | orphan rate 68% — connection-finder acionado | done | dias | [[06-GENERATED/connections/connections-2026-06-22-run2]] |

## Stale (resolvido 2026-06-28)

| Data | Tipo | Nome | Status | Esforço | Fonte |
|------|------|------|--------|---------|-------|
| 2026-06-23 | Concept | agent-runtime-security — [[03-RESOURCES/concepts/agent-systems/agent-runtime-security]] criado | done | 2h | [[06-GENERATED/relatorios/2026-06-23-relatorio-semanal-run2]] |
| 2026-06-23 | Concept | loop-engineering-maturity — [[03-RESOURCES/concepts/agent-systems/loop-engineering-maturity]] criado | done | 2h | [[06-GENERATED/relatorios/2026-06-23-relatorio-semanal-run2]] |
| 2026-06-23 | Concept | speculative-decoding-patterns — [[03-RESOURCES/concepts/agent-systems/speculative-decoding-patterns]] criado | done | 2h | [[06-GENERATED/relatorios/2026-06-23-relatorio-semanal-run2]] |
| 2026-06-23 | Concept | llm-as-judge-audit — [[03-RESOURCES/concepts/agent-systems/llm-as-judge-audit]] criado | done | 1h | [[06-GENERATED/relatorios/2026-06-23-relatorio-semanal-run2]] |

## 2026-06-28 — F3.3 Vault Impact (concluído)

| Data | Tipo | Nome | Status | Esforço | Fonte |
|------|------|------|--------|---------|-------|
| 2026-06-28 | Concept | loop-engineering (4-layer stack) — [[03-RESOURCES/concepts/agent-systems/agent-loops]] atualizado | done | 2h | [[03-RESOURCES/sources/ai-agents/loop-engineering-ieee-field-study]] |
| 2026-06-28 | Concept | progressive-disclosure — [[03-RESOURCES/concepts/agent-systems/progressive-disclosure]] criado | done | 1h | [[03-RESOURCES/sources/ai-agents/harnesses-everything-optimize-yours]] |
| 2026-06-28 | Concept | generator-evaluator-split — [[03-RESOURCES/concepts/agent-systems/generator-evaluator-split]] criado | done | 1h | [[03-RESOURCES/sources/ai-agents/loop-engineering-ieee-field-study]] |
| 2026-06-28 | Skill | evaporation-reconcile — [[04-SYSTEM/skills/core/evaporation-reconcile]] criado | done | 2h | triagem |
| 2026-06-28 | Hook | context-budget-alert — [[04-SYSTEM/wiki/hooks-candidate-context-budget]] criado | done | 3h | [[03-RESOURCES/sources/ai-agents/prompt-engineering-dead-context-engineering]] |

## 2026-06-28 — Consolidation Backlog (concluído)

| Tema | Sources | Concept criado | Status |
|------|---------|----------------|--------|
| Code Review | 151 | [[03-RESOURCES/concepts/agent-systems/code-review]] | done |
| Agent Memory | 72 | [[03-RESOURCES/concepts/agent-systems/agent-memory]] | done |
| Claude Code | 69 | [[03-RESOURCES/concepts/agent-systems/claude-code-ecosystem]] | done |
| LLM Theory | 42 | [[03-RESOURCES/concepts/llm-ml-foundations/llm-theory-synthesis]] | done |
| Loop Engineering | 39 | [[03-RESOURCES/concepts/agent-systems/loop-engineering-synthesis]] | done |
| Fine-tuning | 34 | [[03-RESOURCES/concepts/llm-ml-foundations/fine-tuning-synthesis]] | done |
| Agent Harness | 26 | [[03-RESOURCES/concepts/agent-systems/agent-harness-synthesis]] | done |
| Evaluation | 27 | [[03-RESOURCES/concepts/agent-systems/evaluation-synthesis]] | done |
| Reinforcement Learning | 24 | [[03-RESOURCES/concepts/llm-ml-foundations/rl-synthesis]] | done |
| Security | 13 | [[03-RESOURCES/concepts/agent-systems/security-synthesis]] | done |
| Trading/Quant | 10 | [[03-RESOURCES/concepts/financial-trading/trading-quant-synthesis]] | done |