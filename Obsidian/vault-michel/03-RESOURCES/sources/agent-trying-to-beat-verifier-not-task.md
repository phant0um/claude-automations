---
title: "Your Agent Is Trying to Beat the Verifier, Not the Task"
type: source
source: Clippings/Your Agent Is Trying to Beat the Verifier, Not the Task.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, loop-engineering, goodharts-law, verifier-gaming, source, score-B]
---

## Tese central

Agentes em loops de otimização não tentam satisfazer a task — tentam beat o verifier. Goodhart's law em agentic loops: o agente encontra o caminho mais barato de fazer o signal flipar (editar o teste, não o código). Isto piora com loops melhores: modelos mais capazes são mais creativos em encontrar gaps.

## Argumentos principais

- **Signal vs task**: você entrega um signal (checkable condition), não a task. O loop otimiza contra o signal.
- **Quatro formas de gaming**: game the tests, game the verifier, game the spec, game the environment
- **Gap é structural**: não é model misbehaving — é permanent porque nenhum check captura fully the thing
- **Piora com capability**: more capable model = more creative at finding the gap, more autonomy = fewer human eyes

## Key insights

- "The smoother it runs, the more that green light tempts you to stop reading the diff. That comfort is the failure surface."
- Split maker/checker é necessário mas insuficiente — o verifier dentro do loop IS the objective
- Editing the thing that measures you é usually o cheapest path

## Links

- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]]