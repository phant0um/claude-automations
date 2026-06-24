---
title: "Claude Code 斜杠命令全解：14 条实用指南"
slug: claude-code-slash-commands-14-guide
type: source
category: claude-code
author: "@vincemask"
source_url: "https://x.com/vincemask/status/2056222383116259437"
published: 2026-05-07
ingested: 2026-05-18
tags: [claude-code, slash-commands, context-management, token-economy, workflow, CLAUDE.md]
triagem_score: 8
---

# Claude Code 斜杠命令全解：14 条实用指南

## Tese central

Claude Code users who only use the chat interface access ~20% of the tool's capability. The remaining 80% lives in slash commands organized across four tiers: one-time setup, daily high-frequency, advanced optimization, and failure recovery.

## Key insights

1. **Four-tier structure:** Setup once (`/init`, `/memory`, `/pr_comments`) → Daily high-frequency (`/btw`, `/compact`, `!`, `/cost`) → Advanced optimization (`/review`, `/terminal-setup`, others) → Failure recovery.

2. **/init vs /memory scope distinction:** `/init` generates project-level CLAUDE.md (repo root, current project only). `/memory` writes to global `~/.claude/CLAUDE.md` (all projects, all sessions). Loading order: global first, project-level overrides.

3. **CLAUDE.md hard limits (from source):** max 200 lines; no project history; only executable rules ("named exports, max 200 lines/component, no any" not "write clean code"); explicit allow AND block lists equally important; healthy project CLAUDE.md = 300–600 tokens, >2000 tokens = wrong content.

4. **/compact mechanism:** every Claude Code turn resends full conversation history (Transformer architecture — no "scroll back"). PR review example: diff injection + multi-file reads + back-and-forth = token accumulation per turn. `/compact` summarizes, drops redundant messages, preserves key decisions/code — session continues without restart.

5. **/btw command:** inserts an independent question without breaking main task context. Answers the question, preserves in-progress task state.

6. **`!` inline shell:** runs shell commands (git, npm, tests) from chat without switching to terminal. Requires terminal integration enabled (`/terminal-setup`).

7. **/cost visibility:** shows session token consumption + cost + remaining context %. Proactive trigger for `/compact` before hitting limits.

8. **Relationship to token economy:** CLAUDE.md size directly affects every session's baseline token spend. A 2000+ token CLAUDE.md means 2000 tokens of overhead on every single turn.

## Links

- [[03-RESOURCES/entities/Claude Code]] — tool being documented
- [[03-RESOURCES/concepts/claude-code-tooling/cowork-slash-commands]] — existing slash commands concept (Cowork-flavored; this source is Claude Code native)
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — caching mechanics relevant to `/compact` context
- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]] — CLAUDE.md size discipline connects here
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] — `/compact` directly manages context window pressure

## Mechanism Deep-Dive: How `/compact` Actually Works

The Transformer architecture processes each new token with attention over the full prior context. There is no in-memory "scrollback" — every turn re-reads every prior message. This means a 100-message session accumulates quadratically: turn 1 reads 0 tokens of history; turn 100 reads 99 turns of history before answering.

`/compact` interrupts this accumulation by substituting all prior messages with a single compressed summary. Claude Code generates the summary itself using the current context, then replaces the conversation with `[SYSTEM: Prior conversation compacted. Summary: ...]`. The session continues with a shallow context. Key decisions and code snippets are preserved; intermediate reasoning steps, failed attempts, and tangents are dropped.

**Practical trigger point:** When `/cost` shows more than 60% of context consumed, a `/compact` call pays for itself on the next 10 turns by reducing the baseline per-turn token load.

## `/init` vs `/memory` — Scope and Loading Order

| Command | Writes to | Scope | Loaded when |
|---------|-----------|-------|-------------|
| `/init` | `.claude/CLAUDE.md` (project root) | Current repo only | Every Claude Code session in that directory |
| `/memory` | `~/.claude/CLAUDE.md` | All projects, all machines | Every Claude Code session, everywhere |

Loading order: global `~/.claude/CLAUDE.md` is parsed first; then project `.claude/CLAUDE.md` is appended. Conflicts resolve by last-write-wins at the same rule level, so project rules effectively override global rules when they address the same behavior.

**Implication for CLAUDE.md authoring:** Global memory should hold identity rules and universal preferences. Project CLAUDE.md should hold repo-specific conventions, allowed tool lists, and test/build commands. Never duplicate — duplication inflates every session's baseline token cost.

## The CLAUDE.md Token Budget in Practice

A 2,000-token CLAUDE.md loaded into a session with 50 turns contributes 2,000 × 50 = 100,000 tokens of overhead across the session — tokens that were never "useful" for any single task. The guideline of 300–600 tokens for a healthy CLAUDE.md is not aesthetic; it is a direct cost multiplier.

Rules that work in CLAUDE.md are behavioral contracts with observable failure modes, not preferences or aspirations:

- **Works:** "All exports must be named. Never use `export default`."
- **Fails:** "Write clean, readable code with good naming conventions."
- **Works:** "Run `npm test` before marking any task complete. Never skip."
- **Fails:** "Be thorough and careful when making changes."

The test: if you cannot write a script that detects a violation of the rule, the rule is not behavioral — it is a wish, and it will be honored at roughly 30% compliance.

## Four-Tier Command Structure in Practice

**Tier 1 — Run once, never again:** `/init`, `/memory` (initial setup), `/terminal-setup`. These generate persistent configuration. Running them repeatedly wastes time; their output should be committed to version control.

**Tier 2 — Daily high-frequency:** `/compact` (when context > 60%), `/cost` (check before long tasks), `/btw` (lateral questions), `!` (shell commands). These are the operational layer — using them correctly halves session costs.

**Tier 3 — Advanced optimization:** `/review` (code review pass), `/terminal-setup` (once per machine), custom slash commands defined in `.claude/commands/`. These unlock the long tail of Claude Code capability most users never find.

**Tier 4 — Failure recovery:** `/rewind` (undo last N steps), `/clear` (nuclear option — full reset). Knowing these exist prevents the "kill the session and start over" reflex that wastes accumulated context.

## Vault Relevance

This vault's CLAUDE.md currently sits near the recommended ceiling. The `/compact` pattern maps directly to hot.md: both serve as "compressed state" — hot.md is the vault's equivalent of a post-compact summary, designed so a new session can orient in < 1,000 tokens rather than reading 500+ source files.

The `/btw` command models a useful cognitive pattern: answering a lateral question without breaking a primary task's mental state. This is the same principle behind keeping inbox captures brief — capture the signal, don't context-switch into full processing.
