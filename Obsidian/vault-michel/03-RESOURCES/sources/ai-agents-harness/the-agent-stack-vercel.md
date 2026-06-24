---
title: "The Agent Stack (Vercel)"
type: source
source: "https://vercel.com/blog/agent-stack"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, vercel, agent-stack, ai-sdk, ai-gateway, sandbox, workflow-sdk]
---

## Tese Central

Vercel's Agent Stack fornece todos os building blocks para criar e shipar production-grade agents. Todo agent precisa de três capabilities core: conectar a models e rotear entre eles, rodar workflows multi-step, e conectar a systems que os tornam úteis. O Agent Stack entrega AI SDK + AI Gateway (models), Workflow SDK + Vercel Sandbox (workflows), Vercel Connect + Chat SDK (data/tools/users).

## Pontos-Chave

1. **Connect to models**: AI SDK é single interface para qualquer model (platform/framework/model agnostic). AI Gateway é "CDN for tokens" — rota calls através de single endpoint, failover quando provider cai, tracks cost/usage. Pay provider's price sem markup, use suas próprias keys.
2. **Execute complex workflows**: Workflow SDK checkpointa cada step, mantém state, retrya falhas, pausa para esperar pessoa/API/webhook. Runs resume do last good step. Vercel Sandbox dá cada agent seu próprio microVM (full Linux, filesystem, Docker, kernel próprio) isolado do host. Credentials injetados só quando agent code chama serviço.
3. **Connect to data and tools**: Vercel Connect dá scoped, short-lived access — agent mints token per task scoped apenas às permissions explicitamente granted. Every action traces user→agent→service. Chat SDK ships agents nos apps onde users já estão (Slack, GitHub, Linear, WhatsApp, Discord).
4. **SERHANT. case**: Roda três models de single key — market analysis para Claude, marketing copy para GPT, image gen para Gemini.
5. **FLORA case**: Creative agent em Workflow SDK — single session fan-out across 50+ image models, cada step persiste e retrya.

## Conceitos

- **AI Gateway**: CDN for tokens — rota calls, failover, tracks cost across providers
- **Workflow SDK**: checkpoints cada step, durável, resume do last good step
- **Vercel Sandbox**: microVM isolado por agent com filesystem, Docker, kernel próprio
- **Vercel Connect**: short-lived scoped credentials per task, audit trail user→agent→service
- **Chat SDK**: ships agents em múltiplas plataformas onde users já estão

## Links

- [[03-RESOURCES/entities/Vercel]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-platform-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-security]]