---
title: "Build your own claw and agent harness with Microsoft Agent Framework"
type: source
source: "Clippings/Build your own claw and agent harness with Microsoft Agent Framework.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Build your own claw and agent harness with Microsoft Agent Framework"
source: "
author:
  - "[[Wes Steyn]]"
published: 2026-06-22
created: 2026-06-23
description: "Want to build your own claw? Use Microsoft Agent Framework's harness feature to get up and running with a few lines of code."
tags:
  - "clippings"
---
What does it take to build your own “claw” – a capable, CLI-style agent that can plan, use tools, remember things, and safely act on your behalf? Coding agents and assistan

## Argumentos principais
### A claw is just a harness Copy link
Strip away the UI and a coding agent is a model plus a *harness* that gives it:
- **tools** it can call,
- a **plan** it can follow and adapt,

### Why now? You need a capable model Copy link
The harness multiplies what a model can do, but the model is still the engine. Every turn of the loop depends on the model reliably following *your* instructions **and** the harness’s own instructions – choosing the right tool, sticking to a multi-step plan, knowing when to ask for approval, and reasoning over what it reads back.
That’s why claws feel new: until recently, models couldn’t juggle this many layered instructions or call tools dependably enough for the loop to hold together. Recent advances – stronger instruction-following, reliable tool/function calling, longer context windows, and better multi-step reasoning – are exactly what make this kind of agent practical today.
> 💡 Use a current, high-capability model. You *can* run a harness on an older or smaller model, but expect it to follow your instructions and the harness’s instructions less fully, and to need more hand-holding.

### Our running example: a personal finance assistant Copy link
In our series, we build **one** assistant across the whole series: a personal finance / investing helper. It looks up stock prices, reads your portfolio, drafts reports, and runs analyses. Some of its tools are sensitive (placing a trade, sending a report) and need approval; some tasks need planning. That makes it a great vehicle for showing off every part of the harness on something that feels real.
> ⚠️ It’s an illustrative sample, not financial advice – and the market data in the samples is mock data.

### The series Copy link
| Part | What we add |
| --- | --- |
| [**1 – Meet your agent harness and claw**]() | A minimal harness, a custom `get_stock_price` tool, web search, and planning (todos + plan/execute modes). |


## Key insights
- a **plan** it can follow and adapt,
- memory** that survives across turns and sessions,
- approvals** so risky actions need a human’s OK,
- observability** so you can see what it did,
- and a way to **deploy** it as a real service.

## Exemplos e evidências
See original source at `Clippings/Build your own claw and agent harness with Microsoft Agent Framework.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]]
- [[03-RESOURCES/entities/Microsoft]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
