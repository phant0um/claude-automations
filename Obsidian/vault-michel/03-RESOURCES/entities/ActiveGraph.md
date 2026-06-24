---
title: ActiveGraph
type: entity
categoria: framework
autor: Yohei Nakajima (BabyAGI)
tags: [ai-agents, memory, continuity, framework]
created: 2026-05-19
updated: 2026-05-19
---

# ActiveGraph

## O que é

Camada de **continuidade** para agentes long-running. Mantém grafo persistente de estado, contexto e dependências entre sessões — pensado para agentes que rodam por horas/dias e precisam recuperar contexto sem re-fazer trabalho.

Autor: **Yohei Nakajima** (criador do BabyAGI). Distinto do BabyAGI: BabyAGI é loop de tasks; ActiveGraph é a memória/grafo que sustenta esse loop entre interrupções.

## Por que importa

Resolve o problema central de agentes long-running: **context decay**. Em runs longos, agentes perdem fio do que já fizeram ou re-investigam coisas resolvidas. ActiveGraph indexa decisões, evidências e edges entre eles.

## Conexões

- Conceito relacionado: [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — compounding de contexto entre sessões
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
- Fonte primária: [[03-RESOURCES/sources/memory-context-rag/activegraph-a-continuity-layer-for-long-running-agents]]
- Fonte secundária: [[03-RESOURCES/sources/hermes-agent/x-api-hermes-via-xurl-skill]] (mislabeled, contém conteúdo ActiveGraph)

## Status

Open-source, em desenvolvimento ativo. Verificar repo no GitHub `yoheinakajima`.
