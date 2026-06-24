---
title: "Parallel Reasoning"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, reasoning, inference-time-compute]
status: developing
---

# Parallel Reasoning

Running multiple reasoning paths or agent instances simultaneously — then selecting, aggregating, or synthesizing the best result.

## O que é / What it is

Parallel reasoning trades compute for quality: instead of one careful sequential chain, you generate N independent attempts and pick the best (or combine them). It is a primary strategy in **inference-time compute scaling** — using more compute at test time rather than training time to improve outputs.

## Como funciona

**Best-of-N (BoN):** Sample N independent solutions to the same problem. Use a verifier or scoring function to select the best. Simple and surprisingly effective.

**Parallel subagents:** Decompose a task into independent subtasks; assign each to a separate agent instance running in parallel. Orchestrator collects results. This is [[03-RESOURCES/concepts/agent-orchestration]]'s parallel fan-out pattern.

**Self-consistency:** Sample N chains-of-thought; take the majority answer. Works well when answers are discrete (math problems, MCQ).

**Diverse sampling:** Vary temperature, system prompt, or model across N runs to maximize diversity of solutions before selection.

## Padrões / Patterns

- **Generator-verifier separation:** Generator produces N candidates; verifier scores them. Separation prevents generator from gaming its own verifier.
- **Compute budget:** BoN scales as O(N) compute. Useful when N=4–16; diminishing returns beyond ~32 for most tasks.
- **Speculative parallelism:** Start multiple approaches simultaneously; commit to whichever finishes first with acceptable quality.

## Por que importa

Michel's batch-ingest pipeline runs one subagent per source in parallel — this is parallel reasoning applied to document processing. Understanding the pattern helps design the right degree of parallelism (how many subagents, how to merge results) and when to use BoN for critical tasks like complex concept synthesis.

## Related
- [[03-RESOURCES/concepts/sequential-deliberation]]
- [[03-RESOURCES/concepts/multi-agent]]
- [[03-RESOURCES/concepts/agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
