---
title: "Agentic Video is HTML: Open Sourcing HyperFrames"
type: source
source_file: .raw/articles/Agentic Video is HTML Open Sourcing HyperFrames.md
author: Bin Liu (@liu8in)
ingested: 2026-04-17
tags: [hyperframes, heygen, ai-agents, video-editing, html, gsap, claude-code, open-source, skill]
---

# Agentic Video is HTML: Open Sourcing HyperFrames

**Autor:** [Bin Liu (@liu8in)](https://x.com/liu8in) — HeyGen  
**Repo:** [github.com/heygen-com/hyperframes](https://github.com/heygen-com/hyperframes)

> [!summary]
> HyperFrames é um toolchain de vídeo baseado em HTML, aberto ao público, construído para AI agents. Permite que Claude Code edite vídeos escrevendo HTML+CSS+JS, que são renderizados em MP4/MOV/WebM. HTML é o formato nativo dos agents; eles foram treinados em bilhões de páginas HTML.

## Tese Central

> [!quote]
> "What the symphony was to Beethoven, play was to Shakespeare — HTML is to agents."

Agents (LLMs) foram treinados na web. Ferramentas baseadas em JSON/XML foram feitas para humanos. HTML é a língua nativa dos agents. Quando agents escrevem HTML+CSS+JS, estão trabalhando no seu medium natural.

## Como Funciona

HyperFrames adiciona um conjunto de atributos `data-` ao HTML para definir um timeline de vídeo:

- `data-composition-id` — identifica a composição
- `data-width` / `data-height` — dimensões (ex: 1920×1080)
- `data-start` / `data-duration` — timing em segundos
- `data-track-index` — camadas (layering)

GSAP (GreenSock Animation Platform) controla as animações. Todo o ecossistema web funciona: CSS animations, Lottie, Three.js, D3, Google Fonts.

## Backstory: HeyGen

HeyGen começou com AI avatars mas descobriu que o avatar é só metade da história. A outra metade é motion graphics, B-rolls e storytelling visual. Timeline/keyframes de video editing levam anos para dominar. A alternativa: HTML+JavaScript.

Ponto de inflexão: **Gemini 3 e Opus 4.5** (novembro 2025) tornaram os outputs consistentes e de alta qualidade. Esse foi o momento de convergência para HyperFrames.

## Instalação (Uma Linha)

```bash
npx skills add heygen-com/hyperframes
```

## Outputs Suportados

MP4, MOV, WebM. Criação, preview e render feitos **localmente**. Zero API keys necessárias.

## Por que Open Source

- Qualquer agent, qualquer LLM pode usar
- Crença: HTML é o formato do futuro do vídeo
- Remover fricção para que agents possam criar vídeos para se comunicar com humanos

## Relações no Vault

- [[03-RESOURCES/entities/HeyGen]] — empresa criadora
- [[03-RESOURCES/entities/Bin-Liu]] — autor/criador
- [[03-RESOURCES/entities/Claude Code]] — used as in-house Video Editor
- [[03-RESOURCES/concepts/claude-skills]] — instalado via `npx skills add`
- [[03-RESOURCES/concepts/hyperframes-skill]] — novo conceito de video-as-HTML
