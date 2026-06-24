---
title: Browser Skills para Agentes
type: concept
domain: agent-systems
created: 2026-05-28
updated: 2026-05-28
tags: [concept, agent-skills, browser-agent, memory, autobrowse]
---

# Browser Skills para Agentes

Padrão de memória persistente para browser agents. Em vez de re-descobrir cada site do zero a cada run, o agente converge em um caminho ótimo e o "gradua" para uma skill reutilizável.

## O Problema: Browser Agent Amnesia

Todo browser agent atual sofre de amnesia estrutural:

```
Open browser → explore → find element → click → parse → close → FORGET → repeat tomorrow
```

Custo real (benchmark Craigslist — Browse.sh):
- Generic agent loop: **~$0.22/run** — paga "discovery tax" toda vez
- Browse.sh skill graduada: **~$0.12/run** — 45% mais barato

A skill encoda o *shortest reliable path*: selectors exatos, gotchas, API endpoints ocultos, fallback strategies. Plain text que humanos leem e agentes executam.

## Solução: Skills como Memória

> "Reasoning has stopped being the constraint. Memory has become the bottleneck."
> — @kylejeong (Browserbase)

**Skill = SKILL.md + helper scripts**

Contém:
- Steps exatos para completar a task no site
- Selectors CSS/XPath válidos
- Endpoints de API descobertos por inspeção de rede
- Fallbacks para mudanças de layout
- Gotchas (CAPTCHAs, timeouts, rate limits)

## Browse.sh

Catálogo aberto de 100+ browser skills prontas:
- CLI: `npm i -g browse`
- Open source; agentes buscam, instalam e executam skills on demand
- **Autobrowse:** sistema que usa AI para iterar em tasks reais até convergir no caminho mais barato → skill gerada automaticamente para o catálogo

## Autobrowse — Graduação de Skills

Processo de geração automática de skills:

```
1. Agente tenta task N vezes com estratégias diferentes
2. Avalia custo × sucesso de cada tentativa
3. Path vencedor → graduado para SKILL.md
4. Skill publicada no catálogo Browse.sh
```

Analogia: agente aprende como humano aprende um site — com dificuldade no começo, mecanicamente depois.

## Relação com Agent Skills Standard

Skills de browser são extensão natural do padrão de agent skills (Claude Code, Codex CLI, OpenCode):
- Obsidian skills ([[03-RESOURCES/entities/kepano|kepano]]) = instrui agente sobre Obsidian
- Browser skills = instrui agente sobre websites específicos
- Mesmo primitivo: Markdown file lido no contexto antes da task

**Skills = memória externa persistente.** A diferença entre um agente de $0.22/run e um de $0.12/run é uma SKILL.md de 2KB.

## macOS Dual-Cursor

Padrão identificado: usar dois cursores/agentes em paralelo no macOS:
- Cursor A: agent com browser skill ativo → executa task na web
- Cursor B: agent no vault → processa/anota resultados

Permite pipeline assíncrono sem bloquear o agente principal.

## Relacionado

- [[03-RESOURCES/entities/kepano|kepano]] — obsidian-skills; mesmo padrão de skill-as-memory
- [[03-RESOURCES/concepts/agent-systems/harness-engineering|Harness Engineering]] — skills como camada de memória do harness
- [[03-RESOURCES/sources/ai-agents-harness/clipping-browsesh-browser-skills|Source — Browse.sh Browser Skills]]
- [[03-RESOURCES/sources/open-source-ecosystems/autobrowse-the-mythos-moment-for-browser-agents-is-here|Source — Autobrowse: Mythos Moment]]
