---
title: OpenClaw Personal AI Assistant
type: entity
category: tool / open-source framework
tags: [personal-assistant, open-source, multi-channel, voice, local-first, nodejs]
created: 2026-05-09
updated: 2026-05-19
---

# OpenClaw Personal AI Assistant

GitHub: [github.com/openclaw/openclaw](https://github.com/openclaw/openclaw)
Website: [openclaw.ai](https://openclaw.ai/) | Docs: [docs.openclaw.ai](https://docs.openclaw.ai/)
Skills registry: [ClawHub](https://clawhub.ai/)

> [!note] Disambiguação
> Este é o projeto `openclaw/openclaw` — assistente AI pessoal multi-canal. Diferente de [[03-RESOURCES/entities/OpenClaw]] (agente de crypto trading).

Assistente AI pessoal que roda nos próprios dispositivos do usuário e responde nos canais de mensagens já usados. Tagline: "The lobster way."

## Canais suportados

WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, iMessage, IRC, Microsoft Teams, Matrix, Feishu, LINE, Mattermost, Nextcloud Talk, Nostr, Synology Chat, Tlon, Twitch, Zalo, WeChat, QQ, WebChat + macOS/iOS/Android (voz).

## Instalação

```bash
# Requer Node 24 (recomendado) ou Node 22.16+
npm install -g openclaw@latest
openclaw onboard --install-daemon
```

`openclaw onboard` guia passo-a-passo pelo setup de gateway, workspace, canais e skills. Instala daemon (launchd/systemd user service) para manter o gateway rodando.

## Arquitetura

- **Gateway** — plano de controle: sessões, canais, tools, eventos. Porta padrão: 18789.
- **Multi-agent routing** — canais/contas/peers roteados para agentes isolados (workspaces + sessões por agente)
- **Skills** — via [ClawHub](https://clawhub.ai/); onboarding-driven setup com skills gerenciadas por workspace

## Highlights

- **Voice Wake + Talk Mode** — wake words no macOS/iOS; voz contínua no Android (ElevenLabs + TTS fallback)
- **Live Canvas** — workspace visual controlado pelo agente com A2UI
- **Companion apps** — macOS menu bar app + nodes iOS/Android
- **Cron jobs + Webhooks + Gmail Pub/Sub** — automação nativa

## Modelo de segurança

- Default: tools rodam no host para sessão `main` (acesso completo quando é só o usuário)
- DM pairing: senders desconhecidos recebem código de pareamento; nunca processa sem aprovação
- Sandbox mode para sessões não-main: Docker (padrão), SSH ou OpenShell

## Comandos rápidos

```bash
openclaw gateway --port 18789 --verbose
openclaw agent --message "Ship checklist" --thinking high
openclaw pairing approve <channel> <code>
openclaw doctor   # verifica configs e políticas de DM
```

Chat: `/status`, `/new`, `/reset`, `/compact`, `/think <level>`, `/usage off|tokens|full`

## Patrocinadores

OpenAI, GitHub, NVIDIA, Vercel, Blacksmith, Convex.

## Relação com o vault

- Convergente com a arquitetura de [[03-RESOURCES/entities/OpenClaw]] (crypto) no nome mas produto distinto
- Relacionado a padrões de [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- Modelo de skills/workspace análogo a [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]

## Fonte

- [[03-RESOURCES/sources/open-source-ecosystems/openclaw-personal-ai-assistant]]
