---
title: "Marketing System"
description: "Sistema de 4 agentes para execução e distribuição de marketing pessoal"
version: "1.0.0"
updated: 2026-05-15
status: active
tags: [agents, marketing, claude, orchestration]
---

# Marketing System

Sistema de 4 agentes para **execução e distribuição** de conteúdo de marketing pessoal para Michel Csasznik.
Complementa os agentes de estratégia existentes (`marca-pessoal`, `estrategista-de-conteudo`, `designer-sites`) — não os substitui.

## Arquitetura

```
signal (orchestrator)
├── anchor → estratégia de marca e conteúdo           → claude-sonnet-4-6
├── vox    → posts, threads, roteiros (X+IG+YouTube)  → claude-sonnet-4-6
├── prism  → edição de foto + direção de vídeo         → claude-sonnet-4-6
├── canvas → site design, copy, SEO, UX audit         → claude-sonnet-4-6
├── lens   → prompts DALL-E 3                         → claude-sonnet-4-6
└── folio  → documentos HTML (on-demand apenas) ⚠️   → claude-sonnet-4-6
```

## Roteamento de Modelos

| Agente | Modelo            | Função                                      |
|--------|-------------------|---------------------------------------------|
| Signal | claude-sonnet-4-6 | Orquestração e roteamento                   |
| Anchor | claude-sonnet-4-6 | Marca, posicionamento, estratégia, calendário|
| Vox    | claude-sonnet-4-6 | Posts, threads, roteiros, engajamento        |
| Prism  | claude-sonnet-4-6 | Lightroom exact values, DJI shot lists       |
| Canvas | claude-sonnet-4-6 | Site design, copy, identidade visual, UX     |
| Lens   | claude-sonnet-4-6 | Prompts DALL-E 3                             |
| Folio  | claude-sonnet-4-6 | Documentos HTML on-demand                   |

## Camada no ecossistema

```
ESTRATÉGIA (agentes existentes)     →    EXECUÇÃO (Marketing System)
────────────────────────────────         ──────────────────────────
marca-pessoal-monetizacao-solo      →    Signal → Vox
estrategista-de-conteudo            →    Signal → Vox / Fullstack
designer-estrategista-de-sites      →    Signal → Fullstack
criacao-visual-fotos-videos         →    Signal → Lens
```

## Como invocar

Sempre inicie pelo Signal:

> `@signal — [intenção]. Contexto: [tema / campanha / conteúdo de referência].`

Ou invoque agentes diretamente se souber o modo:

> `@vox — thread: por que IA muda concursos públicos`
> `@fullstack — one-pager: apresentação de perfil tech para recrutadores`
> `@lens — capa: X — tema sobre produtividade com IA`

## Docs do Sistema

| Arquivo | Propósito |
|---|---|
| `docs/progress.md` | Campanhas ativas, últimos outputs, pendências |
| `docs/standards.md` | Padrões de voz, paleta, critérios de qualidade |
| `docs/constitution.md` | Princípios e limites do sistema |
| `docs/adr/` | Decisões que afetam padrões ou arquitetura |

## Regras do Sistema

1. Signal é obrigatório para campanhas multi-agente (Vox + Lens + Fullstack)
2. Nenhum agente inventa estratégia — executam briefing ou chamam agentes de estratégia externos
3. `progress.md` atualizado ao final de cada campanha
4. Contexto Michel (tech/AI, ADS/FIAP, marca solo) baked-in em todos os agentes — nunca pedir novamente
