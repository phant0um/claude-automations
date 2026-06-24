---
title: "Runtime Architecture Patterns & SDB"
type: concept
status: developing
created: 2026-05-28
updated: 2026-05-28
tags: [concept, ai-agents, harness-engineering, runtime-patterns, stochastic-deterministic, distributed-systems]
aliases: [SDB, stochastic-deterministic-boundary, runtime-patterns-llm]
---

# Runtime Architecture Patterns & SDB

## Definição

O **Stochastic-Deterministic Boundary (SDB)** é o contrato load-bearing de qualquer runtime de agente de produção: um contrato de quatro partes entre **proposer**, **verifier**, **commit step** e **reject signal** que especifica como um output de LLM se torna uma ação do sistema.

> Sistemas sem SDB explícito têm falhas difíceis de diagnosticar porque não há contrato que possa ser violado.

O design de runtimes de agentes organiza-se em torno de três concerns:
- **Coordination**: como o agente delega e recebe trabalho
- **State**: como o estado persiste e é compartilhado
- **Control**: quando avançar, pausar ou reverter

---

## Os Seis Padrões de Runtime

| Padrão | Adequado para | SDB key |
|--------|---------------|---------|
| **Hierarchical delegation** | Conversational agents com sub-tarefas | Proposer = agente mestre; verifier = sub-agente |
| **Scatter-gather + saga** | Processamento paralelo com compensações | Fan-out proposals; transações compensatórias como reject signal |
| **Event-driven sequencing** | Pipelines de longa duração | Eventos determinísticos como commit steps |
| **Shared state machine** | Coordenação entre múltiplos agentes | Estado compartilhado como verifier implícito |
| **Supervisor + gate** | Agentes autônomos com risco | Gate explícito antes de commit |
| **Human in the loop** | Decisões de alto custo irreversível | Humano como verifier final |

---

## Metodologia de Cinco Passos

1. Caracterizar o workload (horizonte temporal, reversibilidade, paralelismo)
2. Mapear mecanismos de falha prováveis para o workload
3. Escolher o padrão primário
4. Compor padrões se necessário (e.g., supervisor + gate dentro de scatter-gather)
5. Validar o SDB resultante: contrato explícito proposer/verifier/commit/reject?

---

## Replay Divergence

Nova classe de falha exclusiva de agentes: consumidores LLM de um log de eventos **determinístico** produzem outputs diferentes sob mudanças de versão de modelo ou prompt.

**Causa**: event-driven agents assumem que re-processar o mesmo log produz o mesmo resultado — válido para workers determinísticos, inválido para LLMs.

**Implicação de design**: agentes event-driven precisam de snapshots versionados do estado LLM (model version + prompt), não apenas do estado do sistema.

---

## Decomposição de Confiabilidade

```
R_total = R_model_per_call × R_architectural_momentum
```

À medida que a variância do modelo diminui (melhores modelos), `R_architectural_momentum` torna-se a alavanca dominante para confiabilidade de longo prazo. A escolha do padrão e a força do SDB importam mais, não menos, com modelos melhores.

---

## Relação com Outros Conceitos

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — SDB é o primitivo que o harness implementa
- [[03-RESOURCES/concepts/agent-systems/agentic-patterns]] — padrões de alto nível; SDB é a estrutura de baixo nível
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]] — implementa hierarchical delegation pattern
- [[03-RESOURCES/concepts/agent-systems/agent-error-correction]] — reject signal ativa correction loop

---

## Fontes

- [[03-RESOURCES/sources/ai-agents-harness/runtime-architecture-patterns-srinivasan-2026]] — Srinivasan, arXiv 2605.20173 (2026-05-19)
