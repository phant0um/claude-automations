---
title: "Stop overloading your skills"
type: source
source: "Clippings/Stop overloading your skills.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Stop overloading your skills"
source: "
author:
  - "[[Waldek Mastykarz]]"
published: 2026-06-18
created: 2026-06-23
description: "You built a skill for your technology. API references, authentication flows, SDK patterns, error handling, version info, all packed into one skill. The"
tags:
  - "clippings"
---
You built a skill for your technology.

## Argumentos principais
### It already knows Copy link
Models have ingested your documentation, your Stack Overflow answers, your GitHub repos, your blog posts. The default imports, the standard auth flow, the common CRUD operations: the model already has all of that baked in.
When your skill repeats what the model already knows, you’re not helping, you’re adding weight. Every token your skill returns occupies space in a finite context window, and those tokens aren’t neutral. They [push out the stuff the model *doesn’t* know](): workspace files, conversation history, or output from other tools.
Most skills suffer from the same problem. Stuffed with thousands of tokens of documentation, called by the agent, payload returned, and outcomes don’t improve. Sometimes they get worse, because the skill is doing work the model didn’t need help with.

### How do you know what the model knows? Copy link
You don’t, unless you measure. And most folks skip this step entirely. They go straight from “we have a technology” to “we need a skill” without checking what the model does on its own.
*What if the model already generates correct code for your API 90% of the time?* Then you need a [lightweight skill that covers the remaining 10%](): the auth quirk that trips people up, the breaking change that’s too recent for training data, the configuration pattern that looks like nothing else on the web. You can’t know which 10% to target if you haven’t measured the baseline.

### Measure first, build second Copy link
Start by running your scenarios without the skill. Same model, same harness, same prompts. See what the agent gets right and what it gets wrong, because *that’s* your baseline.
If the model handles CRUD correctly, don’t put CRUD examples in your skill. If auth flows work out of the box, don’t include your auth guide. If it picks the right SDK version, don’t waste tokens telling it which version to use.
What’s left after you subtract the baseline? The patterns the model gets wrong or doesn’t know about at all. **That’s your skill’s scope.** Nothing more.

### Every unnecessary token is drag Copy link
Context windows have a fixed budget. A skill that returns 3,000 tokens of documentation the model already knows is burning context that could hold the developer’s workspace files, conversation thread, or output from another tool the model needs.
It gets worse when skills compose. Your developers have other skills installed, and each one claims tokens just by being present. Your oversized skill isn’t just dragging its own scenarios, it’s eating into the budget other skills need. You’re not just hurting your outcomes, you’re contributing to [everyone else’s drag]().

### The lean skill Copy link
1. Define scenarios: the tasks developers actually ask agents to do with your technology.
2. Run them without your skill, and score the outcomes.
3. Identify where the model fails: those failures are your scope.


## Key insights
- "[[Waldek Mastykarz]]"
- The agent calls it, gets all that context, and generates code.
- The default imports, the standard auth flow, the common CRUD operations: the model already has all of that baked in.
- When your skill repeats what the model already knows, you’re not helping, you’re adding weight.
- They [push out the stuff the model *doesn’t* know](): workspace files, conversation history, or output from other tools.
- Stuffed with thousands of tokens of documentation, called by the agent, payload returned, and outcomes don’t improve.
- Sometimes they get worse, because the skill is doing work the model didn’t need help with.
- They go straight from “we have a technology” to “we need a skill” without checking what the model does on its own.
- See what the agent gets right and what it gets wrong, because *that’s* your baseline.
- If the model handles CRUD correctly, don’t put CRUD examples in your skill.

## Exemplos e evidências
See original source at `Clippings/Stop overloading your skills.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]]
