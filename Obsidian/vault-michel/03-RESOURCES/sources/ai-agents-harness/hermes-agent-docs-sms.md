---
title: "Hermes Agent Docs: SMS (Twilio)"
type: source
source: "Hermes Agent official docs — SMS (Twilio)"
created: 2026-06-14
ingested: 2026-06-14
tags: [ai-agents]
---

# Hermes Agent Docs: SMS (Twilio)

## Tese central

Gateway via API Twilio para SMS padrão (sem app dedicado), exigindo servidor publicamente acessível para webhook e validação de assinatura HMAC obrigatória em produção.

## Argumentos principais

### Pré-requisitos

Conta Twilio + número com SMS, servidor publicamente acessível (webhook), `pip install 'hermes-agent[sms]'`.

> Compartilha credenciais (`TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`, `TWILIO_PHONE_NUMBER`) com a skill opcional de telephony.

### Setup

```bash
hermes gateway setup   # ou manual em ~/.hermes/.env
```

```bash
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your_auth_token_here
TWILIO_PHONE_NUMBER=+15551234567
SMS_ALLOWED_USERS=+15559876543,+15551112222
SMS_HOME_CHANNEL=+15559876543
```

No Twilio Console: **Phone Numbers → Active Numbers → A MESSAGE COMES IN** → webhook `https://your-server:8080/webhooks/twilio` (POST). Para expor local: `cloudflared tunnel` ou `ngrok http 8080`.

**`SMS_WEBHOOK_URL` é obrigatório** — usado para validação de assinatura HMAC-SHA1 (`X-Twilio-Signature`); o adapter se recusa a iniciar sem ele.

## Key insights

### Comportamento específico

- Plain text only — markdown é removido
- Limite de 1600 chars — quebra em múltiplas mensagens
- Echo prevention, redação de números de telefone nos logs

### Segurança

- **Gateway nega todos por default** — exige `SMS_ALLOWED_USERS` ou `SMS_ALLOW_ALL_USERS=true`
- `SMS_INSECURE_NO_SIGNATURE=true` só para dev local
- SMS não tem criptografia — preferir Signal/Telegram para uso sensível

## Exemplos e evidências

### Comparação rápida (canal SMS)

| Credencial principal | Webhook obrigatório? | Allowlist default |
| --- | --- | --- |
| `TWILIO_*` | Sim (`SMS_WEBHOOK_URL`) | Nega todos sem `SMS_ALLOWED_USERS` |

## Implicações para o vault

Canal de menor prioridade de privacidade entre os 5 (sem criptografia) — útil documentar como fallback para contextos sem internet/app, mas com ressalva de segurança explícita da própria doc oficial.

## Links

- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-integrations]] — visão geral do Messaging Gateway, MCP, Voice Mode
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-persistent-memory]] — Memory, Skills, Personality, Context Files, Tools
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-onboarding]] — Installation, Quickstart, Configuration
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-security-model]] — Security model, Architecture, FAQ
- [[03-RESOURCES/entities/hermes]]
