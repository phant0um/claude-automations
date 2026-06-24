---
title: "多智能体协作调查：Agent 到底该怎么分工"
slug: multi-agent-division-of-labor-survey
type: source
category: ai-agents
author: "@Russell3402"
source_url: "https://x.com/Russell3402/status/2056331558223786416"
published: 2026-05-18
ingested: 2026-05-18
tags: [ai-agents, multi-agent, orchestration, topology, fan-out, kanban, codex, hermes, openclaw]
triagem_score: 9
---

# 多智能体协作调查：Agent 到底该怎么分工

## Tese central

Multi-agent systems require engineering decisions beyond "spawning multiple model instances": task scheduling, context isolation, permission control, state management, and result merging are the real complexity. The survey reverse-engineers how Codex, Claude Code, OpenClaw, and Hermes actually handle these problems.

## Key insights

1. **Trigger taxonomy (4 types):** Explicit (Codex — user authorizes parallel), Semantic (Claude Code — description matching drives subagent calls), Routing (OpenClaw — entry channel determines agent), Queue (Hermes Kanban — persistent dispatcher pulls workers by state/assignee).

2. **Topology catalog:** Single agent (default, strong dependency tasks) → Star fan-out/fan-in (most common; orchestrator dispatches, workers don't cross-communicate, orchestrator merges) → Chain pipeline (strictly ordered tasks) → Tree (layered; control depth/fan-out or exponential blowup) → Mesh team (multi-hypothesis; higher coordination cost) → Gateway routing (multi-entrypoint, not task-split) → Durable board (cross-turn, cross-day, persistent state).

3. **Invocation chain model:** `input event → router/dispatcher → context builder → worker profile selection → execution sandbox → state store → merge/reduce → final output or next task`. Each system implements these steps differently.

4. **Context budget discipline:** Star topology pushes all conflict resolution to the merge stage (single responsibility, but no peer correction). Mesh topologies distribute conflict detection but multiply coordination tokens.

5. **Hermes Kanban = durable queue topology:** tasks survive restarts, human interventions, cross-day handoffs — qualitatively different from in-turn fan-out.

6. **Codex design philosophy:** never auto-spawns workers; parallel authorization stays with user + main agent. Trades autonomy for auditability.

7. **Claude Code semantic trigger failure mode:** description written as a "wish" (not a trigger condition) → system calls wrong agent at wrong time.

## Links

- [[03-RESOURCES/entities/hermes]] — Kanban dispatcher, delegate_task, durable board topology
- [[03-RESOURCES/entities/Hermes-Agent]] — Hermes as coding agent with skills
- [[03-RESOURCES/entities/OpenClaw-Assistant]] — gateway routing, channel-based agent selection
- [[03-RESOURCES/entities/Claude Code]] — semantic trigger via subagent description matching
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — core concept; this source expands topology taxonomy
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — harness layer responsible for dispatch/merge
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — skills as worker profiles in multi-agent systems

## Topology Deep-Dives

### Star Fan-Out / Fan-In (Most Common Production Pattern)

A central orchestrator receives the task, decomposes it, and dispatches subtasks to N workers. Workers execute in isolation — no peer communication. The orchestrator collects all outputs and merges them into a final response.

**Why it dominates:** Simple to implement; workers are stateless and swappable; failure of one worker does not cascade. The orchestrator is the single point of consistency enforcement.

**Hidden cost:** All conflict resolution happens at merge time. If two workers produce contradictory outputs (e.g., one finds a bug, the other marks the same code as correct), the orchestrator must adjudicate without being able to trigger a cross-worker debate. Mesh topologies solve this at higher coordination cost.

**When it breaks:** Tasks with strong sequential dependencies between subtasks. If subtask B requires the output of subtask A as input, fan-out cannot parallelize them — it degrades into a chain with fan-out overhead.

### Hermes Kanban (Durable Board Topology) — Why It's Qualitatively Different

Standard fan-out topologies are ephemeral: if the session ends, the task state is gone. Hermes Kanban persists task state to a board (database or structured file) that survives restarts, human interventions, and multi-day execution windows.

The board stores: task ID, assignee agent, status (pending/in-progress/done/blocked), context snapshot, and result. Workers pull from the board rather than receiving pushed assignments. This inverts the control model: the dispatcher is a scheduler consulting a persistent queue, not an active caller.

**Practical implication:** A Kanban-topology agent can hand off a task to a human ("waiting for approval"), resume when approved, and continue across a multi-day gap without re-queuing from scratch.

### Claude Code Semantic Trigger — Failure Mode Analysis

Claude Code's subagent dispatch mechanism matches the incoming task description to registered subagent descriptions using semantic similarity. This is powerful but brittle.

The failure mode: a subagent description written as a goal ("handles all database-related questions") instead of a trigger condition ("activates when the user asks to write, optimize, or debug SQL queries, schema migrations, or ORM mappings") will fire unpredictably. Semantic matching on goal language is ambiguous; semantic matching on trigger-condition language is near-deterministic.

**Fix:** Write subagent descriptions in "activates when [specific condition]" form. Test by giving the orchestrator five representative prompts and verifying which agent fires for each.

## Invocation Chain as Engineering Decision Surface

The full invocation chain:
```
input event → router/dispatcher → context builder → worker profile selection → execution sandbox → state store → merge/reduce → final output or next task
```

Each arrow is an engineering decision with cost and failure mode tradeoffs:

- **Router:** semantic vs. explicit vs. queue-pull. Semantic = flexible, brittle. Explicit = rigid, reliable. Queue = durable, higher latency.
- **Context builder:** what context does each worker receive? Shared context (transcript, global rules) + focused context (task-specific instructions) is the optimal decomposition from Sully.ai research.
- **State store:** in-memory (fast, ephemeral) vs. database (durable, slower). Hermes uses database; most academic multi-agent papers use in-memory.
- **Merge/reduce:** naive concatenation vs. orchestrator re-synthesis vs. voting. Orchestrator re-synthesis is most expensive but handles contradictions. Voting works for factual tasks; fails for generative tasks.

## Complexity Progression and When to Escalate

Starting with single-agent and escalating to multi-agent should be driven by evidence, not anticipation:

1. Single agent fails on a task class reliably → profile whether the failure is context overload, skill gap, or serial bottleneck
2. Context overload → decompose into star fan-out with focused per-worker context
3. Serial bottleneck → chain pipeline
4. Need cross-worker debate → mesh (expensive, justify with quality data)
5. Tasks span multiple days or require human checkpoints → Kanban durable board

The most common mistake in 2026: jumping to mesh topology (multi-agent debate) for tasks that a star fan-out with good context engineering would solve at 1/5 the token cost.
