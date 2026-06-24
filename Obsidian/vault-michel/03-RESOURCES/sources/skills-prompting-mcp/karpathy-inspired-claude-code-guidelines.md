---
title: Karpathy-Inspired Claude Code Guidelines
type: source
created: 2026-04-27
updated: 2026-04-27
tags: [claude-code, guidelines, andrej-karpathy, best-practices]
source_file: .raw/articles/Karpathy-Inspired Claude Code Guidelines.md
author: Forrest Chang
references: Andrej Karpathy
triagem_score: 9
---

# Karpathy-Inspired Claude Code Guidelines

Four principles from [[Andrej Karpathy]]'s LLM coding observations. Single SKILL.md to improve [[04-SYSTEM/agents/claude-code-agent]] behavior. Open source, MIT.

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

---

## Why These Four Problems Are Systemic

The three failure modes Karpathy identified — hidden assumptions, overcomplication, and uncontrolled edits — are not random bugs. They emerge from the same root cause: LLMs are trained on a corpus where the most common pattern is "produce output that looks reasonable given the input." Ambiguous input → pick the most statistically common interpretation and proceed. Complex problems → generate elaborate solutions that pattern-match to similar problems in training data. Adjacent code → modify it freely because doing so is consistent with the surrounding context.

The four principles are structural countermeasures. They do not make the model smarter; they change what the model is rewarded to do within the session.

## Principle 1 — Think Before Coding: Failure Modes Without It

Without explicit assumption surfacing: the model picks interpretation A, codes 200 lines, and the user wanted interpretation B. The fix is to rewrite 200 lines. With assumption surfacing: the model states "I'm assuming X; if you meant Y, tell me now" before writing line one. The fix is one sentence.

The tradeoff: asking clarifying questions adds one round-trip to every task. For trivial tasks (rename a variable) this is friction with no benefit. The principle should activate only when the task has genuine ambiguity — multiple plausible interpretations with materially different implementations.

## Principle 2 — Simplicity First: The Abstraction Trap

The specific failure mode is premature abstraction: writing `AbstractDocumentProcessorFactory` when the task is "parse this one CSV." LLMs generate abstractions because abstractions appear frequently in high-quality code in the training data, and because generating a general solution feels more complete than a specific one.

The test — "would a senior engineer say this is overcomplicated?" — is useful precisely because it invokes a different standard: production code written by experienced engineers is often simpler than what models generate, because experienced engineers have paid the cost of unnecessary abstraction and learned to avoid it.

Simplicity First also catches the inverse failure: under-engineering when the task explicitly requires robustness. The principle is "minimum code that solves the problem," not "minimum code regardless of requirements."

## Principle 3 — Surgical Changes: The Refactoring Drift Problem

The most insidious failure mode is "drive-by refactoring": the model is asked to fix a bug in function A, notices that function B nearby uses a pattern it considers suboptimal, and reformats/renames/restructures B as a side effect. The diff is now twice as large, the review is twice as slow, and if B's change introduces a regression, it is mixed with the intentional change.

Surgical Changes eliminates this by making the rule explicit and verifiable: every changed line must trace directly to the user's request. Lines that cannot be traced are reverted. This produces PRs that are easier to review, easier to revert if needed, and that document intent clearly.

## Principle 4 — Goal-Driven Execution: The Verification Loop

The key insight from Karpathy: LLMs are better at executing loops than at writing correct code on the first pass. Goal-driven prompts exploit this. Instead of asking for a correct solution, ask for a solution that passes a verifiable check — then let the model run the check and iterate until it passes.

This transforms tasks from "write tests for this function" to "write tests for this function; run them; fix failures; loop until all pass." The first form produces a one-shot output of unknown quality. The second form produces a verified output. The cost is additional tool calls (running tests); the benefit is compounded reliability.

## Comparison: SKILL.md vs CLAUDE.md Placement

The guidelines can be installed either as a Claude Code plugin (SKILL.md loaded on demand) or as a CLAUDE.md file baked into the project or user-level config. Plugin placement is better for new projects where the guidelines should be learned gradually. CLAUDE.md placement is better for existing projects where the guidelines should apply universally and immediately.

The difference in practice: plugin load is triggered per session or per slash-command; CLAUDE.md rules are always active. For teams, CLAUDE.md checked into the repo enforces the guidelines for every contributor automatically.

## Vault Relevance

The vault's CLAUDE.md already encodes Karpathy's four principles under "Principles (Karpathy)." The main value of this source is documenting the origin and the specific failure modes each principle addresses — useful context for explaining why the rules exist, not just what they say. The `karpathy-four-principles` concept page is the canonical vault-internal reference; this source is the upstream provenance.

## Links

- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]] — canonical concept page
- [[03-RESOURCES/entities/Andrej Karpathy]] — originator
- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]] — Principle 4 operationalized
