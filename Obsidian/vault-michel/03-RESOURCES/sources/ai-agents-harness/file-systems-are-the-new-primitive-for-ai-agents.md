---
title: "File systems are the new primitive for AI agents"
type: source
category: ai-agents-harness
source: "https://x.com/crtr0/status/2066558169741173177"
created: 2026-06-16
ingested: 2026-06-16
tags: [ai-agents, file-systems, architecture, primitives]
---

# File systems are the new primitive for AI agents

## Tese Central

File systems are replacing relational databases as the foundational primitive for AI agent architecture, offering simpler state management and natural agent-agent communication.

---

## Conteudo Original

![Image](https://pbs.twimg.com/media/HI743smaEAA0dri?format=jpg&name=large)

I started writing web software in 2000 at a dev shop in Washington, DC and everything was built on a foundation of a relational database and carefully designed schemas. That was the job. A customer had some requirements, and my brain immediately went: "Okay, what tables do we need and what custom interface do we need to build?"

Even today, I can't look a web application without thinking of the underlying data model.

![Image](https://pbs.twimg.com/media/HK3U1fFaoAARJOF?format=jpg&name=large)

IMDB screenshot and data model

But software is changing. Interfaces are turning into boxes that ask "What can I do for you?"

<video preload="auto" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/tweet_video_thumb/HI8HamragAA7AhD.jpg" src="https://video.twimg.com/tweet_video/HI8HamragAA7AhD.mp4" type="video/mp4" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"></video>

![](https://pbs.twimg.com/tweet_video_thumb/HI8HamragAA7AhD.jpg?name=large)

GIF

Captain Picard using the replicator to make some tea

Powering these new experiences are agents. And fast following are a litany of frameworks and tools hoping to be the next React for agents.

**Building memory for agents**

Taking a step back, let's talk about what a good read/write memory system for agents might look like. It needs to do a few things:

1. Retain facts across sessions
2. Retrieve facts selectively, because “just dump everything into the context window” stops working quickly
3. Update and correct itself over time, which rules out a lot of read-only approaches
4. Stay inspectable by humans, because LLMs are non-deterministic, and a black-box memory system is a debugging nightmare

If we were designing a memory system for agents, it's pretty natural to reach for things you already know like SQL, ORMs or APIs. I've built a lot of software this way.

**Teaching agents new tricks**

Agents can use SQL and data APIs, and sometimes they should. But those interfaces were designed for programs that already know exactly what they want. A web application calls GET /tasks/123 or runs a parameterized query because a developer has already turned user intent into a precise operation. Agents live one layer earlier in the process. They are still interpreting messy goals, partial context, ambiguous names, changing assumptions, and human corrections. Asking them to operate directly on normalized tables or narrowly scoped endpoints often means forcing them through an interface optimized for deterministic software, not exploratory reasoning.

That mismatch creates a lot of hidden work. You have to teach the agent the schema, the business rules, the relationships between objects, the safe mutations, the edge cases, and the difference between similar-looking fields. Then you have to keep that instruction up to date as the system changes. The agent may be capable of calling the API, but it spends valuable context and reasoning budget reconstructing the mental model that a human developer already had when they designed the API.

What if there was an API that agents have already been trained on, to the tune of trillions of tokens?

**LLMs already know how to use file systems**

Like, really know how to use them.

\`ls\`, \`cat\`, \`grep\`, \`cd\`, \`mkdir\`. Every engineer recognizes these instantly because this is how we learned to operate computers. And every LLM has been trained on a over 50 years of Unix/Linux man pages, Github repos and millions of documents explaining what these commands are, how they behave, and how to combine them.

That’s kind of mind-blowing when you think about it. Trillions of tokens training foundational LLMs about filesystems.

A file system checks all of the boxes for agent long-term memory. And once you see it, you start seeing files everywhere.

<video preload="auto" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/tweet_video_thumb/HI78t6kbkAAPm06.jpg" src="https://video.twimg.com/tweet_video/HI78t6kbkAAPm06.mp4" type="video/mp4" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"></video>

![](https://pbs.twimg.com/tweet_video_thumb/HI78t6kbkAAPm06.jpg?name=large)

GIF

A filesystem isn't a complete memory architecture, and I'm not going to pretend it is. But it's an unusually good substrate for the part of memory agents struggle with most: durable, inspectable, revisable working context. Files give the model names, paths, hierarchy, timestamps, permissions, diffs, and conventions it already knows how to reason about.

Once you notice this, you start seeing files everywhere. CLAUDE.md is just a markdown file. Agent skills are often a directory with a SKILL.md and some supporting files. Coding agents work by reading, editing, searching, and testing repositories. Agent platforms keep exposing file-like workspaces, mounted storage, and document collections as the places models do their work. That's not a coincidence.

I built a small demo to convince myself: a team-management agent backed by two markdown files in Box. One file was organized by team member:

```markdown
# Team

## Maya
- [ ] Draft onboarding checklist
- [x] Review Q3 metrics

## Luis
- [ ] Update customer rollout plan
```

```markdown
# Tasks

## Todo
- Draft onboarding checklist — Maya
- Update customer rollout plan — Luis

## Done
- Review Q3 metrics — Maya
```

Same data, denormalized across both files. A human marked a task complete in the UI. The agent noticed the team-member file had changed more recently, compared it against the status file, synchronized the task across both, and left an audit trail recording what the human changed and what the agent changed. No bespoke task API, no custom query language, no elaborate tool contract, just filesystem semantics. Read the files, compare timestamps, update the stale copy, write a log. It's almost too simple, which is exactly why it's interesting.

**Humans in the loop**

A lot of agent engineering right now goes into teaching models how our abstractions work. Here's the endpoint. Here's the schema. Here are the allowed state transitions. Here's the difference between assignee\_id, owner\_id, and user\_id. Here's the retry behavior, the pagination model, the weird thing this API does when an object gets archived. Sometimes that complexity is essential. Often it's accidental.

The question I keep coming back to is whether we can expose more systems to agents through interfaces they already understand.

That doesn't mean throwing out databases, that would be silly. Databases, APIs, and vector search all earn their keep. Filesystems are a bad answer when you need high-volume transactions, complex joins, strict consistency, arbitrary analytical queries, or carefully enforced invariants. A markdown file is not a database, and pretending otherwise is how you end up with a very expensive shared document with extra steps.

But agents often don't need the database directly. What they need is a working set: plans, notes, task lists, policies, drafts, summaries, logs, corrections, decisions, etc. For that layer, a filesystem-shaped interface tends to be more legible to both the model and the humans supervising it.

The shared legibility is the part that actually matters. If an agent writes a row into a database, a human usually needs a product surface, an admin tool, a SQL query, or a log pipeline to figure out what happened. If an agent edits a markdown file, a human can open it, read the diff, comment, revert, or fix it directly. That changes the debugging loop. You can inspect the agent's memory, spot stale assumptions, delete bad state, version changes, review them in pull requests, and attach permissions, retention policies, audit logs, and governance using systems that already exist.

Cloud filesystems make this more interesting still. A shared drive isn't just storage; it's collaboration, access control, version history, search, preview, comments, legal hold, retention, and auditability — exactly the boring enterprise requirements agent demos tend to ignore until they become production problems.

**Riding the model's priors**

Every time you find yourself spending inference-time effort teaching an agent a custom abstraction, stop and ask whether there's already a paradigm the model knows deeply. The answer won't always be "filesystem." Sometimes it's email, or spreadsheets, or Git, or calendars, or issue trackers. The broader point is that models aren't blank slates, they arrive with operational priors learned from the digital world we already built, and good agent design should use them.

![Image](https://pbs.twimg.com/media/HK3jD_FaoAMazOq?format=jpg&name=large)

Ken Thompson and Dennis Ritchie

Fifty years ago, Ken Thompson and Dennis Ritchie made a powerful bet when designing Unix: devices, streams, programs, and state get easier to compose when they share a file-like interface. That idea scaled astonishingly far. It shaped the systems we use today, including whatever device you're reading this on and the tools we're using to build the most powerful LLMs on the planet.

Now agents are giving it a new job. The filesystem is no longer just where software keeps its files, it may be one of the most natural interfaces we have for giving agents memory, context, and a place to work.

I gave a talk on this at [@DeepLearningAI](https://x.com/@DeepLearningAI) 's AI Dev SF 26, feel free to [check it out](https://www.youtube.com/watch?v=okSgumIGLBY) 📺
