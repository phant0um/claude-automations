---
title: "Lance Martin"
type: entity
category: person
tags: [entity, person, langchain, ai-agents, memory]
created: 2026-05-31
updated: 2026-06-01
---

# Lance Martin

**Handle:** @RLanceMartin (X/Twitter) · LangChain

Pesquisador e developer advocate na LangChain/LangGraph, conhecido no vault pelos conceitos de Outcomes (self-verification loop) e Dreaming (aprendizado offline entre sessões).

## Contribuições relevantes

- "Outcomes" = Ralph Loop: agente gera output → grader sub-agent avalia contra rubric → resultado injetado para refinar (verifier isolado é mais confiável que auto-avaliação)
- "Dreaming": processo offline entre sessões para pruning, consolidação de memória e extração de skills a partir de padrões observados
- Recomenda `claude-api` skill para puxar session logs e atualizar rubric com dados reais
- Talk co-apresentado com @jess__yan no Code With Claude (Anthropic)

## Fontes no vault

- [[03-RESOURCES/sources/ml-research-papers/rlancemartin-outcomes-dreaming-managed-agents]] — Outcomes e Dreaming em Claude Managed Agents
- [[03-RESOURCES/sources/ai-agents-harness/anthropic-dreaming-claude-managed-agents-setup]] — setup dos managed agents
