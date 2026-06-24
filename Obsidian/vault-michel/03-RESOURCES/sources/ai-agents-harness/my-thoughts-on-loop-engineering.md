---
title: "My Thoughts on Loop Engineering"
type: source
category: ai-agents-harness
source: "https://x.com/samueljmcd/status/2066524627585634765"
created: 2026-06-16
ingested: 2026-06-16
tags: [loop-engineering, verification, engineering]
---

# My Thoughts on Loop Engineering

## Tese Central

Loop engineering is the new label but the hard part is the one it has always been: verification. The article argues that loop design is verification design.

---

## Conteudo Original

![Image](https://pbs.twimg.com/media/HK3ClL7XkAA0xPe?format=jpg&name=large)

Loop engineering is the new label. The hard part is the one it has always been. Verification.

**Tip: You can copy and paste this article into Claude and ask for the best insights if you don't want to read it all!!**

There is a line doing the rounds. Boris Cherny, who created and now heads Claude Code, told the Fortune Brainstorm Tech audience in June that he no longer writes the prompts himself. His phrasing was that it is now another Claude doing the prompting. On a given morning he is managing hundreds of agents, sometimes thousands.

The framing that has grown up around this is "loop engineering." The pitch goes in three phases. 2024 was writing good prompts. 2025 was running agents in parallel. 2026 is building the loop that runs the agents for you. You stop typing prompts and start designing the system that types them.

That framing is fine as far as it goes. It also buries the part that decides whether your loop ships anything. A loop is a generator wired to a verifier. The generator was never the bottleneck. The verifier is.

![Image](https://pbs.twimg.com/media/HK3DvqDW0AArHkP?format=jpg&name=large)

## What a loop actually is

Strip the language back. A loop replaces the human cycle of prompt, read, prompt again with a self-running cycle: discover, plan, execute, verify, repeat until a condition is met. The agent drives its own iterations. You design the track it runs on.

The simplest version is a single agent looping over its own output. Research, draft, compare against the goal, fix the weak spots, repeat until it clears the bar. It is a person rewriting a draft, except the person does not get bored.

The larger version is a fleet. A goal goes to an orchestrator. The orchestrator splits it and hands pieces to specialists. Specialists hand detailed work to sub-agents. The tree runs discover, plan, execute, verify at every level until the goal is met. One is a single author. The other is a team running a project end to end.

![Image](https://pbs.twimg.com/media/HK3EEM1X0AI1K1F?format=jpg&name=large)

None of this is new in kind. It is the same agent loop you already run, with the human stepped out of the inner cycle and moved up to the design of it.

## Open and closed

There are two shapes, and the difference is the whole game.

An open loop gives the agent a wide exploratory space. Conditions and a goal, but freedom in between. It can find paths you did not specify and produce things you did not plan for. This is where genuinely novel output comes from. It also burns tokens at a rate most budgets cannot absorb, and on loose criteria it turns into a slop machine. The freer the loop, the more it depends on the thing checking its work.

A closed loop pins the passes down in advance. Clear goal, defined steps, evaluation at each step, a stopping condition or a handoff to a human with the run data attached. The agent still loops, but inside a frame you built. It runs on a normal budget because the paths are bounded.

![Image](https://pbs.twimg.com/media/HK3EOLVWcAE2ZcE?format=jpg&name=large)

Closed loops are what produce results today. People credit the autonomy for that. The autonomy is not the reason. The evaluation gate is. The gate is what stops a confident wrong answer from propagating into the next iteration, and the next.

This is where most loop content goes quiet. Everyone draws the discover, plan, execute, verify diagram. Almost nobody says anything precise about the verify box. That box is the product. The rest is plumbing.

## Where the loop comes from

Loop engineering did not appear from nothing. Two research patterns sit underneath it.

ReAct, out of Princeton and Google, alternates reasoning and action. Think, act, observe the result, think again, repeat until done. In coding terms: understand the goal, write the code, run it, read the error, infer the cause, fix, rerun, until the tests pass. The loop is the point.

Reflexion is ReAct with a memory. When an attempt fails, the agent writes down in plain language why it failed, stores that note, and reads it on the next attempt. In a modern harness that note lives in a file, not the context window. This is the seed of everything people now call persistent memory.

![Image](https://pbs.twimg.com/media/HK3EyubWIAAnB19?format=png&name=large)

Both patterns are about the same thing. An agent that checks itself beats an agent that does not.

## Inner loop and outer loop

A useful loop has two layers, and they get confused constantly.

The inner loop runs inside a single task. The agent validates its work before it answers. A weak agent edits the file and says done. A strong agent edits the file, writes a test, runs it, catches the failing edge case, fixes it, reruns, confirms green, then says done. Same tools. The only difference is whether the model chose to call the verifier. That choice is the difference between a demo and a result.

The outer loop runs across sessions. The agent fails at something, records the lesson in a persistent file, and a later session reads that file and gets it right from the start. SKILL.md and AGENTS.md are the obvious homes for this. The agent forgets when the context window resets. The repository does not.

![Image](https://pbs.twimg.com/media/HK3EZXUXMAATExz?format=png&name=large)

The inner loop is mature. Most agents do it now. The outer loop is still half-built. Persisting the right lesson, in the right place, at the right grain, is harder than it sounds, and it is where a lot of value is currently sitting on the table.

Both layers are verification. The inner loop verifies the task. The outer loop verifies that you do not repeat last week's mistake. And neither is worth much if you cannot see it. You cannot improve a loop you are not measuring. Instrument the gate before you scale the loop, or you are just generating wrong answers faster.

## The Bun port, and the line Anthropic wrote itself

The flagship demonstration is worth reading carefully, because it makes the point better than any diagram.

Jarred Sumner, who built Bun, used Claude Code's dynamic workflows to port the runtime from Zig to Rust. Roughly 750,000 lines of Rust. 99.8% of the existing test suite still passing. Anthropic puts it at eleven days from first commit to merge. Sumner himself said six. Either number is remarkable.

Look at how it was built. One pass mapped the correct Rust lifetime for every struct field. A second wrote each file as a behaviour-identical port, hundreds of agents in parallel, two reviewer agents on every file. A separate layer of agents existed only to refute what the others produced. Then a fix loop drove the build and the test suite until both ran clean. The verification is not a step at the end. It's actually the architecture.

![Image](https://pbs.twimg.com/media/HK3E-yHXcAAmcc8?format=png&name=large)

And then the caveat, which Anthropic wrote into its own announcement: the port is not yet in production.

That is the most honest line in the entire launch, and it is the one I would underline. A 99.8% pass on an existing suite is a benchmark result. It tells you the port reproduces the behaviour the old tests already described. Production is the behaviour nobody wrote a test for yet. The gap between those two is the gap this whole industry keeps tripping over. A loop that goes green is not a loop that is correct. It is a loop that satisfied the verifier you gave it. The quality of the output is capped by the quality of that verifier, and not one point higher.

## So what do you actually build

The mechanical parts are not exotic. A scheduled trigger to discover work and start the agent. Isolated git worktrees so parallel agents do not stand on each other's changes. Skills files so you are not re-explaining the project's conventions every run. Connectors to the tools the work already lives in. Separated generator and verifier roles, because an agent grading its own homework grades generously. And memory: the file that outlives the conversation and carries the lesson forward.

The native tooling has caught up to most of this. The documented features as of now are /goal, which holds a completion condition and keeps working across turns until it is met (added in v2.1.139), and dynamic workflows, where Claude writes an orchestration script that fans the work out across many parallel agents, on by default for some plans and gated behind ultracode and /config for others (research preview, v2.1.154+, capped at sixteen concurrent and a thousand agents per run). Both reduce the same thing: the back-and-forth of you instructing, checking, and instructing again.

Reach for them when the task genuinely does not fit one pass. They cost considerably more tokens than a normal session. Not every job is a workflow job, and dressing a small task up as one is its own kind of waste.

## The bottleneck moved

The skill being sold as loop engineering is real. It is just pointed at the wrong half of the system. Designing the orchestration is the easy part now, and the tools do most of it for you. The part that is still hard, still manual, and still where the results actually come from is the evaluation gate. What does the agent check. Against what. How does a failure get caught before it propagates. What gets written down so the next run starts ahead of this one.

Management in the age of agents is not about hiring capable workers. The workers are capable and cheap. It is about designing the constraints they run inside, the same as it always was with people.

Design the verifier, not the prompt.

Sources: Boris Cherny's remarks, Fortune Brainstorm Tech (June 2026). Dynamic workflows and the Bun port, Anthropic's "Introducing dynamic workflows in Claude Code" and the Claude Code docs. ReAct (Yao et al., Princeton and Google). Reflexion (Shinn et al.). The five-components-plus-memory framing follows Addy Osmani's writing on agent loops.
