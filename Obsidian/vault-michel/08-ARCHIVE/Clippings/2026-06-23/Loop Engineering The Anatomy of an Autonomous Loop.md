---
title: "Loop Engineering: The Anatomy of an Autonomous Loop"
source: "https://x.com/zostaff/status/2068992150243508712"
author:
  - "[[@zostaff]]"
published: 2026-06-22
created: 2026-06-22
description: "In March 2026 the man who created Claude Code admitted he had not opened a code editor once in a month. Boris Cherny shipped 259 pull reques..."
tags:
  - "clippings"
---
![Image](https://pbs.twimg.com/media/HLaJU1bWEAAHSPx?format=jpg&name=large)

In March 2026 the man who created Claude Code admitted he had not opened a code editor once in a month. Boris Cherny shipped 259 pull requests, and every single one was written not by him but by his loops. His job is no longer to write code. His job is to write the thing that writes the code.

A few days earlier, engineer Peter Steinberger put the same idea in one line that millions then saw: you should not be prompting agents anymore, you should be designing loops that prompt your agents for you. Two strong engineers, independently, reached the same conclusion. The skill that now sets the ceiling is not the ability to write a good prompt. It is the ability to build a good loop.

In two weeks the topic was covered in dozens of articles, and almost all of them reduce to a list of tools: here are the commands, here are the files, copy them. This article is about something else. About the mechanics: what a loop actually is, why it either converges on truth or turns into an expensive random walk, and why these are two different engineering problems, the second of which almost nobody teaches. Because in the same month someone else's loop ran for eleven days unwatched and burned tens of thousands of dollars before anyone noticed.

## How a loop differs from a prompt

A prompt is one instruction. You ask for something, get an answer, decide what to ask next. Every step runs through you. You are the engine, the agent is the tool in your hand, and the moment you stop, everything stops.

A loop is a goal the agent walks toward on its own until it arrives. You set the goal once, and from there the system finds the work itself, does it, checks the result, fixes the weak spot, and repeats until the goal is met. You step out of the circuit. The work continues without you.

The difference is not scale but who turns the steps. In a prompt, you turn them. In a loop, the system does. This moves you from the position of a doer to that of a designer: you no longer do the work, you build the machine that does it. And like any machine, it has an internal design you have to understand, or it will drive somewhere you did not intend.

## The five parts of a working loop

Underneath the noise, a working loop is assembled from five recurring parts. The list looks deceptively simple, but the whole difference between a loop that helps and a loop that burns money hides inside these parts.

> Finding work. The loop figures out for itself what needs doing: reads failing tests, open issues, recent commits. Without this you are feeding it tasks by hand again. Plan. Decides how to do it and breaks it into steps. Action. Does the work: writes code, edits a file, hits an API. Verification. Checks the result against the goal. This is the heart of the loop, we will return to it separately. Memory. Remembers what is done and what failed, so tomorrow's run continues instead of starting from zero.

Three of the five do all the real work, and they are exactly where people break loops: verification, memory, and the stop condition hidden inside verification. Let us go through them, because without them the rest is a pretty wrapper around a machine that agrees with itself.

![Image](https://pbs.twimg.com/media/HLXF1H3WsAAF5fs?format=jpg&name=large)

But honestly: of the five parts, only two require real thought. Discover, plan, and act are almost always trivial, handled by the agent with standard means: reading a task list, sketching steps, writing code is what a modern model does out of the box. Finding work deserves attention only in large loops where you must decide what to grab next. But verification and memory are what the loop lives or dies on, which is exactly why we spend separate sections on them ahead and keep the middle three brief.

## Verification: why there is no loop without it

This is the most important part, and the most underestimated. Without a real check on the result, you do not have a loop, you have an agent agreeing with itself over and over.

The model that wrote the code and the model that grades it is a bad judge: it is too generous to its own work. It will always pass itself. So the check has to be something that can say no independently of the agent. A hard test that passes or fails. A measurable condition, a number above a threshold. A type check, a linter, a build. Anything that delivers a verdict based on fact, not on the agent's opinion.

This is why loops first took off in programming. Code is the most verifiable thing in the world: a test is either green or red, there is nothing to argue with, and the agent always knows exactly whether it is finished. Where no such check exists, a loop is useless, because it has no way to tell done from not done.

From this follows a practical filter: build a loop only when there is something that can automatically reject a bad result. If nothing can fail the work for you, the loop just spins idle and burns tokens while producing the appearance of progress.

## The simplest working loop is twenty lines of bash

Enough abstraction, here is a loop you can copy and run today. In its purest form a loop is a while-loop that feeds the agent the same prompt until the check goes green. The technique is called Ralph after the stubborn character: dumb, but it works.

```bash
#!/usr/bin/env bash
set -euo pipefail
MAX_ITER=20
i=0

while [ $i -lt $MAX_ITER ]; do
  i=$((i + 1))
  echo "=== Iteration $i of $MAX_ITER ==="

  # VERIFY first: if already green, exit without spending a model call
  if npm test --silent; then
    echo "Tests green. Done in $i iterations."
    exit 0
  fi

  # otherwise one agent pass: fix the first failing check, touch nothing else
  claude -p "Tests are failing. Run \\`npm test\\`, read the first failure,
  make the smallest change that fixes it. Do not refactor unrelated code.
  Do not weaken tests to make them pass." \
    --permission-mode acceptEdits

done

echo "Hit the $MAX_ITER iteration cap. Tests still red."
exit 1
```

Read what happens here, because these twenty lines hold the whole skeleton. The npm test check is first in every turn: the loop asks "already done?" first and only spends a model call if not. The -p flag is headless mode: the agent reads the prompt, does the work, exits. Memory between turns lives not in the model but on disk and in git: each next pass sees the changed files and the red test, it does not remember the prior conversation. And MAX\_ITER is your main fuse: without it this same loop would run until the money ran out.

Notice the key property that makes it all work: each iteration starts with fresh context. The model degrades as the window fills, so not accumulating history but starting over each time and pulling state from disk is not a bug but the main feature. Progress is held by the file system, not the agent's memory.

## /goal versus /loop: who delivers the verdict

The bash loop above you write yourself. Modern tools built the same logic in, and here it matters to understand the difference between two commands, because it is constantly confused.

/loop re-runs a prompt on a timer or interval. It is polling: check the deploy, re-run the test, see if anything appeared. The agent checks its own work each turn.

/goal runs until a condition you wrote is provably true. And here is the key detail: after every turn a separate, smaller model reads the transcript and independently decides whether the condition is met. The model that wrote the code does not grade itself. This is implemented as a session-scoped Stop hook: after each turn the condition and the conversation go to a fast cheap model like Haiku, it returns a yes or no with a short reason, and a "no" is fed back to the agent as guidance for the next turn.

```bash
# work until the condition is met; a separate model judges
claude -p "/goal all tests in test/auth pass and the linter is clean"

# re-run a prompt on an interval (polling, not until-true)
# /loop watches a deploy and repeats the check
```

The difference is not cosmetic. /loop is "repeat this action," /goal is "work until this becomes true, and let someone other than the doer judge." For a real loop that converges on a result, you need the second, because in it the check cannot be routed around from the inside.

## Memory: why the loop forgets without it

A model forgets when a run ends. The conversation dies, the context clears, the next run wakes up knowing nothing. Memory in the chat dies with the run. So it has to live on disk.

In practice that is one file. Something like a STATUS.md in the repo, which the loop reads first thing and rewrites last. It holds what is done, what is in progress, what is next, and the handful of things the loop must never touch.

```markdown
# STATUS.md  (the loop reads this first, writes it last)
## Done
- [x] auth: migrated to tokens v2, tests green
## In progress
- [ ] billing: webhook refactor (PR #214, CI red)
## Next
- [ ] dashboard: flaky test in test/charts
## Never
- do not modify infra/ without a human
```

This also solves the subtle problem of long context. A model degrades as its window fills: past some threshold, quality measurably drops. If each run starts with fresh context and the state is pulled from a file, the loop does not drown in its own history. Progress lives in files and in git history, not in the model's memory. When the context fills up, you get a fresh agent that reads the status from the file and continues from where the last one stopped.

Treat the loop like a night shift you never watch. You are not judged by what the loop did at 3am. You are judged by the note waiting on your desk at nine. Design that note first, and most of the loop designs itself.

## Separating the maker from the checker

The most valuable structural move in any loop is to split the agent that does the work from the agent that checks it.

The reason is the same as for verification in general: a model is too generous to itself. A second agent, with different instructions and ideally on a different model with higher reasoning effort, catches what the first talked itself into. Your maker can be fast and cheap, your checker slow and strict. That separation is most of the quality.

```markdown
# .claude/agents/reviewer.md
---
name: reviewer
description: Adversarial reviewer. Use after any code change.
model: opus
---
Review like an owner. Assume the author is wrong until the diff proves otherwise.
Look for: logic errors, security holes, missing tests, broken conventions.
You do not edit code, you find problems.
```

The cost is real: the second agent runs its own model and its own tools, doubling the bill. So spend the second opinion where being wrong is expensive, not on every small thing.

## The second half almost nobody teaches

Everything above is about building a loop that does the work. But there is a second half, and it decides whether your loop is an asset or a liability. It is the brakes.

That loop that ran eleven days and burned tens of thousands of dollars was not a clever AI gone rogue. It was two agents, an analyzer and a verifier, politely asking each other for more work, with no step limit, no budget ceiling, and no stop condition. One cap would have killed it on the first day.

Install the brakes before the horsepower. Do not ship the engine until you have shipped the brake pedal. The minimal set you bolt on before you walk away from the loop:

> Step cap. A hard ceiling on the number of iterations, no exceptions. Fifty steps on a large project is already tens of dollars. Budget ceiling. A limit in money per phase, after which the loop stops itself. Blast radius. One worktree, one branch, read-only outside the working folder. The loop should not have physical access to what you are afraid to break. Circuit breaker. The same tool with the same arguments three times in a row means the agent is stuck, not working. Halt. Liveness check. The loop writes a heartbeat to the state file each run. Silence means it died, and you should be woken.

The rule is simple: scope a loop by what it can destroy, not by what you want it to do. Blast radius first, task second.

And price it honestly. The same approach that shipped 259 PRs, in someone else's hands without brakes, ran up a bill of tens of thousands. Here is another number with the same technology: an engineer delivered a fifty-thousand-dollar contract by running an autonomous loop and paid less than three hundred for the API. Same machine. The difference is the brakes, and whether the loop had a real check.

Here is the same twenty-line loop, but with the brakes bolted on. The difference between it and the naive version is the difference between an asset and a bill for tens of thousands.

```bash
#!/usr/bin/env bash
set -euo pipefail
MAX_ITER=20
MAX_BUDGET_USD=10
i=0
last_failure=""
repeat_count=0

while [ $i -lt $MAX_ITER ]; do
  i=$((i + 1))

  # LIVENESS check: write a heartbeat, silence = the loop is dead
  echo "iter=$i ts=$(date +%s)" > .loop_heartbeat

  if npm test --silent; then
    echo "Green in $i iterations."; exit 0
  fi

  # CIRCUIT BREAKER: same failure twice in a row = agent stuck, not fixing
  current_failure=$(npm test 2>&1 | grep -m1 "FAIL" || true)
  if [ "$current_failure" = "$last_failure" ]; then
    repeat_count=$((repeat_count + 1))
    if [ $repeat_count -ge 2 ]; then
      echo "Same failure 3 times. Stuck. Halting for a human."
      exit 2
    fi
  else
    repeat_count=0
  fi
  last_failure="$current_failure"

  # BUDGET ceiling: a money limit per pass
  claude -p "Fix the first failing test with the smallest change." \
    --permission-mode acceptEdits \
    --max-budget-usd "$MAX_BUDGET_USD"
done

echo "Iteration cap reached, tests red."; exit 1
```

The three added things are the engineering of brakes. The heartbeat to a file: if it stops updating, you know the loop died rather than quietly pretending to be alive. The repeat detector: the same failure twice in a row means the agent is guessing, not fixing, and the loop halts itself and calls a human instead of burning fifteen more turns. The budget ceiling per pass: even if something goes wrong, the bill is bounded from above. The blast radius here is also set by which folder you run the loop in and which permissions you gave the agent, which is why you run this in an isolated git worktree or a container, not on your main machine.

## How loops die

Every loop that fails dies one of four deaths. Learn their names now so you recognize them at 3am by the symptom and know the cure immediately.

> Runaway. Symptom: the bill and the iteration count climb, progress does not. Cause: two agents feed each other forever. Cure: a step cap and a budget ceiling, nothing cleverer. Silent death. Symptom: the loop reports work but has actually stood still for hours. Cause: a run hit a full context window, stopped, but pretends it is alive, ramming into the same wall. Cure: a heartbeat and fresh context per phase instead of one endless run. The random walk. Symptom: the loop spins but drifts away from the goal, not toward it. Cause: no verifiable stop condition, and the agent simulates "looks done" forever. Cure: a hard fixpoint check like green tests that cannot be satisfied with words. Comprehension debt. Symptom: the repo does more and more while you understand less and less. Cause: the loop ships code faster than you read it, and you become a stamp approving diffs blindly. Cure: a mandatory human-read gate the loop is never allowed to skip.

The first two kill money and time, the second two kill quality and you as an engineer. The brakes from the previous section cure the top pair directly. The bottom pair is cured by no flag, only by discipline: a check that cannot be satisfied by lying, and a read that cannot be skipped.

## The order that works

If you build a loop, the order matters more than the tools. The people whose loops survive in reality do it the same way.

First get one manual run to pass reliably. Then fold its instructions into a skill file, so you do not paste a wall of text every time. Then wrap the skill in a loop, adding the check and the stop condition. And only then put it on a schedule. Jumping ahead, automating something you have not made reliable by hand, is exactly how loops blow up while you sleep. Prove it once, harden it, then automate.

One important point about money, so there are no illusions. The loud stories about a fleet of a hundred agents are real, but such a fleet costs more than a million a month and works because it is paid for by an employer the size of a major lab. The frontier case is sponsored. Yours is not. On an ordinary plan, the loop that pays off is small, capped, and pointed at one dull job, not a swarm of agents.

## Stay the engineer

Two people can build the identical loop and get opposite results. One uses it to move faster on work they understand to the bone. The other uses it to stop understanding the work at all. The loop cannot tell them apart. You can.

Cherny's point was never that the work got easier. It is that the leverage moved: from the prompt to the loop, from typing to judgment. That is a harder job than prompting, not a softer one. Before, you were responsible for what you wrote. Now you are responsible for what you built, and for whether you still understand what it does.

So the move is small and deliberately modest, because all of this is early and the costs swing wildly. Tomorrow morning, take the most boring job you still do by hand: triaging failed tests, closing stale issues, chasing a flaky test. Wrap one capped loop around it. Brakes first. Small enough that you still read every diff it ships.

Nobody shipping two hundred pull requests a month started with a hundred agents. They all started with one loop they trusted, and they stayed the engineer the whole way. Build that one.