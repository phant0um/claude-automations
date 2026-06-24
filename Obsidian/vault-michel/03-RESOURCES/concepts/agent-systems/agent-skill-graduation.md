---
title: Agent Skill Graduation
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-19
tags: [browser-agents, skill-learning, memory, autobrowse, agentic]
---

# Agent Skill Graduation

The process of converting a **successful agent run** into a **durable, reusable skill artifact** — transforming one-off exploratory behavior into persistent, human-readable, executable knowledge.

## The Graduation Loop (Autobrowse)

1. Agent runs a real task end-to-end on a real site.
2. Agent studies its own trace: where did it stall, guess, over-spend?
3. Agent writes observations to `strategy.md` — what worked, what broke, what to try next.
4. On next iteration, `strategy.md` is read first — improvements compound, they don't reset.
5. Iteration continues until convergence (cost + turn count plateau over consecutive runs).
6. Winning approach is **graduated** into `SKILL.md` + helper files, pushed to a shared repo.

Capped at ~3-5 iterations; short-circuits aggressively. The goal is a reliable, cheap path — not a theoretical optimum.

## The Artifact — SKILL.md

```
SKILL.md = frontmatter (name, website, category, method, gotchas)
         + workflow steps (deterministic path)
         + site-specific gotchas discovered during iterations
         + helper files (Python parsers, CLI calls, selectors)
```

Key property: **same format whether written by a human or graduated by an agent**. Agents loading skills don't distinguish provenance.

## What Graduation Unlocks

- **Legibility:** non-engineers can read the agent's playbook.
- **Durability:** skill survives session close; persists across agents, teams, customers.
- **Economics:** discovery tax paid once; all subsequent runs use the graduated path.
- **Compounding:** each new site = one more skill; library grows, per-run cost falls.

## Craigslist Example

Traditional loop: ~$0.22, ~71s. Graduated skill: ~$0.12, 27s. Form-fill: $1.40 → $0.24/run in 4 iters.

## Failure Mode

Graduation is **wrong** for deterministic static HTML parsing. A 167-row static catalog cost $24 and 4 iterations before recognizing the regime mismatch. The correct solution was 200 lines of Python (sub-second, zero inference cost). Graduation only pays when the task genuinely requires exploration.

## Evidências

- **[2026-06-19]** Workflow inteiro de um swarm de 300 agentes (input format, passos, output format, regras de validação) capturado como Skill reutilizável — 1ª execução 20min, execuções seguintes 30s — [[03-RESOURCES/sources/self-improving-loop-300-agent-swarm-kimi]]
- **[2026-06-22]** PreAct formaliza graduação como máquina de estados verificada (não skill em texto): Verify-before-Store Gate impede que programa que "parece" ter terminado mas deixou tarefa inacabada entre no repositório, evitando degradação composta no reuso — [[03-RESOURCES/sources/preact-computer-using-agents-that-get-faster-on-repeated-tasks]]

- **[2026-06-22]** Skill de alpha research que grava lição a cada perda real (FOMC, drawdown setorial) como nova regra — mecanismo concreto de skill que evolui via casos reais — [[03-RESOURCES/sources/how-to-use-loop-engineering-to-build-a-self-improving-quant-trading-system]]

## Conexoes

- [[03-RESOURCES/entities/Autobrowse]] — implementacao de referencia
- [[03-RESOURCES/concepts/agent-systems/browser-agent-amnesia]] — problema que graduation resolve
- [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]] — campo academico paralelo (AWM, SkillWeaver, WebXSkill)
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — skills como artefato reutilizavel
- [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]] — inspiracao (Karpathy)
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — dinamica de acumulacao
- [[03-RESOURCES/sources/open-source-ecosystems/autobrowse-mythos-moment-browser-agents]]
