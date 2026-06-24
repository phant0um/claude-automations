---
title: "Archify — Claude Skill: Architecture Diagrams with Dark/Light Theme & Multi-format Export"
type: source
category: tools
author: "tt-a1i"
source: "https://github.com/tt-a1i/archify"
published: 2026-05-18
ingested: 2026-05-18
hash: 8c5d0f5fb43f9d95a1480ecdfadcde1a
tags:
  - claude-skill
  - architecture-diagram
  - developer-tools
  - open-source
  - visualization
triagem_score: 6
---

# Archify — Claude Skill: Architecture Diagrams

## Tese central

Archify é uma Claude Skill (single-file HTML output) que converte descrição em linguagem natural em diagramas técnicos de alta qualidade — suportando 5 tipos de diagrama, tema dark/light em um clique, e exportação 4× nativa (PNG/JPEG/WebP/SVG) sem upscaling.

## Origem

Fork de [[03-RESOURCES/entities/Cocoon-AI]] `architecture-diagram-generator` v1.0 (apenas dark HTML). Reescrito do zero como sistema CSS-variable-driven temável.

## 5 tipos de diagrama suportados

| Tipo | Use case |
|------|----------|
| Architecture | Componentes, cloud resources, service boundaries |
| Workflow | Request lifecycle, CI/CD, approval flows, runbooks |
| Sequence | API call chains, cache miss, auth, async trace |
| Data Flow | ETL/ELT, PII isolation, data lineage, downstream consumers |
| Lifecycle | State machines, agent run lifecycle, retry/cancel/timeout |

## Key insights

1. **Single-file HTML**: zero dependências, compartilhável com um arquivo.
2. **Exportação 4× nativa**: PNG/JPEG/WebP renderizados no browser à resolução nativa — sem bitmap upscaling (bug corrigido em v2.3).
3. **SVG dual-theme auto**: SVG exportado tem duas paletas + `@media (prefers-color-scheme)` — funciona no GitHub README sem precisar de dois arquivos `<picture>`.
4. **Iteração via chat**: "move Redis to the left", "add Kafka", "trocando auth service para rosa" — o diagrama atualiza conversacionalmente.
5. **Keyboard shortcuts**: T (toggle theme), E (export menu).
6. **Workflow ≠ flowchart genérico**: tem swim lanes, semantic colors, caminhos async/approval/observability.

## Evolução de versões

v1.0 → 2.0 (CSS vars) → 2.1 (clipboard + keyboard) → 2.2 (print styles + local font fallback) → 2.3 (4× native rasterization) → 2.4 (SVG dual-theme self-contained).

## Links

- Entidade base: [[03-RESOURCES/entities/Cocoon-AI]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agentic-skills]], [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]]
