---
title: "Hindsight: One-Click Memory Provider in the Hermes Desktop App"
type: source
source: "Clippings/Hindsight Is Now a One-Click Memory Provider in the Hermes Desktop App.md"
author: "@Vectorizeio"
published: 2026-06-22
created: 2026-06-22
ingested: 2026-06-22
tags: [memory-context-rag, hermes, hindsight, memory-provider, desktop-app]
score: B
---

## Tese Central

Hindsight agora tem configuração full in-app no Hermes desktop app — Settings → Memory & Context → Hindsight → config panel com Mode, API key, API URL, Bank ID, Recall budget. Não mais editar config.json ou .env. É o único memory provider em Hermes com painel de configuração completo na UI.

## Pontos-Chave

1. **Config in-app**: API key stored as secret (write-only), resto como profile config. Sem editar arquivos, sem environment variables, sem restart dance.
2. **Único com painel completo**: Hermes ships com vários memory plugins, mas Hindsight é o único com configuration panel real. Outros providers render nothing no settings area.
3. **Generic UI**: desktop UI pergunta ao backend "what does this provider need configured?" e desenha o que vem back. Hindsight é o provider que Hermes escolheu fully describe — modes, secrets, defaults.
4. **Cloud mode fast path**: sign up free em ui.hindsight.vectorize.io, paste key, done. Local External mode também suportado.
5. **3 passos**: Settings → Memory & Context → set memory provider to Hindsight → Cloud → paste API key → save. Hermes lembra preferências, decisões, project context across sessions.

## Conceitos

- Memory providers como plugins pluggables
- Secret store (write-only) vs profile config
- Provider descriptor: backend define "what needs configuring" → UI desenha dinamicamente

## Links

- [[03-RESOURCES/concepts/memory-context-rag/rag-architecture]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/sources/guides-courses-howtos/hermes-flightplan-1-the-ultimate-zero-to-always-on-telegram-ai-agent-full-copy-paste-code]]