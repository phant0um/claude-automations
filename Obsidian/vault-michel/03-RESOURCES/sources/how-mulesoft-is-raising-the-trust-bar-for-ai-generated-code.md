---
title: "How MuleSoft Is Raising the Trust Bar for AI-Generated Code"
type: source
source: "Clippings/How MuleSoft Is Raising the Trust Bar for AI-Generated Code.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [ai-agents, source-page]
---

## Tese central
---
title: "How MuleSoft Is Raising the Trust Bar for AI-Generated Code"
source: "
author:
  - "[[Melissa Cazalet]]"
published: 2026-06-11
created: 2026-06-23
description: "Learn how MuleSoft built repeatable governance infrastructure that holds every code change to a consistent trust bar and much more."
tags:
  - "clippings"
---
In our Engineering Energizers Q&A series, we highlight the engineering minds driving innovation across Salesforce. Today, we spotlight Melissa Cazalet, Senior Vice Pres

## Argumentos principais
See original source for full arguments.

## Key insights
- "[[Melissa Cazalet]]"
- This is a model any engineering org adopting agentic development can apply.
- ##### Why did agentic development change the code trust model at MuleSoft?
- That model worked when human-paced review cycles matched human-paced code production.
- It is a reusable model for any engineering org looking to make trust enforcement keep pace with agentic development.
- The hardest part was not the AI, it was the operating model.
- PR-time enforcement depended on [Prizm](), Salesforce’s internal pull-request governance platform, including its deployment infrastructure, org-scope enforcement model, and merge-blocking capabilities, all of which were maturing in parallel.
- Closing that gap is the central engineering problem of any LLM-driven enforcement system.
- Golden Gate closes it by treating determinism as a property the system produces, not one the model provides.
- That consensus filter strips stochastic variation out of the pipeline before any result is even considered for promotion, converting probabilistic model output into stable, evidence-grade signal.

## Exemplos e evidências
See original source at `Clippings/How MuleSoft Is Raising the Trust Bar for AI-Generated Code.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/entities/Rust]]
