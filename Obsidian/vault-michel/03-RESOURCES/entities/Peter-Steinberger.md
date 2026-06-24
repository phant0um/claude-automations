---
title: Peter Steinberger
type: entity
categoria: pessoa
tags: [ai-agents, coding-agents, agent-loops, pspdfkit, developer]
created: 2026-06-09
updated: 2026-06-09
---

# Peter Steinberger

Developer and founder known for the **"stop prompting, start designing loops"** paradigm shift in AI-assisted coding (June 2026). Online handle: **@steipete**.

## Known for

- Tweet on June 7, 2026 that reached 2.2M views: *"Here's your monthly reminder that you shouldn't be prompting coding agents anymore. You should be designing loops that prompt your agents."*
- Recurring thesis: if you do something more than once, automate it as a **reusable skill**; if you do something hard, turn it into a skill afterward so next time is free.
- Runs loops that open pull requests across ~30 open-source repos while he sleeps.

## Core idea

The engineer transitions from being the entity *inside* the loop (typing prompts) to being the **author of the loop**. The model becomes a subroutine called by the loop, not the thing you interact with directly.

## Relationship to Boris Cherny

Steinberger and [[03-RESOURCES/entities/Boris-Cherny]] articulate the same paradigm from two sides: Steinberger frames it as a design principle for practitioners; Cherny demonstrates it as lived practice (259 PRs in 30 days, 100% written by Claude Code, IDE deleted since Nov 2025).

## Production loops (detailed examples)

| Loop | Descricao |
|------|-----------|
| Issue & PR reaper | Le vision.md, decide se o request encaixa, comenta/agrupa/fecha (semanal ou diario) |
| Maintainer report | Crawla Discord+issues+PRs, correlaciona queixas com trabalho aberto, despacha agentes em paralelo — community pain in, prioritized agent work out |
| Mantis (video proof) | PR → grava video do bug → corrige → grava video do fix → agente assiste o video para verificar, humano vê para mergar |
| Auto Review | Antes do commit, Codex chama Codex com contexto fresco, roda rounds de review ate limpo |

## Ferramentas construidas para dar autonomia ao agente

- **Crab Box** — maquinas Linux remotas para testes paralelos (testes locais ficaram lentos)
- **VNC setup** — agente abre browser real, tira screenshot, clica, reproduz bugs de UI sem intervencao humana
- **Fake messaging platform** — ambiente controlado para testes (CAPTCHAs bloqueavam servicos reais)

## Mecanismo de auto-evolucao de instrucoes

`agents.md` = invariantes comportamentais escritos pelo proprio agente para proximas sessoes. Quando um agente entende mal o projeto, nao lecionar no chat — escrever a regra. Periodicamente, pedir ao agente o que no arquivo esta confuso e limpar as contradicoes. **Agentes melhoram as instrucoes que controlam futuros agentes.**

## Sources

- [[03-RESOURCES/sources/wtf-is-a-loop-steinberger-cherny]]
- [[03-RESOURCES/sources/what-are-agent-loops-tutorial]]
</content>
</invoke>