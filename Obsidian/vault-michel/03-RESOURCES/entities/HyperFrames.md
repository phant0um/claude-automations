---
title: HyperFrames
type: entity
categoria: ferramenta
tags: [ai-video, html, gsap, open-source, claude-skill, heygen]
created: 2026-05-31
updated: 2026-05-19
---

# HyperFrames

## O que é

Toolchain de vídeo baseado em HTML, open-source, construído para AI agents. Criado pela [[03-RESOURCES/entities/HeyGen]]. Permite que agents como [[03-RESOURCES/entities/Claude Code]] editem vídeos escrevendo HTML+CSS+JS, que são renderizados em MP4/MOV/WebM.

## Como funciona

Adiciona atributos `data-` ao HTML para definir timeline de vídeo:
- `data-composition-id`, `data-width`, `data-height`
- `data-start`, `data-duration` (em segundos)
- `data-track-index` (camadas/layering)

GSAP anima os elementos. Todo o ecossistema web é compatível.

## Instalação

```bash
npx skills add heygen-com/hyperframes
```

## Por que é relevante para agents

LLMs foram treinados em bilhões de páginas HTML. JSON/XML são formatos para humanos. HTML é a língua nativa dos agents — quando escrevem HTML, operam no seu medium natural.

## Links

- [github.com/heygen-com/hyperframes](https://github.com/heygen-com/hyperframes)

## Onde aparece no vault

- [[03-RESOURCES/sources/skills-prompting-mcp/hyperframes-agentic-video-html]]
- [[03-RESOURCES/concepts/ai-strategy-org/agentic-video]]
