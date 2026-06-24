---
title: "spec-kit: GitHub Official Toolkit for Spec-Driven Development"
type: source
source_type: clipping
source_file: "Clippings/spec-kit 💫 Toolkit to help you get started with Spec-Driven Development.md"
source_url: "https://github.com/github/spec-kit"
author: "GitHub (official)"
created: 2026-05-14
tags: [spec-driven-development, spec-kit, github, ai-coding, slash-commands, agent-skills, specify-cli, extensions]
triagem_score: 8
---

# spec-kit: GitHub's Spec-Driven Development Toolkit

**Source:** Official GitHub repository — `github/spec-kit`  
**Status:** Open source; 92k+ stars  
**Note:** Related source [[03-RESOURCES/sources/open-source-ecosystems/guillecasaus-github-spec-kit]] covers a community thread about this tool.

## Core Premise

> "Specifications become executable, directly generating working implementations rather than just guiding them."

Traditional development treats specs as scaffolding to be discarded. Spec-Driven Development (SDD) inverts this: specs drive implementation. Agents work *from* the spec, not around it.

## Workflow: 5 Core Steps

1. **`/speckit.constitution`** — establish project governing principles and development guidelines
2. **`/speckit.specify`** — describe *what* and *why* (not tech stack); focus on user stories
3. **`/speckit.plan`** — provide tech stack and architecture choices
4. **`/speckit.tasks`** — generate actionable task list from implementation plan
5. **`/speckit.implement`** — execute all tasks

### Optional Commands

| Command | Purpose |
|---|---|
| `/speckit.clarify` | Clarify underspecified areas before planning |
| `/speckit.analyze` | Cross-artifact consistency check after tasks, before implement |
| `/speckit.checklist` | Generate quality checklists ("unit tests for English") |
| `/speckit.taskstoissues` | Convert tasks → GitHub issues |

## Installation

