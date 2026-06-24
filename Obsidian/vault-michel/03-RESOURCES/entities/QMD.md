---
title: QMD
type: entity
category: tool
tags: [vector-search, second-brain, local-search, semantic-search, bm25]
created: 2026-05-31
updated: 2026-05-19
---

# QMD

## O que é

Ferramenta de **vector search local** criada por [@tobi](https://x.com/tobi) (Tobi Lütke, CEO Shopify). Permite indexar coleções de documentos e buscá-los semanticamente (vsearch) ou por keyword exata (BM25). Roda localmente — sem cloud, sem API externa.

Instalação: `bun install -g qmd`
Repo: https://github.com/tobi/qmd

## Dois modos de busca

| Modo | Tipo | Uso ideal |
|------|------|-----------|
| `qmd vsearch` | Semântico/vetorial | Perguntas em linguagem natural; entende significado |
| `qmd search` | BM25 (keyword) | Nomes próprios, siglas, métricas exatas |

Usar os dois em paralelo maximiza cobertura.

## Caso de uso principal no vault

[[03-RESOURCES/entities/Ryan-Wiggins]] usou QMD para indexar 15k documentos (3,5M palavras) e conectá-lo ao Claude Code via hook UserPromptSubmit — injetando contexto relevante automaticamente em cada prompt.

## Onde aparece no vault

- [[03-RESOURCES/sources/pkm-obsidian-second-brain/second-brain-claude-code-ryanwiggins]] — uso central no sistema de Second Brain

## Conceito relacionado
- [[03-RESOURCES/concepts/llm-ml-foundations/vector-search]] — conceito técnico subjacente
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — aplicação principal

## Links externos
- https://github.com/tobi/qmd
