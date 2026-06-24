---
title: "all roads lead to cloud agents"
type: source
source: "Clippings/all roads lead to cloud agents.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [concurso, source-page]
---

## Tese central
---
title: "all roads lead to cloud agents"
source: "
author:
  - "[[@justinsunyt]]"
published: 2026-06-23
created: 2026-06-23
description: "stage 1: the laptop lidyou've seen the trend of developers running around with their laptops open to keep their agents running:Cormac@cormac..."
tags:
  - "clippings"
---


## stage 1: the laptop lid

you've seen the trend of developers running around with their laptops open to keep their agents running:

> May 2
> 
> software engineers before vs after agen

## Argumentos principais
### stage 1: the laptop lid
you've seen the trend of developers running around with their laptops open to keep their agents running:
> May 2
>

### stage 2: loops
loops have been all the rage recently:
> Jun 18
>

### stage 3: towards usefulness
cloud agents with VMs unlock a scale of engineering and productivity that simply isn't possible on local machines. surprisingly, that scale is only half of what changes when the agent moves into the cloud.
local agents inherit the interface of the machine they run on. you open a terminal or IDE, start the process, give it instructions and wait for it to finish. even if you remote into that machine from your phone, you are still operating a terminal process from somewhere else.
there are two ways to move an agent into the cloud. the simplest is to place the entire local setup inside a remote sandbox: the agent harness, its session, the filesystem and all of its tools. this gets the process off your laptop, but preserves the same basic relationship. the agent still lives inside one machine. cloud agents can be built differently. the harness can live outside the sandbox, alongside a durable record of the session. in a [recent blog](), anthropic described this as “decoupling the brain from the hands" - the sandbox can be provisioned, replaced or discarded like any other tool. this separation also means the terminal no longer has to be the entry point to the agent. a slack message, github issue, schedule, CI failure, or production alert can all trigger the same agent loop. the control plane, placed in a separate server, can gather the relevant context, provision a VM when one is needed, and return the result to anywhere the agent desires.

### stage 4: what's next
most cloud agents still preserve the "one agent = one machine" mantra inherited from local coding tools. moving the harness and session outside the sandbox breaks that relationship. the agent can continue reasoning while machines are provisioned, stopped or replaced. it can perform work that does not require a filesystem immediately, then acquire an execution environment when the task reaches that point.
but that already happens today. imagine if an agent could get access to many machines over the course of a session. a coding task might begin on a standard Linux environment, move to a larger machine for a heavy build, use macOS to compile an iOS app, open windows to reproduce a platform-specific bug, or attach a GPU for inference. the operating system and hardware become choices made for a particular step rather than permanent properties of the agent running the task.
this separation becomes more important when agents delegate and replicate in loops. a parent agent can divide a problem among several children subagents, with each child receiving its own context and execution environment. there is no reason for those children to share one oversized machine or even the same operating system. each can acquire the environment its work requires and snapshot it when finished - machine lifecycles stay ephemeral while machine state persists.


## Key insights
- more importantly, every agent is sharing the same CPU, memory, filesystem, ports, and services.
- Spoiler: loops are really powerful

an example of a loop is a recurring heartbeat that wakes an orchestrator agent to scan issues/PRs, triage them, spin up worker threads/sub-agents for fixes/reviews - all without human input.
- the natural architecture is one isolated computer per agent, each with its own copy of the codebase.
- surprisingly, that scale is only half of what changes when the agent moves into the cloud.
- there are two ways to move an agent into the cloud.
- the simplest is to place the entire local setup inside a remote sandbox: the agent harness, its session, the filesystem and all of its tools.
- the agent still lives inside one machine.
- this separation also means the terminal no longer has to be the entry point to the agent.
- a slack message, github issue, schedule, CI failure, or production alert can all trigger the same agent loop.
- the control plane, placed in a separate server, can gather the relevant context, provision a VM when one is needed, and return the result to anywhere the agent desires.

## Exemplos e evidências
See original source at `Clippings/all roads lead to cloud agents.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/Codex]]
