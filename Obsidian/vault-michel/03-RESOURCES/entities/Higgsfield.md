---
title: "Higgsfield"
type: entity
category: tool
tags: [entity, tool, video-generation, mcp, ai-agents]
created: 2026-05-31
updated: 2026-06-01
---

# Higgsfield

**URL:** mcp.higgsfield.ai/mcp · Plataforma de geração de vídeo por IA

Plataforma de geração de vídeo por IA com endpoint MCP, usada no stack do Hermes Agent para renderizar anúncios de ecommerce a partir de prompts estruturados.

## Contribuições relevantes

- Conecta ao Claude Code via MCP (endpoint: `https://mcp.higgsfield.ai/mcp`) → Settings → Connectors
- Aceita prompts estruturados com shot-by-shot effect timeline, effect inventory, density map e energy arc
- Componente de renderização no stack kidpakerot: ViralBuilder → Claude skill → Higgsfield → vídeo final
- Substitui workflow manual de produção de vídeo de $500–$2.000 + 3 horas por 10 minutos

## Fontes no vault

- [[03-RESOURCES/sources/hermes-agent/clipping-kidpakerot-hermes-claude-higgsfield-viralbuilder-stack]] — stack completo com Higgsfield como renderizador final
- [[03-RESOURCES/sources/hermes-agent/clipping-post-kidpakerot-hermes-higgsfield]] — demonstração de produção de vídeo
