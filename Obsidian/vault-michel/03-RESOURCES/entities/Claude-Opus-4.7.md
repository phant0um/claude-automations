---
title: "Claude Opus 4.7"
type: entity
category: model
tags: [entity, ai-model, anthropic]
created: 2026-05-31
updated: 2026-06-01
status: developing
---

# Claude Opus 4.7

Modelo mais capaz da Anthropic, reservado para tarefas que excedem o alcance de Sonnet.

## O que é / What it is

Claude Opus 4.7 é o topo da linha Anthropic em capacidade de raciocínio e compreensão. Tem Fast mode disponível para reduzir latência. ID de API: `claude-opus-4-7`. Custo significativamente maior que Sonnet, justificado em raciocínio multi-passo complexo, análise de documentos muito longos e situações com instruções ambíguas que exigem julgamento mais sofisticado.

## Relevância para o vault

Michel escalona para Opus quando Sonnet retorna resultados insatisfatórios — especialmente em tarefas de `guard`, auditorias de vault e análise de sources densos. O agente `guard` é explicitamente configurado para rodar em Opus.

## Sources

- [[03-RESOURCES/entities/claude-models]]
- [[03-RESOURCES/entities/Claude]]
