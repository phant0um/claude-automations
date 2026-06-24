---
title: Eve
type: entity
entity_type: framework
created: 2026-06-19
updated: 2026-06-19
related: [[03-RESOURCES/entities/Vercel]]
tags: [ai-agents, framework, vercel, open-source]
---

# Eve

Framework open-source da Vercel pra construir, rodar e escalar agentes. Em public preview. Princípio central: **agente = diretório de arquivos**, não código imperativo central.

## Estrutura de um agente

```
my-agent/
  agent.ts        # modelo
  instructions.md  # identidade, "standing rules" prependadas a toda chamada
  tools/           # o que pode fazer
  skills/          # o que sabe
  subagents/       # a quem delega
  channels/        # onde vive (ex: Slack)
  schedules/       # quando age por conta própria
```

Mínimo funcional: 2 arquivos (modelo + instructions). Adicionar tool/skill/channel/schedule = adicionar arquivo — eve detecta em build time, sem registro manual.

## Características

- Convenção sobre configuração (mesmo princípio de Claude Code skills/.claude/agents)
- Produção embutida por padrão: execução durável, compute sandboxed, aprovações human-in-the-loop, sub-agentes, evals
- Scaffold: `npx eve@latest init my-agent` (<1min, dev server local)
- Deploy: `vercel deploy` — mesmo projeto Vercel normal, sem infra separada
- Vercel usa eve internamente pros próprios agentes

## Relacionado

- [[03-RESOURCES/entities/Vercel]] — empresa criadora
- [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]] — mesmo padrão "agente declarativo em arquivo"
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]
- [[03-RESOURCES/sources/introducing-eve-open-source-agent-framework]]
