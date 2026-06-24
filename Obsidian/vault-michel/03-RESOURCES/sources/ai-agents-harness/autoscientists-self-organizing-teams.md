---
title: "AutoScientists: Self-Organizing Agent Teams for Long-Running Scientific Experimentation"
type: source
source: "Clippings/AutoScientists Self-Organizing Agent Teams for Long-Running Scientific Experimentation.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, multi-agent, scientific-ai, decentralized-agents]
---

## Tese central

Sistemas multi-agente descentralizados, que se auto-organizam sem orquestrador central, superam agentes únicos e sistemas com planejador fixo em experimentação científica de longo prazo — porque mantêm hipóteses paralelas, redistribuem recursos conforme evidências acumulam, e preservam memória de direções falhas para evitar exploração redundante.

## Argumentos principais

- **Limitação dos sistemas atuais** — single agents (AIDE, Autoresearch) seguem uma trajetória de busca única; multi-agent com planejador central assume espaço de busca estável desde o início; ambos falham quando direções produtivas mudam ao longo do tempo
- **AutoScientists: estado compartilhado + auto-organização** — agents interpretam um shared experimental state (proposals, experiments, results, failures, current champion), formam teams dinamicamente em torno de hipóteses promissoras sem input externo
- **Critique-before-compute** — proposals passam por peer critique de outros agents antes de consumir compute experimental, filtrando ideias fracas antes de custear experimentos
- **Failure sharing** — agentes compartilham sucessos E falhas, reduzindo exploração redundante de direções já descartadas
- **Adaptação dinâmica de teams** — agents se reorganizam conforme evidence acumula, abandonam direções exauridas, surgem novos teams ao redor de evidências promissoras emergentes

## Key insights

- Descentralização sem orquestrador = mais adaptável que hierarquia com planejador central
- "Shared state" como memória coletiva é mais poderoso que múltiplos skulls isolados (conecta com [[03-RESOURCES/sources/stop-giving-agents-own-skull]])
- Critique antes de executar = gate computacional econômico (análogo ao `guard` agent no vault)
- Falhas têm valor epistêmico: preservar memória de falhas é tão importante quanto preservar sucessos

## Exemplos e evidências

- BioML-Bench (24 tasks — biomedical imaging, protein engineering, single-cell omics, drug discovery): média 74.4th percentile, +8.33% sobre melhor AI agent
- GPT training optimization: chega a target validation bpb 1.9× mais rápido que Autoresearch; descobre 7 vs. 0 melhorias no estado atual
- ProteinGym fitness (ACE2-Spike binding): +12.5% Spearman correlation; generaliza para 217 assays com +6.5%
- Harvard University (Gao, Fang, Zitnik)

## Implicações para o vault

- Pattern de "shared state + critique gate + failure memory" é diretamente aplicável ao design de pipelines multi-agente no vault
- O vault já tem guard (gate) e hot.md (shared state parcial) — falta failure memory sistemática
- Sugere criar `04-SYSTEM/wiki/failures.md` separado de errors.md para preservar direções exploradas e descartadas

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/sources/stop-giving-agents-own-skull]]
