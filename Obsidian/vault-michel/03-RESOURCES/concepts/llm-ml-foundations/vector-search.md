---
title: Vector Search
type: concept
status: developing
tags: [embeddings, semantic-search, bm25, qmd, second-brain, knowledge-retrieval]
updated: 2026-05-19
---

# Vector Search

## O que é

**Vector search** (busca vetorial/semântica) é uma técnica de recuperação de informação que encontra documentos por **significado** em vez de correspondência exata de palavras. Cada texto é convertido em um vetor numérico (embedding) no espaço semântico; documentos com significado similar ficam próximos.

Contraste com **BM25** (keyword search), que busca por ocorrência exata de termos.

## Comparação das duas técnicas

| Técnica | Tipo | Melhor para | Limitações |
|---------|------|-------------|------------|
| **vsearch** (vetorial) | Semântica | Perguntas em linguagem natural; sinônimos; contexto | Pode errar nomes próprios |
| **BM25** (keyword) | Exata | Nomes, siglas, métricas específicas, códigos | Miss em sinônimos e reformulações |

**Estratégia ótima:** rodar os dois em paralelo e combinar resultados.

## Implementação com QMD

```bash
bun install -g qmd
qmd collection add ~/Documents/raw/
qmd update

# Busca semântica
qmd vsearch "como está a performance do produto?"

# Busca keyword
qmd search "NPS Q3 2024"
```

O QMD de [@tobi](https://x.com/tobi) implementa ambas as técnicas localmente, sem cloud.

## Aplicação no Second Brain

No sistema de [[03-RESOURCES/entities/Ryan-Wiggins]]:
- 15k documentos indexados localmente com QMD
- Hook `UserPromptSubmit` dispara vsearch + BM25 em paralelo
- Resultados injetados em `<context>` antes de cada prompt
- Claude recebe contexto relevante sem o usuário buscar manualmente

**Exemplo de poder:** "Como está o funil?" → encontra documentos sobre "taxas de conversão", "pipeline de vendas", "métricas de aquisição" — sem mencionar "funil".

## Onde aparece no vault
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/second-brain-claude-code-ryanwiggins]] — implementação prática central
- [[03-RESOURCES/entities/QMD]] — ferramenta que implementa vector search local
