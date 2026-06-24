---
title: "10T tokens. 10× lower token costs."
source: "https://x.com/rox_ai/status/2068729552726274288"
author:
  - "[[@rox_ai]]"
published: 2026-06-21
created: 2026-06-22
description: "How we cut token spend by 10x while scaling usage up 10x.Right now, most AI companies are tokenmaxxing on frontier models.It’s getting bru..."
tags:
  - "clippings"
---
![Image](https://pbs.twimg.com/media/HLUo8v5bMAAM8Nc?format=jpg&name=large)

How we cut token spend by 10x while scaling usage up 10x. Right now, most AI companies are tokenmaxxing on frontier models.

It’s getting brutally expensive, and the rebel alliance of applied AI teams is getting margins crushed by inference costs (at least for now).

At Rox, we started treating cost per action as a first-class production metric for the engineering team, similar to latency and error rate.

## The DOPA Framework

We named it **DOPA** (Dollar Per Action).

DOPA = token cost ÷ work delivered.

In our case, an action is a unit of real customer value (ex: an agent-drafted email or enriched account). Cutting tokens per action is the whole game.

## How We Achieved 10x Reduction

Here’s how we drove DOPA down **~10x from its peak** while increasing action volume:

- CI gates catch the cost and quality regressions in our own changes before they ship.
- Runtime alerts catch what comes from outside (ex: a provider raising a rate or one customer spiking)
- Continuous evals score every model on price for performance and quality. So, a request moves to a smaller model only after the downgrade clears the same bar.

The biggest unlocks were:

1. Rebuilding the agentic search stack in-house. Search was the single largest token sink, and we cut off that cost by owning search.
2. Unit change. When we run open models on our own fleet, throughput stops being the cost and GPU hours become it, so we optimize utilization rather than tokens per second.

The remainder of the 10x reduction came from:

- Steady maintenance
- Swapping harnesses
- Taming agent sprawl
- Preprocessing context in cheaper models so anything that hit frontier models is minimal

## While the World Tokenmaxxes

In an applied AI company, the cost of an action will change often. It changes whenever a provider changes a price, a new open model ships, a routing change happens, a customer spikes, or a unit cost changes between deployments.

If you treat DOPA as a finance number, it stays hidden until margins are already damaged.

However, if you treat it as a production signal with engineering rigor like any other SLO - you can deliver frontier-level performance at 10x better economics.

As with any metric, we are continuously investing in bringing it down.

While the world tokenmaxxes, Rox will deliver ROI and handle all the underlying nuances for our customers.

Thanks to the nightwatch / DOPA warriors who track and tame this beast! Pranav Pusarla, [@gopalkgoel1](https://x.com/@gopalkgoel1), [@taeukkang](https://x.com/@taeukkang), [@santhoshkumarml](https://x.com/@santhoshkumarml), [@sanchit23082000](https://x.com/@sanchit23082000), [@AksharSarvesh](https://x.com/@AksharSarvesh), [@XuBriGuy](https://x.com/@XuBriGuy) , and the entire elite Applied AI Research talent at Rox. (PS we're hiring!)