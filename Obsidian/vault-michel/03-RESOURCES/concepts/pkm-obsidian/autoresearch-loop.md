---
title: "Autoresearch Loop"
type: concept
status: developing
created: 2026-04-24
updated: 2026-04-24
tags: [autoresearch, self-improvement, autonomous-agents, optimization, keep-or-revert]
---

# Autoresearch Loop

O padrão central do `karpathy/autoresearch` — um loop autônomo de otimização que opera overnight sem supervisão humana.

## O Loop

```
Propor mudança (hipótese/experimento)
    ↓
Executar experimento
    ↓
Avaliar contra fitness function
    ↓
Keep ou Revert
    ↓
Registrar lições (lessons.md)
    ↓
Repetir
```

## Princípio Central

> "If you can measure it, you can optimize it."

A generalização é total: qualquer métrica mensurável pode ser a fitness function — model loss, API latency, Sharpe ratio, test coverage, SQL speed, parse performance, benchmark score.

## Componentes Necessários

1. **Fitness function** — métrica clara e mensurável (sem isso, o loop não converge)
2. **Executor** — roda o experimento (local GPU, Colab, SLURM, browser/WebGPU)
3. **Keep-or-revert** — decisão automática com threshold definido
4. **Lessons log** — acumulação de conhecimento entre runs
5. **Budget** — limite de compute ou tempo (overnight loop)

## Variantes Arquiteturais

| Variante | Diferença chave |
|---------|----------------|
| **Basic loop** | Single agent, single metric, linear |
| **GOAL.md pattern** | Agente constrói a fitness function primeiro |
| **Swarm (ClawTeam)** | Múltiplos agentes em paralelo, diferentes direções |
| **Director pattern** | Injeta novelty (arxiv papers) para escapar local minima |
| **Two-loop (inner+outer)** | Inner = otimização; outer = síntese e generalização |
| **GEPA** | Reflective prompt evolution; Pareto front + mutation operators |

## Riscos

- **Reward hacking** — agente otimiza a proxy metric, não o objetivo real. Ver [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]]
- **Local minima** — loop converge prematuramente; Director pattern é a solução
- **Gamed iterations** — tennis XGBoost case study: cherry-picking seeds, exploiting eval gaps

## Aplicações por Domínio

- ML training (original karpathy use case)
- GPU kernel optimization (profile → edit → benchmark → revert)
- Trading (Sharpe ratio como fitness function)
- Software quality (coverage, test speed, build speed, LOC, performance)
- Prompt optimization (GEPA — supera GRPO/RL em benchmarks)
- Scientific discovery ([[03-RESOURCES/entities/AI-Scientist-Sakana]])

## Relações

- É implementado por: [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] (nível protocolo)
- Risco: [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]]
- Instância em alinhamento: [[03-RESOURCES/concepts/llm-ml-foundations/automated-alignment-researcher]]
- Coordenação multi-loop: [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- Fonte: [[03-RESOURCES/sources/guides-courses-howtos/awesome-autoresearch]]
