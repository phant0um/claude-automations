---
title: "Agent Memory Architecture"
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, memory, architecture, procedural-memory]
---

# Agent Memory Architecture

## Definição

Sistemas de memória para agentes autônomos — como armazenar, recuperar, atualizar e esquecer informação ao longo de sessões. Não é apenas "persistência" — é controle de qualidade do que entra na memória, prevenção de contamination, e gestão de versões de conhecimento. A arquitetura de memória determina se o agente aprende ou degrada.

## Dimensões

1. **Procedural memory**: [[managing-procedural-memory-in-llm-agents-control-adaptation-and-evaluation]] — como agentes armazenam e adaptam procedimentos (skills, workflows). Controle = quem escreve, adaptation = como evolui, evaluation = como validar.

2. **Memory contagion**: [[memory-contagion-cross-temporal-propagation-of-evaluator-bias-via-agent-memory]] — bias de um evaluator propaga temporalmente via memória. Se um judge errado entra na memória, sessões futuras herdam o erro. O lado sombrio da memória persistente.

3. **Persistent memory para tools**: [[persistent-memory-for-the-vercel-ai-sdk-in-five-tools]] — 5 primitivas de memória para AI SDK. Tool-level persistence.

4. **Structural codebase index**: [[code-isnt-memory-a-structural-codebase-index-inside-a-coding-agentcode-and-data]] — o codebase como memória estrutural, não apenas contexto. Índice que substitui leitura linear.

5. **Memory capacity como bottleneck**: [[why-memory-capacity-is-the-real-performance-bottleneck-in-agentic-ai-workstations]] — memória é o bottleneck real de performance em workstations agentic, não compute.

## Insight

Memória tem dois lados: **controle** (gestão deliberada do que entra) e **vulnerabilidade** (contaminação que propaga). O vault-michel é literalmente um sistema de memória procedural para agentes — o que aprendemos sobre memory contagion se aplica ao próprio vault: se um concept errado entra, ele contamina 222 source pages via F2.5 absorption.

## Evidências

- **[2026-06-23]** Procedural memory management: control, adaptation, evaluation — [[managing-procedural-memory-in-llm-agents-control-adaptation-and-evaluation]]
- **[2026-06-23]** Memory contagion: evaluator bias propagates across temporal sessions — [[memory-contagion-cross-temporal-propagation-of-evaluator-bias-via-agent-memory]]
- **[2026-06-23]** Persistent memory for Vercel AI SDK: 5 tools — [[persistent-memory-for-the-vercel-ai-sdk-in-five-tools]]
- **[2026-06-23]** Codebase as structural memory index — [[code-isnt-memory-a-structural-codebase-index-inside-a-coding-agentcode-and-data]]
- **[2026-06-23]** Memory capacity is the real performance bottleneck — [[why-memory-capacity-is-the-real-performance-bottleneck-in-agentic-ai-workstations]]

## Links

- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/ai-agents/memory]]
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/memory-context-rag/rag-patterns]]