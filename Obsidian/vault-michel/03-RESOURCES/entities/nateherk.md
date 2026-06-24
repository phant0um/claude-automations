---
title: "nateherk"
type: entity
category: person
tags: [entity, person, claude-code, ai-agents, deployment]
created: 2026-05-31
updated: 2026-06-01
---

# nateherk

**Handle:** @nateherk (X/Twitter)

Criador de conteúdo sobre deployment de agentes Claude e arquitetura do Hermes Agent Army, com foco prático em como escalar agentes além da sessão local.

## Contribuições relevantes

- Framework WAT (Workflow + Agent + Tools) para escolher método de deployment de agentes Claude
- 3 métodos: Loop/cron (session-scoped) → MCP server (persistente) → Cloud/Modal (escalável)
- Distinção crítica: `/loop` morre quando Claude Code fecha; `/schedule` é infraestrutura real
- Guia completo "From Zero to Ultimate Hermes Agent Army": 5 pilares (memory, skills, soul, crons, self-improving loop) + deployment via Docker/VPS

## Fontes no vault

- [[03-RESOURCES/sources/ai-agents-harness/i-tested-3-ways-deploy-claude-agents-nateherk]] — framework WAT e 3 métodos de deployment
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-army-nateherk]] — arquitetura completa do Hermes Agent Army
