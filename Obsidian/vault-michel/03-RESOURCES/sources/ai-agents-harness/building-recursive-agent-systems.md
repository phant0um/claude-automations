---
title: "Building recursive agent systems"
type: source
category: ai-agents-harness
source: "https://x.com/leerob/status/2065469795529588940"
created: 2026-06-16
ingested: 2026-06-16
tags: [ai-agents, recursive-agents, cursor, engineering]
---

# Building recursive agent systems

## Tese Central

Cursor runs thousands of recursive agents to train Composer: agents receive research tasks, and successful approaches feed back into the system, creating self-improving agent ecosystems.

---

## Conteudo Original

![Image](https://pbs.twimg.com/media/HKoEZz5WsAA9eAu?format=png&name=large)

At Cursor, we run thousands of agents to help us train the next version of Composer.

We give them research tasks, and if they aren't succeeding or run into issues, they DM us on Slack or page us via PagerDuty.

## Scaling training for Composer

We’ve built an org chart of agents that work together.

As we’ve scaled training for [Composer](https://cursor.com/blog/composer-2-5), we’ve wanted to run thousands more experiments. This was possible before, but it was slow and hard to keep track of every experiment’s status. To speed things up and parallelize work, we built an always-running agent system (yes, it's a loop).

## An agent system for research

Here’s how the system works:

1. The main agent runs on a massive remote machine with [all the tools you'd use](https://cursor.com/blog/agent-computer-use) locally, plus a file on disk acting as an “inbox” for the fleet.
2. It SSHes into machines running hundreds of child agents and collects their statuses into the inbox.
3. On every loop, it checks fleet health, keeps healthy tasks running in the background, and surfaces anything broken to the team on Slack.
4. Like all infra, the agents occasionally hit transient issues or need to be poked, so the main agent can control the whole fleet, quitting or restarting processes as needed.

![Image](https://pbs.twimg.com/media/HKoFkILXkAAy0mV?format=jpg&name=large)

This “fleet manager” builds on our previously published research on l[ong-running agents](https://cursor.com/blog/scaling-agents). We’ve given the manager many different [skills](https://x.com/leerob/status/2011810357942084085) that encode tacit knowledge for how to run ML experiments, review and monitor results, and more.

## Researchers with superpowers

Training a great model means trying a bunch of ideas for creating useful [RL](https://leerob.com/ai) data.

A single laptop is not enough here, you really want an army of computers in the cloud to run experiments in parallel. And since we aren't [compute-constrained](https://cursor.com/blog/spacex-model-training), we rolled out this infra for everyone in ML.

> May 18
> 
> Together with SpaceXAI, we’re training a significantly larger model from scratch, using 10x more total compute. With Colossus 2’s million H100-equivalents and our combined data and training techniques, we expect this to be a major leap in model capability.

Researcher time is our scarcest resource and we’ve found a way to scale their leverage by orders of magnitude. Imagine if you had a human manager with 10,000 direct reports. Obviously that wouldn’t work well, but this human → agent “org” kind of does!

If you have a problem that is verifiable, where throwing more tokens at it will solve it faster or better, it’s worth considering building a system like this. It’s enabled us to have [swarms of agents](https://cursor.com/blog/multi-agent-kernels) crawling through Composer’s data to [recursively improve itself](https://x.com/leerob/status/2065069068722241729) for future versions.

And if this sounds exciting, [we’re hiring](https://cursor.com/careers)!
