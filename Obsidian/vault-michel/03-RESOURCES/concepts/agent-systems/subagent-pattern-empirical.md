---
title: subagent-pattern-empirical
type: concept
status: developing
created: 2026-05-19
updated: 2026-05-19
tags: [ai-agents, sub-agents, production, empirical, architecture]
---

# Sub-Agent Pattern — Dados Empíricos de Produção

Evidência quantitativa sobre quando sub-agentes superam multi-agent coordination em ambiente de produção.

## Dado Central

**Sub-agents vencem multi-agents em 7 de 10 casos de produção.**

Fonte: [[03-RESOURCES/sources/ai-agents-harness/sub-agents-vs-multi-agents-full-guide]] (2026-05)

## Por que Sub-agents Vencem

Sub-agents são **compressão de contexto**, não paralelismo. Ao spawnar um sub-agente:

- Contexto principal: 8K tokens de problema complexo → 200 tokens de resultado comprimido
- Sub-agente trabalha em contexto isolado → sem contaminação cruzada
- Falha silenciosa contida: se sub-agente falha, não propaga para sessão principal

Multi-agent coordination vence apenas quando a tarefa exige **escrita paralela genuína** (não apenas leitura paralela).

## Heurística de Decisão

| Critério | Sub-agent | Multi-agent |
|----------|-----------|-------------|
| Tarefa paralela com *write* concorrente | — | ✓ |
| Compressão de contexto necessária | ✓ | — |
| Isolamento de falha crítico | ✓ | — |
| Coordenação cross-task (Kanban/state) | — | ✓ |
| Padrão geral de produção | ✓ (7/10) | — |

## Relação com Memory Curse

Sub-agents com contexto isolado mitigam parcialmente o [[03-RESOURCES/sources/memory-context-rag/memory-curse-expanded-recall-cooperative-intent|Memory Curse]]: sem episodic memory compartilhada, não há retaliação cross-agent.

## 60 Dias em Produção — Taxa de Sobrevivência 28%

Dados empíricos de @Mnilax: 14 sub-agentes construídos em 60 dias em repo TypeScript de 47K LOC. Apenas 4 sobreviveram (28%). Critério: invocado ≥4× nos últimos 7 dias na marca de 60 dias.

**Overhead de 20K tokens por spawn** é o denominador de toda decisão. Sobreviventes têm ROI positivo contra esse custo:
- **code-reviewer**: 20K pago em ~50 invocações; após uma catch em produção, ROI imediato
- **test-runner**: 200 tokens in vs 6.000 tokens de output bruto; payback em ~10 runs
- **doc-maintainer**: Haiku model (barato), artefato durável semanal
- **security-auditor**: Opus model, catch de CVE que não seria capturado em PR review

**Os 10 mortos** morreram por: wrapping de CLI determinístico (dep-auditor, type-checker), trabalho sequencial com dependências (migration-planner), ausência de dados de runtime (perf-profiler), tarefa trivial (commit-formatter), contexto duplicado (pr-summarizer, env-validator), output scope collision (readme-updater vs doc-maintainer), decisão binária de alto risco sem sandbox (deploy-checker).

**Três traços dos sobreviventes:**
1. Single responsibility (um verbo)
2. Bounded context (input finito e específico)
3. Observable output (schema definido antes de construir)

**Checklist pré-build de 7 perguntas** — se #4 (CLI determinística?) = sim → use a CLI; se #5 (sessão principal já tem contexto?) = sim → inline; se #6 (trabalho sequencial?) = sim → não sub-agentar.

Fonte: [[03-RESOURCES/sources/ai-agents-harness/14-claude-code-sub-agents]]

## Ver também

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — memória compartilhada vs. isolada
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]]
- [[03-RESOURCES/sources/ai-agents-harness/sub-agents-vs-multi-agents-full-guide]] — fonte primária (dado 7/10)
- [[03-RESOURCES/sources/ai-agents-harness/14-claude-code-sub-agents]] — 60 dias, 14 agentes, 4 sobreviventes
- [[03-RESOURCES/sources/ml-research-papers/beyond-individual-intelligence-multi-agent-survey]] — survey MAS (quando coordenação vale)

## Evidências
- **[2026-06-19]** Sub-agentes mantêm a "bagunça" de pesquisa fora da thread principal, restringem tools por role, e permitem roteamento de modelo por dificuldade — formalização do padrão crew de 5 roles — [[03-RESOURCES/sources/how-to-run-claude-as-a-team-not-a-tool]]
