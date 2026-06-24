---
title: "Agents Need Feedback Loops, Not Perfect Prompts"
type: source
author: "[[03-RESOURCES/entities/Petra-Donka]]"
source: "https://x.com/petradonka/status/2054897826149101588"
published: 2026-05-14
ingested: 2026-05-14
tags: [agents, feedback-loops, compounding-judgement, principles, skill-as-code, meta-learning, warp]
triagem_score: 8
---

# Agents Need Feedback Loops, Not Perfect Prompts

**Author:** Petra Donka (@petradonka), [[03-RESOURCES/entities/Warp]]  
**Published:** 2026-05-14  
**Source:** https://x.com/petradonka/status/2054897826149101588

## Summary

For agents doing judgment-heavy work, the starting prompt is only the beginning. The best agents learn what "good" looks like from the team and improve themselves over time. The question shifts from "how do we write the perfect prompt?" to "how do we build agents that keep learning from the team after they ship?"

## Key Arguments

### The core thesis

The best prompt you write today will not be the best prompt a month from now. Products change, users change, team taste is refined, new edge cases emerge. Static prompts cannot keep up with judgment-heavy domains.

### Agents that almost work

Many judgment agents plateau: output is good enough to generate hope, not good enough to trust. The team keeps tweaking the prompt. This is the wrong level of abstraction. Getting the agent to do the task once is not the hard part — building a system where the agent gets better from the way your team already does the work is.

Affected domains: social replies, customer outreach, support responses, code review comments, product feedback analysis, docs, recruiting messages.

### Warp's Buzz agent

Buzz monitors mentions of Warp across Twitter, LinkedIn, Reddit, Bluesky, and other platforms. When a new mention comes in, it decides whether to reply, like, note, or skip. If a reply is warranted, it drafts a message and posts the suggestion into Slack. The team then writes the actual reply. Result: the team only sees mentions that need attention; Buzz handles triage and drafting at scale (thousands/month).

### Principles beat rules

First version: long checklist of rules. Brittle — prompt grew, replies turned robotic, any unlisted situation broke the agent. Solution: rewrite the skill as **durable principles** (how to think, not what to do).

Examples from Buzz:
- Be helpful, not defensive.
- Do not talk down to the user.
- Check factual claims against the docs.
- Sound like someone who builds the product, not someone who processes feedback.

### Meta-learning: teaching the agent to learn

Naive feedback application converts corrections into rules ("never mention pricing in the first sentence"). The correct abstraction is a principle ("if someone is venting, lead with empathy, not a pitch"). Solution: a **separate meta-learning skill** that looks at the agent suggestion, what the human actually did, and the current instructions, then identifies what principle is missing or unclear.

The 7-step learning process:
1. Identify what went wrong (or right)
2. Ask: why?
3. Zoom out to the pattern
4. Check against existing principles
5. Write it as a principle, not a rule
6. Put it where it belongs
7. Edit and commit

### Feedback loop design

The loop must live where the team already works. At Warp: Slack emoji reaction = sufficient signal; optional thread = extra context. Once per day, Buzz collects reactions + thread feedback, extracts durable learnings, updates skill files, and opens a PR.

### Skill-as-code

Agent skills should live in a repo with version history, review, and rollbacks. The daily learning agent opens a PR with: what feedback it reviewed, what principle it thinks should change, the exact diff. A human reviews and merges. Self-improvement without loss of control.

### Compounding judgement

The goal: make human judgment compound. Every correction → new principle → reviewed PR → merged → next run improves. Over time, the skill file becomes a working memory of how the team thinks.

> The best teams will not just write better prompts. They will build better loops.

## Key Concepts Introduced

- **Compounding judgement** — human taste and judgment compounding through agent feedback loops over time
- **Meta-learning skill** — a second agent layer that converts specific corrections into generalized principles
- **Skill-as-code** — skill files in version control; agent proposes changes via PR, human reviews before merge
- **Principles > Rules** — durable principles transfer to unseen cases; enumerated rules overfit

## Related Concepts

- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] — full concept page for this pattern
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — autonomous variant (no human review)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — skill-as-code mechanism
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]] — agentic loop fundamentals
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — task agent + learning agent as separate agents
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — fat skills as living context

## Entities Mentioned

- [[03-RESOURCES/entities/Petra-Donka]] — author; Warp team
- [[03-RESOURCES/entities/Warp]] — terminal/developer experience company; built Buzz agent
