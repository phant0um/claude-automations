---
title: "Loop Engineering: Teaching AI Agents to Learn from Their Own Mistakes"
type: source
source: Clippings/Loop Engineering Teaching AI Agents to Learn from Their Own Mistakes.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, loop-engineering, source, score-B]
---

## Tese central
Loop engineering = construir o sistema ao redor do modelo, não só o prompt. 5 stages: Intent, Context, Action, Observation, Adjustment. 6-step core loop: Plan, Search, Modify, Verify, Repair, Summarize. Signal real aparece após primeira action — failure é new context, não cleanup.

## Key insights
- Prompt engineering = better question; loop engineering = better process
- "A test failure is not just an error; it is new context"
- Strong loop reproduz failure, observa onde está o problema, muda smallest relevant code path

## Links
- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]