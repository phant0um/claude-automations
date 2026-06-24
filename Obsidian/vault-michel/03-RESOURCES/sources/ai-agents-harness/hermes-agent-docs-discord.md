---
title: "Hermes Agent Docs: Discord"
type: source
source: "Hermes Agent official docs — Discord"
created: 2026-06-14
ingested: 2026-06-14
tags: [ai-agents]
---

# Hermes Agent Docs: Discord

## Tese central

Bot Discord completo (DMs, canais de servidor, threads, slash commands, voz e anexos) com regras de mention/contexto configuráveis e Privileged Gateway Intents como pré-requisito crítico de setup.

## Argumentos principais

### Comportamento por contexto

| Contexto | Comportamento |
| --- | --- |
| DMs | Responde a toda mensagem, sem `@mention`, sessão própria |
| Canais de servidor | Só responde com `@mention` (default) |
| Free-response channels | `DISCORD_FREE_RESPONSE_CHANNELS` ou `DISCORD_REQUIRE_MENTION=false` — responde inline, sem auto-threading |
| Threads | Responde no mesmo thread; herda regra de mention do canal pai a menos que `thread_require_mention: true` |
| Canais compartilhados | `group_sessions_per_user: true` (default) isola sessão por usuário no mesmo canal |
| Menções a outros usuários | `DISCORD_IGNORE_NO_MENTION=true` (default) — bot fica em silêncio se a mensagem @mention outra pessoa mas não o bot |

### Setup (8 passos)

1. Criar Discord Application no Developer Portal
2. Criar o Bot (Public Bot ON recomendado para invite link)
3. **Privileged Gateway Intents** — habilitar **Server Members Intent** e **Message Content Intent** (causa #1 de bot "online mas não responde")
4. Resetar e copiar o **Bot Token** (mostrado uma única vez)
5. Gerar Invite URL (Installation tab ou manual com `client_id` + `scope=bot+applications.commands` + `permissions=274878286912`)
6. Convidar para o servidor (requer permissão Manage Server)
7. Achar o Discord User ID (Developer Mode → Copy User ID)
8. Configurar via `hermes gateway setup` (interativo) ou manualmente em `~/.hermes/.env`:

```bash
DISCORD_BOT_TOKEN=your-bot-token
DISCORD_ALLOWED_USERS=284102345871466496
```

## Key insights

### Variáveis de ambiente principais

| Variável | Descrição |
| --- | --- |
| `DISCORD_BOT_TOKEN` / `DISCORD_ALLOWED_USERS` | Obrigatórios |
| `DISCORD_ALLOWED_ROLES` | RBAC — qualquer membro com o role é autorizado (OR com allowed_users), auto-habilita Server Members Intent |
| `DISCORD_HOME_CHANNEL` / `DISCORD_HOME_CHANNEL_NAME` | Canal para mensagens proativas (cron, lembretes) — ou use `/sethome` |
| `DISCORD_REQUIRE_MENTION` (default `true`) | Exigir @mention em canais de servidor |
| `DISCORD_THREAD_REQUIRE_MENTION` (default `false`) | Gatear threads como canais (multi-bot) |
| `DISCORD_FREE_RESPONSE_CHANNELS` | Canais mention-free |
| `DISCORD_AUTO_THREAD` (default `true`) | Auto-cria thread por @mention |
| `DISCORD_HISTORY_BACKFILL` (default `true`) | Recupera scrollback do canal desde a última resposta do bot |
| `DISCORD_ALLOW_ANY_ATTACHMENT` / `DISCORD_MAX_ATTACHMENT_BYTES` | Aceita qualquer tipo de arquivo, cacheado em `~/.hermes/cache/documents/` |
| `DISCORD_ALLOW_MENTION_EVERYONE/ROLES/USERS/REPLIED_USER` | Mention Control — `@everyone`/`@role` bloqueados por default |

### Slash Command Access Control (admin/user tiers)

`allow_admin_from` + `user_allowed_commands` no bloco `extra` da plataforma Discord — mesmo padrão admin/user tier descrito na doc de integrations, aqui com sintaxe Discord-específica (`group_allow_admin_from` para canais de servidor).

## Exemplos e evidências

### Voice, Forum Channels, Sending Media

- **Voice messages**: STT via faster-whisper/Groq/OpenAI; TTS via `/voice tts`; pode entrar em voice channel
- **Voice FX** (`config.yaml` → `discord.voice_fx`): mixer de áudio com ambient "thinking" bed + acks verbais, off por default
- **Forum channels** (type 15): auto-detectados, cada send cria novo thread
- **Sending Media**: `send_message` + `MEDIA:` tags → imagens, GIFs, vídeo, voice, documentos nativos

### Troubleshooting principal

Bot online mas sem resposta → Message Content Intent desabilitado. "Disallowed Intents" → faltam os 3 Privileged Intents. 403 → permissões do bot.

### Comparação rápida (canal Discord)

| Credencial principal | Webhook obrigatório? | Allowlist default |
| --- | --- | --- |
| `DISCORD_BOT_TOKEN` | Não (gateway WS) | Nega todos sem `DISCORD_ALLOWED_USERS`/`_ROLES` |

## Implicações para o vault

Documentação primária de configuração — útil como cookbook de referência para validar claims de posts da comunidade sobre setup de bots Discord via Hermes, e para diagnosticar o erro mais comum (Privileged Intents desabilitados).

## Links

- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-integrations]] — visão geral do Messaging Gateway, MCP, Voice Mode
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-persistent-memory]] — Memory, Skills, Personality, Context Files, Tools
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-onboarding]] — Installation, Quickstart, Configuration
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-security-model]] — Security model, Architecture, FAQ
- [[03-RESOURCES/entities/hermes]]
