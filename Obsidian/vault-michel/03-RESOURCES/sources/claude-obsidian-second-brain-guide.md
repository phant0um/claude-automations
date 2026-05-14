---
title: "Claude + Obsidian | How to use your second brain"
type: source
formato: article
author: "@defileo"
source_url: https://x.com/defileo/status/2042241063612502162
fetched: 2026-04-14
tags: [obsidian, claude, pkm, second-brain, setup-guide]
---

# Claude + Obsidian | How to use your second brain

Guia completo de setup do [[03-RESOURCES/entities/claude-obsidian|claude-obsidian]] — plugin para Claude Code que transforma um vault Obsidian em uma wiki persistente e composta automaticamente.

## Tese central

A maioria das ferramentas Obsidian + IA apenas fazem "chat sobre o vault" — você ainda escreve as notas, faz os links, faz a manutenção. O claude-obsidian segue o [[03-RESOURCES/concepts/llm-wiki-pattern|LLM Wiki Pattern]] de Karpathy: você joga uma fonte, o Claude constrói e mantém a wiki.

## Pré-requisitos

- [[03-RESOURCES/entities/Obsidian|Obsidian]] (gratuito)
- Node.js v18+ 
- [[03-RESOURCES/entities/Claude Code|Claude Code]] (CLI)

## Instalação

```bash
claude plugin marketplace add AgriciDaniel/claude-obsidian
claude plugin install claude-obsidian@claude-obsidian-marketplace
```

## Os 3 comandos principais

| Comando | O que faz |
|---------|-----------|
| `/save` | Arquiva a conversa atual como páginas wiki |
| `/autoresearch [tópico]` | 3–5 rodadas de pesquisa web → páginas wiki |
| `/canvas [descrição]` | Cria canvas visual com os nós relevantes do vault |

## Loop diário de ingestão

1. Jogar fonte em `.raw/`
2. `ingest [arquivo]`
3. Claude cria 8–15 páginas interligadas com média de 12 wikilinks

## Como mantém o custo baixo

Ver [[03-RESOURCES/concepts/hot-cache|Hot Cache]]: três arquivos carregados em ordem — `hot.md` (~500 tokens), `index.md` (uma linha por página), páginas relevantes apenas.

## Conceitos extraídos

- [[03-RESOURCES/concepts/llm-wiki-pattern|LLM Wiki Pattern]]
- [[03-RESOURCES/concepts/knowledge-compounding|Knowledge Compounding]]
- [[03-RESOURCES/concepts/hot-cache|Hot Cache]]
- [[03-RESOURCES/concepts/second-brain|Second Brain]]
