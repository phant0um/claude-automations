---
title: "Meet your agent harness and claw"
type: source
source: "Clippings/Meet your agent harness and claw.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
client = FoundryChatClient(credential=AzureCliCredential())
```
- **`FOUNDRY_PROJECT_ENDPOINT`** – your Microsoft Foundry project endpoint. - **`FOUNDRY_MODEL`** – the model deployment to call. - **`AzureCliCredential`** – uses your `az login` session; swap in any other credential you prefer.

## Argumentos principais
### Step 1 – Construct a chat client Copy link
Everything starts with a *chat client* – the thing that actually talks to a model. We point it at an endpoint, give it a credential for auth, and tell it which model deployment to use.
In this example we are using [Microsoft Foundry]() with the [Responses API]().
**.NET**

### Step 2 – Turn the chat client into a harness Copy link
Now we wrap that client in the harness. In.NET you call `AsHarnessAgent`; in Python you call `create_harness_agent`. For now, we supply just two things: **instructions** (what the agent is for) and a **custom tool**.

### Instructions Copy link
The harness handles *how* to operate; our instructions describe *what* the agent is for.
**.NET**
```csharp

### Personal Finance Assistant Instructions
You are a personal finance and investing assistant. When asked about a stock, look up its current
price with the get_stock_price tool, and use web search for recent news, earnings, or analyst
commentary.

### Working style
- Always verify numbers with a tool rather than relying on memory. Stock prices change.
- Cite web sources inline when you use them.
- Keep the user's watchlist in a memory file called \`watchlist.md\`: read it when reviewing the

### A custom tool Copy link
A tool is just a function the model can call. We expose a `get_stock_price` function; the framework generates the JSON schema from its signature and parameter descriptions.
**.NET**
```csharp

### Wire it together Copy link
With the instructions and tool in hand, one call builds the agent.
**.NET**
```csharp

### Step 3 – Run it through the harness console Copy link
Finally, we hand the agent to a shared harness console – a streaming terminal UI with `/todos`, `/mode`, and `/exit` commands, and output colored by mode (cyan for planning, green for execution).
The console is is provided as a sample. Both languages ship the full source, designed to be copied and adapted as a starting point for your own UX (web app, chat surface, IDE extension, …):
- .NET: [`Harness_Shared_Console`]()

### Save and resume a session Copy link
The console can also persist the whole session to disk. Under the hood `/session-export` simply serializes the `AgentSession` object – conversation history *and* context-provider state such as the directory containing your file memory – to JSON via the agent’s `SerializeSessionAsync`, then writes it to a file. `/session-import` reads that file back and deserializes it into a live session. Continue in order:
1. `/session-export my-session.json` – saves the current session (including the watchlist memory) to a file on disk.
2. `/exit`, then relaunch the app – you’re back to a fresh, empty session.

### How plan mode works Copy link
Why does plan mode *ask questions* and *request approval*, while execute mode just gets on with it? The trick is **structured output**.
The harness ships with two modes out of the box – `plan` (the default) and `execute` – and the console’s planning observer treats them differently. In execute mode the model replies with ordinary prose and gets to work. In **plan** mode, the console asks the model for a structured response instead of free-form text, by setting a response format with a JSON schema:
**.NET**

### Turning features off Copy link
Everything the harness gives us – todos, agent modes, web search, file memory, file access, tool approval – is **on by default and individually toggleable**. If a feature doesn’t fit your scenario, switch it off with a single option. For example, to drop the todo list and web search:
**.NET**
```csharp

### The runnable samples Copy link
- **.NET:** [`dotnet/samples/02-agents/Harness/BuildYourOwnClaw/Claw_Step01_MeetYourClaw`]()
- **Python:** [`python/samples/02-agents/harness/build_your_own_claw`]()

### Use these building blocks in your own agent Copy link
The harness wires all of this up for you, but none of it is locked inside the harness. Web search is just a **tool**, and modes and todos are each a plain **context provider** — you can pick up exactly the pieces you want and add them to *any* agent, even without adopting the full harness. Here’s where to find them:
| Feature | .NET (type — namespace) | Python (import) |
| --- | --- | --- |

### What’s next Copy link
Our claw can look things up, search the web, and plan. But it can’t yet touch *your* data, and there’s nothing stopping it from taking a sensitive action. In Part 2 – Working with your data, safely we will give it **file access**, gate risky actions behind **approvals**, and add durable **memory** so it remembers your preferences.

### 📚 The series Copy link
Part of **Build your own claw with Microsoft Agent Framework**:
- [Overview: Build your own claw and agent harness with Microsoft Agent Framework]()
- **Part 1 – Meet your agent harness and claw** *(you are here)*


## Key insights
- `FOUNDRY_PROJECT_ENDPOINT`** – your Microsoft Foundry project endpoint.
- `FOUNDRY_MODEL`** – the model deployment to call (e.g. `gpt-5.4`).
- `DefaultAzureCredential`** – handles auth from your environment (e.g. run `az login` locally to use its session). In
- `FOUNDRY_PROJECT_ENDPOINT`** – your Microsoft Foundry project endpoint.
- `FOUNDRY_MODEL`** – the model deployment to call.
- `AzureCliCredential`** – uses your `az login` session; swap in any other credential you prefer.
- Always verify numbers with a tool rather than relying on memory. Stock prices change.
- Cite web sources inline when you use them.
- Keep the user's watchlist in a memory file called \`watchlist.md\`: read it when reviewing
- Always verify numbers with a tool rather than relying on memory. Stock prices change.

## Exemplos e evidências
See original source at `Clippings/Meet your agent harness and claw.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/entities/OpenAI]]
- [[03-RESOURCES/entities/Gemini]]
- [[03-RESOURCES/entities/Microsoft]]
- [[03-RESOURCES/entities/Azure]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
