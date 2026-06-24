---
title: Agent Eval Framework
type: concept
created: 2026-05-19
updated: 2026-05-19
tags: [ai-agents, evaluation, framework, cluster]
aliases: [agent-evaluation, eval-framework, agent-eval]
status: aggregator
---

# Agent Eval Framework

Cluster conceitual sobre **avaliação de agentes LLM**. Agrega fontes da série Cameron R. Wolfe (PhD) + papers acadêmicos sobre benchmark design, statistical rigor e LLM-as-judge.

## Tese central

Avaliar agentes ≠ avaliar modelos. Agentes operam em **harness** + **ferramentas** + **trajetória multi-step**, exigindo eval pipelines que considerem custo, recovery de erros, e generalização — não só accuracy.

## Quatro pilares

### 1. Harness vs Model Eval
- **Model-Bound**: bottleneck no modelo subjacente — mudar modelo melhora resultados
- **Harness-Bound**: bottleneck no scaffold (tools, prompts, retry logic) — melhorar harness > swap model
- Decisão de onde investir esforço depende de qual fronteira está saturada
- Ver: [[03-RESOURCES/sources/ai-agents-harness/agent-performance-model-bound-versus-harness-bound]]

### 2. Statistical Rigor
- Single-run metrics enganam: variance entre runs > delta entre configs
- **Bootstrap CI** para intervalos de confiança em pequenas amostras
- **McNemar test** para comparações pareadas (A vs B no mesmo conjunto)
- **Power analysis** para dimensionar conjunto de eval
- Ver: [[03-RESOURCES/sources/ml-research-papers/applying-statistics-to-llm-evaluations]]

### 3. Benchmark Anatomy
- **Data contamination**: training set leaked → score inflado
- **Difficulty calibration**: muito fácil → ceiling; muito difícil → noise
- **Leakage paths**: imagem do problema indexada, código de solução em GitHub público
- Bons benchmarks: held-out, calibrado, versionado, com partition de difficulty
- Ver: [[03-RESOURCES/sources/ml-research-papers/the-anatomy-of-an-llm-benchmark]]

### 4. LLM-as-Judge + Rubrics
- **LLM-as-judge**: modelo avalia outro modelo via rubric estruturada
- **Rubric-Based Rewards (RLVR)**: estende RL pra domínios não-verificáveis usando rubric LLM como oracle
- Trade-off: judge LLM herda bias do training; calibrar com human anchors
- Ver: [[03-RESOURCES/sources/ml-research-papers/rubric-based-rewards-for-rl]]

## Fontes agregadas

- [[03-RESOURCES/sources/ai-agents-harness/agent-evaluation-a-detailed-guide]] (9) — overview framework
- [[03-RESOURCES/sources/ml-research-papers/applying-statistics-to-llm-evaluations]] (8) — rigor estatístico
- [[03-RESOURCES/sources/ml-research-papers/the-anatomy-of-an-llm-benchmark]] (8) — benchmark design
- [[03-RESOURCES/sources/ml-research-papers/rubric-based-rewards-for-rl]] (8) — rubric judges
- [[03-RESOURCES/sources/ai-agents-harness/agent-performance-model-bound-versus-harness-bound]] (7) — onde investir

## Conceitos relacionados

- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/concepts/llm-ml-foundations/rl-training-llms]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]] — LLM-as-Judge: 1 de 5 métodos de scoring
- [[03-RESOURCES/sources/ai-agents-harness/clipping-29-llm-eval-concepts]] — 29 conceitos completos + Gavel case study

## Aplicação no vault

- Skill `agent-eval` (sugerida em triagem) implementaria este framework como checklist invocável
- Cross-link em todo source novo sobre eval/benchmark adiciona `[[agent-eval-framework]]`
