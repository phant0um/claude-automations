---
title: "Hermes Analyst 10x Better"
type: source
category: ai-agents-harness
source: "https://x.com/0xJeff/status/2066883577141428563"
created: 2026-06-16
ingested: 2026-06-16
tags: [hermes, analyst, product-update, ui-ux]
---

# Hermes Analyst 10x Better

## Tese Central

Hermes Analyst 10x improvement: UI/UX drastically improved, agent configuration simplified, research capability enhanced - making the agent analyst workflow accessible and powerful.

---

## Conteudo Original

![Image](https://pbs.twimg.com/media/HK8K-qOakAATPWF?format=jpg&name=large)

Hermes Analyst just got **10x better** — the UI/UX drastically improved + configuring the agent has never been easier + research capability is better thanks to nested orchestrator feature

In the past 2 weeks, [@NousResearch](https://x.com/@NousResearch) team has shipped a lot of cool stuff

- Hermes Windows
- Hermes Desktop
- Agent profiles
- Asynchronous sub-agent
- Nested orchestrator
- Native agentic commerce integration with [@stripe](https://x.com/@stripe)
- Rich text/outputs on Telegram

And probably a whole lot more that I missed out.

In this article, I’ll quickly go through what I’m most excited about on the changes + my experience of using Hermes after the last round of patch updates

> **tl;dr** -> it’s 10x smoother, props to Nous team

I’ve been using Hermes on WSL2 on Windows which hasn’t been ideal — accessing files on Linux was complicated, sometimes the agent would drop the file in places that were hard to access, sometimes it’d do things on Linux that wouldn’t surface on Windows.

And so **Hermes** **Windows + Hermes Desktop** came at a right time and the migration was simple

- “hermes backup” on Ubuntu
- install Hermes Desktop by downloading .exe client on Nous site
- and then “hermes import”

Everything was ported over (except agentcash x402 wallet + Hindsight data which I had to manually migrate) but all in all pretty seamless migration.

## Hermes Desktop - Designed for Everyone

![Image](https://pbs.twimg.com/media/HK8LCpIaoAAvQ5W?format=png&name=large)

Hermes Desktop is a desktop UI that’s designed to be a headquarter of using Hermes. ChatGPT/Claude-like interface with rich visuals, chain of thoughts, tables, the outputs all of which are shown in a paginated manner now (vs. just simple texts).

This makes it a lot easier to go through the outputs than before.

It’s also easier to check & configure skills, messaging apps, cron jobs, models, different agent profiles via Hermes Desktop instead of having to manually go to .env or config.yaml to adjust things.

![Image](https://pbs.twimg.com/media/HK8LFH0bQAAhZ6i?format=png&name=large)

Given the recent Fable 5 ban + OpenRouter Fusion (where a combination of open models can achieve Fable 5-level of intelligence), there’s a lot better R/R in tinkering with Hermes now.

More higher quality workflows that can offload your tasks thanks to better harness/toolkits & models powering them.

## Hermes Research Capability just got 10x better

If you’ve been following my Hermes Analyst series, you might remember the Deep Research Pipeline, a skill I created for Hermes to do a structured deep research better.

The challenge with that was, the agent does the entire research step-by-step, waiting for one thing to finish before starting another. This is ok but when the pipeline expanded and many tools get wired into it, it became difficult for the agent to stick to all the tools. The result? Hermes skipped a few tools and the output degraded in quality.

“**Skill bundling**” (i.e. let sub agents batch skills and execute them in parallel) does help ensure that the agent doesn’t skip a tool. BUT.... there’s a way to do this better with much better research output.

Nous Research just released a feature called “**Nested Orchestrator**“

This is a feature where Hermes spawns

- 1 Orchestrator sub-agent (or more)
- The orchestrator then spawns 3 worker (leaf agents) to do complex work

Depending on how complex the task is, more orchestrators can be run concurrently, managing more leaf agents.

![Image](https://pbs.twimg.com/media/HK8LHIra4AAjPT_?format=png&name=large)

The result = orchestrator cross-pollinate sources from leaf agents, synthesize the insights and the delta, resulting in better outputs.

You could probably see the difference in the outputs below (the right is a lot richer and more detailed than the left)

![Image](https://pbs.twimg.com/media/HK8LI6-aAAA8gCb?format=png&name=large)

## What’s Next?

I’m super excited to use Telegram to do quick query with Hermes now since rich text messages are enabled.

Met many cool teams during SuperAI and got a list of cool repos/tools I need to catch up and experiment on. Will be testing them out this week and share the use cases with you guys in the next episode.

For now, I’ll continue running structured research pipeline with the nested orchestrators to get up to speed and macro, geopolitics, equities, crypto, and more.

If you want to learn more about Hermes + how to train him to become an ultimate analyst - feel free to check out last week's article

> Jun 1

Thanks for reading and see you in the next one!
