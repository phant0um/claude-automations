---
title: "I Turned Claude Into My Personal CFO (step-by-step guide)"
type: source
author: "[[Miles-Deutscher]]"
source_url: "https://x.com/milesdeutscher/status/2054955529320198279"
published: 2026-05-14
ingested: 2026-05-14
tags: [claude, personal-finance, cfo, investor-os, memory-pattern, telegram, notebooklm, life-os]
triagem_score: 5
---

# I Turned Claude Into My Personal CFO (step-by-step guide)

**Author:** [[@milesdeutscher]] (Miles Deutscher)
**Source:** X.com thread, 2026-05-14

## Summary

4-step guide to building a McKinsey-caliber personal CFO using Claude. The system combines a structured investor profile interview, a markdown folder architecture with persistent memory, a coded financial dashboard, and mobile access via Telegram BotFather or Claude Dispatch.

## Key Concepts

- [[03-RESOURCES/concepts/pkm-obsidian/life-operating-system]] — Personal CFO is a financial domain implementation of the Life OS pattern
- [[03-RESOURCES/concepts/pkm-obsidian/notebooklm-integration]] — NotebookLM used to ingest YouTube financial transcripts as a knowledge base

## The 4 Steps

### Step 1 — Investor One-Pager (McKinsey-Style Interview)

Uses a 7-phase interview system prompt that runs Claude as a "McKinsey-caliber strategy advisor." The interview forces the user through:

- **Phase 1** — Situation & Constraints (residency, income, liquidity, time budget)
- **Phase 2** — Capital & Horizon (bands, tactical/core/generational split)
- **Phase 3** — Philosophy & Mindset (core beliefs in user's own words)
- **Phase 4** — Behavioural Nuance (blind spots, triggers, guardrails)
- **Phase 5** — Preferences & Anti-Preferences (what they will/won't buy)
- **Phase 6** — Goals in mindset form, not numerical
- **Phase 7** — Stress tests (4 sharp hypotheticals to expose philosophy-behaviour gaps)

Output: markdown `investor-one-pager.md` — the permanent context document dropped into any AI tool or advisor conversation.

Interview rules: one sharp question at a time, no fluff, no flattery, contradictions named directly, user's own voice in the final document.

### Step 2 — Folder Architecture

```
Investment Folder/
├── instructions.md        # tells Claude how to operate (role, rules, default posture)
├── memory.md              # auto-updated change log (reverse chronological, dated)
├── investor-one-pager.md  # output of Step 1
└── financials/
    ├── pnl-summary.md     # rolling 6-month P&L
    └── bank-statement-[month]-[year].md
```

`instructions.md` rules include:
1. Read `investor-one-pager.md` and `memory.md` before every response.
2. Update `memory.md` immediately when new information emerges (life changes, income shifts, new positions, evolving views). Append only — never overwrite. Date every entry.
3. Before any advice touching deployment/sizing/cash management, read `financials/pnl-summary.md`.
4. Never silently overwrite the one-pager — surface conflicts and ask for revision.
5. Run every proposed action against the stated rules; name the rule if violated.

`memory.md` structure: reverse-chronological change log with dated entries. Example:
```
# Change Log
**14 Apr 2026**
Investor one-pager finalised. Goals reframed from numerical targets to mindset states.

**24 Mar 2026**
Drawdown tolerance restated: can sleep through 60% paper drawdown.

*New entries go above this line.*
```

This is the **key mechanism**: Claude never forgets financial context because `instructions.md` mandates updating `memory.md` in every session.

### Step 3 — Financial Dashboard (Claude Cowork / Codex / Claude Code)

- Open Claude Cowork and select the Investment Folder as project.
- Claude now has access to all investing context and can modify the folder directly.
- Build dashboard with graphs, tracking visuals, portfolio insights.
- Add morning brief functionality: market brief tailored to active positions.
- Optional integrations: Google Sheets (real-time position tracking), live exchange APIs.

**NotebookLM integration:** ingest YouTube financial video transcripts into NotebookLM, then prompt Claude with "based on this video and market thesis, how should I adjust my portfolio?"

### Step 4 — Mobile Access

Two patterns:
1. **Telegram BotFather** — create a bot in Telegram for real-time CFO access from phone; use for automated market reports.
2. **Claude Dispatch** — Cowork → Dispatch; connect in ~60 seconds to access desktop folders from mobile.

## Prominent Patterns

| Pattern | Mechanism |
|---------|-----------|
| Persistent memory via folder | `memory.md` + `instructions.md` rule forces Claude to update the log every session |
| Identity document | `investor-one-pager.md` = context document injected into any AI session |
| Separation of stable vs evolving context | one-pager (stable) + memory.md (evolving) + financials/ (live data) |
| Mobile access | Telegram BotFather or Claude Dispatch |
| YouTube→context pipeline | NotebookLM transcript → Claude portfolio query |

## Related Sources

- [[03-RESOURCES/sources/guides-courses-howtos/how-i-built-jarvis-personal-ai-assistant]] — Life OS general implementation (Sid Bharath)
- [[03-RESOURCES/sources/financial-trading/claude-tradingview-full-guide]] — same author (Miles Deutscher), TradingView MCP for technical analysis
- [[03-RESOURCES/sources/financial-trading/investment-analyst-system-prompt-v2]] — production investment analyst system prompt with session compaction
