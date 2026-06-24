---
title: Agentic Video
type: concept
status: developing
tags: [ai-agents, video-editing, html, hyperframes, heygen]
updated: 2026-05-19
---

# Agentic Video

## O que é

Categoria emergente de geração de vídeo onde AI agents constroem vídeos programaticamente, sem usar ferramentas de edição tradicionais (After Effects, DaVinci Resolve). O agent escreve código (HTML/CSS/JS) que é renderizado em vídeo.

## Por que HTML

Agents foram treinados em bilhões de páginas HTML. Quando escrevem HTML, operam no seu medium nativo — não precisam aprender uma nova ferramenta, já "sabem" profundamente como HTML, CSS e JavaScript funcionam. JSON/XML-based tools foram construídas para humanos, não para agents.

## Implementações

- [[03-RESOURCES/entities/HyperFrames]] (HeyGen, 2026) — toolchain open-source baseado em HTML + GSAP
  - `npx skills add heygen-com/hyperframes`
  - Output: MP4, MOV, WebM

## Ponto de Inflexão

Novembro 2025: Gemini 3 e Opus 4.5 tornaram a geração de motion graphics por agents consistente e de alta qualidade. Antes, os modelos não eram capazes de produzir output confiável via HTML puro.

## Stack Técnica

```
HTML + CSS + JS → data- attributes → GSAP animations → render → MP4/MOV/WebM
```

Compatível com: CSS animations, GSAP, Lottie, Three.js, D3, Google Fonts.

## Relações

- [[03-RESOURCES/entities/HyperFrames]] — implementação de referência
- [[03-RESOURCES/entities/HeyGen]] — criadora
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — distribuído como skill instalável
