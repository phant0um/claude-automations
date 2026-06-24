---
title: Spec-Driven Development
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [sdd, spec-kit, ai-coding, agentic, software-development, specifications]
---

# Spec-Driven Development (SDD)

## Core Idea

SDD inverts the traditional relationship between specifications and code. Historically, specs are scaffolding — written and discarded once coding begins. In SDD, **specifications become executable**: they directly generate working implementations rather than merely guiding them.

> "Focus on product scenarios and predictable outcomes instead of vibe coding every piece from scratch."

The key insight: AI agents work *from* well-structured specs. A spec that an AI can read, discuss, and execute is more valuable than one written for human readers.

## Why SDD Addresses Vibe Coding

**Vibe coding** — prompting an AI agent to build from a vague idea — produces unpredictable scope, accumulating drift, and invisible design decisions. SDD structures the gap between user intent and code:

1. User describes *what* and *why* (not how)
2. Spec is written and validated
3. Technical plan is created
4. Tasks are generated from the plan
5. Agent executes against the tasks

At each phase gate, the agent has explicit, checkable artifacts to work against.

## Workflow (spec-kit commands)

| Phase | Command | Output |
|---|---|---|
| Governance | `/speckit.constitution` | Project principles + dev guidelines |
| Requirements | `/speckit.specify` | Spec with user stories |
| Architecture | `/speckit.plan` | Tech stack + implementation plan |
| Breakdown | `/speckit.tasks` | Ordered, actionable task list |
| Execution | `/speckit.implement` | Working implementation |

Optional gates: `/speckit.clarify` (ambiguity elimination), `/speckit.analyze` (cross-artifact consistency), `/speckit.checklist` ("unit tests for English specs").

## Key Properties

- **Spec-first, not code-first** — design decisions are explicit, not embedded silently in code
- **Artifacts are traceable** — each task maps to a spec; each implementation maps to a task
- **Harness-agnostic** — spec-kit works with Claude Code, Copilot, Cursor, Codex, Gemini, 30+ agents
- **Extensible** — 60+ community extensions add capabilities (MAQA, Red Team, Blueprint, Verify, etc.)

## Relationship to Other Patterns

- **Context engineering** — SDD produces fat context (spec + plan + tasks) that the agent operates within; reduces hallucinated decisions
- **Planner/generator/evaluator** — SDD formalizes the planner phase; spec-kit extensions like MAQA add the evaluator
- **SKILL.md pattern** — spec-kit can be installed as agent skills (not just slash commands); `/speckit.implement` as a skill

## Reference Implementations

- **spec-kit** (github/spec-kit) — open source CLI; `specify` command; 92k+ stars
- **MAQA extension** — multi-agent QA with parallel worktrees; coordinator → feature → QA agent
- **Superpowers Bridge** — integrates obra/superpowers TDD + code-review across SDD lifecycle

## Sources

- [[03-RESOURCES/sources/open-source-ecosystems/spec-kit-github-official-readme]] — official spec-kit README
- [[03-RESOURCES/sources/open-source-ecosystems/guillecasaus-github-spec-kit]] — community explanation
