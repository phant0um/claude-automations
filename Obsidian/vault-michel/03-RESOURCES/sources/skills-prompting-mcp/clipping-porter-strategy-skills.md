---
title: "Porter Strategy Skills — 12 Competitive Analysis Skills"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, skills, agent-skills, competitive-strategy, porter, five-forces, business]
score: 6
author: "gnurio"
source_url: "https://github.com/gnurio/porter-strategy-skills"
domain: skills-prompting-mcp
---

# Porter Strategy Skills — 12 Competitive Analysis Skills

**gnurio/porter-strategy-skills**: 12 skills executáveis extraídas do *Competitive Strategy* de Michael Porter. Cada sub-fator, checklist e decision tree vem do texto original (verificado via NotebookLM).

## 12 Skills

**Tier 1 — Entry points:**
- `/analyze-five-forces` — 32 sub-factors (8 barreiras de entrada, 8 rivalry drivers, 7 buyer power, 6 supplier power, 3 substitute indicators), identifica força dominante, rate de profit potential
- `/profile-competitor` — 4-component profile (future goals, assumptions, current strategy, capabilities), gera response profile com predições de retaliation
- `/map-strategic-groups` — 13 strategic dimensions, mobility barriers, per-group rivalry analysis
- `/diagnose-industry-type` — classifica emerging/fragmented/mature/declining via 14 evolutionary processes de Porter, routes para skill certa

**Tier 2 — Build on Tier 1:**
- `/select-generic-strategy` — cost leadership, differentiation, focus; stuck-in-the-middle diagnostic
- `/plan-competitive-move` — commitment framework, retaliation predictions
- Plus 6 skills de casos especiais (industry-type playbooks)

## Orchestrator

```
/orchestrate-porter-strategy
```
Detecta o que você pede → routes para skill(s) corretas. Ou invoque diretamente:
```
/analyze-five-forces
/profile-competitor
```

## Ver Também

- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-directional-prompting]]
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-anatomy-claude-skill]]
