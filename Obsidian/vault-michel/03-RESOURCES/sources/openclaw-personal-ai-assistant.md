---
title: "OpenClaw — Personal AI Assistant (The Lobster Way)"
type: source
source_url: https://github.com/openclaw/openclaw
author: openclaw
published: 2026-05-09
ingested: 2026-05-09
tags: [personal-assistant, open-source, multi-channel, voice, local-first, nodejs, mcp]
---

# OpenClaw — Personal AI Assistant

GitHub: [openclaw/openclaw](https://github.com/openclaw/openclaw)
Tagline: "Your own personal AI assistant. Any OS. Any Platform. The lobster way."

> [!note] Disambiguação
> Este é o `openclaw/openclaw` — assistente pessoal multi-canal. Não confundir com [[03-RESOURCES/entities/OpenClaw]] (agente de crypto trading).

## Proposta

Assistente AI pessoal executado nos próprios dispositivos do usuário que responde nos canais de mensagens já utilizados — sem depender de um app centralizado. Gateway local como plano de controle; produto é o assistente.

## Instalação recomendada

```bash
npm install -g openclaw@latest   # ou pnpm/bun
openclaw onboard --install-daemon
```

Requer Node 24 (ou Node 22.16+). `openclaw onboard` cobre: gateway, workspace, canais, skills.

## Canais suportados (22+)

WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, iMessage, IRC, Microsoft Teams, Matrix, Feishu, LINE, Mattermost, Nextcloud Talk, Nostr, Synology Chat, Tlon, Twitch, Zalo, Zalo Personal, WeChat, QQ, WebChat.

Plataformas: macOS, iOS, Android.

## Capacidades principais

| Feature | Detalhe |
|---------|---------|
| Local-first Gateway | Porta 18789; plano de controle único |
| Multi-agent routing | Canais/contas → agentes isolados |
| Voice Wake | Wake words macOS/iOS; voz contínua Android |
| Live Canvas | Workspace visual com A2UI |
| Skills | Via ClawHub; onboarding-managed |
| Cron + Webhooks | Automação nativa |
| Gmail Pub/Sub | Integração email |

## Modelo de segurança

- Sessão `main`: tools com acesso completo ao host (usuário único)
- Non-main sessions: sandbox mode (Docker padrão; SSH/OpenShell disponíveis)
- DM pairing: senders desconhecidos recebem código de pareamento
- `openclaw doctor` — audita configurações e políticas de DM

## Patrocinadores

OpenAI, GitHub, NVIDIA, Vercel, Blacksmith, Convex.

## Relações

- [[03-RESOURCES/entities/OpenClaw-Assistant]] — página de entidade
- [[03-RESOURCES/entities/OpenClaw]] — produto diferente (crypto trading agent), mesmo nome de org
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — routing multi-agent nativo
