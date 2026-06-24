---
title: "How to Use Deep Agents with Azure Cosmos DB – Plan, act, and verify against operational data"
type: source
source: "Clippings/How to Use Deep Agents with Azure Cosmos DB – Plan, act, and verify against operational data.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "How to Use Deep Agents with Azure Cosmos DB – Plan, act, and verify against operational data"
source: "
author:
  - "[[Abhishek Gupta]]"
published: 2026-06-22
created: 2026-06-23
description: "See how Deep Agents use Azure Cosmos DB to plan, act, and verify multi-step support operations against live operational data."
tags:
  - "clippings"
---
[Deep Agents]() is an agent harness built on [LangGraph](), for agents that need to work through a task over many steps instead of a single LL

## Argumentos principais
### Agent capabilities Copy link
The requests in this sample all come down to a few Azure Cosmos DB operations. Some questions only need reads. Others need the agent to read first, decide what changed, and then patch the ticket.
| Ask it to… | What the agent does | Cosmos DB operations |
| --- | --- | --- |

### Approach: Agentic vs Static Copy link
Most ticket questions don’t have a one-query answer. Take “is something breaking across customers.” We run a query, look at what comes back, and only then know whether a second, narrower query is worth running. [Deep Agents]() handles exactly that kind of back-and-forth. It plans the work as a short todo list, calls tools, reads results, and decides the next step, instead of trying to answer in a single pass. It also keeps the agent’s instructions lean: the role and the ticket schema stay loaded at all times, while the longer how-to guides load only when a task needs them.
Every ticket is stored under its customer (`/customerId`), so anything scoped to one customer, like reading a single ticket or pulling everything for ACME, stays inside one partition and querying it cost-effective. Queue-wide questions like triage or incident detection read across partitions instead, which is the right call when we’re asking about every customer at once. The agent picks single-partition or cross-partition to match the question.

### How it works Copy link
Everything the agent does to the queue goes through the tools, each a thin wrapper over a single Azure Cosmos DB operation: a query, a point read, a grouped count, and a write. The agent never gets a raw database connection. It works the queue with the same handful of operations a support lead would, and decides which one each request calls for.
[]()
`run_query` is the one the agent reaches for most. It takes a `SELECT` and runs it cross-partition, which is what lets the agent search the whole queue. It’s read-only: anything that isn’t a `SELECT` is refused, and so is a cross-partition `GROUP BY` (more on that below). Writes have their own tool.

### Support Ops agent in action Copy link
I’ll use three requests from the sample runs to show what that looks like. They start the way a support lead would ask them, and the agent has to turn each one into the right mix of queries, reads, and updates.

### Morning triage Copy link
```
I just got in, what should I look at first?
```

### Resolve a ticket Copy link
The next request names a specific ticket and expects something done about it:
```
GLOBEX is unhappy about TICKET-1050, can you pick it up and move it forward?

### Spot an incident Copy link
Now try a login related request that starts broad:
```
Logins feel shaky this week, dig in and flag anything related.

### Try it, and build your own Copy link
The repo has everything to run this against your own Azure Cosmos DB account: the tools, the seed data, and a CLI that streams each step as the agent works. The [README]() walks through setup and the az login auth. Run python `seed.py` to load the support queue data, then replay the runs above or ask the agent your own questions.
Once you have the sample running, try the same idea with data from one of your own workflows. Start with read-only questions and watch how the agent breaks them into Azure Cosmos DB operations. Then add scoped writes when the boundary is clear: what the agent can change, what history it should leave, and how it verifies the result. That could be support tickets, incidents, orders, devices, or any other operational data where a multi-step agent can help.

### Learn more Copy link
📘 For the agent framework, start with the [Deep Agents docs]()
📘 [AI agents in Azure Cosmos DB]() is a good place to step back and review the broader agent concepts: planning, tool use, memory, copilots, autonomous agents, and multi-agent systems.
📘 [Agentic Retrieval Toolkit]() shows how to ground answers with multi-step retrieval over Cosmos DB data

### About Azure Cosmos DB Copy link
Azure Cosmos DB is a fully managed and serverless NoSQL and vector database for modern app development, including AI applications. With its SLA-backed speed and availability as well as instant dynamic scalability, it is ideal for real-time NoSQL and MongoDB applications that require high performance and distributed computing over massive volumes of NoSQL and vector data.
To stay in the loop on Azure Cosmos DB updates, follow us on [X](), [YouTube](), and [LinkedIn](). Join the discussion with other developers on the [#nosql channel on the Microsoft Open Source Discord]().


## Key insights
- what the agent can do, and the Azure Cosmos DB operation behind each kind of request
- why Deep Agents and Azure Cosmos DB fit this problem
- the tools it uses to work on the ticket queue
- practical examples of how the agent works: morning triage, resolving a ticket, and spotting an incident
- TICKET-1004 (UMBRELLA): P1 open, unassigned, data issue, untouched since
- TICKET-1003 (INITECH): P2 open, unassigned, login lockout, untouched since
- TICKET-1001 (ACME): P1 open, unassigned, billing, untouched since Jun 8.
- TICKET-1002 (GLOBEX): P1 in-progress, performance, with agent.lee, untouched
- TICKET-1010 (INITECH): P2 open, unassigned, performance, untouched since
- It was a stale P2 login issue sitting open and unassigned.

## Exemplos e evidências
See original source at `Clippings/How to Use Deep Agents with Azure Cosmos DB – Plan, act, and verify against operational data.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/GitHub-Copilot]]
- [[03-RESOURCES/entities/Microsoft]]
- [[03-RESOURCES/entities/Azure]]
- [[03-RESOURCES/entities/LinkedIn]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
