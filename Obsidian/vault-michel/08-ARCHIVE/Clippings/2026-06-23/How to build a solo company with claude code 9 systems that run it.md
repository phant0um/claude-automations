---
title: "How to build a solo company with claude code: 9 systems that run it"
source: "https://x.com/0xMorlex/status/2069015014451659059"
author:
  - "[[@0xMorlex]]"
published: 2026-06-22
created: 2026-06-22
description: "The one-person company used to be a contradiction. One person is a freelancer, a consultant, a maker of one small thing. A company needs eng..."
tags:
  - "clippings"
---
![Imagem](https://pbs.twimg.com/media/HLaeFAoWEAAiGWd?format=jpg&name=large)

The one-person company used to be a contradiction. One person is a freelancer, a consultant, a maker of one small thing. A company needs engineers, support, ops, an analyst, someone who answers email at 6am. The headcount was the product.

That assumption is the thing breaking. Not because an agent replaces a team, it doesn't, but because the work a team used to do can increasingly be encoded into systems that run without a person sitting on each one. The leverage is no longer how many people you employ. It is how many systems you have built that do the work while you do something else.

This is nine of those systems, built entirely out of Claude Code parts you already have. Three to build and ship the product, three to keep the operation running, three to grow it. None of them is magic, and every one of them has a line where you stay in the loop on purpose. That line is the whole point. A one-person company is not a person who does nothing. It is a person who only does the things that actually need them.

Follow \[[https://t.me/autoApprove1](https://t.me/autoApprove1)\] for more.

## Tier 1 · The product: build and ship

**01\. The build loop.**

![Imagem](https://pbs.twimg.com/media/HLaYpLHWIAASPaT?format=jpg&name=large)

The core system, the one everything else leans on, is a disciplined loop for turning intent into shipped code. The naive version is "type a request, accept the diff." The system version has three moves: a CLAUDE.md so the agent knows your stack and conventions without being re-told, plan mode so it explores and proposes before it edits, and a verification target so it can check its own work instead of guessing.

That last move is the one solo builders skip and shouldn't. When Claude Code can run a test, hit an endpoint, or diff against an expected output, the quality of what it produces jumps, because it stops writing into the dark. Your job in this loop is not to write the code. It is to write the spec sharp enough that "done" is measurable, and to own the review.

A CLAUDE.md that earns its place is short and factual, not a manual:

```text
# Project: ledger-api

## Stack
- pnpm, not npm. Node 22. TypeScript strict.
- Postgres via Prisma. No raw SQL in handlers.

## Conventions
- Every endpoint ships with a test. No test, no merge.
- Money is stored in integer cents, never floats.

## Verify before claiming done
- \`pnpm test\` passes and \`pnpm typecheck\` is clean.
```

Where you stay: deciding what to build and what "correct" means. The agent is good at the how, not the whether.

**02\. The reviewer.**

A one-person company has no second engineer to catch what you missed. So you build one. The most valuable subagent you can define is a reviewer with its own fresh context window, pointed at the work the main agent just did.

![Imagem](https://pbs.twimg.com/media/HLaa292XoAA2j2m?format=jpg&name=large)

This matters because a model checking its own output is too easy on itself. It sees its own reasoning trail and prefers conclusions consistent with what it already wrote. A separate reviewer sees only the artifact and the standard you set, and catches what the writer talked itself into. Pair it with deterministic hooks: a PreToolUse hook that blocks dangerous commands by exit code, a PostToolUse hook that runs your linter after every edit. CLAUDE.md is a suggestion the model can ignore. A hook is a wall it cannot.

The reviewer is just a file in .claude/agents/:

```text
---
name: reviewer
description: Independent review of any non-trivial diff. Use before merge.
tools: Read, Grep, Bash
---
You did not write this code. Review the diff for correctness,
security, and adherence to CLAUDE.md. Run the tests. List concrete
problems with file and line. Do not praise. If it is not ready to
merge, say why as a short list.
```

Where you stay: setting the standard. The reviewer enforces taste it was given, not taste it invented.

**03\. The release and maintenance system.**

![Imagem](https://pbs.twimg.com/media/HLaa6_ZWEAAVy-b?format=jpg&name=large)

Shipping once is a task. Shipping continuously is a system. This is where Claude Code stops being an app you sit in front of and becomes infrastructure. Headless mode (claude -p) runs it non-interactively, so you can wire it into CI, pipe data through it, and get structured output back. Scheduled loops (/loop, or cloud routines that run with your laptop closed) let it chip away at the boring, compounding maintenance work: triaging a failing test, drafting a dependency bump, cleaning a backlog of small issues on a cadence.

Route the work by cost. Reserve the heavyweight model for the orchestrator role and let cheaper models handle the high-volume passes. You do not need the top tier to fix a lint error.

In CI it runs headless and hands back structured output you can act on:

```text
# .github/workflows/triage.yml (a step)
claude -p "Triage the failing tests in this run. Draft fixes in
  claude/ branches for the deterministic ones, escalate the rest." \
  --output-format json
```

Where you stay: the merge button on anything that touches production. Automate the drafting, not the deciding.

## Tier 2 · The operation: keep it running

**04\. The support desk.**

![Imagem](https://pbs.twimg.com/media/HLaa9dsWMAAWci1?format=jpg&name=large)

Support is the function that quietly eats a solo founder alive, because it never batches and never ends. The system: connect your inbox or issue tracker through MCP so Claude Code can read incoming tickets in context, then have it triage and draft. Categorize by type, pull the relevant docs, draft a reply in your voice, and flag the handful that actually need you.

The discipline is that drafts are drafts. The system handles the eighty percent that are variations on questions you have answered before, and surfaces the twenty percent that are genuinely new, angry, or legally sensitive. Those you write yourself.

Where you stay: anything emotional, anything that sets a precedent, anything a refund. A wrong auto-reply costs more than the time it saved.

**05\. The analyst.**

You will not hire a data team, so you build the function. Claude Code reads CSVs, queries a connected database, and turns a pile of numbers into a chart and a paragraph that says what changed. The system version is recurring: a scheduled run every Monday that pulls last week's metrics, compares them to the week before, and writes you a short digest of what moved and what is worth looking at.

![Imagem](https://pbs.twimg.com/media/HLabDISXQAAsJsE?format=jpg&name=large)

The honest limit: it reports, it does not divine. It will tell you revenue dropped on Thursday. It cannot tell you that a competitor launched that morning unless you give it that context. Treat its output as a well-organized starting point for your judgment, not a verdict.

Where you stay: causation. The system is excellent at "what happened" and unreliable at "why," so you own the why.

**06\. The second brain.**

A company has institutional memory. A one-person company has one tired person who forgets why they made a decision three months ago. So you externalize it. A STATE.md file, or a connected board, records what was tried, what worked, what failed, and what rules survived. Skills capture the procedures you keep re-explaining, and get sharper every time one fails in a new way.

![Imagem](https://pbs.twimg.com/media/HLabFMtXkAAvfPU?format=jpg&name=large)

The memory is a plain file every system reads at the start and writes at the end:

```text
# State · ledger-api

## Verified facts
- Webhook secret lives in STRIPE_WEBHOOK_SECRET, not the dashboard.
- prc column is integer cents. Confirmed via SELECT MIN/MAX.

## Lessons learned
- Migrations on tables over 1M rows must batch in 10k chunks.

## Last session
2026-06-22 · weekly digest shipped, 2 support drafts await review.
```

This is the system that makes all the others compound. Without it, every run restarts from zero and your agents re-derive your business every morning. With it, the work accumulates. The lesson from a bug in March is consulted automatically in June instead of being re-learned the hard way.

Where you stay: deciding what is worth remembering. Memory that records everything is as useless as memory that records nothing.

## Tier 3 · The growth: reach and leverage

**07\. Research and intel.**

The function a team usually staffs as "someone who keeps an eye on the market." You build it as a research system: subagents with their own context windows and web access, pointed at a question, producing a brief instead of a wall of tabs. What did competitors ship this week. What are people complaining about in your category. What changed in the regulation you depend on.

![Imagem](https://pbs.twimg.com/media/HLabHR_W8AEKXUM?format=jpg&name=large)

Run the heavy reading in subagents so the noise, the forty open sources, stays out of your main thread and only the synthesis comes back. Schedule it so the brief is waiting when you start your week.

Where you stay: the search is only as good as the question, and the synthesis is only as trustworthy as your skepticism. Verify anything you are about to act on against the primary source.

**08\. The content engine.**

Distribution is the other half of a product, and a solo founder is also the entire marketing department. The system turns work you already did into things people can read: a shipped feature into a changelog, a hard debugging session into a post, a research brief into a thread. Claude Code drafts in your structure, you edit for truth and voice.

![Imagem](https://pbs.twimg.com/media/HLabJadXIAAQMtE?format=jpg&name=large)

The trap here is the one that kills credibility fastest: letting the draft ship without you. An agent will happily invent a statistic, a quote, or a confident claim it cannot support. For anything public, you are the fact-checker, and that is non-negotiable. The content engine is a drafting system, not a publishing one. The publish button stays human.

Where you stay: every factual claim, every number, every quotation. Accuracy is the only moat a small operation has.

**09\. The wiring.**

The last system is the one that connects the other eight. Most of a company's overhead is not the work, it is the handoffs: moving a thing from email to the tracker, from the tracker to the calendar, from the calendar to the invoice. Through MCP, Claude Code can reach across those tools and close the small gaps that would otherwise be twenty manual steps a day.

Build this one last and build it carefully. Automation across tools that can send, pay, or delete is exactly where a silent failure is most expensive. Give it narrow permissions, deny the destructive actions outright, and log what it does.

Give it room to read and move information, and a hard wall on anything destructive:

```json
{
  "permissions": {
    "allow": ["Read(*)", "mcp__tracker__*", "mcp__calendar__create_event"],
    "deny": ["mcp__billing__*", "Bash(rm *)", "mcp__email__delete_*"]
  }
}
```

Where you stay: anything irreversible. The glue should move information freely and touch money, contracts, and deletions never, without you.

## § The mistakes that turn a one-person company back into a one-person scramble

- **Automating the deciding, not just the doing.** The systems draft and prepare. You decide. Blur that line and you ship someone else's judgment as your own.
- **No memory layer.** Without a STATE.md and skills, every system restarts from zero and nothing compounds. This is where most of the leverage quietly leaks out.
- **Skipping the reviewer.** One agent writing and grading its own work is not a quality system. It is a confident one.
- **Letting the content engine publish.** An unverified draft going out under your name is the fastest way to lose the only advantage a small operation has.
- **Broad permissions on the glue.** A connector that can act across your tools needs tight scopes and hard denies, or one silent error becomes a real-world mess.
- **Top-tier model for everything.** Route by task. Paying orchestrator prices for a lint fix is how a solo P&L bleeds.
- **Treating reports as verdicts.** The analyst tells you what happened. You still have to figure out why.

## The point

A one-person company is not one person doing the work of ten. It is one person who has built ten systems that do the work, and who spends their time on the few things that genuinely require a human: deciding what to build, defining what correct means, owning the truth of what goes out, and touching anything irreversible.

The parts are already in your hands. A CLAUDE.md and a verification target make the build loop. A reviewer subagent and a hook make the quality gate. Headless mode and a schedule make the operation run while you sleep. MCP makes the glue. Memory makes all of it compound.

Pick the function that is currently eating the most of your week, support, maintenance, the weekly numbers, and build the system for that one first. Get it reliable. Then the next. The company is not the headcount you avoided hiring. It is the systems you built instead.