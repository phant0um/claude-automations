---
title: "Symphony: Uma Especificação Open Source para Orquestração do Codex"
type: source
source: "Clippings/Uma especificação open source para orquestração do Codex Symphony..md"
author: "OpenAI"
published: 2026-03-07
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents-harness, codex, orchestration, open-source, spec-driven]
score: A
---

## Tese Central

Symphony é um orquestrador de agentes que transforma um issue tracker (Linear) em plano de controle para agentes de programação. Cada tarefa aberta recebe um agente, agentes rodam continuamente, humanos revisam resultados. Aumento de 500% (6x) em PRs concluídas em algumas equipes. É tecnicamente apenas um `SPEC.md` — uma definição do problema e solução pretendida.

## Pontos-Chave

1. **Gargalo identificado**: agents eram rápidos mas atenção humana era o bottleneck. 3-5 sessões simultâneas antes de troca de contexto ficar dolorosa. Engenheiros microgerenciando agents = não escala.
2. **Mudança de perspectiva**: parar de supervisionar agents diretamente, deixar puxarem trabalho do rastreador. Tickets/issues/tickets/marcos como unidades de trabalho, não sessões ou PRs.
3. **Linear como máquina de estados**: cada issue = workspace dedicado de agente. Symphony monitora continuamente, garante toda tarefa ativa tenha agente rodando. Se agente falhar, reinicia. Se trabalho novo surge, assume.
4. **DAG de dependências**: agentes só começam tarefas não bloqueadas. Execução desenrola naturalmente em paralelo. Atualização de React bloqueada por migração Vite — agentes esperam Vite concluir.
5. **Agentes criam trabalho**: percebem melhorias fora de escopo (perf, refatoração, arquitetura). Registram nova issue para avaliação posterior.
6. **Custo cognitivo reduzido**: trivial iniciar tarefas especulativas. Tente ideia, explore refatoração, descarte explorações que não agradam. PM e designer podem abrir solicitações diretamente — sem checkout, sem gerenciar sessão.
7. **Monorepo handling**: Symphony observa CI, faz rebase, resolve conflitos, tenta verificações instáveis. Ticket em Merging = alta confiança que entra no main sem babá.
8. **Goals > transições estritas**: primeiras versões tratavam agentes como nodes rígidos em máquina de estados. Modelos mais inteligentes que a caixa. Dê ferramentas e contexto, deixe fazer trabalho — como bom gerente atribui meta.
9. **SPEC.md**: Symphony é language-agnostic specification. Workflow Loader, Config Layer, Issue Tracker Client, Orchestrator, Workspace Manager, Agent Runner, Status Surface, Logging. 6 abstraction layers: Policy, Configuration, Coordination, Execution, Integration, Observability.

## Conceitos

- Issue tracker como plano de controle para agents
- WORKFLOW.md como repo-owned contract (prompt + runtime settings versioned com código)
- DAG de dependências entre tarefas
- Agentes criam trabalho emergente (novas issues)
- Goals vs transições estritas (modelos precisam de flexibilidade)
- SPEC.md como spec language-agnostic

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/sources/ai-agents-harness/harness-engineering-polymarket-trading-agent]]
- [[03-RESOURCES/sources/claude-code-cowork/criando-agentes-ia-tributaria-codex]]