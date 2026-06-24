---
title: "Long-Horizon Agents"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, long-horizon]
status: developing
---

# Long-Horizon Agents

Agents that operate over hundreds of steps and minutes-to-hours of real time — pushing the frontier of autonomous task completion.

## O que é / What it is

A long-horizon agent sustains coherent, goal-directed behavior over a task duration that far exceeds the typical LLM interaction. The challenge is not individual action quality but **sustained coherence under accumulating uncertainty**.

## Métricas / Metrics

**METR Time-Horizon Metric:** Measures the length of tasks (in time) that SOTA models can complete with 50% success. In 2025–2026, this roughly **doubles every 4 months** — one of the fastest capability trajectories in AI.

Current SOTA (~mid-2026): ~1–4 hours of autonomous task completion before human intervention needed.

## Desafios / Challenges

| Challenge | Description |
|-----------|-------------|
| Context management | Context window fills; agent must compress or delegate |
| Error compounding | Early mistakes cascade; correction cost grows with horizon |
| Credit assignment | Hard to attribute long-run outcomes to specific actions |
| State drift | World state changes during a long run (files modified externally, etc.) |
| Goal drift | Agent loses track of original objective after many steps |

## Padrões / Patterns

- **Checkpointing:** Save state every N steps; enable resume without restart.
- **Episodic summaries:** Compress earlier context into a structured summary; keep full detail only for recent steps.
- **Subgoal decomposition:** Break the horizon into sub-horizons. Each is tractable; orchestrator chains them. See [[03-RESOURCES/concepts/multi-step-planning]].
- **Invariant monitors:** Background process checks that invariants (e.g., "never delete production files") hold throughout the run.

## Por que importa

Michel's vault's ambitious goal — a "self-writing vault" with continuous improvement — is a long-horizon agent task. Understanding the failure modes shapes the design of the hill agent, checkpoint policies, and human oversight thresholds.

## Context Management em Long-Horizon Tasks (AdaCoM, 2026)

Gerenciamento de contexto externo resolve o desafio "Context management" da tabela acima sem retreinar o agente. **AdaCoM** treina um manager externo (4B params) por RL para editar o contexto antes de cada passo — resultando em +39% médio em web search e +15% em deep research.

Causa raiz identificada: *constraint forgetting* (agent esquece requisitos), *premature abandonment* (desiste cedo), *redundant exploration* (loops de tool calls idênticos — 42,6% dos passos Kimi eram repetições).

Ref: [[03-RESOURCES/sources/adacom-adaptive-context-management]]

## Related
- [[03-RESOURCES/concepts/long-horizon-agent-training]]
- [[03-RESOURCES/concepts/agentic-execution]]
- [[03-RESOURCES/concepts/multi-step-planning]]
- [[03-RESOURCES/concepts/human-in-the-loop]]
- [[03-RESOURCES/concepts/agentic-memory-taxonomy]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/sources/adacom-adaptive-context-management]]
- [[03-RESOURCES/concepts/agent-systems/_index]]

## Evidências
- **[2026-06-19]** Project Fetch Phase 2: Opus 4.7 sem assistência humana, ~20x mais rápido que o time humano mais veloz da Fase 1, usando quase 10x menos código que Team Claude — [[03-RESOURCES/sources/project-fetch-phase-two]]
