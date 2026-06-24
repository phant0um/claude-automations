---
title: "Using Lambda MicroVMs as a sandbox for Claude Managed Agents"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://docs.aws.amazon.com/lambda/latest/dg/microvms-integrations-claude-managed-agents.html"
author: "AWS Lambda Docs"
published: 2026-06-23
grade: B
tags: [articles, aws, lambda, microvm, claude, sandbox, security, firecracker, agent, source]
---

# Using Lambda MicroVMs as a sandbox for Claude Managed Agents

**Tese central**: AWS Lambda MicroVMs é um managed sandbox provider em self-hosted sandboxes para Claude Managed Agents. Anthropic hospeda o agent loop e Claude model; a Lambda MicroVM é onde tool calls rodam. Você controla o execution environment — o que está instalado, network access, recursos que agent pode reachar.

## Como funciona

Cada MicroVM é uma Firecracker-isolated virtual machine com snapshot-based sub-second startup, roda por até 8 hours, e pode ser terminada quando session ends. Sessions nunca share state. Security boundary de VM com operational model de serverless — no clusters to manage, no idle capacity to pay for.

### Control plane flow
1. Session reaches running state → Anthropic envia `session.status_run_started` webhook para endpoint na sua account
2. Launcher Lambda function verifica webhook signature, chama `RunMicroVM`
3. Code no MicroVM claims a session, executa tool calls (bash, read, write, edit, glob, grep) em `/workspace`, posta results back para Anthropic
4. MicroVM suspended ou terminated quando session ends

**Security**: Anthropic organization API key nunca reacha AWS compute. Launcher só passa AWS Secrets Manager reference para Anthropic environment key; MicroVM's execution role permite code ler at runtime.

## Key properties

| Property | Benefit |
|----------|---------|
| Firecracker isolation | Hardware-virtualized boundary per session |
| Snapshot-based boot | Resume from Firecracker snapshot em sub-second to single-digit seconds |
| IAM via IMDSv2 | Short-term, least privilege credentials |
| Stateful duration | Up to 8 hours com full disk e memory access |
| Pay-per-session | MicroVMs terminated quando sessions complete — ends billing |

## Prerequisites

- AWS account com permissions para Amazon S3, IAM, Secrets Manager, AWS WAF, Lambda, e Lambda MicroVMs
- Claude Managed Agents agent com `self_hosted` environment
- Environment key e webhook signing secret do Claude Console

## Deploying the reference implementation

Reference repo: [Claude Managed Agents Self-Hosted Sandboxes on Lambda MicroVMs](https://github.com/aws-samples/sample-lambda-microvm-claude-managed-agents)

Inclui:
- CloudFormation stack (API Gateway, launcher Lambda, Secrets Manager secrets, S3 bucket, IAM roles)
- MicroVM image (`Dockerfile`, Node.js EnvironmentWorker, lifecycle hooks)
- Deploy script e verification script

### Deployment steps
1. Deploy CloudFormation stack
2. Store environment key e signing secret nos created Secrets Manager secrets
3. Build MicroVM image
4. Register stack's webhook URL no Claude Console
5. Verify criando uma session

## Networking

Lambda MicroVMs têm public internet access por default — no configuration needed para reachar `api.anthropic.com`.

Para private resources (Amazon Aurora, ElastiCache) ou network restrictions: attach VPC egress connector at launch time. See Working with egress network connectors.

## Idle policy

Para per-session MicroVMs: `suspendedDurationSeconds: 0` e `autoResumeEnabled: false`. `maximumDurationInSeconds` como ceiling para stuck sessions (max 28,800 s).

```json
{
  "maxIdleDurationSeconds": 120,
  "suspendedDurationSeconds": 0,
  "autoResumeEnabled": false
}
```

## Monitoring

**Application logs** — CloudWatch Logs:
```bash
aws logs tail /aws/lambda-microvms/claude-worker --follow
```

**Running MicroVMs** — list na account:
```bash
aws lambda-microvms list-microvms \
  --image-identifier claude-worker \
  --query 'items[].[microvmId,state,startedAt]' --output table
```

## Troubleshooting

| Symptom | Cause |
|---------|-------|
| Webhook returns 401 | Signing secret mismatch ou stale delivery |
| No MicroVM launches | Webhook not registered for `session.status_run_started`, ou launcher Lambda execution role missing `RunMicroVM` permission |
| MicroVM terminates immediately | `/run` hook timeout — raise `runTimeoutInSeconds` |
| Worker exits immediately | Outbound HTTPS to `api.anthropic.com` blocked |
| Image build fails `S3_*` | Build role ou bucket misconfiguration |

## Por que importa para o vault

- **Sandbox pattern**: tool calls isolados do agent loop — Anthropic hospeda agent + model, AWS hospeda execution. Equivalente ao vault onde agents rodam em context separado do usuário
- **Firecracker isolation per session**: cada session é isolada, hardware-virtualized boundary — modelo para multi-session agent runs com garantia de não-leakage de state
- **Pay-per-session**: economic model relevante para cost budget do pipeline-semanal — billing ends quando session completa
- **Self-hosted sandbox spec**: Anthropic define spec, AWS implementa — pattern de standard spec + managed provider que pode apply a outros agent platforms
- **Secrets Manager reference, not raw key**: API key nunca reacha compute launcher, só reference — security best practice para agent credentials
- **Webhook-driven lifecycle**: session events triggeram MicroVM launch/suspend/terminate — event-driven agent execution model
- **VPC egress connector**: network isolation optional via connector at launch — modelo para agents que precisam reachar private resources
- **8-hour stateful duration**: sessions longas com full disk e memory — habilita agents que precisam de estado persistente durante execução

## Links

- [[03-RESOURCES/sources/ai-agents/lambda-microvms-claude-managed-agents]]
- [[03-RESOURCES/sources/ai-agents/new-in-amazon-bedrock-agentcore]]
- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[04-SYSTEM/agents/core/guard]]