---
title: "How To Use Obsidian + Vellum To Build A Second Brain That Thinks 24/7"
type: source
created: 2026-05-28
ingested: 2026-05-28
tags: [obsidian, vellum, second-brain, pkm, automation, n8n, readwise, workflows]
source_url: "https://x.com/cyrilXBT/status/2059461814333673705"
author: "@cyrilXBT"
published: 2026-05-26
---

# How To Use Obsidian + Vellum To Build A Second Brain That Thinks 24/7

## Tese Central

Stack de quatro ferramentas (Obsidian + Vellum + Readwise + N8N) cria um "chefe de gabinete" digital que lê tudo que você leu, lembra tudo que esqueceu, e te faz um briefing diário — por ~$0 além do custo de API.

## Key Insights

- **Stack:** Obsidian (base local) + Vellum (inteligência/AI) + Readwise (captura de highlights) + N8N (automação e scheduling).
- **Decisão arquitetural crítica:** Organizar capturas por *tipo de nota* (padrões, ideias, números, perguntas), não por tópico. Padrões de crypto e padrões psicológicos caem na mesma pasta → Vellum encontra conexões automaticamente.
- **Estrutura de vault CHIEF:** 00-INBOX → 01-CAPTURES/{articles,ideas,patterns,questions,numbers} → 02-CONNECTIONS → 03-PROJECTS → 04-VELLUM/{VELLUM.md,workflows/}
- **VELLUM.md:** Arquivo de identidade/contexto que persiste entre sessões — quem você é, foco atual, projetos ativos, o que quer da AI. Qualidade do output de Vellum proporcional à qualidade deste arquivo.
- **4 workflows core:** (1) Process Inbox — sharpen raw captures em frases específicas; (2) Daily Brief (6am via N8N) — conexões, padrão da semana, uma pergunta; (3) Weekly Connections (domingo) — 4 tipos de conexão: mesmo princípio em domínios diferentes, contradição, padrão de 3+ notas, pergunta de uma nota que outra responde; (4) Deep Research — o que já acredito, o que contradiz, o que está faltando, pergunta não feita.
- **Captura via Telegram Bot (N8N):** Ideia às 2am → mensagem para bot → land em INBOX automaticamente.
- **Compounding:** 30 dias = ferramenta útil; 90 dias = sistema que conhece padrões antes de você; 6 meses = registro completo de crenças formadas e mudadas.
- **Loop de fechamento:** Quando uma tese se prova correta, atualizar a nota. Vellum aprende o que funciona especificamente para você.

## Implicações para o Vault

- Vellum.ai como alternativa ao Claude Code para interface com vault — especialmente útil para usuários não-técnicos.
- Arquitetura por tipo-de-nota (não tópico) já implementada no vault-michel com estrutura diferente; pode inspirar refinamento do 01-CAPTURES.
- VELLUM.md é análogo ao CLAUDE.md do vault-michel — pattern já em uso aqui.
- N8N scheduling para Daily Brief replicável com Brave Search MCP (ver source de research agent do mesmo autor).

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — sistema que este artigo implementa
- [[03-RESOURCES/concepts/pkm-obsidian/self-writing-vault]] — vault que se mantém sozinho
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/jarvis-obsidian-second-brain-thinks-full-setup]] — setup similar anterior
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/obsidian-vault-writes-back-cyrilxbt]] — mesmo autor, vault mais avançado
