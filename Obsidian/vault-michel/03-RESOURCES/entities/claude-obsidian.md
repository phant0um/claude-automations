---
title: claude-obsidian
type: entity
categoria: ferramenta
author: AgriciDaniel
repo: https://github.com/AgriciDaniel/claude-obsidian
tags: [claude, obsidian, pkm, plugin]
created: 2026-04-14
updated: 2026-05-19
---

# claude-obsidian

Plugin para [[03-RESOURCES/entities/Claude Code|Claude Code]] que transforma um vault [[03-RESOURCES/entities/Obsidian|Obsidian]] em uma wiki persistente e composta automaticamente via [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern|LLM Wiki Pattern]].

## O que faz

- Ingere qualquer fonte (PDF, URL, transcrição, notas) e constrói páginas wiki estruturadas
- Extrai conceitos, cria entidades, linka tudo com wikilinks
- Sinaliza contradições com `[!contradiction]` callouts
- Mantém [[03-RESOURCES/concepts/pkm-obsidian/hot-cache|hot cache]] para custo de tokens baixo
- Gera canvas visuais do grafo de conhecimento

## Instalação

```bash
claude plugin marketplace add AgriciDaniel/claude-obsidian
claude plugin install claude-obsidian@claude-obsidian-marketplace
```

## Skills incluídas (10 total)

| Skill | Comando | Função |
|-------|---------|--------|
| wiki | `/wiki` | Scaffold inicial do vault |
| wiki-ingest | `ingest [fonte]` | Ingere uma fonte e constrói páginas |
| save | `/save` | Arquiva conversa atual como wiki |
| autoresearch | `/autoresearch [tópico]` | Pesquisa web → wiki |
| canvas | `/canvas [descrição]` | Canvas visual do vault |
| wiki-lint | `/wiki-lint` | Health check do vault |

## Estrutura de vault gerada

```
wiki/
├── concepts/
├── sources/
├── entities/
├── sessions/
├── log.md
├── index.md
└── hot.md
```

## Onde aparece neste vault

- [[03-RESOURCES/sources/pkm-obsidian-second-brain/claude-obsidian-second-brain-guide|Guia de setup]] (fonte original)
- Usado para construir e manter este vault inteiro
