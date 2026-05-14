---
title: "spec-kit: GitHub Official Toolkit for Spec-Driven Development"
type: source
source_type: clipping
source_file: "Clippings/spec-kit 💫 Toolkit to help you get started with Spec-Driven Development.md"
source_url: "https://github.com/github/spec-kit"
author: "GitHub (official)"
created: 2026-05-14
tags: [spec-driven-development, spec-kit, github, ai-coding, slash-commands, agent-skills, specify-cli, extensions]
---

# spec-kit: GitHub's Spec-Driven Development Toolkit

**Source:** Official GitHub repository — `github/spec-kit`  
**Status:** Open source; 92k+ stars  
**Note:** Related source [[03-RESOURCES/sources/guillecasaus-github-spec-kit]] covers a community thread about this tool.

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

- [[03-RESOURCES/concepts/spec-driven-development]] — main concept
- [[03-RESOURCES/sources/guillecasaus-github-spec-kit]] — community thread on same tool
- [[03-RESOURCES/concepts/agentic-harness-engineering]] — spec-kit as a structured harness approach
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — MAQA extension as multi-agent pattern
- [[03-RESOURCES/concepts/claude-skills]] — skills mode installation
- [[03-RESOURCES/entities/GitHub]] — publisher of spec-kit