Via `specify-cli` using `uv` or `pipx`. Integrates with 30+ AI coding agents including Claude Code, GitHub Copilot, Cursor, Codex, Gemini.

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@vX.Y.Z
specify init <PROJECT_NAME>
specify init . --integration copilot
```

Skills mode: `--integration-options="--skills"` installs agent skills instead of slash commands.

## Extension System

Community extensions (60+) are organized by category and effect:

| Category | Examples |
|---|---|
| `process` | MAQA (multi-agent QA), Fleet Orchestrator, Agent Assign |
| `code` | Review, Staff Review, SpecTest, Cleanup |
| `docs` | Blueprint, Reconcile, DocGuard |
| `integration` | GitHub Issues, Jira, Azure DevOps, Confluence |
| `visibility` | Project Health Check, Status, Spec Diagram |

Notable extensions:
- **MAQA** — Coordinator → feature → QA agent workflow with parallel worktrees
- **Superpowers Bridge** — integrates obra/superpowers skills across full SDD lifecycle
- **Red Team** — adversarial lens review before plan; surfaces prompt injection and integrity gaps
- **Agent Assign** — assigns specialized Claude Code agents to spec-kit tasks
- **Token Consumption Analyzer** — captures and compares token costs across SDD workflows

## Template Priority Stack

```
Project-Local Overrides (.specify/templates/overrides/) — highest
Presets (.specify/presets/templates/)
Extensions (.specify/extensions/templates/)
Spec Kit Core (.specify/templates/) — lowest
```

Templates resolve at runtime (top-down first match). Extension/preset commands applied at install time.

## Connections

- [[03-RESOURCES/concepts/learning-cognition/spec-driven-development]] — main concept
- [[03-RESOURCES/sources/open-source-ecosystems/guillecasaus-github-spec-kit]] — community thread on same tool
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] — spec-kit as a structured harness approach
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — MAQA extension as multi-agent pattern
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — skills mode installation
- [[03-RESOURCES/entities/github]] — publisher of spec-kit

---

## Spec-Driven Development: the inversion explained

Traditional software development treats specifications as temporary scaffolding — they guide early decisions and are discarded once the code exists. The spec-kit philosophy inverts this relationship: the specification is the primary artifact, and code is a derivative output.

This inversion has concrete consequences. When the spec is the source of truth, any inconsistency between spec and code is unambiguously a bug in the code, not in the spec. Agents can be given clear instructions: "implement this spec faithfully; if you deviate, document why in implementation notes." Without a canonical spec, agents improvise — and improvisation at scale compounds into architectural drift.

The `/speckit.specify` step enforces a discipline that is harder than it sounds: describe *what* and *why*, not *how*. Most engineers default to mixing requirements with implementation details because the two feel inseparable in practice. spec-kit forces the separation by making `specify` a distinct phase from `plan` — the tech stack and architecture choices live in `plan`, not in the spec.

## How the 5-step workflow maps to agent handoffs

Each step in the spec-kit workflow produces a structured artifact that becomes the input for the next agent:

| Step | Output artifact | Consumed by |
|---|---|---|
| `constitution` | `CONSTITUTION.md` | All subsequent steps |
| `specify` | `SPEC.md` | `plan`, `clarify`, `analyze` |
| `plan` | `PLAN.md` | `tasks`, `analyze` |
| `tasks` | `TASKS.md` | `implement`, `taskstoissues` |
| `implement` | Working code | Human review, QA agents |

This chain is what makes spec-kit compatible with multi-agent workflows like MAQA: each artifact is a stable handoff point. The Coordinator agent in MAQA reads `TASKS.md` and routes individual tasks to Feature agents; QA agents read `SPEC.md` to validate outputs. The spec is the shared memory across the agent team.

## Why `/speckit.analyze` matters before implementation

The `analyze` command does cross-artifact consistency checking after `tasks` but before `implement`. This is the spec-kit equivalent of a compiler's type checker: it surfaces contradictions between what the spec promises, what the plan assumes, and what the tasks describe, *before* any code is written.

Skipping `analyze` is the most common source of expensive implementation rework. An agent that starts implementing with inconsistent artifacts will make locally reasonable choices that are globally incorrect, and the inconsistency only becomes visible late in the process.

## Template priority stack: practical implications

The priority stack (Project overrides → Presets → Extensions → Core) means that spec-kit is fully customizable without forking the core toolkit. A team can:

- Override the default `specify` template with an organization-specific user story format (Project overrides)
- Apply a domain preset (e.g., "API-first" or "data-pipeline") that adjusts `plan` defaults
- Install community extensions for QA or integration without those extensions affecting core behavior

This layered approach follows the same principle as Obsidian's CSS snippets: each layer adds without replacing unless explicitly overriding.

## Extension ecosystem patterns

The 60+ community extensions reveal recurring patterns in how teams extend spec-kit:

**Parallelism extensions** (MAQA, Fleet Orchestrator, Agent Assign) add coordination layers on top of the sequential 5-step flow. These are for teams whose tasks are independent enough to fan out.

**Quality gate extensions** (Staff Review, Red Team, SpecTest) insert adversarial checkpoints. Red Team is particularly notable: it applies an adversarial lens *before* planning, surfacing prompt injection risks and integrity gaps at the cheapest possible moment.

**Integration bridges** (GitHub Issues, Jira, Azure DevOps) convert `TASKS.md` into tickets in external systems, closing the loop between AI-generated task lists and human project management workflows.

## Relevance for vault-michel

The `04-SYSTEM/agents/spec` agent in this vault applies spec-driven principles at the note level: any non-trivial restructuring starts with a spec (written to `.claude/todo.md`) before execution. The spec-kit workflow formalizes and scales this practice to software projects. Key transferable insights:

- The `constitution` step maps to CLAUDE.md — governing principles before any task
- The `specify` step maps to writing an agent's AGENTS.md before writing its implementation
- The `analyze` step maps to the lint/verify cycle before marking ingestion complete

## Limitations

- **LLM quality dependency:** spec-kit is a harness, not a model. Poor prompts to `/speckit.specify` produce ambiguous specs that propagate downstream; the framework cannot compensate for underspecified inputs
- **Sequential overhead:** the 5-step flow adds latency compared to prompting an agent directly; justified for complex projects, overkill for single-file changes
- **Extension compatibility:** community extensions vary in quality and maintenance; the `Red Team` and `MAQA` extensions are well-regarded but most extensions lack automated tests
- **Template drift:** as projects evolve, overrides in `.specify/templates/overrides/` can diverge from updated core templates without warning
