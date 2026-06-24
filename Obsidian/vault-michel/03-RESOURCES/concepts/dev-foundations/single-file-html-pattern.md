---
title: Single-File HTML Pattern
type: concept
status: developing
tags: [html, artifacts, claude-code, pattern, throwaway-ui, export]
created: 2026-05-09
updated: 2026-05-09
---

# Single-File HTML Pattern

Padrão de design de artefatos: um único arquivo `.html` auto-contido, construído para uma tarefa específica e descartável, que sempre termina com um botão de exportação ("copy as JSON" / "copy as prompt") para fechar o loop de volta ao Claude Code.

## Estrutura típica

```
single HTML file
├── UI funcional (drag-drop, forms, sliders, preview)
├── Dados embutidos (JSON inline ou hard-coded)
└── Export button → clipboard (JSON / Markdown / prompt)
```

## Princípios

1. **Throwaway**: não é um produto nem ferramenta reutilizável — resolve exatamente o problema atual.
2. **Auto-contido**: sem dependências externas além de CDN básico (opcional).
3. **Export-first**: sempre há uma saída que pode ser colada de volta no terminal do Claude Code.

## Exemplos de aplicação

- Triagem de tickets: Kanban com drag-and-drop → "copy as Markdown" com rationale por bucket
- Editor de feature flags: formulário com dependências e warnings → "copy diff"
- Tuner de system prompt: editor lado a lado com live preview → "copy final prompt"
- Seletor de cores/easing: controles visuais para parâmetros difíceis de descrever em texto

## Skill de Referência

O projeto `html-artifacts` de [[03-RESOURCES/entities/dogum]] empacota este padrão como uma Claude skill instalável, com referências por categoria (comparisons, code-review, decks, custom-editors, etc.) e regras explícitas de carve-out para quando não usar HTML.

## Relação com outros conceitos

- [[03-RESOURCES/concepts/dev-foundations/html-as-llm-artifact]] — motivação e vantagens do formato HTML
- [[03-RESOURCES/concepts/claude-code-tooling/claude-artifacts]] — tipo HTML nos artifacts nativos de Claude
- [[03-RESOURCES/concepts/pkm-obsidian/format-decision-framework]] — quando usar este padrão vs MD
- [[03-RESOURCES/concepts/pkm-obsidian/markup-drift]] — por que single-file throwaway é preferível a HTML iterativo
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — o padrão pode ser instalado como skill

## Fontes

- [[03-RESOURCES/sources/skills-prompting-mcp/claude-code-unreasonable-effectiveness-of-html]]
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-html-artifacts-claude-skill-dogum]] — implementação como skill
