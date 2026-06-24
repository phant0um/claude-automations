---
title: Meta-Coaching Claude Code
type: concept
status: developing
created: 2026-05-03
updated: 2026-05-03
tags: [claude-code, workflow, self-improvement, token-economy]
cadence: weekly-saturday-2330-amt
---

# Meta-Coaching Claude Code

Weekly self-audit loop. Use Claude Code to coach own Claude Code usage.

## Cadence

Saturday 23:30 AMT (America/Manaus). Calendar event auto-fires reminder.
First run: 2026-05-09.

## Why Weekly Aggregate, Not Per-Session

Single-session reports overweight whatever fire happened that day. Weekly aggregate surfaces boring patterns:
- Bash retries
- Ignored agents
- Same prompt repeated across files
- Reads where grep would suffice (and inverse: grep where read needed context)

## Procedure

1. **Saturday 23:30** — calendar fires.
2. **Sunday morning** — open fresh Claude Code session (no prior context).
3. **Aggregate logs** — past 7 days from `~/.claude/projects/*/transcripts/`. Concat into single file or paste excerpts.
4. **Run `/insights`** if available, else paste raw transcripts.
5. **Paste prompt below** into fresh session along with logs.
6. **Pick max 2 fixes** from output. More = drift, none stick.
7. **Log** outcome to `tasks/lessons.md` after the week applying fixes.
8. **A/B next Saturday** — compare against this week's baseline.

## Refined Prompt

```
You are auditing my Claude Code usage to surface high-leverage behavior changes.

INPUT: Aggregated session logs from past 7 days (attached or pasted below).
Treat single-session anomalies as noise. Look for repeated patterns.

TASK:
1. Cluster my tool calls by intent (search / read / edit / bash / agent / mcp).
   For each cluster report: count, est. tokens consumed, % of total session time.

2. Identify 3-5 patterns ranked by (frequency × estimated waste). For each:
   - Pattern name (one line)
   - Evidence: 2-3 concrete examples with file/command
   - Root cause hypothesis
   - Estimated cost (tokens or wall-clock)

3. Surface what surprised you — patterns I likely don't notice myself.
   Do NOT fabricate problems to hit a quota. If only 2 real patterns exist, return 2.

4. For top 2 patterns only, propose ONE concrete fix each:
   - Specific behavior change (not "use grep more" — say when/why/how)
   - How to verify it worked (metric I can check next week)
   - Cost if I do nothing

CONSTRAINTS:
- Outcome-weighted, not count-weighted. A 10x cheap pattern that misses context is
  worse than a slow pattern that finds the answer.
- No vague advice. Every fix must name specific tool, situation, threshold.
- If logs insufficient for a claim, say so. Don't guess.
- Compare against prior baseline if I attach last week's report.

OUTPUT: Markdown. Tables for clusters. Bulleted patterns. Numbered fixes.
```

## Anti-Patterns to Avoid

- Optimizing past tokens, not future value. 30% savings worthless if grep miss context.
- "5 worst habits" framing primes negativity bias. Better: "what surprised you, ranked by token impact."
- Cargo-culting tips from Twitter without measuring own baseline.
- Acting on single-session noise.

## Related

- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/dev-foundations/ai-legible-backend]]

## History

| Date | Patterns Found | Fixes Applied | Result Next Week |
|------|---------------|---------------|------------------|
| 2026-05-09 | _pending_ | — | — |
