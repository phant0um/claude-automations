---
title: Knowledge Graph — Code/Wiki Analysis
type: concept
created: 2026-05-29
updated: 2026-05-29
tags: [knowledge-graph, codebase, tree-sitter, multi-agent, claude-code-plugin, visualization]
---

# Knowledge Graph — Code/Wiki Analysis

Transformação de codebases ou knowledge bases em grafos interativos exploráveis visualmente. "Graphs that teach > graphs that impress" — o objetivo não é mostrar complexidade, mas ensinar como cada peça se encaixa.

## Arquitetura híbrida ideal (Understand-Anything)

- **Tree-sitter (determinístico):** estrutura — imports, exports, funções, classes, call sites, herança. Mesma entrada → mesma saída. Usada também para fingerprint-based change detection.
- **LLM (semântico):** intent — resumos em linguagem natural, tags, arquitetura em camadas, mapeamento de domínio de negócio. O que parsers não conseguem.

Resultado: grafo reproduzível na estrutura + expressivo na semântica.

## Features que diferenciam

- **Semantic search:** "which parts handle auth?" → resultados relevantes no grafo
- **Diff impact analysis:** veja ripple effects antes de commitar
- **Persona-adaptive UI:** mesmo grafo, nível de detalhe diferente para junior dev vs PM
- **Guided tours:** walkthrough da arquitetura ordenado por dependência
- **Business logic view:** como código mapeia para processos reais

## Aplicação para LLM wikis (Karpathy-pattern)

`/understand-knowledge` (Understand-Anything) aponta para wiki com `index.md` + wikilinks e produz:
- Force-directed graph com community clustering
- Descoberta de relacionamentos implícitos entre artigos
- Extração de entities e claims
- Wiki textual → grafo navegável de ideias interconectadas

## Git integration

O grafo é JSON — commitar uma vez e teammates pulam o pipeline. Post-commit hook (`--auto-update`) mantém grafo sempre atualizado incrementalmente.

## Relacionado

- [[03-RESOURCES/entities/Understand-Anything]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/sources/open-source-ecosystems/understand-anything-code-knowledge-graph]]
