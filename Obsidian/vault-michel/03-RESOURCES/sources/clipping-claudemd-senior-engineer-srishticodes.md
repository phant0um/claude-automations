---
title: "CLAUDE.md — Turning Claude Code into a Senior Engineer (srishticodes)"
type: source
source_type: social-media
platform: Thread Reader App
author: "@srishticodes"
original_url: "https://threadreaderapp.com/thread/2050830626157482321.html"
created: 2026-05-05
tags: [claude-code, CLAUDE.md, workflow, self-improvement, subagents, plan-mode, autonomous-bug-fixing]
---

# CLAUDE.md — Turning Claude Code into a Senior Engineer

Thread by [@srishticodes](https://threadreaderapp.com/user/srishticodes) summarizing internal Claude Code workflows attributed to [[03-RESOURCES/entities/Boris-Cherny]] (creator of Claude Code at Anthropic), turned into a drop-in CLAUDE.md template.

## Core claim

A CLAUDE.md configured with these patterns turns Claude Code into a senior engineer that permanently encodes corrections:

> Every time you correct Claude, the rule gets encoded permanently. Next session it doesn't repeat the mistake. Next month it matches how you think. Next year you're not managing Claude.

## The Drop-in CLAUDE.md — Full Template

### Workflow Orchestration

**1. Plan Node Default**
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

**2. Subagent Strategy**
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

**3. Self-Improvement Loop**
- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

**4. Verification Before Done**
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

**5. Demand Elegance (Balanced)**
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes — don't over-engineer

**6. Autonomous Bug Fixing**
- When given a bug report: just fix it — no hand-holding
- Point at logs, errors, failing tests — then resolve them
- Go fix failing CI tests without being told how

### Task Management

1. **Plan First** — Write plan to `tasks/todo.md` with checkable items
2. **Verify Plan** — Check in before starting implementation
3. **Track Progress** — Mark items complete as you go
4. **Explain Changes** — High-level summary at each step
5. **Document Results** — Add review section to `tasks/todo.md`
6. **Capture Lessons** — Update `tasks/lessons.md` after corrections

### Core Principles

- **Simplicity First** — Make every change as simple as possible. Impact minimal code.
- **No Laziness** — Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact** — Changes should only touch what's necessary. Avoid introducing bugs.

## Key concepts surfaced

- [[03-RESOURCES/concepts/claudemd-self-improvement-loop]] — the self-encoding corrections pattern
- [[03-RESOURCES/concepts/claude-code-workflow]] — plan mode + EPCC; this source reinforces and extends with autonomous bug fixing
- [[03-RESOURCES/concepts/claude-folder-anatomy]] — CLAUDE.md role in project configuration

## Related entities

- [[03-RESOURCES/entities/Boris-Cherny]] — creator of Claude Code; attributed source of these workflows
- [[03-RESOURCES/entities/Claude Code]] — tool being configured
- [[03-RESOURCES/entities/Srishticodes]] — thread author / curator
