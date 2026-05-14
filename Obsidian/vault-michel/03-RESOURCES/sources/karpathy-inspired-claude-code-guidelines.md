---
title: Karpathy-Inspired Claude Code Guidelines
type: source
created: 2026-04-27
updated: 2026-04-27
tags: [claude-code, guidelines, andrej-karpathy, best-practices]
source_file: .raw/articles/Karpathy-Inspired Claude Code Guidelines.md
author: Forrest Chang
references: Andrej Karpathy
---

# Karpathy-Inspired Claude Code Guidelines

Four principles from [[Andrej Karpathy]]'s LLM coding observations. Single SKILL.md to improve [[Claude Code]] behavior. Open source, MIT.

## The Problem (Andrej's Observations)

**Hidden assumptions:** Models pick interpretations silently, don't seek clarification, don't surface inconsistencies or tradeoffs.

**Overcomplication:** Bloated abstractions, 1000-line code when 100 suffices, unnecessary error handling.

**Uncontrolled edits:** Change/remove comments & code not fully understood as side effects, even if orthogonal.

## Four Principles

| Principle | Addresses | Key Rule |
|-----------|-----------|----------|
| **Think Before Coding** | Hidden confusion, missing tradeoffs | State assumptions explicitly; push back when simpler exists |
| **Simplicity First** | Overengineering, feature creep | Minimum code solving the problem; no speculative abstractions |
| **Surgical Changes** | Uncontrolled edits, refactoring drift | Touch only what you must; clean up only your own mess |
| **Goal-Driven Execution** | Imperative vs. verifiable success | Define criteria, loop until verified |

## 1. Think Before Coding

Don't assume. Don't hide confusion. Surface tradeoffs.

- State assumptions explicitly; ask rather than guess
- Present multiple interpretations when ambiguity exists
- Push back on simpler approaches if they exist
- Name what's unclear and ask

## 2. Simplicity First

Minimum code solving the problem. Nothing speculative.

- No features beyond asked
- No abstractions for single-use code
- No "flexibility" or "configurability" not requested
- No error handling for impossible scenarios
- Test: "Would a senior engineer say this is overcomplicated?" If yes, rewrite.

## 3. Surgical Changes

Touch only what you must. Clean up only your own mess.

- Don't "improve" adjacent code, comments, formatting
- Don't refactor things that aren't broken
- Match existing style (even if you'd do it differently)
- When your changes create orphans: remove only the ones YOU made unused
- Test: Every changed line traces directly to user's request

## 4. Goal-Driven Execution

Define success criteria. Loop until verified.

Transform imperative tasks into verifiable goals:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let the LLM loop independently.

## Installation

**Option A: Claude Code Plugin (recommended)**
```bash
/plugin marketplace add forrestchang/andrej-karpathy-skills
/plugin install andrej-karpathy-skills@karpathy-skills
```

**Option B: CLAUDE.md (per-project)**
```bash
curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md
```

**Option C: Cursor** (includes `.cursor/rules/karpathy-guidelines.mdc`)

## How to Know It's Working

- Fewer unnecessary changes in diffs
- Fewer rewrites due to overcomplication
- Clarifying questions come before implementation
- Clean, minimal PRs (no drive-by refactoring)

---

**Author:** Forrest Chang (@forrestchang)  
**Repository:** forrestchang/andrej-karpathy-skills  
**Related:** [[Multica]] (open-source agent platform with reusable skills)  
**Key Insight:** "LLMs are exceptionally good at looping until they meet specific goals. Don't tell it what to do, give it success criteria." — Andrej Karpathy
