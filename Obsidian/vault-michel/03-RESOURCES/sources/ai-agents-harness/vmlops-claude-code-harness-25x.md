---
title: "@_vmlops — Claude Code Harness 25x: Plan→Work→Review Loop"
type: source
source_url: "https://x.com/_vmlops/status/2058587050140717278"
author: "@_vmlops"
published: 2026-05-24
ingested: 2026-05-28
tags: [harness, claude-code, go, guardrails, parallel-workers, plan-work-review, workflow]
---

# @_vmlops — Claude Code Harness 25x: Plan→Work→Review Loop

## Tese central

Um harness open-source envolve Claude Code em um ciclo estruturado Plan→Work→Review, com motor Go nativo (10ms vs 40-60ms Node), 13 guardrails para operações destrutivas, workers paralelos com auto-revisão e hook precompact para sessões longas.

## Key insights

- **Motor Go nativo:** substitui hooks do Node.js, passando de 40-60ms para 10ms de latência.
- **13 guardrail rules:** bloqueiam automaticamente operações destrutivas — `rm -rf`, force push, escritas de secrets.
- **Workers paralelos:** rodam simultaneamente, cada um com auto-revisão antes de passar o resultado.
- **Comando `/harness-work all`:** executa o loop completo (plano → implementar → revisar → commit) com um único comando.
- **Hook precompact:** previne que o Claude seja cortado no meio de uma tarefa durante sessões longas (contexto cheio).
- Instalação: 30 segundos.
- Claim de velocidade: 25x mais rápido que Claude Code "cru".

## Implicações para o vault

- O hook precompact resolve o problema de context rot em sessões longas — ver [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]].
- Os 13 guardrails são implementação concreta dos princípios de [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]].
- Workers paralelos com auto-revisão = padrão de [[03-RESOURCES/sources/ai-agents-harness/blader-adversarial-subagent-review-gate]] aplicado a harness.
- Complementa [[03-RESOURCES/sources/ai-agents-harness/claude-code-agent-harness-architecture]] e [[03-RESOURCES/sources/ai-agents-harness/agent-harness-breakdown-chinese]].

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]
