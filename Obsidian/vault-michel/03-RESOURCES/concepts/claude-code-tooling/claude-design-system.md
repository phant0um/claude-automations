---
title: "Claude Design System"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# Claude Design System

Sistema de design da Anthropic para interfaces Claude — component library, design tokens e padrões de interação para AI chat UIs.

## O que é

O Claude Design System define os padrões visuais e de interação usados nos produtos Claude (Claude.ai, Claude Code, API docs). Inclui:

- **Design tokens** — cores, tipografia, espaçamento, light/dark mode
- **Component library** — botões, inputs, chat bubbles, code blocks, thinking indicators
- **Padrões de interação** — loading states para streaming, feedback de tool use, artifacts panel
- **Voice & tone** — diretrizes para copy em interfaces AI

## Como funciona

O sistema é implementado como biblioteca de componentes (React/CSS) usada internamente pela Anthropic. Externamente, é relevante como referência para quem constrói interfaces que integram Claude (via API ou embeds).

**Padrões específicos de AI chat:**
- **Streaming text** — animação de cursor durante geração de tokens
- **Tool use indicators** — exibir qual ferramenta está sendo chamada sem poluir a resposta
- **Artifacts** — painel lateral para conteúdo estruturado (código, SVG, HTML preview)
- **Thinking disclosure** — exibir thinking tokens de forma colapsável

## Por que importa

Para projetos que integram Claude via API com UI própria, o Claude Design System é referência de boas práticas de UX para AI. Para o vault-michel, informa decisões de como apresentar outputs de agentes em interfaces Obsidian (canvas, callouts, frontmatter).

## Related
- [[03-RESOURCES/entities/Claude-Design]]
- [[03-RESOURCES/concepts/claude-ecosystem]]
- [[03-RESOURCES/concepts/claude-code-tooling/_index]]
