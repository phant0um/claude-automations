---
title: "How to Build Your Own Agent Harness"
type: source
source: Clippings/How to build your own agent harness???.md
created: 2026-05-28
ingested: 2026-06-21
tags: [ai-agents, harness-engineering, source, score-B]
---

## Tese central
Harness não é uma coisa — são 10-12 coisas bundled. Provider router, credential vault, policy engine, approval gate, model catalog, session storage, budget tracker, after-call hook fanout, durable turn loop são concerns independentes. Framework que shipa como block único vende tradeoff que você não tinha que fazer.

## Key insights
- 15 jobs que harness tem que fazer: accept turn, resolve credentials, look up model capabilities, drive state machine, load skills, assemble system prompt, stream tokens, check tool calls against policy, pause for human decisions, track spend, run hooks, persist branching session, compact context
- "Build your own" = swap a few workers, não fork a framework
- iii engine: workers on shared engine, each replaceable, connected by trigger primitive

## Links
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-platform-architecture]]