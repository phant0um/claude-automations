---
title: Coordination Layer (LLM Multi-Agent)
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-19
tags: [multi-agent, coordination, architecture, llm, orchestration, declarative]
---

# Coordination Layer (LLM Multi-Agent)

Proposta de [[03-RESOURCES/sources/ai-agents-harness/coordination-architectural-layer-multi-agent-prediction-markets|Nechepurenko & Shuvalov 2026]]: tratar a coordenação de sistemas multi-agente LLM como uma **camada arquitetural configurável**, separável da lógica dos agentes e do acesso a informação.

## Três camadas

1. **Information layer** — ferramentas, contexto recuperado, sensores externos
2. **Coordination layer C** — especificação estrutural de como agentes interagem
3. **Agent layer** — chamada LLM por agente + prompt de papel

## Especificação mínima da camada C (7 elementos)

| Elemento | Descrição |
|---|---|
| Agent endpoints | Nome + schema de input/output por agente |
| Communication topology | Grafo direcionado de fluxos de mensagens |
| Authority distribution | Quem decide o quê; operadores de agregação |
| Synchronization regime | Event-driven / round-based / asynchronous |
| Aggregation rules | Mean, median, log-pooling, hierarchical-select, etc. |
| Termination conditions | Max rounds, convergence threshold, budget |
| Failure handling | Retry, fallback, exclude-and-continue, abort |

## O que a separação habilita

- **Rastreabilidade de decisão** — cada output atribuível a agente + delegação específica
- **Assinaturas de failure mode** — cada configuração induz pathways de erro previsíveis (ver [[03-RESOURCES/concepts/learning-cognition/murphy-decomposition]])
- **Comparabilidade cross-system** — variar C com agentes fixos; variar agentes com C fixo
- **Heterogeneidade especificável** — papéis com diferentes tool access, content policies, latências

## Cinco configurações de referência

| Config | Centralização | Info sharing | Pareto status (n=100) |
|---|---|---|---|
| Independent ensemble | Baixa | Nenhuma | Frontier (cost-sensitive) |
| Peer-critique debate | Baixa | Total | Dominated |
| Orchestrator-specialist | Alta | Via orquestrador | Dominated |
| Sequential pipeline | Média | Upstream-only | Frontier (quality-sensitive) |
| Consensus alignment | Baixa | Total + convergência | Dominated (tracks market) |

## Conexões

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/learning-cognition/murphy-decomposition]]
- [[03-RESOURCES/concepts/finance-trading/prediction-markets]]
- [[03-RESOURCES/sources/ai-agents-harness/coordination-architectural-layer-multi-agent-prediction-markets]]
