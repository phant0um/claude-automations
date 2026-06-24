---
title: Scheduled Ingest Routine
type: concept
status: developing
tags: [automation, pkm, n8n, daily-brief, cron, obsidian]
created: 2026-05-09
updated: 2026-05-09
---

# Scheduled Ingest Routine

Padrão de automação que executa ingestão, processamento e briefing de conhecimento via cron job — sem interação manual. O vault recebe, processa e retorna insights **antes de você sentar para trabalhar**.

## Componentes principais

### Daily Brief (N8N cron 6h, dias úteis)
- Lê `/inbox` das últimas 24h + `/notes` dos últimos 7 dias
- Gera 3 conexões inesperadas com passagens citadas
- Identifica 1 padrão semanal implícito
- Formula 1 pergunta (não tarefa) baseada no padrão
- Salva em `/inbox/brief-{{date}}.md` automaticamente

### Capture pipeline (event-triggered)
- Readwise webhook → N8N → formata como `.md` → `/notes/`
- Telegram message → N8N → `/inbox/` (latência < 1 min)
- Whisper transcript → N8N → `/ideas/`

### Weekly Synthesis (manual, 15 min)
- Prompt profundo: tese emergente, contradições, gaps, 1 ação de alavancagem
- Sessão de domingo → segunda com 2 briefs prontos

## Implementação N8N (Telegram → Obsidian)

```
Node 1: Telegram Trigger → event: message → chat_id: bot_id
Node 2: Code (format) → filename: inbox/{{date}}-quick-capture.md
Node 3: Write File → path: /vault/inbox/
```

## Por que cron > manual

Dependência de memória para abrir o vault = vault que nunca é aberto. Cron inverte a relação: o vault te encontra, você não precisa encontrar o vault. O brief é o hook que justifica retornar todo dia.

## Diferença de padrões similares

| Padrão | Trigger | Output |
|--------|---------|--------|
| Scheduled Ingest Routine | Cron (6h) | Brief + connections |
| [[03-RESOURCES/concepts/claude-code-tooling/cowork-scheduled-automations]] | Cron (Cowork scheduler) | Tarefas de manutenção do vault |
| [[03-RESOURCES/concepts/pkm-obsidian/dream-cycle-self-consolidation]] | Cron (nightly) | Promoção episódico → semântico |

Todos são instâncias do princípio: **processamento agendado > processamento manual** para sistemas de conhecimento de longa duração.

## Ver também

- [[03-RESOURCES/sources/pkm-obsidian-second-brain/obsidian-vault-smarter-every-day-automation]] — implementação completa (@cyrilXBT)
- [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]] — o padrão habilitado por esta rotina
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — efeito ao longo do tempo
- [[03-RESOURCES/concepts/claude-code-tooling/cowork-scheduled-automations]] — equivalente via Cowork

## Evidências
- **[2026-06-19]** Loops locais morrem ao fechar o laptop; routines no servidor resolvem rodando por cron/webhook/API independente da máquina estar ligada — [[03-RESOURCES/sources/how-to-set-up-claude-loops]]
