---
title: "Masterclass AI Skills (Full Guide with Prompts)"
type: source
category: skills-prompting-mcp
source: "https://x.com/zaimiri/status/2066816324936904903"
created: 2026-06-16
ingested: 2026-06-16
tags: [ai-skills, guide, prompts, framework]
---

# Masterclass AI Skills (Full Guide with Prompts)

## Tese Central

AI Skills masterclass: skills are composable, repeatable workflows that go beyond single prompts. The guide provides full prompts for building production-grade skill systems.

---

## Conteudo Original

![Image](https://pbs.twimg.com/media/HK2fD_IWEAAwlQc?format=jpg&name=large)

What are AI Skills?

How do you use them?

Can they really change your life? (yes, they can)

Most people are still using AI like a chatbox.

Open a new conversation.

Paste the same context.

Explain the same rules.

Correct the same mistakes.

Ask for the same output.

Then do it again tomorrow.

That is fine when you are experimenting.

It is a terrible way to run repeated work.

The next jump is not a better prompt library.

It is **skills**.

An AI skill is a reusable procedure your agent can load when a task matches.

Not one magic prompt.

Not a personality preset.

Not a folder of vague instructions.

A real skill tells the agent:

- when to use it
- what inputs it needs
- what steps to follow
- what tools or files matter
- what examples to copy
- what mistakes to avoid
- how to verify the result

That sounds small.

It changes the entire shape of AI work.

## Prompt vs skill vs agent

Keep these layers clean:

```text
Prompt = ask once
Skill = repeat reliably
Agent = choose and execute workflows
```

A prompt is a one-off instruction.

“Summarize this article.”

A skill is the repeatable method behind the instruction.

“Turn a long AI article into a source-backed Zaimiri post, pick the angle, preserve the claim, remove AI slop, and create a review draft.”

An agent is the system that can decide which skill to load, use tools, read files, call APIs, write drafts, run checks, and come back with the result.

Most people are trying to solve agent problems with prompt files.

That is why their AI setup keeps resetting.

## What actually goes inside a skill

A useful skill is usually plain text.

The power is not the format.

The power is that the workflow is written down where the agent can find it.

A simple skill usually needs seven parts:

1. Trigger
2. Inputs
3. Steps
4. Examples
5. Tools or files
6. Failure modes
7. Verification

The trigger tells the agent when the skill should load.

**Bad trigger:**

```text
Use for writing.
```

**Better trigger:**

```text
Use when turning a technical AI announcement into a Zaimiri quote post. Verify the source, explain the mechanism, write one useful angle, and create a draft-only Typefully review post.
```

The second version gives the agent a lane.

It knows the task.

It knows the boundary.

It knows the output.

It knows what not to do.

That is the difference between a prompt and a reusable operating procedure.

## Bad skill vs good skill

**Bad skill:**

```text
Write better tweets.
Make it viral.
Sound human.
```

This is not a workflow.

It is a wish.

**Good skill:**

```text
Use when zaimiri sends an AI product announcement for @zaimiri.

1. Read the source.
2. Identify the actual mechanism.
3. Ignore hype claims unless the source supports them.
4. Pick one of three structures:
   - personal receipt
   - feature → before/after
   - mechanism breakdown
5. Draft in Hana voice.
6. Remove AI-slop phrases.
7. Create a Typefully review draft only.
8. Verify it is not scheduled or published.
```

Now the agent has a job.

It is not guessing your taste from scratch.

## Why skills compound

Skills are where your taste becomes reusable.

Every correction can become part of the system.

If the agent writes in a style you hate, update the skill.

If it forgets a source rule, update the skill.

If a command breaks, update the skill.

If a client workflow changes, update the skill.

This is the part most people miss.

The skill is not only a setup file.

It is a place to store operational memory without turning your main memory into a junk drawer.

Memory should remember stable facts.

Skills should remember procedures.

**Examples:**

```text
Memory: zaimiri prefers concise Telegram receipts.
Skill: When creating a Zaimiri article, route to Typefully draft-only, run slop lint, and create a native X Article HTML helper.
```

The first is a preference.

The second is a workflow.

If you mix them, your AI becomes messy.

If you separate them, your system starts compounding.

## The first skill you should build

Do not start with ten abstract skills.

Start with one annoying repeated task.

Pick something you have already explained to AI at least three times.

Good first skills are boring:

- turn a voice memo into tasks
- review a pull request
- research a new market
- rewrite a post in your voice
- summarize a customer call
- screen a sponsor offer
- turn a link into a useful brief

The boring ones work because they have clear inputs and outputs.

**Use this test:**

```text
If you paste the same prompt twice, it probably wants to become a skill.
```

**How to build one.**

Start with this template:

```text
---
name: research-brief
description: Use when turning a topic, link, or rough question into a source-backed research brief. Return recommendation, source facts, caveats, and next action. Do not use for final public copy.
---

# Research Brief

## When to use
Use this for source discovery, decision briefs, or topic research.

## Inputs
- Topic, link, or question
- Audience
- Required sources or exclusions
- Desired output format

## Steps
1. Restate the decision the research should support.
2. Find primary sources first.
3. Use social posts as signal, not proof.
4. Separate facts from inference.
5. Return a short brief with links and caveats.

## Output
- Recommendation
- Source-backed facts
- Caveats
- Next action

## Failure modes
- Do not invent source claims.
- Do not bury the answer under raw links.
- Do not write final public copy unless asked.

## Verification
- Important links were checked.
- Claims are supported.
- The next action is obvious.
```

This is enough for a first version.

Do not overbuild it.

The point is to make the agent more reliable on one repeated job.

Then patch the skill every time it fails.

## The folder structure

A skill is usually a small folder.

```text
research-brief/
  SKILL.md
  references/
    source-quality.md
    output-format.md
  scripts/
    fetch_sources.py
  assets/
    brief-template.md
```

\`SKILL.md\` is the main procedure.

\`references/\` is for judgment the agent should keep nearby:

- voice rules
- source rules
- examples
- rubrics
- edge cases

\`scripts/\` is for deterministic work:

- fetch sources
- parse files
- dedupe links
- validate output
- compare snapshots

Use the model for judgment.

Use scripts for mechanics.

This is one of the easiest ways to make AI agents less flaky.

## How agents decide to use a skill

This is why the description matters so much.

Many agents see the skill name and description before they load the full instructions.

If the description is vague, the agent misses the skill.

**Bad:**

```text
description: Helps with research.
```

**Better:**

```text
description: Use when turning a topic, link, or rough question into a source-backed research brief. Return recommendation, source facts, caveats, and next action. Do not use for final public copy.
```

That one line does a lot of work.

It tells the agent:

- the trigger
- the input
- the output
- the boundary

A good description is the routing layer.

## Testing the skill

A skill is not done when the file exists.

It is done when the agent uses it correctly.

Run four tests.

1\. Explicit trigger

```text
Use the research-brief skill on this topic: <topic>
```

Check if it follows the steps.

2\. Natural trigger

```text
Can you turn this rough question into a source-backed decision brief?
```

If the agent misses the skill, tighten the description.

3\. Over-trigger test

```text
Write final public copy from this research.
```

If the research skill fires, add an exclusion.

4\. Output check

Verify the output has the required sections, caveats, and next action.

This is how skills get sharp.

Not by writing a huge manual once.

By using them, watching the failure, and patching the procedure.

## Where skills get really useful

A single skill is useful.

A library of good skills becomes an operating layer.

Skills + memory

The agent remembers stable preferences and loads the right procedures.

Skills + tools

The agent can follow the procedure and actually do the work: search, read files, call APIs, write drafts, run checks.

Skills + scheduled jobs

The agent can run the same workflow every morning, every week, or when a new source appears.

Skills + subagents

One agent can split work across specialist procedures: researcher, writer, reviewer, operator.

Skills + profiles

Different agents can have different skill libraries, memories, tools, and boundaries.

This is where AI stops feeling like one giant prompt.

It starts feeling like a team of small operating procedures.

## The real shift

Prompt libraries were the first version.

They helped people save useful instructions.

But prompts still depend on you remembering when to use them, where to paste them, what context to add, and how to check the result.

Skills move that burden into the system.

The agent can discover the procedure.

Load the instructions.

Use the examples.

Call the tools.

Run the checks.

Patch the workflow later.

That is why skills matter.

They turn AI from a clever autocomplete box into something closer to an operating system for repeated work.

Start with one skill.

One repeated task.

One clear trigger.

One output format.

One verification checklist.

Then let it compound.

**If you like AI Guides make sure to follow me** [@zaimiri](https://x.com/@zaimiri)
