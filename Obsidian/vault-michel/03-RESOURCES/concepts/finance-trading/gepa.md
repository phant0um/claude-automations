---
title: GEPA — Genetic-Pareto Prompt Evolution
type: concept
status: developing
created: 2026-05-16
updated: 2026-05-16
tags: [optimization, skills, agents, hermes, evolutionary-search, iclr]
---

# GEPA — Genetic-Pareto Prompt Evolution

Pipeline de **otimização offline de skills de agentes** via busca evolutiva. Publicado como ICLR 2026 Oral (NousResearch/hermes-agent-self-evolution). MIT license.

## Problema que resolve

O loop de auto-aprendizado in-agent do [[hermes|Hermes]] tem uma fraqueza conhecida: **o agente tende a auto-congratulação** — avalia sua performance como boa mesmo quando não foi. GEPA corrige isso lendo traces de execução (o que realmente aconteceu) ao invés de pedir ao agente que se avalie.

## Como funciona

```
1. Lê skill atual do repo Hermes
2. Gera dataset de avaliação:
   - Casos sintéticos (Claude Opus)
   - Histórico real de sessão (SQLite)
   - Golden sets manuais
3. GEPA optimizer:
   - Lê execution traces → identifica failure points
   - Gera variantes candidatas (busca evolutiva)
4. Avalia via LLM-as-judge (rubrics, não pass/fail binário)
5. Constraint gates:
   - Test suite 100% pass
   - Skill ≤ 15KB
   - Caching compatibility preservada
   - Semantic purpose sem drift
6. Melhor variante → PR (nunca commit direto)
```

## Características

- **Sem GPU** — tudo via API calls
- **Custo:** ~$2–10/run
- **Output:** PR contra o repo Hermes, nunca commit direto
- **Repositório separado** do Hermes runtime — roda offline como pipeline companion

## Quando usar

Alternativa antes de full finetuning ou RL (GRPO):
- Skill com comportamento inconsistente
- Skill que falha em edge cases específicos
- Antes de investir em RL/GRPO (muito mais barato)

```
Custo: GEPA ($2-10) << RL/GRPO (centenas a milhares de $)
Qualidade: GEPA < RL/GRPO (mas suficiente para maioria dos casos)
```

## vs. Auto-Curator

| | Auto-Curator | GEPA |
|--|--|--|
| Quando roda | Background (inactivity check, 7 dias) | On-demand, offline |
| O que avalia | Uso/relevância das skills | Qualidade de execução via traces |
| Output | Keep/patch/archive | PR com skill otimizada |
| Custo | Tokens de LLM review | $2–10/run |
| Integrado ao runtime | Sim | Não (companion repo) |

## Relacionado

- [[hermes]] — framework onde GEPA otimiza as skills
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-masterclass-akshay-pachaar]] — fonte
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — pattern geral de auto-evolução
- [[03-RESOURCES/concepts/llm-ml-foundations/recursive-self-improvement]] — conceito relacionado

## Evidências
- **[2026-06-24]** Tuning AI systems by hand doesn't scale. — [[cocoevolve-evolutionary-optimization-for-ai-systems]]
