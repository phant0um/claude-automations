---
title: "The Self-Cleaning Codebase"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - source
  - ai-agents
  - code-quality
  - automation
  - developer-tools
  - rust
---

author: [[@HarivanshRathi]]
source: https://x.com/HarivanshRathi/status/2069088950241907089
published: 2026-06-22

## Central Thesis

Instead of spending all day reviewing AI-generated "slop" and yelling at Claude, you can let the codebase clean itself. Bad patterns can be detected and fixed automatically on a cadence — but only if your codebase is **legible** to the agents in the first place. The system requires: (1) docs as entry points, (2) concrete language-level opinions, (3) named anti-patterns as deterministic cleanup skills, and (4) structural CI rules that enforce shape so cleanup PRs merge without human review.

## Key Arguments

### The Problem: Correctness ≠ Quality

AI-generated code often passes tests, passes Antithesis assertions for prod fault injection, and handles edge cases — but it's ugly. And it compounds. Ugly code teaches the next agent the wrong patterns, and no test will ever catch it. The usual advice ("review harder") is funny because the entire reason you specced was to not have to re-review the diff.

### Codebase Legibility

Before any automation, an agent needs two things: a map of the repo and an opinion about how things are done in each language.

**Docs philosophy:** Docs should be the first place an agent looks before invoking `rg`. Not a complete reference — just the entry point. Enough context to orient, then dive into source with ripgrep.

- Structure is boring on purpose: one doc tree shaped like the package tree
- Root `index.md` as dispatch table
- One directory per package with `overview.md`
- Bigger packages split into concern pages or nested subdirs

### Forming Opinions

The failure everyone hits with spec-driven agents: you write a careful spec, the agent follows it to the letter, behavior is correct, but abstractions are spaghetti. A spec says **what** the code does; it says almost nothing about **how** the code is shaped.

Opinions must be concrete and language-level, not vibes. For Rust:
- Errors go through snafu and preserve their source, never anyhow or `Result<_, String>`
- No unwrap/expect in library code
- How borrows and mutability should flow
- When an impl block earns its keep and when it doesn't

Once you have genuinely opinionated codebases, you can step away from reading every line of code. The opinions become what keeps output looking like you wrote it — which frees you from confirming line by line.

### Deterministically Bad Behavior

Once you have opinions, you have something to measure against. Now you can watch what agents actually do and write down the recurring ways they produce slop.

- Each bad behavior gets a **name**
- That list of named anti-patterns is the raw material for automation
- Each becomes a single skill: a tight deterministic cleanup for exactly that pattern, with all house context baked in
- Something runs each skill on a schedule sized to the behavior: hourly for noisy ones, weekly for structural ones

They run this on **Symphony** (open-sourced), a boring DAG runtime for deterministic agent workflows. Boring is the point. It's Elixir on the BEAM, which buys:
- OTP supervision: crashed runs get recovered instead of silently lost
- Cheap distribution: runs fan out across machines

Each run gets its own git checkout, runs a headless agent (e.g., claude-opus-4-8 or 5.5 gpt) under a bot identity on git, and opens a PR.

### Merge in CI

Cleanup PRs are tiny — ten to twenty lines — and merge without human review. The trust comes from:
- Every PR passes a structural rule set encoding exactly how they like their languages to look
- The agent that wrote the PR already had all that context going in
- Small diff, pre-aligned with rules, lands clean

Rules run on **astlog** (their own DSL, replacing ast-grep). Built for a specific reason: pattern tools (ast-grep, Semgrep, tree-sitter queries) answer "does this node match this shape." But the rules you want during cleanup are **joins**: an `unwrap()` inside a function that returns `Result`, or a value read from an attribute you just checked for existence.

astlog runs the same way everywhere — pre-commit hook and CI. Suppressions need an inline `astlog-ignore` you can audit later. Every rule ships a good/bad fixture pair so the rules themselves are tested.

**astlog is not a bug-finder.** Correctness is a different axis, covered by tests and Antithesis. astlog only enforces shape.

### The Loop Closes

The agent writes against the opinions → the gate enforces the opinions → a ten-line cleanup either passes clean or gets bounced with a precise reason. That's what makes "merge it without me" possible.

## Key Insights

- **Codebase legibility is the prerequisite for self-cleaning.** If agents don't know how the code is meant to look, they can't fix code that doesn't.
- **Specs describe behavior, not structure.** The gap between "correct" and "good" is filled by opinions, and they must be concrete and language-level.
- **Named anti-patterns are the automation primitive.** Each recurring bad behavior becomes a deterministic cleanup skill with a schedule.
- **Shape enforcement ≠ correctness.** astlog enforces structural style; tests and fault injection handle correctness. These are separate axes.
- **The architecture enables trustless merging.** Small diffs + pre-aligned context + structural CI gate = cleanup PRs that merge without human review.
- **OTP supervision matters for agent workflows.** Crashed runs get recovered instead of silently lost — a property most agent orchestration lacks.

## Related Concepts

- [[03-RESOURCES/concepts/software-engineering/tech-debt-automation]]
- [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]]
- [[03-RESOURCES/concepts/agent-systems/coding-agents]]