---
title: "How to build your own agent harness???"
type: source
source: "Clippings/How to build your own agent harness？？？.md"
created: 2026-05-28
ingested: 2026-06-21
tags: [ai-agents, agent-harness-architecture]
---

## Tese central
A maioria dos times de agentes adota um harness monolítico (LangChain, CrewAI, AutoGen etc.) em vez de compor um — e isso é o motivo pelo qual todo time de agente de longa duração acaba reescrevendo o harness do zero. O harness não é uma coisa só: são 13-15 responsabilidades independentes (roteador de provider, vault de credenciais, policy engine, approval gate, catálogo de modelo, storage de sessão, budget tracker, hooks, loop de turno durável) que deveriam ser workers substituíveis conectados por um primitivo único, não um bloco único e indissociável.

## Argumentos principais
- As 13-15 responsabilidades de um harness de produção: aceitar/persistir turn request, resolver credenciais por provider, consultar capacidades do modelo escolhido, rodar a state machine por turno, servir corpos de skill, montar o system prompt, fazer streaming de tokens, checar cada tool call contra policy, pausar tool calls que precisam decisão humana, rastrear gasto por budget, rodar hooks pre/post tool call, persistir sessão como árvore ramificável (forks/resumes), compactar histórico quando contexto enche, emitir event stream, e correlacionar tracing (OpenTelemetry) por todo o turno.
- O erro estrutural dos frameworks existentes é empacotar essas responsabilidades como monolito com uma única versão de cada — quando o policy engine que você precisa não é o que o framework ships, trocar significa trocar o harness inteiro.
- A alternativa proposta (iii.dev) trata cada responsabilidade como worker independente, versionado, plugável, conectado por um único primitivo de trigger compartilhado (`iii.trigger()`) — "build your own" passa a significar "troque alguns workers", não "fork um framework inteiro".

## Key insights
- A lista de 15 responsabilidades é um checklist útil e direto para avaliar qualquer agent harness próprio (incluindo o `04-SYSTEM/agents/nexus-agent-system/`): persistência de sessão como árvore ramificável e compactação de contexto ao encher são duas responsabilidades raramente endereçadas explicitamente em specs de agentes mais simples.
- "Policy engine" e "approval gate" como workers separados e versionados independentemente é diretamente análogo aos tiers de autonomia já definidos no `CLAUDE.md` deste vault ("agir sem confirmação" vs "confirmar antes") — sugere que, se o Nexus crescer, vale desacoplar a lógica de aprovação da lógica de execução em módulos distintos.

## Exemplos e evidências
- Lista numerada completa das 15 responsabilidades, com stack real do harness iii (monorepo `iii-hq/workers`) como implementação de referência.

## Implicações para o vault
Framework mental útil para avaliar a maturidade do `04-SYSTEM/agents/nexus-agent-system/` — em particular, as responsabilidades "compactar histórico" e "persistir sessão como árvore" não são hoje endereçadas explicitamente nos specs de ingest-agent/report-agent/ledger.md; candidatas a melhoria futura se o pipeline crescer em duração de sessão.

## Links
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[04-SYSTEM/agents/nexus-agent-system/ingest-agent]]
