---
title: "Hermes Agent Docs: Email (IMAP/SMTP)"
type: source
source: "Hermes Agent official docs — Email (IMAP/SMTP)"
created: 2026-06-14
ingested: 2026-06-14
tags: [ai-agents]
---

# Hermes Agent Docs: Email (IMAP/SMTP)

## Tese central

Adapter nativo via `imaplib`/`smtplib`/`email` (sem dependências externas) que responde in-thread a qualquer email, distinto da skill Himalaya de gerenciamento de mailbox via terminal.

## Argumentos principais

> Diferente da skill **Himalaya** (gerenciamento de mailbox via terminal, requer CLI `himalaya` externo) — este gateway é só "receber email → responder email".

### Setup

```bash
EMAIL_ADDRESS=hermes@gmail.com
EMAIL_PASSWORD=abcd efgh ijkl mnop    # app password
EMAIL_IMAP_HOST=imap.gmail.com
EMAIL_SMTP_HOST=smtp.gmail.com
EMAIL_ALLOWED_USERS=your@email.com,colleague@work.com
EMAIL_POLL_INTERVAL=15
EMAIL_HOME_ADDRESS=your@email.com
```

Gmail: 2FA + App Password em myaccount.google.com/apppasswords. Outlook: `outlook.office365.com` / `smtp.office365.com`.

### Como funciona

- Polling IMAP de mensagens UNSEEN (default 15s); ao iniciar marca tudo existente como "seen"
- Subject incluído como contexto (`Re:` não duplica prefixo)
- Anexos: imagens → vision tool, documentos → file access; HTML stripado para plain text
- Filtra self-messages e senders automatizados (`noreply@`, `mailer-daemon@`, `Auto-Submitted`, `List-Unsubscribe`)
- Replies via SMTP com `In-Reply-To`/`References`/`Message-ID` corretos
- `MEDIA:/path/to/file` anexa arquivo na resposta; `skip_attachments: true` ignora anexos recebidos

## Key insights

### Access control & segurança

Mesmo padrão dos demais gateways: `EMAIL_ALLOWED_USERS` set → só esses senders; sem allowlist → pairing code; `EMAIL_ALLOW_ALL_USERS=true` → qualquer um (cuidado, agente tem terminal access).

Usar conta dedicada — senha fica em `~/.hermes/.env` (`chmod 600`).

## Exemplos e evidências

### Comparação rápida (canal Email)

| Credencial principal | Webhook obrigatório? | Allowlist default |
| --- | --- | --- |
| `EMAIL_ADDRESS`/`EMAIL_PASSWORD` | Não (polling IMAP) | Pairing code sem `EMAIL_ALLOWED_USERS` |

## Implicações para o vault

Útil como referência rápida para diferenciar o gateway de email nativo da skill Himalaya — evita confusão ao documentar setups que usam ambos.

## Links

- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-integrations]] — visão geral do Messaging Gateway, MCP, Voice Mode
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-persistent-memory]] — Memory, Skills, Personality, Context Files, Tools
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-onboarding]] — Installation, Quickstart, Configuration
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-security-model]] — Security model, Architecture, FAQ
- [[03-RESOURCES/entities/hermes]]
