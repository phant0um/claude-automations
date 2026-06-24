---
title: "Mem0"
type: entity
category: tool
tags: [entity, tool, memory]
created: 2026-05-31
updated: 2026-06-01
status: developing
---

# Mem0

Camada de memória persistente para agentes IA, com extração automática e busca semântica sobre memórias.

## O que é / What it is

Mem0 monitora conversas, extrai fatos relevantes automaticamente e os armazena em banco vetorial. Busca semântica recupera memórias por contexto, não por keyword exata. Disponível como API gerenciada ou self-hosted. Funciona como motor de personalização: quanto mais o agente interage, mais contextualizado fica.

## Relevância para o vault

Alternativa ao gerenciamento manual de memória que Michel faz via `MEMORY.md` e `token-savior memory_*`. Mem0 poderia automatizar a extração de preferências e padrões de uso do vault sem custo de manutenção manual.

## Sources

- [[03-RESOURCES/entities/llm]]
