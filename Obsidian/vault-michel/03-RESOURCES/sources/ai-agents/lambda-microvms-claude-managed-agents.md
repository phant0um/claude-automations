---
title: "Using Lambda MicroVMs as Sandbox for Claude Managed Agents"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://docs.aws.amazon.com/lambda/latest/dg/microvms-integrations-claude-managed-agents.html"
author: "AWS Lambda Docs"
grade: B
tags: [aws, lambda, microvm, claude, sandbox, security, agent, source]
---

# Lambda MicroVMs as Sandbox for Claude Managed Agents

**Tese central**: AWS Lambda MicroVMs como managed sandbox provider para Claude Managed Agents. Anthropic hospeda o agent loop e Claude model; a Lambda MicroVM é onde tool calls rodam. Você controla o execution environment — o que está instalado, network access, recursos.

## Arquitetura

1. Session ativa → Anthropic envia `session.status_run_started` webhook
2. Launcher Lambda verifica signature → chama `RunMicroVM`
3. MicroVM claima session, executa tool calls (bash, read, write, edit, glob, grep) em `/workspace`
4. MicroVM suspended/terminated quando session ends

## Key properties

| Property | Benefit |
|----------|---------|
| Firecracker isolation | Hardware-virtualized boundary per session |
| Snapshot boot | Sub-second to single-digit seconds |
| IAM via IMDSv2 | Short-term, least privilege |
| Stateful duration | Up to 8 hours |
| Pay-per-session | Billing ends when session completes |

## Security model

- Anthropic API key never reaches AWS compute
- Launcher passa AWS Secrets Manager reference, MicroVM lê at runtime
- VPC egress connector para private resources

## Por que importa para o vault

- **Sandbox pattern**: tool calls isolados do agent loop — equivalente ao vault onde agents rodam em context separado do usuário
- **Firecracker isolation**: cada session é isolada — modelo para multi-session agent runs
- **Pay-per-session**: economic model relevante para cost budget do pipeline-semanal

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-sandbox-pattern]]
- [[04-SYSTEM/agents/core/guard]]
- [[03-RESOURCES/concepts/ai-agents/agent-loop-pattern]]