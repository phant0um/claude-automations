---
title: "I Spent a Week Inside AI Loops. Prompting Is Dead. Here Is What Replaced It."
source: "https://x.com/DamiDefi/status/2069001369697079431"
author:
  - "[[@DamiDefi]]"
published: 2026-06-22
created: 2026-06-22
description: "The Best AI Engineers Stopped Prompting. They Started Building Loops. Here Is the Difference.Most people using AI every day are still doing ..."
tags:
  - "clippings"
---
![Image](https://pbs.twimg.com/media/HLX9byvXUAA2aBw?format=jpg&name=large)

The Best AI Engineers Stopped Prompting. They Started Building Loops. Here Is the Difference.

Most people using AI every day are still doing it the slowest way possible.

Type a request. Wait. Fix it. Ask again. Repeat manually for every single step. Not because the faster way is complicated. Because nobody actually explained what it looks like.

The faster way is a loop. Right now it is the single thing the best AI engineers in the world are obsessing over. Here is what nobody explains properly: what a loop actually is, how it works under the hood, when it is worth building and when it is a trap, how to run one yourself in Claude or ChatGPT today, and the version that requires zero code for everyday use.

## Why the One-Request-at-a-Time Habit Has a Ceiling

Every step in a normal AI session runs through you. You decide what to ask. You judge the answer. You decide what comes next. The AI never moves unless you push it, and the moment you stop, it stops.

You are the engine. The AI is the tool in your hand. A tool does nothing on its own.

There is another way to work. Instead of walking the AI through every step, you give it the goal once and let it run the steps itself. It plans, does the work, checks its own result, fixes what is weak, and repeats until the goal is actually met. You step out. The work keeps going.

Peter Steinberger put it bluntly on X:

> "Here's your monthly reminder that you shouldn't be prompting coding agents anymore. You should be designing loops that prompt your agents."

Most people read a line like that and have no idea what it means in practice. Here is the actual breakdown.

## What a Loop Actually Is

A prompt is a single instruction. A loop is a goal the AI keeps working toward until it gets there. Think of it as a recursive goal: you define a purpose, and the AI iterates until it is complete.

A prompt gives you one answer and waits for you to decide what is next. A loop runs the full cycle on its own:

- **Discover** — work out what needs doing
- **Plan** — decide how to do it
- **Execute** — do the work
- **Verify** — check it against the goal
- **Iterate** — not there yet? Feed the result back in and repeat

Three of these five steps do all the real work, and they are where people get loops wrong.

**Verify is the heart of the loop.** Without a real check on the result, you do not have a loop. You have the agent agreeing with itself on repeat. The check can be a hard test, a measurable condition, or a rubric the model scores against. No gate means the agent grades its own homework, and the model that did the work is far too generous a grader.

**State is what makes the loop learn.** Each pass, the AI has to remember what it already tried, or it repeats the same mistake forever. A real loop keeps a small record on the side: what is done, what failed, what is next. Tomorrow's run resumes instead of starting from zero. This is also exactly where the cost starts climbing, which matters later.

**A stop condition is what keeps it sane.** A loop with no exit runs until it succeeds, breaks, or drains your account. Every serious loop has two ways to stop: success, and a hard limit like "after 8 tries, stop and report." Skip this and you have built a machine that runs all night for nothing.

A prompt hands the AI an instruction. A loop hands the AI a job, a way to know when the job is done, and a rule for when to give up.

## Do You Even Need One

Most explanations sell you the loop before telling you when it is a mistake. Here is the test serious builders actually use. A loop is worth building only when all four of these are true:

1. **The task repeats, at least weekly.** Less than that and the setup cost never pays itself back. A one-off is still better served by one good prompt.
2. **Something can automatically reject bad output.** A test, a type check, a build, a linter, a hard rule. If nothing can fail the work for you, the loop just spins.
3. **The agent can do the work end to end**, not hand half of it back to you.
4. **"Done" is objective, not a judgment call.** If quality is a matter of taste, a human still wins.

Miss one of the four, keep it as a manual prompt. Loop engineering is real, but most people do not need the heavy version yet. The light version, which we get to below, is what nearly everyone can actually use.

## The Version Built for Code

Loops took off in software first because code is the easiest thing in the world to verify. A test passes or it fails. There is no arguing with it, so the AI always knows whether it is actually finished.

A coding loop is given a goal and a strict way to check it:

**Loop Spec**

> GOAL: every test in /tests/auth passes, lint is clean, no type errors.EACH ITERATION: 1. run the test suite and read every failure 2. pick the single highest-impact failure 3. write the smallest change that fixes it 4. re-run the tests, lint, and type checkerVERIFY: green tests + zero lint warnings + zero type errors STOP WHEN: verify passes, OR 8 iterations reached ON STOP: summarise what changed and what still fails

A real loop is assembled from five building blocks. Claude Code and Codex now ship all five natively.

**1\. The automation (the heartbeat).** This is what makes it a loop and not a one-off. You define a prompt, a cadence, and a goal, and it runs on schedule without you starting it manually. In Claude Code, /loop re-runs a prompt on an interval, /goal keeps a session going until a condition you wrote becomes true, hooks fire commands at points in the agent's lifecycle, and pushing it to a cron job or GitHub Actions keeps it running after you close the laptop.

**2\. The skill (reusable instructions).** Instead of pasting a wall of instructions into every run, you save them once as a file the loop reads every time: the rules, the patterns to follow, a hard list of what it must never touch. The automation calls the skill by name and the recurring job stays maintainable.

**3\. Sub-agents (keep the maker away from the checker).** The single most useful structural trick in a loop is splitting the agent that does the work from the agent that checks it. The model that wrote the code is too generous grading its own homework. A second agent, with different instructions and sometimes a stronger model on higher effort, catches what the first one talked itself into. Writer fast and cheap, reviewer slow and strict. That separation is most of the quality.

**4\. Connectors (so it acts, not suggests).** The difference between an agent that says "here is the fix" and a loop that opens the pull request, links the ticket, and pings the channel once the build is green, by itself. Connectors let the loop act inside your real environment instead of describing what it would do.

**5\. The verifier (the gate).** The test, type check, or build that automatically rejects bad work. This is the one block that decides whether the loop helps you or just spends your money.

Stack all five together and you get what large teams now run at scale: fleets of agents looping on the same job, dozens or thousands at once. One engineer used this exact structure to rewrite an entire codebase from one programming language to another in roughly six days, work that would have taken close to a year by hand.

It comes with a catch the demos never show.

## The Cost Nobody Mentions

Loops run on tokens, and tokens are money. The problem is not that each step costs something. The problem is how the cost compounds.

Every time the loop goes around, the agent re-reads its context: the goal, the code, the last result, what failed. That entire pile gets sent through the model again on every iteration, and it grows each pass. A loop that runs ten times does not cost ten prompts. It costs ten prompts that each keep getting bigger. The maker-and-checker trick that lifts quality also doubles the bill, because now two models read the work instead of one.

**Rough cost of one loop:**

- Single agent, one medium task: 50,000 to 200,000 tokens
- Context re-sent every iteration: grows each pass
- A fleet of agents in parallel: multiply all of the above

The metric that actually matters, and almost nobody tracks it, is cost per accepted change. Not tokens spent. Not loops run. If the loop gives you ten results and you toss six, you are doing the review work it was meant to save you. Below a 50% accept rate, it costs more than it gives back.

Loops also fail quietly. Engineer Geoffrey Huntley calls it the "Ralph Wiggum loop": the agent decides it is done too early, exits on a half-finished job, and the loop keeps running and spending while producing nothing useful. Without a hard gate that can actually fail the work, loops do not crash. They bill you in silence.

The heavy version belongs to teams with the budget and the guardrails to run it: iteration caps, token budgets, cheap models on the boring steps, monitoring. If that is not you, you are not missing out. The core idea works at a fraction of the cost and none of the setup, which is what the rest of this article is about.

## The Order That Actually Works

If you build one, the order matters more than the tools. The people who ship loops that survive in production all do it the same way:

1. Get one manual run reliable first.
2. Turn that into a skill (save the instructions).
3. Wrap the skill in a loop (add the gate and the stop condition).
4. Then put it on a schedule.

Skipping ahead, scheduling something you have not made reliable by hand, is exactly how loops blow up while you sleep. Prove it once, harden it, then automate it.

## Build a Basic Loop Yourself, in Any LLM

You do not need a coding agent to feel how this works. You can run a simple loop by hand inside any LLM right now, with nothing but a prompt. The trick is giving the model all three loop parts at once: a goal, strict success criteria, and a protocol that forces it to check itself before it is allowed to stop.

**Self-Checking Loop**

> You will work in a loop until the task meets the bar.TASK: \[describe exactly what you want produced\]SUCCESS CRITERIA (be strict, no soft passes): - \[criterion 1\] - \[criterion 2\] - \[criterion 3\]LOOP PROTOCOL, repeat every turn: 1. PLAN - state the single next step. 2. DO - produce or improve the work. 3. VERIFY - score the result 1-10 on each criterion. Be brutally honest. List exactly what is still weak. 4. DECIDE - if every criterion is 8+, print "FINAL" and stop. Otherwise print "ITERATING" and go again, fixing the weakest point first.RULES: - Never call it done until every criterion is 8 or higher. - Each pass must fix the weakest score from the last VERIFY. - Do not ask me questions. Make a sensible assumption, note it, and keep going.Begin. Run the loop until FINAL.

Watch what happens. The model drafts, grades its own work against your criteria, finds the weak spot, and rewrites, over and over, until it actually clears the bar instead of handing you the first thing that looked close enough. That is a loop. You just built one with a paragraph.

But notice what is still missing, because it is the entire point of what comes next. You are the trigger. You opened the chat, pasted the prompt, and sat there watching it iterate. Close the tab and it is gone. No schedule. No "do this every morning." No "wake up when an email arrives." It cannot reach out to you, because it only exists while you are looking at it.

Getting a loop that runs on its own, on a schedule, triggered by real events, without you babysitting it, normally means stepping into the heavy world from earlier: tools, hosting, code, gates, a bill.

That makes sense for genuinely heavy tasks. For nearly everything else, there is a far simpler option.

## The Same Idea, for Your Actual Life

Strip away the code and the cost, and what is left is one useful concept: a task that runs itself, on a schedule or the moment something happens, with no need for you to remember it or be there.

You do not need to be an engineer for that. You need loops built for life instead of for codebases.

Mira lives inside Telegram, the app you probably already have open. You message it like a friend, and the loops it runs are called Skills. Every Skill quietly has the same parts a real loop needs, a trigger, an action, a way to run by itself, except you never wire any of it together. You just say what you want.

**Skill**

> "Every weekday at 7am, check my Gmail and Google Calendar. Send me a short brief: my 3 most important meetings, anything urgent in the inbox, and one thing I said I'd follow up on but haven't. Keep it under 120 words."

That is a real loop. A time trigger, a multi-step action across two connected apps, running on its own and coming to you. Written as one message.

## What Mira Can Actually Do

The difference from a standard chatbot is simple: ChatGPT answers, Mira acts. You do not ask it to write the email, you tell it to send the email. You do not get a draft ticket, you get a real one in Linear with the owner assigned. It does the thing, in the background, and remembers you across every conversation.

It connects to 800+ apps through Composio, Notion, Gmail, Google Calendar, GitHub, Figma, Stripe, and hundreds more. It has long-term memory that holds across sessions and group chats. It is model-agnostic, running GPT, Claude, and Gemini depending on the task.

**Two honest things to know before connecting anything sensitive.**

First, cost. Mira does not currently publish a stated usage cap or a paid tier breakdown. It is free to start and free to use for the examples in this article. There is no published ceiling to plan a budget against, which cuts both ways: nothing to calculate up front, but also nothing to point to if usage patterns change later. Treat it as free until you personally hit a wall, not as free with a known limit.

Second, data. Connecting Gmail, Calendar, Linear, or Stripe to a Telegram bot means a third-party service can read and act on that data, not just view it. Mira's answer to this is Private Mode: sensitive requests route through Cocoon, a confidential compute network that processes them inside a Trusted Execution Environment rather than standard infrastructure. That is a real architectural answer, not a marketing line, but it is still worth knowing exactly which Skills you are running in Private Mode versus standard mode before you connect anything you would not want a standard cloud service to see.

**If you already run N8N, here is the honest comparison.**

If you have built any of the automations elsewhere in this series, the natural question is why use Mira instead of just adding another N8N workflow. The honest answer: different tradeoffs, not a strictly better or worse option.

N8N gives you full control, your own hosting, no per-message dependency on a third party, and direct access to the same Claude API key you are already using everywhere else. The cost is setup time. Every workflow is nodes you configure yourself.

Mira gives you zero setup. You type a sentence and the loop exists. The cost is that you are inside someone else's infrastructure, with someone else's model routing and someone else's uptime.

The practical split: N8N for anything tied to your research vault, your Claude Projects, or anything where you want the workflow itself to be inspectable and owned by you. Mira for the everyday personal loops, the 7am brief, the calorie photo, the flight watcher, where the value is speed of setup and you do not need to see the wiring.

**For work:**

**Skills**

> "An hour before each meeting, remind me with the context and decisions from our last conversation with that person.""When I forward a message here, turn it into a Linear ticket with the right priority and assign the owner.""Every Friday at 4pm, collect the team's task status and metrics and post a clean weekly digest in our chat.""Summarise everything I missed in this group chat while I was away, in 5 bullets."

It catches you up on a 200-message thread in seconds, files the ticket while you keep talking, and walks into meetings already briefed. In group chats it remembers the team's decisions, not just yours.

**For creators:**

**Skills**

> "I'll send a voice note with a raw idea. Turn it into a finished post with a caption and hashtags.""Take this one idea and write versions for X, Instagram, LinkedIn, Email, and a newsletter, each in the right format.""Generate 3 image options for this post.""Turn this image into a short video for my Telegram channel."

Voice note in, finished post out in roughly thirty seconds. One brief becomes six platform-native versions. It generates images and video directly in the chat, edits photos, swaps backgrounds, builds avatars, even animates them.

**For voice:**

**Skills**

> "Transcribe my voice messages into clean text.""Read this article back to me as audio.""Summarise the voice notes in this group chat into key points."

**For your life:**

**Skills**

> "Every evening at 7, ask if I trained today. Keep a streak and don't let me quietly skip more than one day.""Every night, ask me 3 questions about my day, remember the answers, and once a week tell me what changed.""Track my calories from a photo of my plate.""Watch this flight route and buy when the price drops to my number.""Every morning, give me a no-clickbait news digest on my topics."

A coach that holds you to a streak. A journal that actually remembers you and becomes a check-in companion over time. Calorie tracking from a photo, no separate app. A flight watcher that buys when the price is right. A daily digest with the clickbait stripped out.

## Where to Start

Twenty example Skills across four categories is too many to build at once. Start with one, and pick it by what it costs you if it fails.

**Build the morning brief first.** It is low stakes if the format needs adjusting, it runs daily so you get fast feedback on whether the system actually works for you, and it is the closest analogue to the daily synthesis brief already covered elsewhere in this series. If it works, everything else on the list becomes an easy yes. If the timing or format is off, you find out within 24 hours, not a week.

**Add the inbox or chat summarizer second.** Immediate, obvious value with almost no setup risk.

**Save anything touching money, Stripe, flight purchases, financial tracking, for last**, after you have a feel for how the system behaves and whether you trust it with something that has consequences if it gets it wrong.

## How to Start in Two Minutes

Open Telegram. Go to Mira. Send it a message. Free access works immediately.

**Setup**

> [@mira](https://x.com/@mira), plan my week [@mira](https://x.com/@mira), summarize this chat [@mira](https://x.com/@mira), remind me to review PRs every Monday at 9am [@mira](https://x.com/@mira), write a post about \[topic\] for X and Instagram

Any example in this article becomes a running loop the moment you type it.

**Two practical things worth testing in your first week.**

What happens when a Skill fails. The coding loop section earlier in this article is explicit about failure: hard gates, stop conditions, the Ralph Wiggum loop where an agent quietly exits a half-finished job. Mira does not publish detailed documentation on how each Skill handles a failure case, a missed API call, a Gmail auth token expiring, a Linear connection dropping. The practical fix: for the first week, treat every Skill as unverified. Check that the 7am brief actually arrived. Check that the ticket actually got created. Once you have seen a Skill run reliably for several cycles, you can trust it the way you trust the N8N automations you have already hardened elsewhere.

How to adjust a Skill once it is running. None of the public documentation describes a dedicated edit flow. The most reliable approach in a conversational system like this is to message Mira directly with the change: "update the 7am brief to under 80 words" rather than trying to find a settings panel. Treat every Skill as a living instruction you can redirect by talking to it again, not a fixed configuration you have to tear down and rebuild.

## What This Actually Means

Loops are not a trend. They are a shift in who does the work. The AI stops waiting for you to push it through every step and starts running the whole job on its own.

This is not something to chase or force into places it does not belong. More often than not, forcing a loop where a single prompt would do just burns money for nothing.

Start with what is already free. Only once that genuinely stops being enough should you start thinking about what the heavier version actually requires.

Follow [@damidefi](https://x.com/@damidefi) on X for daily Claude AI tools, crypto analysis, and the full journey to 100K. Bookmark this. Share it with one person still typing the same request into a chat box every single morning.