---
title: "How Agents Manage Other Agents: Four Subagents Patterns in 2026"
type: source
source_type: clipping
category: ai-agents
ingested: 2026-05-05
tags: [subagents, multi-agent, agent-patterns, inline-tool, fan-out, agent-pool, agent-teams, philschmid, orchestration]
---

# How Agents Manage Other Agents: Four Subagents Patterns in 2026

**Source:** https://x.com/_philschmid/status/2051674663965606052  
**Author:** [[@_philschmid]] (Philipp Schmid, Hugging Face)  
**Published:** 2026-05-05  
**Full article:** https://www.philschmid.de/subagent-patterns-2026

## Summary

Philipp Schmid presents four subagent patterns ordered by increasing complexity of main agent control over subagent lifecycle. The taxonomy progression goes from Pattern 1 (Inline Tool — subagent as a simple function call) through Pattern 4 (Teams — agents coordinate directly without main agent involvement). Each pattern has clear sync/async variants, specific toolsets, and explicit model capability requirements. The core insight is that Pattern 1 covers most subagent use cases and only frontier-class models should attempt Pattern 4, where agents communicate directly with each other.

## Key Takeaways

- **Pattern 1 — Inline Tool:** `call_agent` tool spawns subagent, returns result. Supports sync (blocks) and async (returns ID, result injected later). Works with smaller models. No mid-task course correction possible.
- **Pattern 2 — Fan-Out:** `spawn_agent` returns ID immediately, `wait_agent` blocks for results. Main agent can interleave its own work between spawn and wait. Value depends on model's ability to interleave — naive models get no benefit.
- **Pattern 3 — Agent Pool:** Persistent, stateful agents with messaging. Tools: `spawn_agent`, `send_message`, `wait_agent`, `list_agents`, `kill_agent`. Agents retain conversation history. Main agent routes information between specialists. Requires multi-turn state tracking.
- **Pattern 4 — Teams:** Cross-agent messaging, main agent sets up team and steps back. Requires frontier models for ALL participants, not just main agent. Infrastructure challenges: cycle detection, conflict resolution, shutdown coordination.
- Start with Pattern 1 — most tasks don't need complex orchestration
- Higher patterns demand progressively more capable models
- Pattern 4 failure modes: agents message wrong partner, forget to report completion, deadlock loops

## Concepts Linked

- [[03-RESOURCES/concepts/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/subagent-spawning]]
- [[03-RESOURCES/concepts/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/multi-principal-agent]]
- [[03-RESOURCES/concepts/agentic-patterns]]

## Entities Linked

- [[03-RESOURCES/entities/Philipp-Schmid]]
