---
title: Prompt Debt
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, prompt-engineering, tech-debt, model-agnostic]
---

# Prompt Debt

Natural language prompts são uma armadilha para sistemas duráveis. O que faz protótipos effortless torna-se prompt debt: iteração lenta, team incapacitada, lock-in a um modelo.

## 3 sintomas

1. **Slowing iteration**: Edge cases → mais instruções → regressões → já não dá para fix com one-liner
2. **Team incapacitated**: Brittle prompt é imp legível para colegas. Templates runtime viram thicket de condições
3. **Model lock-in**: Hot fixes funcionam em GPT-4o, fail em GPT-5.4-mini. Datadog: GPT-4o é modelo mais usado (>50% de calls em alguns providers)

## Por que acontece

- Linguagem natural + modelos probabilísticos = mesmas palavras, diferentes outputs
- "Fighting the weights": repetir instruções porque behavior treinado do model resiste. ChatGPT repetia 8x "não responda quando imagem retornada". Claude Code diz 7x "return multiple tool calls". Fable repete copyright rule 6x.
- Cada fix aumenta brittleness → regressão em instruções que funcionavam

## Prevenção — 2 princípios

1. **Specify with measurements, not prose**: Evaluations, metrics, typed specifications. Artifacts legíveis que colegas podem ler e contribuir.
2. **Stop writing prompts by hand**: DSPy, GEPA — systems que geram e otimizam prompts contra seus metrics. "Once prompts are generated and behavior is defined by measurements, you are no longer bound to a particular model."

## Paralelo histórico

Assembly → compilers. Hand-tuned queries → planners. Manual memory → GC. Prompt-writing → prompt generation.

## Prompt debt = Tech debt da era AI

"Fighting the weights" = "fighting the codebase". Solução em ambos: measurements not prose, automated gates, sistemas gerando fixes.

## Evidências

- [[03-RESOURCES/sources/ai-agents/the-problem-is-prompt-debt]] — Análise completa dos 3 sintomas + 2 princípios de prevenção
- [[03-RESOURCES/sources/ai-agents/how-frontier-teams-are-reinventing-ai-native-development]] — "Make intent explicit before code" = specify with measurements
- [[03-RESOURCES/sources/ai-agents/i-tested-agentic-loops-real-code]] — CLAUDE.md em loops é o único contexto sobre standards

## Aplicação no vault

CLAUDE.md é um system prompt sujeito a prompt debt. As invariant sections (`<!-- [INVARIANT] -->`) são o equivalente a "repeating instructions with severity" — mas com propósito (proteção contra auto-evolution). Skills são a evolução em direção a "measurements not prose" — cada skill tem critérios de sucesso, não apenas prose.

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-loop-pattern]]
- [[03-RESOURCES/concepts/ai-agents/beautiful-nonsense]]
- [[04-SYSTEM/agents/nexus-agent-system/model-router]]
- [[04-SYSTEM/agents/core/hill]]