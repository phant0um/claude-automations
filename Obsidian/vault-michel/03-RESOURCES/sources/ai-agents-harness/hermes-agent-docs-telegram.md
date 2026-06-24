---
title: "Hermes Agent Docs: Telegram"
type: source
source: "Hermes Agent official docs — Telegram"
created: 2026-06-14
ingested: 2026-06-14
tags: [ai-agents]
---

# Hermes Agent Docs: Telegram

## Tese central

Integração full-featured via `python-telegram-bot` — texto, voz (auto-transcrita), imagens, arquivos, grupos — com modos avançados de grupo e escolha entre polling/webhook conforme ambiente de deploy.

## Argumentos principais

### Setup básico

1. Criar bot via **@BotFather** (`/newbot`) → username termina em `bot`, recebe API token
2. Customização opcional (`/setdescription`, `/setcommands`, etc.)
3. **Privacy Mode** (crítico para grupos) — ON por default, bot só vê comandos `/` e replies diretos. Desabilitar via @BotFather → Bot Settings → Group Privacy → Turn off, **e remover/re-adicionar o bot ao grupo**
4. Achar User ID via [@userinfobot](https://t.me/userinfobot)
5. Configurar:

```bash
TELEGRAM_BOT_TOKEN=123456789:ABCdefGHIjklMNOpqrSTUvwxYZ
TELEGRAM_ALLOWED_USERS=123456789
```

### Webhook vs Polling

| | Polling (default) | Webhook |
| --- | --- | --- |
| Direção | Gateway → Telegram (outbound) | Telegram → Gateway (inbound) |
| Melhor para | Local, always-on | Cloud (Fly.io/Railway) com auto-wake |
| Setup | Nenhum | `TELEGRAM_WEBHOOK_URL` + `TELEGRAM_WEBHOOK_SECRET` (obrigatório, `openssl rand -hex 32`) |

## Key insights

### Modos avançados de grupo

- **`observe_unmentioned_group_messages`**: bot observa chatter de grupo sem auto-responder; só dispara em @mention/reply subsequente, mensagens observadas tagueadas com `[nickname|user_id]`
- **`group_allow_from` / `group_allowed_chats`** (Group Allowlisting): allowlist de senders vs. allowlist de chats inteiros — gates ortogonais
- **`guest_mode`**: grupos fora do allowlist respondem só em @mention explícito, sem stickiness de sessão
- **`exclusive_bot_mentions`** (default `true`): em grupos com múltiplos bots Hermes, só o bot mencionado processa
- **`mention_patterns`**: regex wake-words além de @mention

### Private Chat Topics & Multi-session DM (`/topic`)

- **`extra.dm_topics`** (operator-driven): topics fixos declarados em config, com skill binding opcional
- **`/topic`** (user-driven, Bot API 9.4+): usuário ativa multi-sessão na DM, cria topics livremente via botão **+**; root DM se torna lobby
- **`extra.group_topics`**: skill binding por forum topic em supergrupos

## Exemplos e evidências

### Voice & Large Files

- STT: local (faster-whisper), Groq, OpenAI; `stt.enabled: false` entrega o áudio cru ao agente
- TTS: voice bubbles nativas (OpenAI/ElevenLabs Opus nativo; Edge TTS precisa ffmpeg)
- **Local Bot API server** (`telegram-bot-api` self-hosted): levanta limite de `getFile` de 20MB → 2GB via `--local` mode + `local_mode: true` no config

### Outras features

- Streaming transport (`auto`/`draft`/`edit`/`off`) via `sendMessageDraft` (Bot API 9.5)
- Tabelas markdown normalizadas (row-group bullets ou code block, `pretty_tables`)
- DNS-over-HTTPS fallback IPs para redes restritas
- Reactions (👀/✅/❌), status messages editados in-place, pin da mensagem durante o turno
- Slash Command Access Control (mesmo padrão admin/user de Discord)

### Comparação rápida (canal Telegram)

| Credencial principal | Webhook obrigatório? | Allowlist default |
| --- | --- | --- |
| `TELEGRAM_BOT_TOKEN` | Opcional (polling default) | Nega todos sem `TELEGRAM_ALLOWED_USERS` |

## Implicações para o vault

Referência de configuração para grupos complexos (multi-bot, multi-topic) — relevante para cenários de Hermes operando em comunidades/grupos com múltiplas sessões simultâneas.

## Links

- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-integrations]] — visão geral do Messaging Gateway, MCP, Voice Mode
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-persistent-memory]] — Memory, Skills, Personality, Context Files, Tools
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-onboarding]] — Installation, Quickstart, Configuration
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-security-model]] — Security model, Architecture, FAQ
- [[03-RESOURCES/entities/hermes]]
