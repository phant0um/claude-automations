---
title: "Maintaining Code Quality at Agent Speed: 7 Patterns"
type: source
source: "Clippings/Maintaining Code Quality at Agent Speed 7 Patterns.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Maintaining Code Quality at Agent Speed: 7 Patterns"
source: "
author:
  - "[[Amit Sharma]]"
published: 2026-06-17
created: 2026-06-23
description: "Learn 7 patterns for maintaining code quality at agent speed, including quality gates, mutation testing, code review, and lifecycle engineering practices."
tags:
  - "clippings"
---
*By Amit Sharma and Antonio Garrote. *  
How do you know whether code generated at agent speed can be [trusted]()? That question is fast becoming one of the 

## Argumentos principais
See original source for full arguments.

## Key insights
- *  
How do you know whether code generated at agent speed can be [trusted]()?
- The result is a new kind of engineering problem.
- It is an engineering model — a set of architecture choices, repository patterns and workflow gates that let many agents build in parallel while the team keeps its confidence in the result.
- The 7 patterns that follow are the model Salesforce’s [Agent Fabric]() Salesforce built to get past that wall.
- When an engineer writes code by hand, the act of writing builds a mental model of how the system behaves, where it is fragile and what to watch for in production.
- When an agent writes the code, that model does not come for free.
- This is why, within our Agent Fabric team, we treat verifiability as a first-class design constraint rather than a step at the end.
- When the same agent writes both, the signal weakens, because the tests inherit whatever the agent misunderstood about the problem.
- You can tell an agent to avoid a pattern, follow a coding standard or structure a module a certain way, and it will often comply.
- Anything that depends on the agent remembering and choosing to follow it will eventually slip.

## Exemplos e evidências
See original source at `Clippings/Maintaining Code Quality at Agent Speed 7 Patterns.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/concepts/llm-ml-foundations/regression]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.
