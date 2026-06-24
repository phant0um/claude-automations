---
title: Adaptive Thinking
type: concept
status: developing
updated: 2026-04-16
tags: [claude, reasoning, opus-47, thinking]
---

# Adaptive Thinking

Mecanismo de raciocínio do [[03-RESOURCES/entities/Claude-Opus-47|Claude Opus 4.7]] que substituiu o Extended Thinking com budget fixo. Em vez de alocar um budget de tokens de pensamento pré-definido, o modelo decide dinamicamente quando e quanto pensar antes de responder.

## Diferença vs Extended Thinking

| Extended Thinking (4.6) | Adaptive Thinking (4.7) |
|---|---|
| Budget fixo definido pelo usuário | Modelo decide quando pensar mais |
| Sempre pensa pelo tempo alocado | Pensa apenas quando necessário |
| Mais previsível em custo | Mais eficiente em tarefas simples |

## Controle pelo usuário

- Para **mais** raciocínio: `"Think carefully and step-by-step; this problem is harder than it looks"`
- Para **menos** raciocínio: `"Prioritize responding quickly rather than thinking deeply"`
- Nível `max` tende a "overthinking" — usar com parcimônia

## Fontes

- [[03-RESOURCES/sources/misc-low-confidence/claude-knowledge-digest-abril-2026]]
- [[03-RESOURCES/sources/guides-courses-howtos/best-practices-claude-opus-47-claude-code]]
