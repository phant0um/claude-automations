---
title: "Reduced Claude Code Token Usage by 50%: Model Selection & Config"
type: source
source: https://x.com/DeRonin_/status/2050194196007387175
author: DeRonin (@DeRonin_)
created: 2026-05-02
ingested: 2026-05-02
language: Portuguese
tags:
  - token-optimization
  - cost-reduction
  - model-selection
  - subagents
  - claude-code
  - configuration
---

# Reduced Claude Code Tokens by 50% with Single Configuration File

Practical token optimization technique using model delegation and Claude Code settings.

## Core Strategy

**Teach Claude when to use cheap vs expensive models:**
- **Haiku**: Bulk mechanical tasks (no judgment needed)
- **Sonnet**: Bounded research, code exploration, synthesis
- **Opus**: Only when real planning or trade-offs involved

Result: Same output, half the token cost.

## Configuration Block 1: Task Delegation (claude.md)

### Model Selection Rules

**Haiku constraints:**
- Never create additional subagents (if needed, task is wrong size)
- Max spawn depth: 2 (parent → subagent → one level more)
- If subagent detects need for smarter model → return to parent (don't escalate)

### Tool Preferences

Prioritize free options first:
- **WebFetch** for public pages (free, text-only)
- **agent-browser CLI** for dynamic/auth pages (~82% fewer tokens than screenshot-based tools)
- **pdftotext** for PDFs instead of Read tool
- Wrap repeated patterns as reusable tools

## Configuration Block 2: Settings.json (Two Lines)

```
"CLAUDE_CODE_DISABLE_1M_CONTEXT": "1"
→ Prevents loading massive context windows you don't need

"CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "80"
→ Auto-compacts at 80% instead of waiting for full context
```

These two lines alone save massive tokens per session.

## Results

- Setup time: 2 minutes
- Token savings: ~50%
- Scaling: Savings multiply across every task executed after

## Key Behaviors Changed

1. Model selection → Always ask: "Is this Haiku work or Opus work?"
2. Tool choice → Free option first, screenshot tools last
3. Context management → Aggressive auto-compaction

## Related Concepts

- [[03-RESOURCES/concepts/token-efficiency-prompting]] — Core economics
- [[03-RESOURCES/concepts/model-selection-patterns]] — When to use which model
- [[03-RESOURCES/entities/Claude-Haiku-4.5]] — Cost-optimized reasoning
- [[03-RESOURCES/entities/Claude-Sonnet-4.6]] — Speed/cost balance
- [[03-RESOURCES/entities/Claude-Opus-4.7]] — Advanced reasoning
- [[03-RESOURCES/concepts/rtk]] — Token-optimized CLI proxy
