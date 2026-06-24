---
title: "Loop Engineering Maturity"
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, loop-engineering, maturity, process]
---

# Loop Engineering Maturity

## Definição

Loop engineering amadureceu de conceito para framework. A tese consolidada: **o loop é a unidade de valor, não o agente**. Agentes são commodity — o que diferencia é a qualidade do loop que os orquestra. Um bom loop com um agente mediano supera um agente excelente num loop ruim. 6+ sources independentes convergem nesta tese.

## Estágios de Maturidade

1. **Loop as pattern** (início) — "Act → Observe → Learn → Repeat" como padrão observado. [[movez-on-x-a-senior-google-engineer-just-dropped-a-19-page-pdf-on-loop-engineeri]] — Google engineer 19-page PDF formalizando o padrão.

2. **Loop as architecture** — o loop determina a arquitetura do sistema. [[build-the-loop-not-the-agent-winning-ai-iteration]] — "Build the Loop, Not the Agent". O loop é a arquitetura; o agente é um componente substituível.

3. **Loop as skill** — loops como artefatos reutilizáveis. [[hypothesis-driven-skill-optimization-for-llm-agents]] — skills são loops otimizados via hypothesis testing.

4. **Loop as routing** — o loop decide qual agente/modelo usar. [[agent-as-a-router-agentic-model-routing-for-coding-tasks]] — agent-as-a-router é loop engineering aplicado a model selection.

5. **Loop as governance** — o loop inclui verificação. [[rigorbench-benchmarking-engineering-process-discipline-in-autonomous-ai-coding-a]] — engineering process discipline = loop com gates de qualidade.

6. **Loop as compensation** — o loop compensa fraquezas do agente. [[robust-agent-compensation-rac-teaching-ai-agents-to-compensate]] — RAC: agentes aprendem a compensar suas próprias limitações dentro do loop.

## Insight

No vault-michel, o pipeline-semanal É um loop engineering implementation. Cada fase (triagem → ingest → relatório) é um step do loop, com gates (Nexus) entre fases. A melhoria contínua dos patches (11 hoje) é o "Learn" do loop. O vault é um caso de estudo vivo de loop engineering.

## Evidências

- **[2026-06-23]** Build the Loop, Not the Agent — winning AI iteration — [[build-the-loop-not-the-agent-winning-ai-iteration]]
- **[2026-06-23]** Hypothesis-driven skill optimization for LLM agents — [[hypothesis-driven-skill-optimization-for-llm-agents]]
- **[2026-06-23]** Agent-as-a-Router: agentic model routing for coding — [[agent-as-a-router-agentic-model-routing-for-coding-tasks]]
- **[2026-06-23]** RigorBench: engineering process discipline in autonomous coding — [[rigorbench-benchmarking-engineering-process-discipline-in-autonomous-ai-coding-a]]
- **[2026-06-23]** Robust Agent Compensation (RAC): agents compensating weaknesses — [[robust-agent-compensation-rac-teaching-ai-agents-to-compensate]]
- **[2026-06-23]** Google engineer 19-page PDF on Loop Engineering — [[movez-on-x-a-senior-google-engineer-just-dropped-a-19-page-pdf-on-loop-engineeri]]
- **[2026-06-22]** Loop engineering amadureceu de conceito para framework — 20 sources em 2 runs (hot.md run anterior)

## Links

- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/ai-agents/skill]]
- [[03-RESOURCES/concepts/ai-agents/orchestrat]]