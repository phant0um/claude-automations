---
title: "How to build a 4-agent team, that ships a feature while you sleep (Exact Setup Inside)"
type: source
source: "Clippings/How to build a 4-agent team, that ships a feature while you sleep (Exact Setup Inside).md"
source_url: "https://x.com/zodchiii/status/2060674246880149900"
author: "@zodchiii"
published: 2026-05-30
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, ai-agents-harness, multi-agent, pipeline, subagents, planner-coder-tester-reviewer, handoff]
---

## Tese central

A diferença entre um monte de agentes e um pipeline é o handoff. Quatro especialistas escrevendo para arquivos compartilhados, um orquestrador rodando-os em ordem, cada estágio construindo sobre o anterior — e uma feature pode ser desenvolvida overnight sem supervisão humana contínua.

## Argumentos principais

- Um agente fazendo tudo preenche o context window com planning + code + tests + review notes até a qualidade cair; quatro especialistas ficam cada um em contexto limpo e estreito
- O handoff file é o mecanismo core: cada agente escreve output onde o próximo lê — `.pipeline/spec.md` → `.pipeline/changes.md` → `.pipeline/test-results.md` → `.pipeline/review.md`
- Agent 1 — Planner (opus): transforma feature request em spec concreta com files/paths, interfaces, edge cases, padrões a seguir; NUNCA escreve código; sinaliza OPEN QUESTIONS
- Agent 2 — Coder (sonnet): lê spec e implementa exatamente o descrito; para em OPEN QUESTIONS ao invés de adivinhar; não refactora fora do scope; escreve changes summary
- Agent 3 — Tester (sonnet): lê changes.md, escreve testes (happy path + edge cases da spec + ≥1 failure case), roda; em falha: escreve failures e PARA — não toca no código
- Agent 4 — Reviewer (opus): read-only (sem edit tools); lê spec+changes+results+git diff; veredito SHIP / NEEDS WORK / BLOCK; "green tests are not the same as correct behavior"
- Orquestrador como slash command `/ship`: invoca subagents em ordem, confirma existence do handoff file antes de cada próximo estágio, para em OPEN QUESTIONS ou test failures para input humano
- Model selection deliberada: opus para Planner e Reviewer (quality ceiling e last line of defense), sonnet para Coder e Tester (balanced cost-quality para trabalho bem especificado)
- Teamly como alternativa hosted: resolve handoff automaticamente via Coordinator, roda 24/7 em infraestrutura gerenciada, $29/mo para 5 agents

## Key insights

- "The difference between a pile of agents and a pipeline is the handoff." — definição precisa do problema
- Planner em opus porque "a vague spec produces vague code no matter how good the Coder is" — quality ceiling está na especificação
- Reviewer read-only por design: não pode papear problemas editando — só pode julgar; garante honestidade do veredito
- Build incremental recomendado: começar com Planner+Coder como dois estágios, só adicionar Tester e Reviewer quando o fluxo estiver sólido
- Comando final: `/ship add rate limiting to the login endpoint` — um trigger, quatro estágios, feature pronta de manhã
- Pipeline `.claude/agents/` + `.claude/commands/` é o padrão de composição de subagents para Claude Code

## Exemplos e evidências

- Agentes definidos como arquivos `.claude/agents/planner.md`, `coder.md`, `tester.md`, `reviewer.md` com frontmatter (name, description, tools, model)
- Planner tools: Read, Grep, Glob, Write (sem Bash — não executa código)
- Reviewer tools: Read, Grep, Glob, Bash (para git diff) — sem Write ou Edit
- Orquestrador em `.claude/commands/ship.md` com lógica sequencial explícita e checkpoints em cada handoff file
- Teamly: $29/mo para 5 agents, 3-day free trial, same handoff architecture com Coordinator automático

## Implicações para o vault

- Complementa e aprofunda [[03-RESOURCES/sources/ai-agents-harness/claude-code-agents-zodchiii]] (mesmo autor, @zodchiii)
- O padrão Planner→Coder→Tester→Reviewer é a instância mais concreta de pipeline de desenvolvimento agentic no vault — deve ser referenciado como template
- A distinção opus/sonnet por papel (especificação/julgamento vs. implementação/teste) alinha com e aprofunda as discussões de model selection do vault
- O conceito de "handoff file" como mecanismo de coordenação é análogo ao que o Hermes Kanban faz com tasks — dois paradigmas diferentes para o mesmo problema
- Pode criar conceito [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]] linkando este source com Hermes Kanban

## Links
- [[03-RESOURCES/entities/zodchiii]]
- [[03-RESOURCES/sources/ai-agents-harness/claude-code-agents-zodchiii]]
- [[03-RESOURCES/sources/hermes-agent/hermes-kanban-field-manual-tonysimons]]
- [[03-RESOURCES/concepts/agent-systems/]]
