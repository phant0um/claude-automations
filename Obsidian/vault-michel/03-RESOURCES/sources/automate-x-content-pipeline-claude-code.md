---
title: "How I Automate My X Content Pipeline Using Claude Code"
type: source
author: m0h (@exploraX_)
created: 2026-04-24
updated: 2026-04-24
tags: [content-automation, claude-code, x-pipeline, CLAUDE.md, scraping]
---

# How I Automate My X Content Pipeline Using Claude Code

**Autor:** m0h ([@exploraX_](https://x.com/exploraX_))
**Fonte:** Artigo/thread publicado em X

## Resumo

m0h descreve um pipeline de automação de conteúdo para X (Twitter) construído com Claude Code. O sistema automatiza 80% do trabalho manual de criação de conteúdo — pesquisa de tópicos, redação, design de banners/infográficos — deixando apenas edição, seleção e decisão de postar para o humano.

## Pilares do sistema

### 1 — CLAUDE.md como arquitetura do sistema

O arquivo [[03-RESOURCES/concepts/claude-folder-anatomy|CLAUDE.md]] é o componente central. Define:
- **Three-layer architecture:** directives → orchestration → execution
- Claude verifica scripts existentes antes de escrever novos
- **Self-annealing loop:** quando algo quebra, Claude lê o erro, corrige o script, e atualiza a diretiva para evitar a mesma falha — equivalente a [[03-RESOURCES/concepts/self-evolving-agents]]

**Por que CLAUDE.md importa:** LLMs são probabilísticos, não determinísticos. CLAUDE.md resolve isso separando o que IA faz bem (decisão contextual) do que código faz bem (execução determinística). Python scripts executam a mesma lógica toda vez; Claude decide qual script chamar e verifica o output.

Template disponível: [Google Docs](https://docs.google.com/document/d/1GHnnuFlHEotTmxaaDFIATEkHc0EVwJh209LXdGCZ6ls/edit?usp=sharing)

### 2 — Scraping de tópicos trending no X

Usa X API para automatizar descoberta de tópicos:
- Lista de contas de referência no nicho (AI tools, agentic AI, crypto)
- Ranking de posts por engajamento (likes, retweets, replies)
- Output: 5 ideias de conteúdo em menos de 2 minutos

**Prompt arquétipo usado:**
> "I want to scrape X for trending content in my niche. my niche is AI tools, agentic AI, and crypto opportunities. pull the top performing posts from accounts I follow and from keyword searches across these topics. rank results by engagement — likes, retweets, replies. then pass the top 30 posts to you and generate 5 content topic ideas tailored to my account style and audience. save the output so I can review and pick the best one."

Claude constrói os Python scripts, conecta a API, e configura a lógica de ranking. O autor não revisa o código — apenas o output.

### 3 — Redação de artigos assistida

Fluxo em duas etapas:
1. Claude gera o esqueleto (estrutura) do artigo
2. Script de execução separado faz scraping de X e YouTube para conteúdo relevante via **Apify** (third-party scraper), puxa transcrições, e passa tudo ao Claude

Claude escreve no tom e voz do usuário (treinado com o histórico de correções). O usuário edita: adiciona humor, corta rigidez, reformula frases. "É menos escrever, mais editar."

**Efeito composto:** cada correção treina o sistema para precisar de menos correção na próxima vez.

**Filosofia:** "Never let AI post for you" — IA constrói a fundação, o humano torna humano.

### 5 — Banners e infográficos

Workflow anterior: Canva (banners) + Excalidraw (infográficos) → 30 min por post.

Workflow atual: Claude gera diretamente com "infographic agentic skill" customizada:
- Claude analisa referências visuais enviadas pelo usuário
- Replica estrutura e layout com conteúdo do draft
- Output em menos de 5 minutos

**Prompt real usado:**
> "hey, I need a comprehensive infographic for this drafted post, use the infographic skill to create a perfect befitting graphic in X portrait image standard."

### 6 — Workflow end-to-end

| Passo | Ação | Responsável |
|-------|------|-------------|
| 1 | Script de content strategy → 5 tópicos rankeados | Automatizado |
| 2 | Escolher o tópico mais forte | Humano |
| 3 | Script YouTube → transcrições → Claude escreve artigo | Automatizado |
| 4 | Editar draft — adicionar humor, ajustar tom | Humano |
| 5 | Claude gera banner + infográfico via skill | Automatizado |
| Pós | Decisão de postar | Humano |

## Conceitos relacionados

- [[03-RESOURCES/concepts/claude-folder-anatomy]] — CLAUDE.md como arquitetura central
- [[03-RESOURCES/concepts/claude-code-workflow]] — padrão EPCC e uso de scripts determinísticos
- [[03-RESOURCES/concepts/life-operating-system]] — automação de fluxos repetitivos via Claude Code
- [[03-RESOURCES/concepts/self-evolving-agents]] — self-annealing loop é análogo estrutural
- [[03-RESOURCES/concepts/claude-agent-harness-architecture]] — separação decisão (IA) / execução (código)
- [[03-RESOURCES/concepts/content-automation-pipeline]] — conceito criado nesta ingestão

## Entidades mencionadas

- [[03-RESOURCES/entities/exploraX]] — autor m0h
- Apify — third-party scraper para X e YouTube
- X API — scraping de trending posts
