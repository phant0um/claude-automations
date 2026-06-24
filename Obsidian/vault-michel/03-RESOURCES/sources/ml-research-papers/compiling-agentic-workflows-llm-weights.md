---
title: "Compiling Agentic Workflows into LLM Weights: Near-Frontier Quality at Two Orders of Magnitude Less Cost"
type: source
source: Clippings/Compiling Agentic Workflows into LLM Weights Near-Frontier Quality at Two Orders of Magnitude Less Cost.md
created: 2026-05-22
ingested: 2026-05-23
tags: [ml-research, ai-agents, fine-tuning, workflow-compilation, token-economy]
institutions: [i14, University of Melbourne]
score: 9
---

## Tese central
Compilar workflows agenticos em pesos de modelos pequenos fine-tuned ("subterranean agents") entrega 87-98% da qualidade de modelos frontier em-context, com custo 128-462× menor por conversa. Os três barriers percebidos (qualidade, custo, flexibilidade) são menores do que assumido.

## Argumentos principais
- Arquitetura dominante: orquestrador externo + LLM frontier → injeta instruções e decisões de roteamento a cada turno
- Problema: consome context window, requer modelo frontier para cada conversa, expõe procedimentos proprietários a third-parties
- Compilação: faz fine-tune do workflow em modelo pequeno (3B-8B) → prompt de tamanho constante independente da complexidade do procedimento
- Qualidade: modelo 3B compilado bate mesmo 3B base com orquestração explícita em 4/5 métricas (p<0.001)
- Custo: 65× redução por token (self-hosting) × 2-7× menos volume de tokens = 128-462× mais barato
- Flexibilidade: recompile cycle = 30-50 minutos (CI/CD cycle, não retraining longo)
- Failure rate: compiled models têm failure rate menor que orquestrador em travel (5.5% vs 24%) e insurance (9% vs 17%)

## Key insights
- "Subterranean agent": model compilado age como especialista no domínio do workflow, sem overhead de orquestração
- Vantagem cresce com complexidade do procedimento (prompt compilado é constant-size)
- 87-98% de qualidade vs frontier in-context; gap fecha ao escalar para 8B
- Local inference: 2.8× mais rápido em insurance task
- Casos: travel booking (14 nodes), Zoom support (14 nodes + product knowledge), insurance claims (55 nodes, 6 decision hubs)
- Prior work: SimpleTOD, FireAct, SynTOD, WorkflowLLM, Agent Lumos — todos validaram a técnica

## Exemplos e evidências
- Travel: 3B compiled vs 3B in-context → vence em 4/5 métricas
- Insurance: 55-node workflow, 8B compiled ≈ frontier LangGraph orquestrador
- Cost: compiled $0.X vs frontier in-context $0.Y → 128-462× diferença
- Latency: 2.8× mais rápido (inference local)

## Implicações para o vault
Valida estratégia de "distilação de workflows em skills/agents especializados". Sugere que agentes do vault (nexus, guard, etc.) poderiam ser compilados em modelos menores para reduzir custo operacional. Contradiz paradigma dominante de "sempre use modelo maior com orquestração".

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/fine-tuning]]
- [[03-RESOURCES/concepts/agent-systems/workflow-compilation]]
- [[03-RESOURCES/sources/token-economy-cost/how-anthropic-engineers-save-tokens]]
