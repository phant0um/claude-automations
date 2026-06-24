---
title: AiScientist
type: entity
category: system
created: 2026-04-19
updated: 2026-04-19
tags: [ai-agent, ml-research, long-horizon, orchestration, multi-agent]
---

# AiScientist

Sistema de engenharia autônoma de longo horizonte para pesquisa em ML, desenvolvido por pesquisadores da Renmin University of China (Guoxin Chen, Jie Chen et al.).

**Princípio fundador:** Performance de longo horizonte requer *thin control over thick state* — orquestração hierárquica + continuidade de estado durável via [[03-RESOURCES/concepts/pkm-obsidian/file-as-bus]].

## Capacidades

- Interpreta papers de ML underspecified e os transforma em implementações executáveis
- Configura ambientes completos (Docker, GPU, datasets, dependências)
- Executa ciclos implement → run → diagnose → patch → re-validate de forma autônoma
- Opera por até 24h sem intervenção humana

## Benchmarks

| Benchmark | Score | Nota |
|---|---|---|
| PaperBench (GLM-5) | 33.73 avg | +11.15 sobre melhor baseline |
| MLE-Bench Lite | 81.82 Any Medal% | Melhor resultado controlado reportado |

**Caso emblemático:** Detecting Insults (MLE-Bench Lite) — 74 ciclos de experimento em 23h, AUC 0.903 → 0.982.

## Arquitetura

Ver [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]] e [[03-RESOURCES/concepts/pkm-obsidian/file-as-bus]] para detalhes.

- **Tier-0 Orchestrator** — stage-level planning via workspace map + summaries
- **Tier-1 Specialists** — Paper Comprehension, Prioritization, Implementation, Experimentation, Generic Helper
- **Tier-2 Subagents** — leaf workers escopados para subtarefas focadas

## Custo (PaperBench)

- Gemini-3-Flash: ~$15.67/task
- GLM-5: ~$12.20/task
- Full 20-task eval: ~$832 (com GPT-5.4 como grader)

## Fonte

- [[03-RESOURCES/sources/ml-research-papers/toward-autonomous-long-horizon-engineering-ml-research]] (arXiv 2604.13018)
