---
title: "Agent Orchestration"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, orchestration]
status: developing
---

# Agent Orchestration

Coordinating multiple AI agents so that together they accomplish tasks no single agent could handle alone.

## O que é / What it is

Agent orchestration is the discipline of designing how an **orchestrator** (often itself an LLM) routes work to **subagents**, collects results, and assembles a final output. The orchestrator holds the goal; subagents hold the tools or domain knowledge.

This note is the top-level entry point. For deep patterns, see [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]].

## Como funciona

1. Orchestrator receives a high-level goal.
2. It decomposes the goal into subtasks (see [[03-RESOURCES/concepts/multi-step-planning]]).
3. Each subtask is dispatched — sequentially or in parallel — to a subagent with the right tools.
4. Results are collected, validated, and synthesized.
5. If a subagent fails, the orchestrator replans or retries.

## Padrões / Patterns

| Pattern | When to use |
|---------|-------------|
| Sequential chain | Each step depends on the previous output |
| Parallel fan-out | Independent subtasks; maximize throughput |
| Hierarchical delegation | Subagents spawn their own subagents |
| Critic-actor | One agent acts, another reviews before commit |

**Single agent vs multi-agent:** Use a single agent when the task fits in one context window and requires no specialization. Add subagents when you hit the context ceiling, need parallelism, or want role isolation.

## Por que importa

Michel's vault uses orchestration daily: Nexus dispatches ingest jobs to subagents, parallel batch-ingest runs one subagent per source, and the SO layer (guard, hill, review) operates as a specialist tier. Understanding orchestration tradeoffs directly improves agent design.

## Related
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/multi-agent]]
- [[03-RESOURCES/concepts/multi-step-planning]]
- [[03-RESOURCES/concepts/agentic-execution]]
- [[03-RESOURCES/concepts/human-in-the-loop]]

## Evidências
- **[2026-06-19]** "Se as skills morrem no restart do processo, o compounding reseta a zero" — durabilidade é pré-requisito para qualquer estratégia de longo prazo baseada em agentes — [[03-RESOURCES/sources/the-agent-loop-architecture]]
- **[2026-06-19]** Padrão "council": juiz frontier lê respostas de painel de modelos baratos/abertos e escreve a melhor versão combinada — útil para orquestrar decisões de jobs longos e multi-etapa (qual o plano, o que é arriscado), com agente mais barato executando os passos — [[03-RESOURCES/sources/fable-intelligence-model-council]]

- **[2026-06-24]** This two-part series explores how ontology-grounded agentic AI transforms Design Failure Mode and Effects Analysis (DFME — [[reimagining-b-pillar-dfmea-why-ontology-grounded-ai-is-the-future-of-automotive-engineering]]
- [[03-RESOURCES/sources/snowflake-aim-migration-agent-automating-enterprise-migrations]] — Orquestração de migração enterprise com estado persistente, deployment waves por dependências
