---
title: "Multi-Step Planning"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, planning, reasoning]
status: developing
---

# Multi-Step Planning

Breaking a complex goal into an ordered sequence of executable steps before or during action — the skeleton of deliberative agency.

## O que é / What it is

Multi-step planning transforms a high-level goal ("migrate this codebase to Python 3.12") into a concrete sequence of verifiable actions. Without planning, agents take locally greedy steps that fail globally.

## Como funciona

**Plan-then-execute:** Generate a full plan upfront, then execute each step. Advantage: coherent global strategy. Risk: early plan assumptions may be wrong by step 10.

**Interleaved planning (ReAct style):** Alternate between a reasoning step (think about next action) and an execution step (do it). More adaptive; plan evolves as new observations arrive.

**Replanning on failure:** If an action fails or observation contradicts the plan, replan from current state. Critical for robustness in noisy environments.

## Padrões / Patterns

- **CoT planning:** Use chain-of-thought to generate a numbered step list before the first tool call. Visible to verifier/critic.
- **Structured plan (JSON/YAML):** Machine-readable plan enables automated validation of completeness and dependency ordering.
- **Hierarchical decomposition:** Break goal → subgoals → actions. Each level can be re-planned independently.
- **Dependency graph:** Model which steps can run in parallel vs must sequence. Feed to orchestrator for parallel fan-out.

## Por que importa

Every complex vault operation — batch ingest, FIAP source expansion, agent audits — begins with a plan. Explicit plans are auditable, checkpointable, and resumable. Michel's `.claude/todo.md` pattern is a lightweight form of structured multi-step planning.

## Related
- [[03-RESOURCES/concepts/agentic-execution]]
- [[03-RESOURCES/concepts/sequential-deliberation]]
- [[03-RESOURCES/concepts/agent-orchestration]]
- [[03-RESOURCES/concepts/long-horizon-agents]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
