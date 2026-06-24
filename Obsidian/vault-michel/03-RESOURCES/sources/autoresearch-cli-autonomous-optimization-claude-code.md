---
title: "autoresearch-cli: Autonomous no-human-in-the-loop optimization research for Claude Code"
type: source
source: Clippings/trotsky1997autoresearch-cli Autonomous no-human-in-the-loop optimization research for Claude Code.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, claude-code, autonomous-research, hooks, source, score-A]
---

## Tese central

autoresearch-cli é a camada de contrato que um agente Claude Code usa para rodar loops autônomos de otimização: o usuário states a need once, o agente frames em measurable target, roda experiment loop (try hypothesis, measure, keep wins, revert losses), e entrega reviewable branches. O CLI garante honest measurement — números vêm só de real execution, nunca do agente.

## Argumentos principais

- **Responsibility split**: agent-own (judgment: framing, hypothesis selection, result reading), cli-own (contract: honest measurement, keep→commit/loss→revert, checks gate), hooks-own (lifecycle: Stop blocks turn ending, SessionStart re-injects state, PreCompact guard)
- **Stop hook**: bloqueia o turno de terminar e empurra próxima iteração — o mecanismo real behind "never stop", não instruction de prompt
- **SessionStart hook**: re-injeta session state para fresh instance pick up relay após context reset
- **Numbers from real execution only**: o CLI faz a measurement, o agente não pode fabricar números
- **Reviewable branches**: cada win vira um branch reviewable, não merge automático

## Key insights

- Separar judgment (agent) de measurement (CLI) é fundamental — agentes não devem ser trusted com números que avaliam a si mesmos
- Stop hook como mecanismo de "never stop" é mais robusto que prompt instruction — código > prompt
- SessionStart hook resolve amnésia entre context resets — state lives on disk
- Experiment loop (hypothesis → measure → keep/revert) é o padrão core de autonomous improvement

## Exemplos e evidências

- npm install -g autoresearch-cli
- Commands: init (name, metric, direction), run (timeout), log (metric, status, metrics JSON), hook (stop/sessionstart/precompact)
- Claude Code lifecycle hooks: Stop, SessionStart, PreCompact
- skill/SKILL.md for agent integration

## Implicações para o vault

- Stop hook pattern é diretamente aplicável ao [[04-SYSTEM/agents/core/hill]] — em vez de prompt "continue improving", hook que bloqueia término
- SessionStart state injection conecta com [[03-RESOURCES/concepts/pkm-obsidian/self-rewrite-hooks]] e [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- Experiment loop (keep wins, revert losses) é o padrão que falta para hill-climbing sistemático no vault
- "Numbers from real execution only" é princípio que deveria aplicar ao pipeline-semanal: metrics de qualidade devem vir de verificação real, não auto-avaliação do agente

## Minha Síntese

**O que muda:** A separação agent-owns-judgment / CLI-owns-measurement é um design pattern que falta no vault. Atualmente o agente que faz o trabalho também avalia a qualidade. autoresearch-cli mostra como separar isto com um contract layer.

**Conexão pessoal:** O hill agent melhoraria significativamente com o pattern de Stop hook + experiment loop. Atualmente hill faz uma melhoria por run — com experiment loop, poderia fazer N iterações autônomas com keep/revert.

**Próximo passo:** Avaliar instalação de autoresearch-cli ou implementação do pattern Stop-hook + SessionStart-state para o hill agent. O conceito de "reviewable branches" para melhorias é superior ao commit direto atual.

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/pkm-obsidian/self-rewrite-hooks]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/concepts/agent-systems/observability-driven-evolution]]
- [[03-RESOURCES/entities/Claude]]