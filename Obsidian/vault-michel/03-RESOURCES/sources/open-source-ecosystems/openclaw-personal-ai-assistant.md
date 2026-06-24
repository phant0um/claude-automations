---
title: "OpenClaw — Personal AI Assistant (The Lobster Way)"
type: source
source_url: https://github.com/openclaw/openclaw
author: openclaw
published: 2026-05-09
ingested: 2026-05-09
tags: [personal-assistant, open-source, multi-channel, voice, local-first, nodejs, mcp]
triagem_score: 7
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

## Arquitetura Técnica em Detalhe

### Gateway Local (porta 18789)

O coração do OpenClaw é o gateway local — um servidor Node.js que roda nos dispositivos do usuário e age como plano de controle unificado. Toda comunicação entre canais e agentes passa por este gateway:

```
WhatsApp → [API do canal] → Gateway:18789 → [routing] → Agente específico
Telegram → [API do canal] → Gateway:18789 → [routing] → Agente específico
iMessage → [AppleScript/MCP] → Gateway:18789 → [routing] → Agente específico
```

**Por que local?** A alternativa (cloud gateway) significaria que as mensagens passariam por servidores de terceiros — o OpenClaw prioriza privacidade ao manter o gateway no dispositivo do usuário.

### Multi-Agent Routing

Cada canal/conta pode ter um agente diferente:

```yaml
channels:
  whatsapp-personal: agent: personal-assistant
  slack-work: agent: work-assistant
  telegram-crypto: agent: finance-agent
```

Agentes são isolados — o agente de WhatsApp não tem acesso ao contexto do Slack. Isso é tanto segurança quanto separation of concerns: o agente de trabalho não vê mensagens pessoais.

### Live Canvas e A2UI

O Live Canvas é um workspace visual onde o agente pode renderizar outputs complexos — tabelas, gráficos, dashboards — em vez de responder apenas em texto. A2UI (Agent-to-UI) é o protocolo que permite ao agente enviar components visuais para o canvas.

Casos de uso:
- Agente de finanças renderiza gráfico de portfolio em vez de tabela de texto
- Agente de pesquisa renderiza canvas com mind map de conceitos
- Agente de tarefas renderiza Kanban interativo

### Skills via ClawHub

O ClawHub é o marketplace de skills do OpenClaw — análogo ao npm para packages, mas para capacidades de agente. A instalação via `openclaw onboard` cobre a configuração inicial; skills adicionais são instaladas via:

```bash
openclaw skill install <nome-da-skill>
# ou durante onboarding: openclaw onboard --skills slack-summarizer,calendar-sync
```

### Cron e Webhooks

```bash
# Criar tarefa agendada
openclaw cron add "0 9 * * 1-5" "Summarize yesterday's messages from all channels"

# Webhook para eventos externos
openclaw webhook add --event "github.push" --channel telegram-dev --agent dev-assistant
```

Isso transforma o OpenClaw de assistente reativo para proativo — não espera o usuário perguntar, age em eventos e schedules.

## Onboarding Flow

O comando `openclaw onboard --install-daemon` percorre 4 etapas:

1. **Gateway setup**: configura servidor local na porta 18789, certificado TLS self-signed
2. **Workspace**: cria estrutura de diretórios para notas, memória e outputs do agente
3. **Canais**: wizard interativo para conectar cada canal (WhatsApp QR code scan, Telegram bot token, etc.)
4. **Skills**: seleção de skills básicas + instalação

O daemon (`--install-daemon`) registra o gateway como serviço do sistema (launchd no macOS, systemd no Linux) — o assistente fica disponível 24/7 sem precisar manter um terminal aberto.

## Comparação de Segurança com Alternativas

| Aspecto | OpenClaw | ChatGPT (cloud) | Claude.ai (cloud) |
|---------|----------|-----------------|-------------------|
| Dados trafegam por terceiros | Não (local-first) | Sim | Sim |
| Mensagens armazenadas em cloud | Não | Sim | Sim |
| Acesso ao sistema de arquivos | Sim (main session) | Não | Não |
| Execução de código local | Sim | Limitado | Não |
| Autenticação de remetentes | DM pairing | N/A | N/A |

O DM pairing é particularmente interessante: remetentes desconhecidos (alguém que envia mensagem via Telegram sem ser um contato autorizado) recebem um código de pareamento. Sem o código, o agente não responde — proteção contra spam e uso não autorizado.

## Integração com Outros Sistemas

### Gmail Pub/Sub

O OpenClaw usa Gmail Pub/Sub (não polling) para receber emails:
- Mais eficiente: não polica o inbox a cada N segundos
- Mais rápido: notificação chega em segundos, não minutos
- Requer configuração de GCP project + Pub/Sub subscription

### MCP (Model Context Protocol)

Como assistente pessoal, o OpenClaw tem acesso a MCPs locais:
- `mcp__filesystem`: leitura/escrita de arquivos
- `mcp__calendar`: integração com calendário
- `mcp__contacts`: acesso a contatos (para contexto de conversas)
- `mcp__browser`: navegação web em modo headless

## Limitações Conhecidas

- **Node 24 requirement**: força usuários em distros LTS (Ubuntu 22.04, Debian 12) a instalar Node manualmente
- **WhatsApp não-oficial**: a integração WhatsApp usa baileys (cliente não-oficial) — risco de ban por TOS violation
- **iOS limitations**: acesso a iMessage no iOS requer jailbreak ou usar o Mac como bridge via AppleScript
- **Gmail Pub/Sub custo**: volumes altos de email podem ter custo não trivial no GCP
- **Escalabilidade**: o modelo é para uso pessoal (1 usuário) — não é multi-tenant

## Casos de Uso Práticos

**Morning briefing automatizado:**
```
Cron 7:00 → "Summarize: emails não lidos, mensagens Slack importantes, 
              reuniões de hoje, notícias relevantes" 
→ resposta enviada via Telegram
```

**Assistant de estudo (relevante para FIAP):**
```
Telegram: "explica o conceito de connection pooling no FIAP contexto"
→ agente lê vault-michel → responde com contexto personalizado
```

**Pipeline de conteúdo:**
```
Webhook GitHub push → "new article published" 
→ agente gera thread para X 
→ envia para aprovação via Telegram
→ aguarda "OK" → publica
```

## Relações

- [[03-RESOURCES/entities/OpenClaw-Assistant]] — página de entidade
- [[03-RESOURCES/entities/OpenClaw]] — produto diferente (crypto trading agent), mesmo nome de org
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — routing multi-agent nativo
- [[03-RESOURCES/sources/hermes-agent/clipping-release-hermes-agent-v0120-2026430]] — harness alternativo open-source
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — skills como capacidades extensíveis
