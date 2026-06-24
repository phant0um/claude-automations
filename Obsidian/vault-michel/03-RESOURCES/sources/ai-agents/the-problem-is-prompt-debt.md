---
title: "The Problem is Prompt Debt"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://x.com/dbreunig/status/2069455716478603536"
author: "@dbreunig"
published: 2026-06-23
grade: B
tags: [ai-agents, prompt-engineering, prompt-debt, model-agnostic, source]
---

# The Problem is Prompt Debt

**Tese central**: Natural language prompts são uma armadilha para sistemas duráveis. O que faz protótipos effortless torna-se prompt debt: iteração lenta, team incapacitada, lock-in a um modelo. A solução é especificar comportamento com measurements, não prose, e deixar LLMs gerarem os prompts.

## Os 3 sintomas do prompt debt

1. **Slowing iteration**: Edge cases → mais instruções → regressões → já não dá para fix com one-liner
2. **Team incapacitated**: Brittle prompt imp legível para colegas. Templates runtime viram thicket de condições
3. **Model lock-in**: Hot fixes funcionam em GPT-4o, fail em GPT-5.4-mini. Datadog: GPT-4o é o modelo mais usado, >50% de calls em alguns providers

## Por que acontece

- Linguagem natural + modelos probabilísticos = mesmas palavras, diferentes outputs
- Estudo: mesma pergunta clínica em voz de patient vs physician flipou Opus de decline-all para answer-all
- Harvard study: mencionar time da NFL mudou refusal rate
- "Fighting the weights": repetir instruções porque behavior treinado do model resiste. ChatGPT repetia 8x "não responda quando imagem retornada". Claude Code diz 7x "return multiple tool calls". Fable repete copyright rule 6x.
- Cada fix aumenta brittleness → regressão em instruções que funcionavam

## Prevenção — 2 princípios

1. **Specify with measurements, not prose**: Evaluations, metrics, typed specifications. Artifacts legíveis que colegas podem ler e contribuir. "The best engineers now spend more bandwidth on tests than ever."
2. **Stop writing prompts by hand**: Use systems como DSPy e GEPA que geram e otimizam prompts contra seus metrics. "Once prompts are generated and behavior is defined by measurements, you are no longer bound to a particular model."

## Parallelo histórico

Assembly → compilers. Hand-tuned queries → planners. Manual memory → GC. Prompt-writing → prompt generation.

## Por que importa para o vault

- **CLAUDE.md é um system prompt**: Está sujeito a prompt debt. As invariant sections (`<!-- [INVARIANT] -->`) são o equivalente a "repeating instructions with severity" — mas com propósito (proteção contra auto-evolution)
- **Skills vs prompts**: Skills são a evolução do vault em direção a "measurements not prose" — cada skill tem critérios de sucesso, não apenas prose
- **Model routing**: O vault já é parcialmente model-agnostic (Haiku/Sonnet/Opus por tarefa). Mas CLAUDE.md ainda tem hand-tuning
- Conecta com [[03-RESOURCES/concepts/ai-agents/agent-loop-pattern]] — loops amplificam prompt debt

## Links

- [[03-RESOURCES/concepts/ai-agents/prompt-debt]]
- [[03-RESOURCES/concepts/ai-agents/agent-loop-pattern]]
- [[04-SYSTEM/agents/nexus-agent-system/model-router]]
- [[03-RESOURCES/sources/ai-agents/missing-piece-every-agent-loop]]