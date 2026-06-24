---
title: "A Methodology for Selecting and Composing Runtime Architecture Patterns for Production LLM Agents"
type: source
source: "Clippings/A Methodology for Selecting and Composing Runtime Architecture Patterns for Production LLM Agents.md"
arxiv: "2605.20173"
author: ["Vasundra Srinivasan"]
created: 2026-05-19
ingested: 2026-05-28
tags: [ai-agents, source, runtime-patterns, harness-engineering, arxiv]
---

## Tese central

O **stochastic-deterministic boundary (SDB)** é o primitivo load-bearing de qualquer runtime de agente de produção: um contrato de quatro partes (proposer, verifier, commit step, reject signal) que especifica como um output de LLM se torna uma ação do sistema. O design de runtimes deve ser organizado em torno deste primitivo, não em torno do modelo.

## Argumentos principais

1. **SDB como contrato explícito.** A fronteira entre outputs estocásticos (LLM) e sistemas determinísticos (software) raramente é tratada como objeto arquitetural de primeira classe — este paper nomeia e formaliza essa fronteira.

2. **Três concerns de design.** Todo runtime de agente gira em torno de: **Coordination** (como o agente delega e recebe trabalho), **State** (como o estado persiste e é compartilhado), **Control** (como o sistema decide quando avançar, pausar ou reverter).

3. **Seis padrões de runtime.** Cada padrão compõe o SDB diferentemente:
   - **Hierarchical delegation** — agente mestre → sub-agentes; adequado para conversational agents
   - **Scatter-gather plus saga** — fan-out + fan-in com transações compensatórias; adequado para processamento paralelo
   - **Event-driven sequencing** — triggers assíncronos; adequado para pipelines de longa duração
   - **Shared state machine** — estado compartilhado com transições explícitas; coordenação entre agentes
   - **Supervisor plus gate** — supervisor verifica output antes de commit; adequado para agentes autônomos com risco
   - **Human in the loop** — inserção de aprovação humana como gate; adequado para decisões de alto custo

4. **Metodologia de cinco passos.** Para selecionar padrões: (1) caracterizar o workload, (2) mapear os mecanismos de falha prováveis, (3) escolher o padrão primário, (4) compor padrões se necessário, (5) validar o SDB resultante.

5. **Replay divergence.** Nova classe de falha: consumidores LLM de um log de eventos determinístico produzem outputs diferentes sob mudanças de versão de modelo ou prompt. Isso significa que agentes event-driven precisam de snapshots versionados do estado LLM, não apenas do estado do sistema.

6. **Decomposição de confiabilidade.** `R_total = R_model_per_call × R_architectural_momentum`. À medida que a variância do modelo diminui (melhores modelos), a escolha do padrão e a força do SDB tornam-se alavancas cada vez mais importantes para confiabilidade de longo prazo.

## Key insights

- O SDB é análogo a um contrato de API: torna explícito o que antes era implícito. Sistemas sem SDB explícito têm falhas difíceis de diagnosticar porque não há contrato que possa ser violado.
- A linhagem dos padrões vem de sistemas distribuídos (sagas, event sourcing, supervisors) — o que muda quando o worker é estocástico é que os contratos de idempotência e determinismo precisam ser renegociados.
- Aplicação a cinco workloads: contract-renewal agent (90 dias), document review, customer support, code review, financial audit. Cada workload ativa um subconjunto diferente dos seis padrões.

## Exemplos e evidências

- Implementação de referência executável: agente de renovação de contrato de 90 dias usando supervisor plus gate + human in the loop.
- Diagnóstico de falhas de produção mapeadas a fraquezas de padrão: e.g., agente event-driven sem snapshot de estado LLM → replay divergence.

## Implicações para o vault

- Enriquece [[03-RESOURCES/concepts/agent-systems/harness-engineering]] com vocabulário formal de SDB e seis padrões de runtime.
- Fornece a taxonomia de "três concerns" (Coordination/State/Control) que pode estruturar o design de novos agentes no vault.
- Complementa [[03-RESOURCES/concepts/agent-systems/agentic-patterns]] com padrões vindos da tradição de sistemas distribuídos.
- O conceito de **replay divergence** é novo no vault — agentes event-driven precisam de estratégia de versionamento de estado LLM.

## Links

- arxiv: https://arxiv.org/abs/2605.20173
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agentic-patterns]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- Conceito novo: [[03-RESOURCES/concepts/agent-systems/runtime-architecture-patterns-sdb]]
