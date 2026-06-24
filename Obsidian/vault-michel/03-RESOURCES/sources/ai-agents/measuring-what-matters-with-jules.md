---
title: "Measuring What Matters with Jules"
type: source
source: "https://developers.googleblog.com/measuring-what-matters-with-jules/"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, agent-evaluation, proactive-agents, google, jules, benchmarks]
---

## Tese Central

AI coding agents estão shiftando de reactive assistants (completam tasks quando prompted) para proactive engines que continuamente absorvem context, spot emerging risks, e surface diagnostic insights antes do developer pedir. O paper "Agentic Coding Needs Proactivity, Not Just Autonomy" argumenta que agents proativos devem ser avaliados pela sua insight policy — a habilidade de decidir o que importa, que evidência suporta, e se interromper o developer ou ficar silente.

## Pontos-Chave

1. **Tasks vs Goals**: Benchmarks como SWE-Bench testam completion de tasks (fix narrowly defined bug). Não existem benchmarks para goals — que requerem agent para explorar codebase, descobrir relevância, surface diagnostic observations que guiam developer toward higher-level objective.
2. **Ground truth via bug-fixing history**: Análise de temporal proximity e semantic similarity. Cluster de bugs related filed em short period são symptoms de single engineering effort. Individualmente task-specific, juntos revelam aspirational goal.
3. **Methodology**: 705 bugs (1,178 CLs) de internal Google codebases. Cluster bugs históricos → aspirational goals. Reverte codebase a pre-fix state. Agent investiga por até 3 rounds (exploration budget N). LLM judge 1-5 contra ground truth. Mede average top score + Hit@K.
4. **Resultados preliminares**: (1) Core diagnostic logic works — com 1 round, agent consistentemente identificou insight altamente relevante (avg 4.5/5). (2) Exploration budgets matter — Hit@5 accuracy rebounded de 33% (2 rounds) para 57% (3 rounds), provando que passes extras ajudam a uncover secondary signals.
5. **Future**: Expandir para public GitHub data (issues + resolving PRs). Ingest richer context streams: issue trackers, conversations, design docs além de codebase.

## Conceitos

- **Insight policy**: habilidade do agent de decidir o que importa, que evidência suporta, se interromper ou ficar silente
- **Proactive agent**: agent que absorve context continuamente e surface insights antes do developer pedir
- **Temporal proximity**: heuristic — bugs filed e fixed em short period são symptoms de single effort
- **Exploration budget (N)**: número de rounds que agent pode investigar codebase antes de gerar insights

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/agent-systems/llm-as-a-judge]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]