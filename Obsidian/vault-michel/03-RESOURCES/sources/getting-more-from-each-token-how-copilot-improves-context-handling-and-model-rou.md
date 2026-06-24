---
title: "Getting more from each token: How Copilot improves context handling and model routing"
type: source
source: "Clippings/Getting more from each token How Copilot improves context handling and model routing.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Getting more from each token: How Copilot improves context handling and model routing"
source: "
author:
  - "[[Joe Binder]]"
published: 2026-06-17
created: 2026-06-23
description: "How GitHub Copilot is making more of each session go toward useful work, so your credits go further."
tags:
  - "clippings"
---
As Copilot takes on more agentic work, from planning and editing to debugging, reviewing, and calling tools across longer sessions, efficiency means more than using fewer tokens.

## Argumentos principais
### Increased prompt caching and deferred tools
In longer GitHub Copilot sessions in VS Code, the harness prepares a lot of recurring information for the model: instructions, repository context, conversation history, available tools, and the current state of the task. Some of that context is needed. Some of it can be cached, deferred, or loaded only when it becomes relevant.
Two improvements in GitHub Copilot for VS Code are doing most of the work here. Prompt caching helps Copilot reuse model state for repeated prompt prefixes instead of recomputing the same prefix on every request. Tool search lets the model load tool definitions on demand, instead of sending every full tool schema into context on every turn.
That matters more as agents use more tools. A session may need access to MCP tools, terminal commands, file operations, workspace search, and product-specific actions. Loading every full tool definition up front adds fixed cost to each turn, even when only a small number of tools are relevant to the task. With tool search, Copilot can keep the available toolset broad while sending less unnecessary tool schema into the model.

### Where GitHub Copilot auto model selection fits in
Auto answers a practical question: which model is the best fit for this task right now?
After your first prompt, Copilot uses task intent and current model health to choose a model that best fits the task. Different kinds of work, like quick explanations, focused edits, or multi-file changes, do not all benefit from the same level of reasoning, so Auto makes that call without requiring you to tune model settings.
In our evaluations, no single model consistently performed best across tasks. In many cases, a more efficient model reached the same outcome, while stronger models mattered most when the task required deeper reasoning. Auto learns where stronger reasoning improves the result. It routes up when the task demands it and stays more efficient when it does not. The goal is not to trade quality for cost, but to use the model that best fits the work.

### How Auto selects the right model
Auto combines two signals: what model is healthy and available right now, and what kind of work Copilot is being asked to do.
- **Real-time model health:** a dynamic engine tracks model availability, utilization, speed, error rates, and cost. A model may be capable of handling a task, but that does not mean it is the best choice at that moment. Auto takes current system conditions into account so Copilot can route to a model that is both capable and ready to respond.
- **Task-aware routing with [HyDRA]():** a routing model that considers factors like reasoning depth, code complexity, debugging difficulty, and tool orchestration needs. HyDRA identifies models that can meet the quality bar for the task, then chooses the best fit among them.

### Making Auto work in practice
Getting routing right in evaluations is only part of the problem. To make Auto useful in real workflows, we also had to account for how developers actually use Copilot: conversations get longer, context builds up, tasks shift, and developers work in many languages.
**Cache-aware routing.** Switching models on every turn may sound flexible, but it can work against efficiency. When a conversation stays on the same model, the prompt prefix can be cached and reused across turns. Switching models mid-conversation breaks that cache, which can cost more than the routing change saves. Auto avoids that by routing at natural cache boundaries: on the first turn, when there is no cache to lose, and after compaction, when Copilot summarizes older turns and the prompt prefix resets. Between those points, the selected model stays in place so the cache can keep building.
**Routing across languages.** Copilot serves developers around the world, so routing has to work in languages other than English. We trained the routing model on conversations across 16 language families, including CJK, European, and others. In evaluations, routing accuracy stayed within four points of the English baseline across language groups, with no statistically significant quality gap.

### Auto with task intent is expanding
Auto with task intent is already live in Visual Studio Code, github.com, and mobile. It gives Copilot more signal about the kind of work you are doing, whether that is coding, debugging, planning, or using tools, so it can make a better model choice for the task.
We are continuing to expand that experience across Copilot. Next, we are bringing Auto with task intent to more surfaces and adding more ways for teams to make Auto the default.
- Auto with task intent is coming to Copilot CLI, GitHub App, and additional IDEs.

### Getting more value from your AI credits
Copilot is getting more efficient by default, but a few habits can help your credits go further.
- **Start with Auto.** Auto is the strong default for many tasks because it chooses a model based on what you are trying to do, without making you pick one manually every time.
- **Keep context focused.** Start a new session when you switch tasks, compact long-running sessions when needed, and mention the files you want Copilot to use when you already know where the relevant code lives. Less unnecessary context means more of the session goes toward the actual work.

### Get started
Auto model selection is available today across supported Copilot experiences. To learn more, see the [Auto model selection docs](). You can also share feedback in [Copilot discussions]().
We are continuing to make Copilot more efficient across the system so more of your credits go toward useful work, without requiring you to tune every model choice yourself.


## Key insights
- Task-aware routing with [HyDRA]():** a routing model that considers factors like reasoning depth, code complexity, debugging difficulty, and tool orchestration needs. HyDRA identifies models that can meet the quality bar for the task, then chooses the best fit among them.
- Auto with task intent is coming to Copilot CLI, GitHub App, and additional IDEs.
- Copilot Free and Student plans will be simplified to leverage Auto as the only model selection option.
- Admin controls will let organizations set Auto as the default or enforce Auto as the only option.
- Start with Auto.** Auto is the strong default for many tasks because it chooses a model based on what you are trying to do, without making you pick one manually every time.
- Keep context focused.** Start a new session when you switch tasks, compact long-running sessions when needed, and mention the files you want Copilot to use when you already know where the relevant code lives. Less unnecessary context means more of the session goes toward the actual work.
- Avoid changing models or settings mid-session.** Switching models, reasoning levels, context size, or tool configuration can break cache reuse and make Copilot rebuild context. Set up the session the way you want it, then keep related work together.
- Plan before parallelizing.** For larger tasks, ask Copilot to plan first. Parallel agents can be useful when work can truly be split up, but they also consume credits in parallel, so use them deliberately.
- Use only the tools you need.** Tools and MCP servers are powerful, but broad toolsets can add extra context. Enable what is relevant to the task and turn off what you do not need. Check out [agent finder in GitHub Copilot]() to help streamline your tool usage.
- Check your usage.** Your AI usage page shows where credits are going across features and models. In Copilot CLI, session-level usage can also help you spot expensive patterns while you work.

## Exemplos e evidências
See original source at `Clippings/Getting more from each token How Copilot improves context handling and model routing.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/token]]
- [[03-RESOURCES/entities/GitHub-Copilot]]
- [[03-RESOURCES/entities/Azure]]

## Minha Síntese
**O que muda:** Este estudo reforça que as copilot takes on more agentic work, from planning and editing to debugging, reviewing, and calling tools across longe — impacta diretamente como projetar e avaliar agentes.

**Conexão pessoal:** Conecto isso ao meu trabalho com Hermes Agent e o vault-michel: preciso aplicar este padrão nos meus fluxos de ingestão e consolidação.

**Próximo passo:** Implementar um experimento prático com este conceito nos próximos ciclos de desenvolvimento do vault.