---
title: "Pi Coding Agent — pi-loopflows"
type: source
source: "https://pi.dev/packages/pi-loopflows"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, pi, loopflows, subagents, deterministic-workflows, agent-harness]
---

## Tese Central

Pi é um agent de coding terminal-based que suporta extensions/skills via npm packages. `pi-loopflows` é um package que permite construir deterministic AI workflows a partir de Pi subagents — "LEGO for subagents". Conecta small specialist agents em processos com gates onde decisions matter, com control flow explícito: steps, feedback loops, stop rules, saved evidence. AI deve trabalhar através de um processo, não apenas produzir confident answer.

## Pontos-Chave

1. **Loopflows philosophy**: Linear chains são úteis mas real work não é sempre linear. Reviewer pode request changes, validator pode rejeitar missing evidence, planner pode revelar task blocked, builder pode precisar de several focused passes.
2. **Control flow explícito**: step → step → gate, com approved/changes_requested/blocked branches. Define quem faz work, quem checks, o que conta como success, quantas attempts, onde evidence é saved, quando run deve parar.
3. **Tool API**: `loopflow_run({ workflow, task, maxIterations })` — invoca workflow com task e iteration cap.
4. **Commands**: `/loopflow-list` para listar workflows disponíveis.
5. **Pi subagents como backend**: Usa Pi subagent definitions como first backend. Instala `pi-subagents` como prerequisite.

## Conceitos

- **Loopflows**: deterministic workflows de subagents com gates, loops, stop rules
- **Gate**: decision point em workflow que pode branch (approved/changes_requested/blocked)
- **Stop rules**: conditions explícitas para quando run deve parar

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/workflow-compilation]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]- [[03-RESOURCES/sources/ai-agents-harness/stop-babysitting-agents-definition-of-done-ericosiu]] — Pi LoopFlows implements 'Definition of Done' principle with explicit control flow
