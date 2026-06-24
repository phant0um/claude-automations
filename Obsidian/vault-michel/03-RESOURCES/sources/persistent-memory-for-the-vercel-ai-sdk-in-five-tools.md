---
title: "Persistent Memory for the Vercel AI SDK in Five Tools"
type: source
source: "Clippings/Persistent Memory for the Vercel AI SDK in Five Tools.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
```
## Adding Memory to a Generation
This is the whole integration. Create a client, create the tools with a **bankId**, and pass them to any AI SDK call:
```typescript
import { HindsightClient } from "@vectorize-io/hindsight-client";
import { createHindsightTools } from "@vectorize-io/hindsight-ai-sdk";
import { generateText } from "ai";
import { openai } from "@ai-sdk/openai";
const client = new HindsightClient({ baseUrl: process.env.HINDSIGHT_API_URL! });
const tools = createHindsightTools({


## Argumentos principais
### TL;DR
- The Vercel AI SDK has no persistent memory. Each **generateText** / **streamText** call is stateless.
- [@vectorize]()**\-io/hindsight-ai-sdk** adds memory as **five AI SDK tools**: **retain**, **recall**, **reflect**, **getMentalModel**, and **getDocument**.
- One call wires them in: **createHindsightTools({ client, bankId })**, then pass the result to **tools**.

### Why the AI SDK Needs Memory
The AI SDK gives you a clean request-shaped abstraction: messages in, text or a stream out, with tool calls in between. That statelessness is exactly what makes it easy to deploy on serverless and edge runtimes. It's also what makes memory your problem.
For anything you run more than once against the same user, the gap shows up fast. A support assistant re-asks for the account details every session. A coding helper re-learns the project's conventions on every reload. A personal assistant forgets the preferences the user told it yesterday. The usual fix is to stuff prior turns into the prompt, but that only stretches as far as the context window and it resets the moment the session ends. You either build a real memory layer yourself (a datastore, embeddings, retrieval, deduplication) or you ship an assistant with amnesia.
Hindsight is that memory layer, exposed as tools the AI SDK already knows how to drive.

### Memory as Tools, Done Right
The AI SDK is a tool-calling framework. The native way to give a model a new capability is to hand it a tool, so that's how this integration works: the model decides when to reach for memory, the same way it decides when to call a weather API or run a calculation.
The trap with tool-based memory is handing the model too many knobs. If the model gets to pick the bank ID, the cost budget, and the tagging strategy on every call, you've turned infrastructure decisions over to a language model, and it will get them wrong. Hindsight's integration avoids that by drawing a hard line between two kinds of inputs:
- **Semantic inputs belong to the agent.** What to remember, what to search for, what question to reflect on. These are language decisions, which is exactly what the model is good at.

### The Five Tools
**createHindsightTools** registers five tools. The middle column is what the model fills in on each call; the right column is what you lock at construction time.
The first three are the core loop. **retain** stores something worth remembering. **recall** searches memory for relevant facts. **reflect** reasons over those memories to synthesize an answer rather than just returning matches. The last two are for exact retrieval: **getMentalModel** pulls a consolidated, pre-synthesized summary that's cheaper than searching raw memories, and **getDocument** fetches a stored document by ID for cases where you need the exact original text back.

### Setup
Install the package alongside the AI SDK and the Hindsight client:
```text
npm install @vectorize-io/hindsight-ai-sdk @vectorize-io/hindsight-client ai

### Adding Memory to a Generation
This is the whole integration. Create a client, create the tools with a **bankId**, and pass them to any AI SDK call:
```typescript
import { HindsightClient } from "@vectorize-io/hindsight-client";

### Streaming and Agents
Because memory is just tools, it drops into every AI SDK entry point unchanged.
With **streamText**, the tools work exactly the same; tokens stream while the model calls memory mid-generation:
```typescript

### Per-User Memory in a Next.js Route
The **bankId** is the routing key for memory, and a Hindsight bank is just a namespace. The most common pattern is one bank per user. Because the bank is fixed at construction, the clean way to do this on the server is to create the tools **inside** your request handler, closing over the current user's ID:
```typescript
// app/api/chat/route.ts

### Tuning Without Touching Your Agent Loop
Every infrastructure concern is an option on **createHindsightTools**, grouped under the tool it affects. You set these once; the model never sees them:
```typescript
const tools = createHindsightTools({

### Why This Design Holds Up
The split between semantic and infrastructure inputs is the part worth copying even if you build your own memory tools. Let the model decide what to remember and what to look up. Don't let it decide where memory lives or how much it costs. That's the difference between a memory layer you can run in production and a demo that works until a model picks the wrong bank.

### Next Steps
- **Hindsight Cloud:** [ui.hindsight.vectorize.io]()
- **Integration docs:** [Vercel AI SDK + Hindsight]()
- **Source:** [vectorize-io/hindsight/hindsight-integrations/ai-sdk]()


## Key insights
- The Vercel AI SDK has no persistent memory. Each **generateText** / **streamText** call is stateless.
- [@vectorize]()**\-io/hindsight-ai-sdk** adds memory as **five AI SDK tools**: **retain**, **recall**, **reflect**, **getMentalModel**, and **getDocument**.
- One call wires them in: **createHindsightTools({ client, bankId })**, then pass the result to **tools**.
- The design splits responsibility cleanly: the **agent** controls semantic inputs (what to remember, what to search for); your **application** locks infrastructure (the bank, cost budget, tags, async mode). The model can't change the bank ID or blow your token budget.
- Works with **generateText**, **streamText**, and **ToolLoopAgent**, on any provider (OpenAI, Anthropic, Google, and the rest).
- Hindsight Cloud means no infrastructure to run. [Sign up free.]()
- Semantic inputs belong to the agent.** What to remember, what to search for, what question to reflect on. These are language decisions, which is exactly what the model is good at.
- Infrastructure belongs to your application.** Which bank to write to, how much latency to spend, what tags to attach, whether writes are fire-and-forget. These are fixed when you create the tools, and the model never sees them.
- retain.async: true** makes writes fire-and-forget, so a retain call doesn't add ingestion latency to the user's turn.
- recall.budget** trades latency for depth: **low** for snappy lookups, **high** when thoroughness matters more than speed.

## Exemplos e evidências
See original source at `Clippings/Persistent Memory for the Vercel AI SDK in Five Tools.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
