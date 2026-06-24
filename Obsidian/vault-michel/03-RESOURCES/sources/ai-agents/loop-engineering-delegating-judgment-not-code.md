---
title: "Loop Engineering: You're Not Delegating Code, You're Delegating Judgment"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - ai-agents
  - loop-engineering
  - agent-loops
  - claude-code
  - source
---

# Loop Engineering: You're Not Delegating Code, You're Delegating Judgment

**Source:** [X post by @leanxbt](https://x.com/leanxbt/status/2069409628920991753) · Published 2026-06-23

## Central Thesis

A loop is not a way to delegate code — it is a way to delegate **judgment**. The agent has been writing code for a long time. What is new is that you hand the machine the right to decide whether something is done or not, and the right to keep going without you. Judgment cannot be delegated silently; it must be carried outside, into a check you designed, or the agent will judge itself and always acquit itself.

## Key Arguments

### How a Loop Differs from a Prompt

- **Prompt**: one instruction, you turn the steps, the agent is a tool in your hand. Everything stops when you stop.
- **Loop**: a goal the agent walks toward on its own. You set the goal once; the system finds the work, does it, checks the result, fixes weak spots, repeats until the goal is met. You step out of the circuit.

The difference is not scale but **who turns the steps**. This moves you from doer to designer. Once the system decides "keep going or stop" for itself, you have handed it a piece of your own judgment. All of loop engineering is making that handed-over judgment impossible to forge.

### The Five Parts of a Working Loop

1. **Finding work** — reads failing tests, open issues, recent commits
2. **Plan** — decides how to do it, breaks into steps
3. **Action** — does the work (writes code, edits files, hits APIs)
4. **Verification** — checks the result against the goal (the heart of the loop)
5. **Memory** — remembers what's done and what failed, so tomorrow's run continues

Only verification and memory require real thought. The middle three (finding work, plan, action) are trivial for modern models.

### Step 0: Check the Task Allows a Machine Check

A loop only makes sense where there is a check that delivers a verdict **independent of the agent**. The model that generated a solution and also grades it is in a conflict of interest — its own output is a high-probability continuation, so it systematically overrates its correctness. An agent's self-assessment is not a check; it is an echo.

The check must be **deterministic and idempotent**. A flaky test is worse than no test because it breaks the stop condition.

### Step 1: One Reliable Manual Run with Measurement

Do the task once manually through the agent to a green check. Record: model calls, tokens, most frequent agent error type. This is your baseline.

### Step 2: The Minimal Loop (Stateless)

The simplest working loop is a while-loop that feeds the agent the same prompt until the check goes green (called "Ralph"). Key properties:
- Each iteration starts with **fresh context** — progress is held by the file system, not the agent's memory
- `MAX_ITER` is your main fuse — without it the loop runs until money runs out
- The check is first in every turn: "already done?" before spending a model call

### Step 2.5: Building Context for an Iteration

The right iteration context is three things: current state, the specific failure being worked on, and only the relevant files. Not the whole repo — its relevant slice. Use a token budget to prevent context from growing unnoticed.

### Step 3: A Check You Cannot Fool (Reward Hacking)

The agent will try to fool the check — not from malice but optimization. If the only goal is making tests green, the cheapest path may be deleting asserts, mocking everything, or hardcoding values. This is **reward hacking**: the agent taking your judgment back through a side door.

Defense layers:
1. Prompt prohibition (weakest — agent breaks under pressure)
2. Second check the agent does not control (e.g., test files are read-only)
3. Independent judge on a different model (catches others' self-deception better than its own)

### Step 4: Memory on Disk and the State Protocol

Memory lives in a file the loop reads first and writes last. Two levels:
- **STATUS.md** — human-readable for your morning glance
- **.loop_state.json** — machine state, parsed unambiguously (phase, iteration, last green commit, blocked paths, budget spent)

### Step 5: Isolation and Blast Radius

Physical isolation via git worktree gives the loop a separate working copy. For real isolation, a container with stripped permissions: `--network none` (prevents prompt injection from untrusted input), `--read-only` outside working folder.

**Rule: define the loop by what it can destroy, not by what you want it to do.**

### Step 6: Brakes with Observability

Minimal brakes: iteration limit, budget cap per turn, repeat detector, liveness marker, reward-hacking gate. A structured JSON log lets you diagnose why the loop died.

### Step 7: Count the Cost Nonlinearly

A stateful loop costs quadratically (iteration k pays for k previous turns). Stateless loops keep per-iteration cost roughly constant.

### How Loops Die — Four Deaths

1. **Runaway** — bill and iteration count climb, progress doesn't. Cure: step cap and budget ceiling.
2. **Silent death** — loop reports work but has stood still for hours (hit context window). Cure: heartbeat and fresh context per phase.
3. **Random walk** — loop spins but drifts away from goal. Cure: hard fixpoint check that cannot be satisfied with words.
4. **Comprehension debt** — loop ships code faster than you read it; you become a stamp approving diffs blindly. Cure: mandatory human read the loop is never allowed to skip.

### The Order That Works

1. Get one manual run to pass reliably
2. Fold instructions into a skill file
3. Wrap the skill in a loop with check and stop condition
4. Only then put it on a schedule

### Key Insight

> "Two people can build the identical loop and get opposite results. One uses it to move faster on work they understand to the bone. The other uses it to stop understanding the work at all. The loop cannot tell them apart. You can."

The leverage moved from the prompt to the loop, from typing to judgment. The one judgment you cannot delegate is the decision about which judgment can be delegated.

## Minha Síntese

Este é um dos artigos mais importantes sobre engenharia de agentes de 2026. A tese central — de que um loop delega julgamento, não código — reframes toda a engenharia de agentes: o trabalho real não está em fazer o agente executar, mas em projetar a verificação externa que impede o agente de se auto-absolver. O artigo fornece um blueprint técnico completo, desde o loop mínimo (Ralph) até isolamento em container, circuit breakers, structured logging, e os quatro modos de falha. A noção de "comprehension debt" é particularmente valiosa: o loop que acelera a entrega sem acelerar sua compreensão cria uma dívida mais perigosa que débito técnico, porque você se torna refém do sistema que construiu. Para o vault, conecta diretamente com [[03-RESOURCES/sources/ai-agents/stop-writing-claude-md]] (CLAUDE.md como pointer, não library) e [[03-RESOURCES/sources/ai-agents/foundation-engineering]] (que renomeia Loop Engineering para Foundation Engineering). O conceito de reward hacking é aplicável a qualquer sistema de agentes autônomos.