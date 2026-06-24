---
title: "Verification-Driven Development"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations, agent-systems, software-engineering]
status: developing
---

# Verification-Driven Development

Building verification into the development cycle from the start — so that generated or edited code is checked automatically before it is accepted.

## O que é / What it is

Verification-driven development (VDD) is a pattern where the **verifier is defined before or alongside the generator**. In agentic contexts, this means the agent's success criterion is an executable check (test suite, linter, type checker, contract assertion) — not a human eyeball.

It generalizes TDD: where TDD requires a human to write tests first, VDD encompasses any workflow where a machine-executable verifier gates acceptance.

## Como funciona

**Generator-verifier loop:**
1. Specify verification criteria (tests, schemas, constraints).
2. Generator (LLM / coding agent) produces a candidate solution.
3. Verifier runs automatically.
4. If pass → accept. If fail → return error to generator for retry.
5. Loop until pass or budget exhausted.

**Verifier types:**
- Unit / integration tests (most common)
- Type checkers (mypy, TypeScript)
- Linters and formatters
- LLM-as-judge (for prose, plans, or subjective quality)
- Formal specs (rare but powerful)

## Padrões / Patterns

- **Tests as specs:** The test suite is the specification. If it passes, the contract is met — regardless of implementation.
- **Agentic quality gates:** Claude Code's verify agent and the vault's `verify` step in ingest flow are VDD instances.
- **Escape hatch:** Generator gets K retry attempts. If K fails, escalate to human. Prevents infinite loops.

## Por que importa

The vault's ingest checklist (file in correct space, wikilinks valid, hot.md updated, manifest updated) is a manual VDD checklist. Automating it via the `verify` agent turns a human bottleneck into a machine gate — accelerating the ingest-consolidation loop.

## Related
- [[03-RESOURCES/concepts/coding-agents]]
- [[03-RESOURCES/concepts/agentic-execution]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/dev-foundations/_index]]
