---
title: "walkinglabs/learn-harness-engineering: Beginner Tutorial, from 0 to 1"
type: source
source_url: "https://github.com/walkinglabs/learn-harness-engineering"
author: walkinglabs (community)
ingested: 2026-05-09
source_type: github-repo-readme
tags:
  - harness-engineering
  - ai-agents
  - coding-agents
  - tutorial
  - clippings
---

# walkinglabs/learn-harness-engineering — Harness Engineering Tutorial

A project-based open-source course on building the environment, state management, verification, and control mechanisms that make AI coding agents work reliably. Available in EN, ZH, RU, VI, KO.

Core references cited by the course:
- OpenAI: "Harness engineering: leveraging Codex in an agent-first world"
- Anthropic: "Effective harnesses for long-running agents"
- Anthropic: "Harness design for long-running application development"

## The Central Argument

> "The strongest model in the world will still fail on real engineering tasks if you don't build a proper environment around it."

**Anthropic experiment (Opus 4.5, same model, same prompt — "build a 2D retro game editor"):**
- Without harness: $9 in 20 min → non-working output
- With full harness (planner + generator + evaluator): $200 in 6h → playable game

**OpenAI / Codex:** well-harnessed repo = "unreliable" → "reliable." Not marginal — qualitative shift.

The model didn't change. The harness did.

## The Five Harness Subsystems

```
THE HARNESS
====================
Instructions  │  State       │  Verification
AGENTS.md     │  progress.md │  tests + lint
CLAUDE.md     │  feature_list│  type-check
feature_list  │  git log     │  smoke runs
docs/         │  session hand│  e2e pipeline

Scope         │  Session Lifecycle
one feature   │  init.sh at start
at a time     │  clean-state checklist at end
definition    │  handoff note for next session
of done       │  commit only when safe to resume
```

Each subsystem has one job:

1. **Instructions** — What to do, in what order, what to read before starting. Not one giant file; a progressive disclosure structure the agent navigates on demand.
2. **State** — Track what's done, in progress, and next. Persisted to disk so the next session picks up exactly where the last left off.
3. **Verification** — Only a passing test suite counts as evidence. Agent cannot declare victory without runnable proof.
4. **Scope** — Constrain agent to one feature at a time. No overreach. No half-finishing three things.
5. **Session Lifecycle** — Initialize at start. Clean up at end. Leave a clean restart path.

## Quick-Start File Structure

```
YOUR PROJECT ROOT
├── AGENTS.md              ← agent's operating manual
├── CLAUDE.md              ← (alternative for Claude Code)
├── init.sh                ← runs install + verify + start
├── feature_list.json      ← what features exist, which are done
├── claude-progress.md     ← what happened each session
└── src/                   ← your actual code
```

Four files — sessions become significantly more stable than running on prompts alone.

## Course Structure

- **12 Lectures**: conceptual units on harness theory
- **6 Projects**: hands-on harness building from scratch
- **Resource Library**: copy-ready templates (AGENTS.md, feature_list.json, init.sh, verification workflows)
- **Capstone**: Electron-based personal knowledge base desktop app

The `skills/harness-creator/` skill scaffolds a production-grade harness (AGENTS.md, feature lists, init.sh, verification workflows) for any project in minutes.

## Key Insight: Without vs. With Harness

| Without Harness | With Harness |
|---|---|
| Session starts fresh each time | Session reads progress log |
| No memory of what happened | Picks up exactly where it left off |
| Agent re-does work | Agent continues unfinished feature |
| You fix it manually | You review, not rescue |
| More time cleaning up than if done yourself | Agent does the work; you verify |

## Related

- [[03-RESOURCES/concepts/agent-harness]] — existing wiki concept: thin harness design philosophy
- [[03-RESOURCES/concepts/agentic-harness-engineering]] — AHE auto-evolution framework (Fudan)
- [[03-RESOURCES/concepts/claude-agent-harness-architecture]] — Claude Code's 8 internal patterns
- [[03-RESOURCES/concepts/progressive-disclosure]] — instruction structure principle
- [[03-RESOURCES/concepts/verification-driven-development]] — "only passing tests count"
- [[03-RESOURCES/entities/walkinglabs]] — org behind the course
- [[03-RESOURCES/sources/clipping-a-closer-look-at-harness-engineering-from-top-ai-companies]] — industry perspective
- [[03-RESOURCES/sources/clipping-agentic-harness-engineering-ahe]] — AHE paper
