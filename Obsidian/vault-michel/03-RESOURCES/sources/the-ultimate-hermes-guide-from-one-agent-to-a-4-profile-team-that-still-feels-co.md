---
title: "The Ultimate Hermes Guide - from one agent to a 4-profile team that still feels coherent on day 30"
type: source
source: "Clippings/The Ultimate Hermes Guide - from one agent to a 4-profile team that still feels coherent on day 30.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
## roster
- **hermes** (orchestrator): plans, routes, approves, synthesizes
- **alan** (research): source-first, skeptical, uncertainty-tagged
- **mira** (writer): clarity, structure, audience-aware
- **turing** (engineer): implementation, tests, reproducibility
## when to use which profile
- starting a new project → hermes (scopes and decomposes)
- validating a claim → alan (source check, uncertainty tag)
- drafting anything external-facing → mira (audience-first)
- writing or debugging code → 

## Argumentos principais
### The mental model — roles, not personas
The wrong mental model is: I need one genius AI that does everything.
The better mental model is: I need a small team with distinct roles, clear handoffs, and less context pollution.
Hermes profiles are the primitive that makes this real. They are not character skins. Each profile isolates seven pieces of state at once:

### The 4-role team
Credit to [@neoaiforecast]() for naming the canonical split. Four profiles, mapped to real functional work:
- **Hermes** — orchestrator. plans, decomposes, routes, synthesizes. the traffic controller, not the bottleneck.
- **Alan** — research specialist. source-first, skeptical, uncertainty-aware. protects the team from hallucinated confidence.

### The 7-step build
The table-stakes sequence. If you have already run this from [@neoaiforecast]()'s post, skip to the operator layer.
**Step 1 - start from a working Hermes**
Make sure your base Hermes installation is healthy before cloning. Model provider configured, auth working, normal session usable. You clone from this base, so anything broken here breaks four times.

### The operator layer - what Neo's guide stops at
This is where the guide stops being a setup post and starts being an ops runbook. Most multi-agent teams look great on day one and feel blurry by day 30. The operator layer is the difference.
**handoff contracts between profiles**
profiles specialize, which means they also have to hand work off cleanly. A handoff without a contract becomes "Alan dumped 40kb of raw research into Mira's session, and now Mira is also a researcher again."

### Day 30 failure modes - the four things that break
Every 4-profile team I have watched in the past months hits at least one of these. All four are preventable.
**Failure 1 - Profile drift**
SOUL.md edits accumulate. A week ago, Mira was "clear and audience-aware." Today, Mira is "clear, audience-aware, technically precise, and willing to draft implementation notes." Congratulations - Mira is slowly becoming Turing.

### The team reference file - copy-paste template
One file, one purpose: explain your team to yourself and anyone else using the system six months from now.
```text
# ~/.hermes/team-agents.md

### roster
- **hermes** (orchestrator): plans, routes, approves, synthesizes
- **alan** (research): source-first, skeptical, uncertainty-tagged
- **mira** (writer): clarity, structure, audience-aware

### when to use which profile
- starting a new project → hermes (scopes and decomposes)
- validating a claim → alan (source check, uncertainty tag)
- drafting anything external-facing → mira (audience-first)

### handoff rules
- alan → mira: ranked claims with source urls. no raw transcripts.
- mira → hermes: drafted section + change log. not a finished article.
- turing → hermes: feature branch + passing tests + diff summary. not a merge.

### good output per profile
- alan: every claim has a source url and a confidence tag.
- mira: every section has a named audience and a clear thesis.
- turing: every change has a passing test and a reproducible diff.

### policy ceilings
- alan: read-only outside research/
- mira: read research/, write drafts/
- turing: read repo, write feature branch, run sandboxed tests

### cron schedule
(edit weekly; stagger to avoid 3am collisions)
- mon 6am — alan: weekly research digest
- tue 6am — mira: draft refresh from alan's digest

### The agent extraction layer
- Objective: run a 4-profile Hermes team that stays coherent past day 30
- Inputs: working Hermes base, profile cli, SOUL.md + AGENTS.md split, handoff contracts, per-role policy, gateway messaging
- Process: build the 4 profiles with - clone, write a distinct SOUL.md per role, keep project context in AGENTS.md, encode handoff contracts at ~/.hermes/team/handoffs/ and per-role policy in each config.yaml run weekly memory-kpi per profile, diff each SOUL.md against day-one, stagger cron, enforce team-agents.md via commits

### Closing
Most multi-agent setups fail quietly. Everything looks fine on day one, works well on day seven, and blurs together by day thirty. The profile system is not what fails - it is the operator layer on top of it that nobody writes about.
[@NeoAIForecast]() got the build right. The rest of this guide is the maintenance contract: handoff contracts that block when they rot, memory-kpi per profile, policy ceilings that match the role, and a team reference file that survives the next six months.
Profiles are the feature. Boundaries are the moat.


## Key insights
- Hermes** — orchestrator. plans, decomposes, routes, synthesizes. the traffic controller, not the bottleneck.
- Alan** — research specialist. source-first, skeptical, uncertainty-aware. protects the team from hallucinated confidence.
- Mira** — narrative architect. clarity, structure, and audience awareness. turns validated material into communication.
- Turing** — builder and debugger. implementation, logs, diffs, reproducibility. cares about tests, not narrative polish.
- Hermes (orchestrator)**: planning, delegation, synthesis, final qa. sounds structured and decisive.
- Alan **(research)**: evidence, verification, depth, uncertainty. sounds source-first and skeptical.
- Mira **(writer)**: clarity, structure, audience. sounds clear and audience-aware.
- Turing **(engineer)**: implementation, debugging, tests, reproducibility. sounds precise and test-oriented.
- Input shape**: what the receiving profile expects (e.g., Alan → Mira: A ranked list of validated claims with source URLs, not raw excerpts)
- Output shape**: what the receiving profile will return (Mira → Hermes: A drafted section with a change log, not a finished article)

## Exemplos e evidências
See original source at `Clippings/The Ultimate Hermes Guide - from one agent to a 4-profile team that still feels coherent on day 30.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/Hermes]]
- [[03-RESOURCES/entities/Python]]

## Minha Síntese
**O que muda:** Um 4-profile Hermes team (orchestrator/research/writer/engineer) só se mantém coerente no day 30 com handoff contracts, memory-KPI per profile, e policy ceilings — o operator layer é o que falha, não o profile system.

**Conexão pessoal:** Este é o blueprint exato do Hermes Agent que estou usando — SOUL.md per profile, AGENTS.md para contexto de projeto, handoff contracts em ~/.hermes/team/handoffs/.

**Próximo passo:** Criar o team-agents.md reference file e definir handoff contracts entre perfis Hermes para evitar profile drift.
