---
title: "Why AI Agents Keep Rereading Their World"
type: source
source: "Clippings/Why AI Agents Keep Rereading Their World we.md"
author: "@karankendre"
published: 2026-06-22
created: 2026-06-22
ingested: 2026-06-22
tags: [memory-context-rag, world-model, context-window, agent-memory]
score: B
---

## Tese Central

Um agent que tem que reread seu world toda session não tem um world model — tem um habit. World model não é transcript que cresce; é statement maintained, small e current. Building usable world model é subtractive: a disciplina de decidir o que agent pode não saber e ainda agir corretamente.

## Pontos-Chave

1. **O problema**: agent começa fresh session, runs pwd, reads progress file, greps repo, abre 6 files para confirmar. Reconstrói do nada o shape do sistema. Context já se foi antes de act.
2. **Model ≠ transcript**: term "world model" em ML significa learned model de environment dynamics. Para agents, significa current structured description do que existe e como conecta. Transcript cresce; model é maintained.
3. **Context window constraint**: models retrieve most reliably no start/end, least no middle (Liu et al.). Attention cost rises ~quadratically com context length. Duplo context não dobra cost — faz pior. Pergunta certa: quão pouco precisa load para estar right.
4. **Subtraction is the work**: instinct é aditivo (capture more, store more). Constraint acima é por que more information CAN hurt e DOES. Decidir o que agent pode não saber e ainda act correctly. O que colapsa para one-line summary. O que é stale e nunca load again.
5. **World model ≠ why-layer**: world model diz o que é true agora. Não diz por que veio a ser true. Record de como decisão foi feita é emergente, messy, cresce sem ceiling. Structure de environment é largely determined e stable. Conflate os dois = memory system enorme, slow, ainda não responde "where am I".
6. **Infrastructure, not application**: todo team building multi-session agents hit same wall independentemente. Escrevem próprios loaders, pruning logic, staleness rules. Problema é horizontal — belongs underneath all applications. HydraDB está building o layer.

## Conceitos

- World model vs transcript (maintained vs accumulated)
- Subtractive model building (decidir o que não saber)
- Context window: quadratic attention cost, middle-position unreliability
- World model (what is true now) vs why-layer (how it came to be)
- Memory infrastructure como horizontal layer

## Links

- [[03-RESOURCES/concepts/memory-context-rag/rag-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]