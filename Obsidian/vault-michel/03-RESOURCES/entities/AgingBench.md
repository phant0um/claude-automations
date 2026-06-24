---
title: AgingBench
type: entity
subtype: benchmark
created: 2026-05-28
updated: 2026-05-28
tags: [entity, benchmark, agent-memory, agent-reliability, eval, longitudinal]
---

# AgingBench

Benchmark longitudinal para **Agent Lifespan Engineering (ALE)** — mede não só se agentes degradam, mas *como* e *onde* degradam após deployment.

**Instituição**: University of Texas at Austin  
**Autores**: Jianing Zhu, Yeonju Ro, et al. (2026-05-25)  
**Paper**: arXiv:2605.26302

## O que mede

4 aging mechanisms + diagnóstico por pipeline stage:

| Mecanismo | Trigger | Exemplo |
|-----------|---------|---------|
| **Compression** | Write-time summarization dropa detalhes relevantes | Dose "daily medication" perde valor exato |
| **Interference** | Memórias similares acumuladas confundem retrieval | "John Smith" confundido com "John Smyth" |
| **Revision** | Estado mudado não propagado | Plano premium cancelado ainda tratado como ativo |
| **Maintenance** | Eventos de ciclo de vida (compaction, flush) causam regressão | Reunião semanal desaparece após recompaction |

## Diagnóstico

Pipeline stage attribution via counterfactual probes:
- **Write** → oracle retrieval (bypassa write, testa se a info foi preservada)
- **Retrieval** → gold context (bypassa write+retrieval, testa utilization pura)
- **Utilization** → resultado com contexto ideal

## Relevância para o vault

- hot.md como Layer 3 de memória = candidato a **compression aging** (seções antigas ficam comprimidas/obsoletas)
- Agentes com memória compartilhada (Nexus + guard + hill) = risco de **interference aging**
- Nexus AGENTS.md quando atualizado = risco de **maintenance aging**
- Vault concepts que ficam desatualizados = **revision aging**

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-lifespan-engineering]] — conceito derivado
- [[03-RESOURCES/concepts/agent-systems/floor-raising-vs-benchmark-maxing]] — filosofia eval convergente
- [[03-RESOURCES/sources/ml-research-papers/agingbench-agent-lifespan-engineering-2026]] — source page
