---
title: "The Agent Optimization Loop — How We Built It in Foundry"
type: source
source: Clippings/The agent optimization loop and how we built it in Foundry.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, optimization, eval, traces, production, foundry]
---

## Tese central

Melhorar agent quality em produção é o problema operacional mais difícil. Microsoft Foundry construiu um optimization loop que fecha o gap entre "ver o que está errado" e "shipar versão melhor sem quebrar o resto". Caminho: prompt engineering → traces → evals → optimization loop.

## Argumentos principais

1. **Evolução**: prompt engineering (craft/intuition) → traces (visibility) → evals (quality bars) → optimization loop (systematic improvement)
2. **Quality conundrum**: ver o que está errado não significa saber como fixar sem regressão
3. **Optimization loop**: fecha gap entre diagnóstico e ship de melhoria
4. **Agent optimizer**: quickstart disponível no Foundry

## Key insights

- Traces são necessários mas não suficientes — visibility ≠ improvement
- Evals com scoring rubric multi-dimensional (policy compliance, cost-awareness, etc.)
- Optimization loop é o passo após evals — systematic, não vibes
- "Try it, read output, tweak prompt" é craft, não engineering

## Links

- [[03-RESOURCES/concepts/agent-systems]]
- [[03-RESOURCES/sources/loop-engineering-a-technical-roadmap-for-an-autonomous-loop]]