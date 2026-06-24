---
title: Agent Loop
type: concept
created: 2026-06-09
updated: 2026-06-09
tags: [agent-systems, agent-loops, orchestration, coding-agents, paradigm-shift]
status: active
---

# Agent Loop

**Definição concisa:** Um loop é um pequeno programa que prompta o agente de codificação, lê o que ele produziu, decide se está pronto e, se não, prompta novamente. O engenheiro para de ser a coisa dentro do loop e se torna o **autor do loop**. O modelo vira uma subrotina.

> *"cron plus a decision-maker in the body"* — @mvanhorn, 2026-06-08

A decisão de próxima ação pertence ao modelo, não a um branch hardcoded.

## Lineagem histórica (5 estágios)

| Stage | Ano | Característica |
|-------|-----|----------------|
| 1. ReAct while-loop | 2022 | Reason→Tool→Observe; humano observa |
| 2. AutoGPT | 2023 | Goal-prompted self-loop; girava infinitamente |
| 3. Ralph loop (Huntley) | Jul 2025 | Bash one-liner; contexto reiniciado a cada iteração; construiu linguagem por US$297 |
| 4. /goal command | Abr 2026 | Codex + Claude Code; loop até validador confirmar |
| 5. Orchestration loops | 2026 | Loops supervisionam outros loops; cron-scheduled; git-backed state |

Stages 1–3 são "old hat" na terminologia de @trashpandaemoji. Stage 5 é o que Steinberger e Cherny realmente descrevem.

## Quatro mudanças no Stage 5

1. **O loop como unidade de trabalho** — não a tarefa pontual
2. **Loops supervisionam outros loops** — concorrentemente e por agendamento
3. **Scheduling substitui o kickoff humano** — roda em infrastructure time, não na sua atenção
4. **Durabilidade explícita** — git-backed state, crash recovery (ralph assumia terminal aberto; 2026 assume que não)

## Loop vs. cron job

- Cron: script fixo. Loop: modelo decide a próxima ação a cada tick.
- Loop = cron + decision-maker no corpo.
- O que cron não tinha: o modelo lê estado atual, decide o que fazer, faz, verifica se funcionou, decide se continua.
- Stack múltiplos, dê a eles estado durável compartilhado, e você tem algo que cron não consegue expressar.

## O feedback é o que faz o loop funcionar

> *"An open loop that writes code with no feedback is a machine for generating confident mistakes."*

- A verificação end-to-end é o tip 5 de Boris Cherny — o mais importante e o mais ignorado.
- **roborev** (DanKornas): revisão de cada commit em background, fed back ao agente enquanto contexto está fresco.
- Loop sem feedback = while-true gerando confiança errada.

## O loop é agora o custo, não o modelo

> *"The costliest thing in AI coding is no longer writing code, it's managing the agent loop."* — @runes_leo

- Uber: US$1.500/pessoa/mês de cap por ferramenta após queimar orçamento anual em 4 meses.
- Três hard stops obrigatórios em produção:
  1. **Max iteration count**
  2. **No-progress detection**
  3. **Dollar/token budget ceiling**
- Sem guardrails: billing surprises "orders of magnitude over budget."
- Gartner: agentic AI no pico de expectativas infladas; ~17% de orgs em deployment real.

## Skills como ativo reutilizável

> *"The loop is plumbing. The asset is the skill it calls."*

- Loop sem skills reutilizáveis = while-true em torno de um estranho.
- Loop que chama biblioteca de skills nomeadas e testadas = sistema que **compõe e acumula valor**.
- Steinberger: se você faz algo mais de uma vez → skill; se você faz algo difícil → skill depois, para próxima vez ser grátis.

## Exemplos em produção

- **Boris Cherny** — 259 PRs em 30 dias (100% Claude Code); IDE deletado nov 2025; `/loop babysit all my PRs`
- **Gas Town** (Steve Yegge, Jan 2026) — 20–30 instâncias Claude Code + Mayor agent + patrol agents + estado em git. Open source: gastownhall/gastown
- **roborev** — loop de revisão contínua de commits

## Boris Cherny — 5 tips para Opus autônomo por horas

1. Auto mode (Claude não pede aprovação)
2. Dynamic workflows (Claude orquestra centenas/milhares de agentes)
3. `/goal` ou `/loop` para manter Claude rodando até conclusão
4. Claude Code na nuvem (pode fechar o laptop)
5. **Auto-verificação end-to-end do próprio trabalho** ← o que o hype pula

## Relação com o vault

- Arquitetura `04-SYSTEM/skills/` implementa o conceito de "skills como ativo reutilizável"
- Hard stops (budget ceiling, no-progress detection) devem guiar design de rotinas em `07-QUEUE/rotinas/`
- Pipeline diário do vault = stage 4/5: loop agendado (launchd/cron) com verificação de resultado

## Links

- [[03-RESOURCES/entities/Boris-Cherny]]
- [[03-RESOURCES/entities/Peter-Steinberger]]
- [[03-RESOURCES/sources/wtf-is-a-loop-steinberger-cherny]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/orchestration-mode-pattern]]
- [[03-RESOURCES/concepts/agent-systems/skill-authoring]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
</content>
</invoke>
## Evidências
- **[2026-06-19]** Loop de auto-correção de bugs: implementar → rodar testes → classificar tipo de erro → corrigir causa → repetir, cap de 5 tentativas, nunca enfraquecer o teste para passar — [[how-to-build-a-claude-code-agent-that-fixes-its-own-bugs-in-a-loop]]
- **[2026-06-19]** Loop = Claude + cron + intervalo; mudança mental de "o que prompto a seguir" para "que job deveria rodar sozinho" — [[03-RESOURCES/sources/how-to-set-up-claude-loops]]
- **[2026-06-22]** Loop = objetivo perseguido até concluir (Discover→Plan→Execute→Verify→Iterate); prompt = instrução única que sempre passa pelo humano. Verify e State são onde loops quebram na prática — [[03-RESOURCES/sources/i-spent-a-week-inside-ai-loops-prompting-is-dead-here-is-what-replaced-it]]
- **[2026-06-22]** Loop engineering aplicado a trading quant: 6 peças universais (automação, skill, state file, verifier, worktrees, connectors) mapeadas para estágios de um sistema autoaperfeiçoável de sinais — [[03-RESOURCES/sources/how-to-use-loop-engineering-to-build-a-self-improving-quant-trading-system]]
