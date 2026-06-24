---
title: Browser Agent Amnesia
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-19
tags: [browser-agents, memory, web-automation, agentic, discovery-tax]
---

# Browser Agent Amnesia

The structural failure mode where browser agents **re-discover every site from scratch on every run**, paying the full exploration cost indefinitely regardless of how many times they've visited the same site.

## The Discovery Tax

On each run, the agent:
- Wanders the page to understand structure
- Figures out navigation patterns
- Discovers hidden endpoints or gotchas
- Adapts to JavaScript rendering, auth gates, captchas

This exploration is paid in full every single run. The cost graph is a straight line going up. No artifact carries forward.

> "The real bottleneck for browser agents in production is memory, in a form humans and agents can both read and trust. Reasoning has stopped being the constraint."
> — Kyle Jeong, Autobrowse article (2026-04-22)

## Why It Happens

Browser agent loops are designed for **generality**: handle any site, any task, in the moment. The trade-off is that all discovered knowledge is session-local — it evaporates when the session closes.

The reasoning that solved Monday's problem is gone by Tuesday. There is no hippocampus.

## Solutions

| Approach | Mechanism | Limitation |
|----------|-----------|------------|
| [[03-RESOURCES/entities/Autobrowse]] | Iterative convergence → SKILL.md graduation | Only for non-deterministic sites |
| [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]] (AWM, WebXSkill, SkillWeaver) | Skill libraries built from trajectories | Academic; varied grounding approaches |
| Hand-written skills | Human reverse-engineers and documents site | Doesn't scale; requires expertise |

## Evidências
- **[2026-06-22]** PreAct: primeira execução bem-sucedida de um computer-using agent é compilada num programa de máquina de estados (checks observacionais + transições de ação) e reexecutada direto nas próximas vezes, 8.5–13× mais rápido, sem chamada de LLM por passo — cura quantificada e verificada (Verify-before-Store Gate) para a amnésia repetida — [[03-RESOURCES/sources/preact-computer-using-agents-that-get-faster-on-repeated-tasks]]

## Conexoes

- [[03-RESOURCES/sources/open-source-ecosystems/autobrowse-mythos-moment-browser-agents]] — fonte que cunha o termo
- [[03-RESOURCES/entities/Autobrowse]] — solucao pratica
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — mecanismo de cura
- [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]] — campo de pesquisa
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — problema de memoria procedural
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]] — discovery tax como deficit de memoria episodica
