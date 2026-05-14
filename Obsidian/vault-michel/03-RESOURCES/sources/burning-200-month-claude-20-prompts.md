---
title: "You're Burning $200/Month on Claude. These 20 Prompts Fix That."
type: source
source_type: clipping
source_file: "Clippings/You're burning $200month on Claude. These 20 prompts fix that..md"
source_url: "https://x.com/thegreatest_sv/status/2053128520138739985"
author: "@thegreatest_sv"
created: 2026-05-14
tags: [token-efficiency, claude-code, prompt-engineering, cost-optimization, caveman-mode, opus-47, budget-prompting]
---

# You're Burning $200/Month on Claude. These 20 Prompts Fix That.

**Author:** @thegreatest_sv  
**Context:** Opus 4.7 API rates; typical Claude Code session = 80,000–200,000 tokens / $3–15

## Top 10 Saving Prompts

| # | Technique | Est. Savings/Month | Mechanism |
|---|---|---|---|
| 1 | **Startup audit** | ~$45 | Add minimal-response instructions before first message; cuts 11k→800 tokens |
| 2 | **Caveman mode in CLAUDE.md** | ~$25 | 22–87% output reduction; [source](https://github.com/juliusbrussee/caveman) |
| 3 | **Diff only** | ~$15 | Show only changed lines + 3 context lines; 8k→400 tokens per edit |
| 4 | **No preamble rule** | ~$8 | Ban "Great question", "Of course", "Let me" — 30 tokens × 100 resp/day |
| 5 | **Thinking cap** | ~$20 | Explicit "minimal reasoning" for simple tasks; stops 50k-token pre-answers |
| 6 | **Output budget** | ~$8 | "Your response budget is 300 tokens." Hard cap on explanations |
| 7 | **File scope lock** | ~$20 | "Only read files inside /src/[folder]." Stops full-repo reads for one function |
| 8 | **Plan before agent** | ~$20 | Require text plan + approval before any multi-file task; catches wrong approaches |
| 9 | **Context compression** | ~$30 | Ask for 500-token project summary as working memory |
| 10 | **Session handoff** | ~$8 | 200-token summary saved to `.claude/SESSION_[date].md` |

**Combined top-10 savings: ~$179/month**

## Combined CLAUDE.md Snippet (Prompts 2+3+4+5+6)

```
Respond in minimal words. No preamble. No summary. No markdown unless showing code.
Start with the answer. Show only changed lines in code edits.
For simple tasks: skip extended reasoning.
Budget: 300 tokens unless I say otherwise.
```

## 10 Scenario-Specific Prompts

| Scenario | Key prompt pattern | Savings |
|---|---|---|
| Bug fixing | "Read only [specific file]. Fix only the broken logic. Show only changed lines." | 40k→800 tokens; ~$90/month at 5 bugs/day |
| Article writing | Explicit word count + format + "Start with first sentence of piece, not intro" | 60% output cut |
| Concept explanation | "Explain in 3 sentences maximum. Simplest words possible." | 80% reduction |
| Code review | "Flag only: bugs, security issues, breaking changes. Output: file→issue→severity." | 70% cut |
| Research | "5 key players (1 sentence each). 3 market trends (1 data point each). 1 opportunity sentence." | 5k→400 tokens |
| Data analysis | "Read only first 20 rows to understand structure. Answer: [specific question]." | 15k→1k tokens |
| Context contamination | "New task. Disregard everything from previous conversation." | 3k–8k tokens saved |

## Core Insight

> "Most people optimize the model. Nobody audits the prompts. That's where the real money goes."

The model is not the problem. The prompts are. The same model, same plan, same bill — prompt discipline is the lever.

## References

- [github.com/juliusbrussee/caveman](https://github.com/juliusbrussee/caveman) — caveman mode
- [github.com/nadimtuhin/claude-token-optimizer](https://github.com/nadimtuhin/claude-token-optimizer)
- [github.com/ooples/token-optimizer-mcp](https://github.com/ooples/token-optimizer-mcp)

## Connections

- [[03-RESOURCES/concepts/token-efficiency-prompting]] — update: concrete $ savings benchmarks added
- [[03-RESOURCES/concepts/prompt-engineering-patterns]] — extended: budget/scope patterns
- [[03-RESOURCES/concepts/context-engineering]] — context compression as engineering practice
- [[03-RESOURCES/concepts/context-rot]] — session handoff prevents context contamination between tasks
- [[03-RESOURCES/concepts/claude-folder-anatomy]] — CLAUDE.md as the permanent home for caveman rules
