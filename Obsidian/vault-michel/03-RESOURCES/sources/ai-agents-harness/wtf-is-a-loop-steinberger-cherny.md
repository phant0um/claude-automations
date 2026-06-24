---
title: "WTF Is a Loop? Peter Steinberger vs. Boris Cherny"
type: source
source: "Clippings/WTF Is a Loop? Peter Steinberger vs. Boris Cherny.md"
author: "@mvanhorn"
published: 2026-06-08
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, agent-loops, coding-agents, paradigm-shift, orchestration]
status: ingested
score: A
---

# WTF Is a Loop? Peter Steinberger vs. Boris Cherny

## Tese central

A pergunta certa não é "qual modelo usar" mas "como projetar o loop que usa o modelo." O paradigma mudou de **prompting manual → loop autônomo**: o engenheiro deixa de ser o agente dentro do loop e passa a ser o **autor do loop**. O loop, não o modelo, é agora o recurso caro.

## Argumentos principais

1. **O tweet pivotal** — Peter Steinberger (@steipete), 7 jun 2026, 2,2 M views: *"You shouldn't be prompting coding agents anymore. You should be designing loops that prompt your agents."*
2. **A definição de Cherny** — Boris Cherny (Anthropic, criador do Claude Code) no Acquired Unplugged/WorkOS, 2 jun 2026: *"I don't prompt Claude anymore. I have loops that are running. My job is to write loops."*
3. **Três estágios de Cherny**: (a) escrevia código manualmente; (b) rodava 5–10 sessões Claude em paralelo e promptava cada uma; (c) hoje não prompta: escreve os loops que promptam Claude. Centenas de agentes leem seu GitHub/Slack/Twitter e decidem o que construir.
4. **Receita Cherny**: 100% dos seus commits nos últimos 30 dias foram escritos pelo Claude Code. 259 PRs abertos. Deletou o IDE em novembro de 2025.

## Key insights

### Cinco camadas históricas do "loop"

| Stage | Quando | O que era |
|-------|--------|-----------|
| 1. ReAct while-loop | 2022 | Reason → Tool → Observe; humano assiste |
| 2. AutoGPT | 2023 | Goal-prompted self-loop; famoso por girar sem parar |
| 3. Ralph loop (Huntley) | Jul 2025 | Bash one-liner; contexto reiniciado a cada iteração; construiu linguagem por US$297 |
| 4. /goal command | Abr 2026 | Codex + Claude Code: loop até validador confirmar tarefa |
| 5. Orchestration loops | 2026 | Loop como **unidade de trabalho**; loops supervisionam outros loops; cron-scheduled; git-backed state |

### Loop vs. cron job
- Cron roda script fixo. Loop roda **modelo que decide** a próxima ação a cada tick.
- Loop = cron + decision-maker no corpo.
- A parte interessante é o que envolve essa decisão: feedback, verificação, halt conditions.

### O loop só vale seu feedback
- "Feedback inside it is the magic." — open loops geram "confident mistakes."
- **roborev** (DanKornas): revisão de cada commit em background, fed back ao agente enquanto o contexto ainda está fresco.
- Steve Yegge's **Gas Town** (Jan 2026): 20–30 instâncias Claude Code + Mayor agent + patrol agents com estado em git. Open source.

### O loop agora é o custo

> *"The costliest thing in AI coding is no longer writing code, it's managing the agent loop."* — @runes_leo

- Uber: capou engenheiros em US$1.500/pessoa/mês por ferramenta (Claude Code + Cursor) após queimar orçamento anual de IA em 4 meses.
- Sem guardrails: loops infinitos e billing surprises.
- **Três hard stops obrigatórios:** (1) max iteration count; (2) no-progress detection; (3) dollar/token budget ceiling.
- Gartner: agentic AI no pico das expectativas infladas; apenas ~17% das orgs realmente deployando agentes.

### Skills > prompts

> *"The loop is plumbing. The asset is the skill it calls."* — @mvanhorn

- Steinberger: se você faz algo mais de uma vez, vire uma **skill** reutilizável.
- Loop sem skills reutilizáveis = while-true em torno de um estranho.
- Loop que chama uma biblioteca de skills nomeadas e testadas = sistema que **compõe**.

### Cinco dicas de Cherny para rodar Opus autônomo por horas

1. Auto mode para permissões (Claude não pede aprovação)
2. Dynamic workflows — Claude orquestra centenas/milhares de agentes
3. `/goal` ou `/loop` para manter Claude rodando até tarefa concluída
4. Claude Code na nuvem (fechar o laptop)
5. Claude deve ter mecanismo de **auto-verificar seu trabalho end-to-end**

## Exemplos e evidências

- `/loop babysit all my PRs. Auto-fix build issues, and when comments come in, use a worktree agent to fix them.` — comando canon de entrada de Cherny
- Gas Town (gastownhall/gastown): 20–30 instâncias coordenadas por Mayor agent
- roborev: loop de revisão de commits contínuo
- @rohit_jsfreaky: *"Every AI agent I shipped this year is a for-loop, an llm call, and a try/catch around the json parsing."*

## Implicações para o vault

- [[03-RESOURCES/concepts/agent-systems/agent-loop]] — conceito central novo; relacionar com harness-engineering
- O loop como unidade de trabalho reforça [[03-RESOURCES/concepts/agent-systems/harness-engineering]]: harness é o que segura, o loop é o que executa
- **Skills como ativo reutilizável** confirma a arquitetura existente de `04-SYSTEM/skills/`
- Hard stops (budget ceiling, no-progress detection) devem ser adicionados à filosofia de `04-SYSTEM/agents/`
- [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]: loop-bound é uma terceira categoria emergente (o custo é gerenciar o loop, não o modelo em si)

## Links

- [[03-RESOURCES/entities/Boris-Cherny]]
- [[03-RESOURCES/entities/Peter-Steinberger]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/orchestration-mode-pattern]]

## Ver tambem (loop engineering cluster)

- [[03-RESOURCES/sources/loop-engineering-14-step-roadmap]]
- [[03-RESOURCES/sources/what-are-agent-loops-tutorial]]
- [[03-RESOURCES/sources/design-loop-prompts-agent]]
- [[03-RESOURCES/sources/designing-loops-with-fable-5]]
- [[03-RESOURCES/sources/most-devs-dont-need-agent-loops-yet]]
