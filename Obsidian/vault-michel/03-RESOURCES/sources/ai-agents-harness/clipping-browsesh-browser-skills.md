---
title: "Browse.sh — Catalog of Browser Skills for Agents"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, ai-agents, browser-agent, skills, memory, agentskills]
score: 7
author: "@kylejeong (Browserbase)"
source_url: "https://x.com/kylejeong/status/2056487690175152601"
domain: ai-agents-harness
---

# Browse.sh — Catalog of Browser Skills for Agents

**@kylejeong** (Browserbase): catálogo aberto de 100+ browser skills. Um CLI command instala. Resolve browser agent amnesia.

## O Problema

Todo browser agent re-descobre cada site do zero a cada run. Open browser → poke around → find button → click → parse → close → **forget everything** → repeat tomorrow.

Custo na prática (benchmark Craigslist):
- Generic agent loop: ~$0.22/run — paga o "discovery tax" toda vez
- Browse.sh skill graduado: ~$0.12/run — **45% mais barato** porque skill encoda o shortest reliable path

## O Que é Browse.sh

1. **Catálogo** em browse.sh — search, preview, install skills para sites reais
2. **Browse CLI** (`npm i -g browse`) — open source, agents drive browsers, fetch pages, search web, load skills on demand

**Skill = markdown file (SKILL.md) + helper scripts**. Contém: steps exatos, gotchas, API endpoints, selectors, fallback strategies. Plain text que humanos leem e agentes executam.

## Princípio Chave

> "Reasoning has stopped being the constraint. Memory has become the bottleneck."

Skills são o novo primitivo. Claude Code ships com skills. Codex suporta. AgentSkills standard ganha tração. Browser skills = próximo passo natural para web messy (JS-rendered, hidden APIs, CAPTCHAs, redesigns).

## Autobrowse

Sistema que usa AI para iterar em tasks reais até convergir no path mais barato/rápido. Powers a geração de skills para o catálogo.

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-anatomy-claude-skill]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/clipping-kepano-obsidian-skills]]
