---
title: Claude Design
type: concept
status: developing
created: 2026-04-24
updated: 2026-04-24
tags: [claude-design, anthropic, design, ui, visual-ai]
---

# Claude Design

Produto separado da Anthropic para geração de design visual com IA. Lançado como **research preview** em [claude.ai/design](https://claude.ai/design).

## Características

- **URL própria** — não está dentro do app Claude ou Claude Code
- **Modelo:** [[03-RESOURCES/entities/Claude-Opus-47]] (Opus 4.7) — melhor modelo de visão da Anthropic
- **Planos necessários:** Pro ou Max. Team/Enterprise: desligado por padrão (admin ativa)
- **Consome tokens extremamente rápido** — usar com cautela nos limites do plano

## O Que Cria

| Tipo | Descrição |
|------|-----------|
| Landing pages | High-fidelity, one-shot com prompt de 2 linhas |
| Slide decks | Com speaker notes em cada slide |
| Vídeos animados | 45s, motion + transitions + kinetic typography |
| Multi-page websites | 2-3h para site completo |

## Modos de Entrada

- **Wireframe:** escolher "High fidelity" → prompt → gerar
- **Slide deck:** prompt → Claude faz perguntas → Continue
- **From template:** prompt ou sketch manual → vídeo animado
- **Upload DESIGN.md:** design system aplicado automaticamente a todos os prompts futuros

## Padrão de Prompt Eficaz

4 inputs obrigatórios: **goal, layout, content, constraints**

Quando o design system é upado + o prompt é específico: resultados distintos. Sem isso: "mesmo design em todo lugar".

## Iteração

- **Estrutural:** chat ("Show me 3 alternative layouts.") → Tweaks
- **Pixel-level:** canvas → edit button → selecionar elemento → editar inline
- **Branching:** pedir para salvar o estado atual antes de experimento radical

## Exportação

Formatos: Send to Canva (instável), PPTX, PDF, HTML standalone, bundle para Claude Code.

## Hack: Copiar Estilo de Qualquer Marca

[getdesign.md](https://getdesign.md/) — baixa `DESIGN.md` de marcas (Mastercard, Airbnb, Ferrari). Subir no Claude Design → replica o estilo instantaneamente.

## Workflow com Cowork

1. [[03-RESOURCES/entities/Claude-Cowork]]: gerar `DESIGN.md` a partir dos assets de marca
2. Claude Design: subir `DESIGN.md` → aplicado em todos os prompts futuros
3. Gerar → Iterar (Tweaks) → Validar (WCAG, responsive) → Exportar

## Posicionamento

- Antes do Claude Design: 1 dia de trabalho para uma landing page. Com Claude Design: ~1 hora.
- Competidor direto percebido: **Figma** (perdeu $730M de valuation após o anúncio)
- Alternativa preferida para slides: Gamma (mais diversidade e simplicidade)

## Limitação Central

Claude Design não tem **taste** — não sabe qual dos 10 designs gerados enviar para usuários específicos. Isso ainda é humano.

## Workflow Completo (Masterclass Corey Ganim)

### Fórmula de Prompt
**Goal + Layout + Content + Audience + Tone** — sem linguagem técnica de design.

### Setup em 5 min
1. Ir para claude.ai/design (Pro ou Max)
2. Criar novo projeto
3. Upload de logo, brand guidelines, site para crawl
4. Build da primeira entrega

### Métodos de Iteração

| Método | Uso |
|--------|-----|
| Chat | Mudanças estruturais, direção estética |
| Inline Comments | Tweak em elemento específico |
| Direct Editing | Editar texto direto no canvas |
| Adjustment Knobs | Sliders custom (spacing, color intensity) |

### ROI Solopreneur
- Landing page: $2K–3K designer → incluso na assinatura, 15 min
- Pitch deck: 4–5h PPT → 20 min
- Batch social graphics (5): 1.5h → 10 min

## Fontes

- [[03-RESOURCES/sources/ai-agents-harness/claude-design-guide-rubenhassid]] — guia prático de Ruben Hassid
- [[03-RESOURCES/sources/ai-agents-harness/claude-design-masterclass-beginners]] — masterclass completa (Corey Ganim, @coreyganim)

## Conexões

- [[03-RESOURCES/entities/Claude-Opus-47]] — modelo base
- [[03-RESOURCES/entities/Claude-Cowork]] — usado para extrair DESIGN.md
- [[03-RESOURCES/concepts/claude-code-tooling/claude-research-mode]] — gera markdown para o "video hack"
- [[03-RESOURCES/concepts/ai-strategy-org/agentic-video]] — vídeos animados gerados por IA
- [[03-RESOURCES/concepts/learning-cognition/adaptive-thinking]] — base do Opus 4.7
