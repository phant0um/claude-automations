---
title: "Anatomy of Boris Cherny's CLAUDE.md — 13 Operating Principles"
type: source
source_type: clipping
hash: cbfeeca9a4fd42e493ef4cbde7ea5bd7
ingested: 2026-05-14
tags: [claude-code, CLAUDE.md, workflow, boris-cherny, operating-principles, self-improvement, plan-mode]
---

# Anatomy of Boris Cherny's CLAUDE.md

This file defines how the agent should behave day-to-day in a project, functioning as a working "constitution". 13 explicit rules mapped from CLAUDE.md verbatim to practical meaning.

## The 13 Rules Table

| # | Rule | CLAUDE.md Verbatim | Practical Meaning |
|---|------|--------------------|-------------------|
| 1 | **Plan Mode Default** | `### 1. Plan Mode Default` | Forces Claude to write the plan first. Prevents running in the wrong direction and wasting tokens. |
| 2 | **Subagent Strategy** | `### 2. Subagent Strategy` | Guides use of subagents to keep main context clean. Allows multiple research flows while main thread focuses on execution. |
| 3 | **Self-Improvement Loop** | `### 3. Self-Improvement Loop` | After any correction, error + solution must be logged to `tasks/lessons.md`. Goal: the same mistake never happens twice. |
| 4 | **Verification Before Done** | `### 4. Verification Before Done` | "Done" does not exist without proof. Claude must prove work functions via test, log, or diff comparison. |
| 5 | **Demand Elegance (Balanced)** | `### 5. Demand Elegance (Balanced)` | If a solution feels like a hack, implement the correct version. But: avoid over-engineering on simple fixes. |
| 6 | **Autonomous Bug Fixing** | `### 6. Autonomous Bug Fixing` | Given an error report, Claude reads logs, finds the cause, and fixes without hand-holding. |
| 7 | **Plan First** | `### 7. Plan First` | Maintains a live to-do list in `tasks/todo.md` with checkable items updated in real time. |
| 8 | **Verify Plan, Track Progress** | `### 8. Verify Plan, Track Progress` | Requires re-reading the plan before starting and marking each item as work advances. |
| 9 | **Explain Changes & Results** | `### 9. Explain Changes & Results` | One-line summary for each step taken. No mysterious edits without explanation. |
| 10 | **Capture Lessons** | `### 10. Capture Lessons` | Every lesson learned from a correction is saved for the next session. |
| 11 | **Simplicity First** | `### 11. Simplicity First` | Prioritize a simple one-line fix over a complex, "intelligent" rewrite. |
| 12 | **No Laziness** | `### 12. No Laziness` | No band-aids or temporary fixes. Claude must find the root cause to prevent breakage next week. |
| 13 | **Minimal Impact** | `### 13. Minimal Impact` | Touch only what is necessary. Avoid unsolicited refactors that introduce bugs in unrelated files. |

---

## Relationship to Existing Coverage

This source presents Cherny's principles in a structured 13-rule table format. The earlier source [[03-RESOURCES/sources/clipping-claudemd-senior-engineer-srishticodes]] covers similar content as a CLAUDE.md template with narrative explanations. Together they give both the rule-set and the implementation template.

**Key delta this source adds:**
- Explicit rule numbering (1–13) as a canonical reference
- Rule 13 (Minimal Impact) not prominently named in the earlier source
- "Demand Elegance Balanced" as a named, numbered principle

---

## See Also

- [[03-RESOURCES/entities/Boris-Cherny]] — creator of Claude Code at Anthropic
- [[03-RESOURCES/sources/clipping-claudemd-senior-engineer-srishticodes]] — drop-in CLAUDE.md template from same principles
- [[03-RESOURCES/concepts/claude-code-workflow]] — EPCC workflow; Cherny's principles extend and reinforce it
- [[03-RESOURCES/concepts/claude-folder-anatomy]] — CLAUDE.md role in project configuration
