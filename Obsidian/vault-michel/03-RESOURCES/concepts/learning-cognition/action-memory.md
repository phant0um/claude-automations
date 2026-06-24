---
title: "Action Memory"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, memory]
status: developing
---

# Action Memory

An agent's memory of what it has done — distinct from what it knows — enabling it to avoid repeating mistakes, build on past runs, and maintain continuity across sessions.

## O que é / What it is

In the [[03-RESOURCES/concepts/agentic-memory-taxonomy|agentic memory taxonomy]], action memory is the **procedural / episodic** layer: a record of actions taken, outcomes observed, and errors encountered. It answers "what did I do and what happened?" rather than "what do I know?"

Also called **episodic memory** or **procedural memory** depending on the taxonomy used.

## Como funciona

Action memory is typically stored externally (outside the context window) because:
- Context windows are ephemeral — cleared between sessions.
- Action logs grow without bound; context doesn't.

**Storage mechanisms:**
- Append-only log files (e.g., `errors.md`, `.manifest.json`)
- Structured databases with timestamps and outcomes
- Compressed episodic summaries: "on 2026-05-31, ingested 17 sources; 3 failed due to encoding errors"

**Retrieval:** At session start, relevant action history is retrieved and injected into context. Not all history — just the slice relevant to the current task.

## Padrões / Patterns

- **Error log pattern:** Log failures with root cause. On similar tasks, retrieve recent errors to preempt. Michel's `04-SYSTEM/wiki/errors.md` is exactly this.
- **Manifest pattern:** `.raw/.manifest.json` records which sources have been processed, preventing re-ingestion.
- **Session memory:** Token-savior's memory tools store inter-session state as action memory.

## Por que importa

Without action memory, agents repeat the same mistakes across sessions. The vault's `errors.md` (max 30 entries, consolidate before adding) and `.manifest.json` are concrete implementations of action memory that prevent duplicate work and cascading errors.

## Related
- [[03-RESOURCES/concepts/agentic-memory-taxonomy]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/long-horizon-agents]]
- [[03-RESOURCES/concepts/agentic-execution]]
