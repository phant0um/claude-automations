---
title: Agent Sandbox Pattern
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, sandbox, security, isolation]
---

# Agent Sandbox Pattern

Isolar tool calls do agent loop. O agent (LLM + loop) roda em infraestrutura do provider; as tool calls rodam em sandbox que você controla.

## Princípio

- Provider hospeda agent loop e modelo
- Sandbox hospeda execução de tool calls (bash, read, write, edit)
- Você controla: o que está instalado, network access, recursos acessíveis

## Lambda MicroVMs implementation

- Firecracker-isolated VM per session
- Snapshot-based boot: sub-second
- IAM via IMDSv2: short-term, least privilege
- Stateful até 8 horas
- Pay-per-session: billing ends when session completes
- API key nunca reacha AWS compute (Secrets Manager reference)

## Por que importa

- Security boundary de VM com operational model de serverless
- Sessions nunca shared state
- Tool calls isolados = prompt injection contido

## Evidências

- [[03-RESOURCES/sources/ai-agents/lambda-microvms-claude-managed-agents]] — AWS Lambda MicroVMs para Claude Managed Agents

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-loop-pattern]]
- [[04-SYSTEM/agents/core/guard]]