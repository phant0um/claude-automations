---
title: "Understanding Hermes — Samyak"
type: source
source_type: article
source_url: https://samyak1729.github.io/hermes-blog/
author: Samyak
created: 2026-05-31
updated: 2026-06-10
tags: [hermes-agent, ai-agents, memory-architecture]
status: seed
---

# Understanding Hermes — Samyak

**Autor:** Samyak (contribuidor Nous Research) — série de 7 capítulos explicando estrutura interna do Hermes Agent.

## Resumo

Hermes Agent (Nous Research, OSS, lançado fev/2026): runtime de agente de longa duração, memória persistente, criação autônoma de skills, automações agendadas, mensageria multi-canal e learning loop embutido.

**Learning loop fechado:** ao resolver uma tarefa, o agente escreve um arquivo de skill markdown reutilizável, persiste o resultado em memória, e ajusta abordagem na próxima vez.

**Memória em 3 camadas:**
1. **Working Memory** — lista in-memory dentro do processo
2. **Episodic Memory** — persistida via SQLite + FTS5
3. **Long-Term Memory** — markdown plain-text

**Flexibilidade de modelo:** Nous Portal, OpenRouter (200+ modelos), NovitaAI, NVIDIA NIM, Xiaomi MiMo, GLM, Kimi, MiniMax, HF, OpenAI, ou endpoint próprio.
**Mensageria:** Telegram, Discord, Slack, WhatsApp, Signal, Email, CLI.

## Por que importa (vault)

Detalhamento técnico complementar a [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]] — 3-layer memory aqui é mais granular que o "7-layer memory" descrito noutras fontes; comparar e reconciliar.

## Notes
Conteúdo via WebSearch (2026-06-10) — Clippings original consumido.
