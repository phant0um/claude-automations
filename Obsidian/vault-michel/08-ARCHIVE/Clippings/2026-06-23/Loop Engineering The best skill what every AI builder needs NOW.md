---
title: "Loop Engineering: The best skill what every AI builder needs NOW"
source: "https://x.com/sunaiuse/status/2069077492267098483"
author:
  - "[[@sunaiuse]]"
published: 2026-06-22
created: 2026-06-22
description: "97% of AI builders are doing this wrong.They're not bad at prompting. They're building the wrong thing entirely.A prompt gets you an answer...."
tags:
  - "clippings"
---
![Imagem](https://pbs.twimg.com/media/HLbV4t3WcAAa4Wa?format=jpg&name=large)

97% of AI builders are doing this wrong.

They're not bad at prompting. They're building the wrong thing entirely.

A prompt gets you an answer. A loop gets you a system that finds the answer, checks it, fixes the mistakes, and tells you when it's done — without you touching it again.

Here's everything you need to build one that actually works.

**Why Loops Beat Prompts**

Boris Cherny, creator of Claude Code at Anthropic, said it plainly:

"I don't prompt Claude anymore. I have loops running that prompt Claude and figure out what to do. My job is to write loops."

One engineer shipped 259 pull requests last month. His AI wrote every one. He never opened a code editor.

Someone else ran a loop unattended for 11 days. It burned $47,000 before anyone noticed.

Same technology. Same tools. One difference: brakes.

**What a Loop Actually Is**

Strip the jargon. Every real loop has 4 parts.

→ **Trigger** — what starts the cycle → **Process** — what the agent does each run → **Verification** — how the loop checks its own output → **Stop condition** — when it's actually done

Most "automations" that fail are missing #3 and #4 entirely.

A script that runs every 5 minutes with no checker isn't a loop. It's a timer with opinions.

An agent that retries a failed task 200 times without escalating isn't persistent. It's stuck — and billing you for the pleasure.

**Part 1: The Trigger**

3 types. Only one of them scales.

**Fixed interval** — runs on a clock regardless of state. Fine for daily summaries or weekly dependency bumps. Wastes tokens when nothing changed.

**Event-driven** — fires when something specific happens. A new PR opens. A test fails. A webhook arrives. Best when the work only needs to happen in response to something real.

**Dynamic interval** — the agent decides how long to wait based on what it found. Nothing changed? Wait longer next time. Something significant happened? Check again in 5 minutes.

```text
# Claude Code
/loop every 30 min: check src/auth for new failures

# Scales down to 5min if failures are found
# Scales up to 2hr if last 3 runs found nothing
```

Most people pick a fixed number and never revisit it. The dynamic version costs a few extra tokens to reason about cadence. It saves hundreds deciding whether to run at all.

**Part 2: The Process**

Narrow scope wins. Always.

A process step that tries to do everything in one pass is harder to verify, harder to debug, and nearly impossible to make reliable. 4 narrow steps each doing 1 clear thing beats 1 mega-prompt doing everything.

This is the real argument for multi-agent architecture — not that more agents are inherently better, but that narrow scope makes verification tractable.

A Researcher agent that only gathers and cites sources can be checked against one standard: is every claim sourced?

A Builder agent that only writes code from a brief can be checked against a different standard: does the output match the spec?

Collapse those into one agent doing both simultaneously and verification becomes a judgment call instead of a checklist.

```text
# Bad: one agent doing everything
agent.run("Research the competitor, write the analysis, 
           and summarize findings with citations")

# Better: scoped handoffs
researcher.run("Find 5 recent sources on competitor pricing. 
                Cite every claim. Output JSON.")
builder.run(f"Summarize these findings for a founder: {research_output}")
verifier.run(f"Check: does every claim in this summary 
               trace to the source list? {summary}, {sources}")
```

**Part 3: Verification (The Part Everyone Skips)**

This is the component that separates a loop that compounds in quality from one that just generates activity.

The naive failure: the agent that produced the output also judges whether it's good. The same reasoning that created the mistake reviews the mistake and says it looks fine.

An agent that fabricated a citation doesn't catch its own fabrication on review. Neither does a developer who wrote a bug catch it in their own code review.

**3 patterns that actually work:**

**Separate verifier agent** — different model, different context, explicit instruction to look for failures rather than confirm success.

```text
# .claude/agents/verifier.md
name: verifier
description: Adversarial reviewer. Runs after every code change.
developer_instructions: |
  Your job is to find what's wrong, not confirm what's right.
  Assume the previous agent missed something.
  Output: PASS or FAIL with specific evidence.
model: opus
```

**Cross-reference against ground truth** — check specific claims against verifiable sources. Did the code pass the test suite? Does the cited statistic appear in the document? Does the output match a schema? This is mechanical verification, not judgment.

**Stronger model verifying weaker model** — fast agents generate in parallel, one stronger model checks every output before it reaches a human. The verifier doesn't share the generator's failure modes.

The hard rule: never let a loop declare success because the thing being verified also says it succeeded.

**Part 4: The Stop Condition**

Most homebuilt systems have 2 states: running and done.

Real stop conditions have 3.

**Success** — verification passed. Loop stops. It should say so explicitly, with what passed and why, not just silently terminate.

**Bounded retry** — verification failed, retry budget not exhausted. The loop tries again with specific correction feedback from the verifier, not from scratch.

```text
# Claude Code
/goal all tests in test/auth pass and lint is clean
# runs until condition is TRUE or max_turns is hit
# each retry uses the error output from the previous attempt
```

**Escalation** — retry budget exhausted. This is the state almost nobody builds, and it's the most important one.

4 failed attempts at the same narrow task is a signal. It usually means the task definition is wrong, not that the system needs attempt #5.

```text
# loop.config — set BEFORE you walk away
max_turns: 50
max_budget_usd: 10
scope: [src/]
circuit_breaker: 3   # same call 3x in a row = halt
heartbeat: STATUS.md # silence instead of an update = alarm
```

A loop with escalation converts "this might run forever and you'll never know" into "this either finishes or tells you exactly why it can't, within a bounded number of cycles."

That conversion is the entire difference between a system you trust to run unattended and one you have to babysit.

![Imagem](https://pbs.twimg.com/media/HLbWzk6XUAUnF_2?format=jpg&name=large)

**Part 5: Memory (What Makes Loops Compound)**

A loop without memory does the same quality of work on cycle 100 as cycle 1

A loop with memory gets measurably better — because each cycle's output, including its failures and what corrected them, feeds into the context for the next run.

```text
# STATUS.md — the loop reads this first, writes it last

## Done
- [x] auth: migrated to tokens v2, tests green

## In Progress  
- [ ] billing: webhook refactor (PR #214, tests red)

## Never Touch
- do not modify infra/ without a human in the loop
```

This is why documented context engineering numbers are so stark. The jump from a 41% mistake rate with no persistent context document to a 3% mistake rate with a comprehensive one isn't the model getting smarter. It's the context the model has access to getting better.

The loop accumulates that context automatically instead of requiring a human to re-explain it every session.

**A Real Loop: Start to Finish**

Here's the complete architecture applied to one task: monitoring a competitor's content for strategic shifts.

```text
Trigger:   Twice weekly, Monday and Thursday at 7 AM
Process:   Search public content from past 3-4 days
           Compare against 6 weeks of accumulated notes
           Flag anything representing a genuine shift
Verify:    Would this be newsworthy to someone who follows 
           this space closely?
           Is there evidence of pattern vs isolated data point?
Memory:    Write findings (including null results) to STATUS.md
           After 6 weeks: 12 logged cycles, gradual positioning 
           shifts visible only in accumulated data
Stop:      If significant shift found → send alert
           If 3+ cycles find nothing → widen search scope, flag
```

A routine product update fails the verifier. A consistent messaging shift sustained across 3+ data points over 4 weeks passes it.

A single cycle shows you what happened this week. 12 cycles show you what's actually changing.

**The 4 Ways Loops Actually Die**

**Runaway recursion** — 2 agents feed each other work indefinitely. Fix: step cap plus money ceiling, set before the first run.

**Silent death** — context window fills, loop stalls, still reports "progress." Fix: heartbeat file that must update every cycle or an alarm fires.

**Walking in circles** — no verifiable stop condition, so the agent defines "done" however it wants. Green tests are a condition a loop can reach. "Looks better" is not.

**Comprehension debt** — the faster a loop writes code you never read, the further you drift from your own project. Fix: mandatory human review step that never gets skipped, not because you distrust the loop but because you need to remain its engineer.

**The Actual Skill Shift**

The people shipping production agent systems right now aren't doing it because they have access to a model nobody else has.

The frontier model gap is closing. GLM 5.2 sits within 1% of Claude Opus 4.8 on the hardest agentic coding benchmarks. Open-weight models close the gap on a near-monthly cadence now.

What doesn't commoditize is the architecture around the model. The trigger design. The verification logic. The stop conditions. The memory structure.

Anyone can switch to whichever model benchmarks best this month.

Far fewer people can look at a stalled multi-agent system and correctly diagnose that the problem isn't the model. It's a missing verification step.

That diagnostic skill is what scales.

Build 1 loop this week using the framework above.

Define the trigger. Scope the process to 1 narrow task. Build a verifier that doesn't trust the thing being verified to verify itself. Cap the retries and write the escalation path before you run it once.

That's the whole thing.

Not the model. Not the prompt.

The architecture around both.