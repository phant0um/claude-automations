---
title: "The Debug Loop: How Claude Code Finds the Bug in 6 Steps Instead of 60"
source: "https://x.com/0xMortyx/status/2067916241994391711"
author:
  - "[[@0xMortyx]]"
published: 2026-06-19
created: 2026-06-20
description: "You hit a bug at 2pm. You paste the error into Claude Code. It suggests a fix. Still broken. You paste the new error. Another fix. Still bro..."
tags:
  - "clippings"
---
![Image](https://pbs.twimg.com/media/HLAa3dlXwAAvsp5?format=jpg&name=large)

You hit a bug at 2pm. You paste the error into Claude Code. It suggests a fix. Still broken. You paste the new error. Another fix. Still broken. It's 4pm now, you've sent 40 messages, patched three things that weren't the problem, and the original bug is exactly where it started.

![Image](https://pbs.twimg.com/media/HLAR1arXoAAJrmW?format=jpg&name=large)

Everyone has lived this. And it has nothing to do with the model being weak. It happens because pasting an error and asking for a fix is not debugging, it's gambling. You're asking for a guess, getting a guess, and acting surprised when the guess is wrong.

![Image](https://pbs.twimg.com/media/HLARuD5WwAA6P_7?format=png&name=large)

Real debugging is a process: reproduce the bug, isolate where it lives, trace it to the actual root cause, fix that, verify, and guard against its return. Six steps. Claude Code can run all of them, you just have to stop letting it skip to step four. Here's the loop.

![Image](https://pbs.twimg.com/media/HLAR7iRW8AAYYmV?format=jpg&name=large)

## 1\. Reproduce It Reliably First

A bug you can't reproduce on demand is a bug you can't fix.

**main session**

You cannot fix what you cannot trigger. If a bug only shows up sometimes, every "fix" is unfalsifiable, you can never tell if it worked or you just got lucky. So the loop starts by nailing the bug down: have Claude Code build a reliable repro, the exact steps, inputs, or a failing test that triggers it every single time.

```python
ESTABLISH THE REPRO
"Before fixing anything: reproduce this bug reliably.
Write a failing test or a minimal script that triggers it
every time. Show me it failing. Don't propose a fix yet."
```

> ✓ Now there's a concrete, repeatable signal of "broken" to fix against

![Image](https://pbs.twimg.com/media/HLATM-rXsAApip2?format=jpg&name=large)

## 2\. Isolate the Search Area in Plan Mode

Bound the hunt so it doesn't read your whole codebase for 20 minutes.

**plan mode**

Left unbounded, an agent will happily read your entire codebase looking for a bug. Plan mode fixes this: it lets Claude form a hypothesis about where the bug likely lives and lay out an investigation plan before touching anything. You narrow the search to the suspect area instead of the whole repo.

```python
ISOLATE IN PLAN MODE
# enter plan mode (Shift+Tab twice)
"In plan mode: given this failing test, where is the bug
most likely to live? List the 2-3 most suspect files and
your reasoning. Plan how you'd confirm it before changing
anything."
```

> ✓ The search is now bounded to a few suspect files, not the whole repo

## 3\. Trace the Root Cause With Subagents

Send investigators into the suspect area without bloating your session.

**investigation subagents**

This is the heart of the loop. Instead of one agent reading everything into your main context, you dispatch **investigation subagents**, each with its own context window, to dig into a specific suspect. They report findings back, and a lead agent assembles them into a root-cause conclusion. This is distributed reasoning: the bug gets cornered from several angles at once.

```python
DISPATCH THE INVESTIGATION
"Launch investigation subagents (read-only) to trace this bug:
- one to follow the data flow into the failing function
- one to check recent changes to the suspect files
- one to inspect the edge case the test exposes

Each reports findings. Then tell me the single root cause,
with the evidence, before proposing any fix."
```

> **Why subagents and not one big session:**Investigation generates a lot of reading. Done in your main context, it bloats the session and Claude loses the thread. Subagents keep each line of inquiry in its own context and return only the conclusion, so the main session stays sharp.

> ✓ You get one evidence-backed root cause, not a pile of guesses

![Image](https://pbs.twimg.com/media/HLAUJ4gXYAAn438?format=jpg&name=large)

## 4\. Fix the Cause, Not the Symptom

The whole point of tracing: now you fix the right thing.

**main session**

With a confirmed root cause, the fix is targeted instead of speculative. This is where the 60-message approach quietly fails: it patches the symptom (the NaN), so the underlying cause (no empty-cart guard) resurfaces in a new form next week. Tell Claude explicitly to fix the cause you identified, and to flag if the "fix" is actually just another symptom patch.

```python
FIX THE ROOT CAUSE
"Fix the root cause we identified, not the surface symptom.
Keep the change minimal and targeted. If your fix only
addresses the symptom and not the cause, say so instead
of pretending it's solved."
✓ The fix targets the actual cause, so the bug doesn't mutate and return
```

## 5\. Verify the Fix With a Hook

Make "fixed" mean the repro test passes, automatically.

**PostToolUse / Stop hook**

The trust-then-verify gap is real: the agent says "fixed," you accept, and later find the tests are red. The fix is a hook that runs your test command automatically before "done" can complete. Now your Step 1 repro test runs after every edit, and a fix isn't a fix until that test goes green.

```python
.claude/settings.json // VERIFY-ON-EDIT HOOK
{
  "hooks": {
    "Stop": [{
      "command": "npm run test"
    }]
  }
}

# the repro test now runs before the agent can finish
# "fixed" requires green, not a claim
```

> ✓ "Fixed" is now backed by a passing test, every time, no exceptions

![Image](https://pbs.twimg.com/media/HLAVBqxXAAADIAX?format=jpg&name=large)

## 6\. Guard Against Its Return

A senior engineer leaves a test so the bug can never come back silently.

**regression test**

The repro test from Step 1 becomes a permanent regression test. This is what separates fixing a bug from actually closing it: if anyone reintroduces the same cause later, the test catches it instantly instead of it shipping to production again. Have Claude keep the test, name it clearly, and note the root cause in a comment.

```python
LOCK IN THE GUARD
"Keep the repro test as a permanent regression test. Name it
clearly and add a one-line comment explaining the root cause
it guards against, so future changes can't reintroduce it
silently."
```

> ✓ The bug is now closed, not just fixed. It can't come back unnoticed.

![Image](https://pbs.twimg.com/media/HLAV7KDXUAAdln0?format=jpg&name=large)

## Why This Beats 60 Messages

The 60-message death spiral happens for one reason: you skip straight to fixing before you've found what's actually broken. Every "fix" is a guess, and guesses patch symptoms. The 6-step loop refuses to fix until the root cause is found, which is the entire difference.

- Reproducing first means you have a real signal for "fixed," not a vibe
- Isolating in plan mode means the agent hunts a few files, not the whole repo
- Subagents trace from multiple angles without drowning your main session
- Fixing the cause means the bug doesn't reappear in a new disguise
- The hook plus regression test means "fixed" is proven and stays fixed

> **The honest takeaway:**Claude Code was always able to trace and fix bugs. The reason most people get 60 messages of symptom-patching is that they never ask it to find the cause first. Run the loop, and the same model that frustrated you yesterday closes the bug today.