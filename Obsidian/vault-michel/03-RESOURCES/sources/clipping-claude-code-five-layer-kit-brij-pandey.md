---
title: "Claude Code: 5 Architectural Layers — Post by @LearnWithBrij"
type: source
source_type: social-media
platform: X/Twitter
author: "@LearnWithBrij"
source_url: "https://x.com/LearnWithBrij/status/2050803172793372769"
published: 2026-05-03
hash: 0ae9f55735145bb1df4b069ec2a51cb8
ingested: 2026-05-05
tags: [claude-code, agent-architecture, five-layers, CLAUDE.md, hooks, subagents, plugins, skills, social-media]
---

# Claude Code: 5 Architectural Layers — @LearnWithBrij

**Author:** [[03-RESOURCES/entities/Brij-Pandey]] (@LearnWithBrij)
**Source:** [X post, 2026-05-03](https://x.com/LearnWithBrij/status/2050803172793372769)

## Summary

O Claude Code possui 5 camadas arquiteturais que a maioria dos engenheiros ignora. Cada camada resolve um problema distinto que LLMs sozinhos não conseguem resolver. Quatro das cinco não têm nada a ver com prompting.

## The 5 Layers

| # | Layer | Role | Key Point |
|---|-------|------|-----------|
| 1 | **CLAUDE.md** | Memory Layer | Regras, convenções, mapa do repo — sempre carregado. A "constituição do agente". |
| 2 | **Skills** | Knowledge Layer | Cada SKILL.md carrega uma descrição; o Claude bifurca em subagente isolado sob demanda. Modular. |
| 3 | **Hooks** | Guardrails Layer | PreToolUse / PostToolUse / SessionStart / Stop — comandos de shell determinísticos e orientados a evento. |
| 4 | **Subagents** | Delegation Layer | Cada subagente tem sua própria janela de contexto, modelo, ferramentas e permissões. Sem recursão. |
| 5 | **Plugins** | Distribution Layer | Empacota habilidades + agentes + hooks + comandos. Uma instalação; toda a equipe herda o comportamento. |

**Envelope externo:**
- MCP Servers à esquerda (GitHub, DBs, APIs)
- Agent Teams à direita (execução paralela, passagem de mensagens, permissões compartilhadas)

## One-liner stack

> CLAUDE.md define regras → Skills fornecem expertise → Hooks aplicam qualidade → Subagentes delegam trabalho → Plugins distribuem para a equipe

## Key Insight

> "A maioria das falhas em produção em sistemas agênticos remete a uma camada ausente."

---

**See Also:**
- [[03-RESOURCES/concepts/claude-code-five-layer-architecture]]
- [[03-RESOURCES/concepts/claude-folder-anatomy]]
- [[03-RESOURCES/concepts/claude-hooks]]
- [[03-RESOURCES/concepts/claude-skills]]
- [[03-RESOURCES/concepts/subagent-spawning]]
- [[03-RESOURCES/concepts/claude-cowork-plugins]]
