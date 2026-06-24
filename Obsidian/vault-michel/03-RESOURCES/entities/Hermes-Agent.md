---
title: "Hermes Agent"
type: entity
category: tool
tags: [entity, tool, ai-agents, open-source, harness]
created: 2026-05-31
updated: 2026-06-01
---

# Hermes Agent

**GitHub:** github.com/NousResearch/hermes (140K+ stars)

Sistema de agente autônomo open-source criado por @kidpakerot e mantido pela NousResearch, com skill system, memória persistente e crons nativos — complementar ao Claude Code para uso on-the-go e automações agendadas.

## Contribuições relevantes

- 5 pilares: memory (`user.md` + `memory.md`), skills (91 built-in + 520+ community hub), soul (`soul.md`), crons (linguagem natural, sessão isolada), self-improving loop
- Deployment: Docker container por agente, VPS (Hostinger KVM2), Telegram como interface principal
- Comparação com Claude Code: Hermes é pocket-first + voice-first com crons nativos; Claude Code é para deep work no terminal
- Contexto persistente em `git`: skills + memory + soul portáveis entre qualquer agente
- Usado por @kidpakerot como context layer no stack de produção de vídeo

## Fontes no vault

- [[03-RESOURCES/sources/hermes-agent/hermes-agent-army-nateherk]] — arquitetura completa e deployment
- [[03-RESOURCES/sources/hermes-agent/clipping-kidpakerot-hermes-claude-higgsfield-viralbuilder-stack]] — Hermes como context/routing layer no stack de vídeo
