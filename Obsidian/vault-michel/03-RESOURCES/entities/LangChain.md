---
title: "LangChain"
type: entity
category: tool
tags: [entity, tool, framework]
created: 2026-05-31
updated: 2026-06-01
status: developing
---

# LangChain

Framework Python/JavaScript para aplicações LLM, com abstrações de chains, agents, tools e memory.

## O que é / What it is

LangChain padronizou o vocabulário de desenvolvimento LLM: chains (sequências de passos), agents (LLMs com tool use), retrievers (RAG) e memory (estado entre turnos). LangGraph estende isso para workflows de agente com grafos de estado. LangSmith adiciona observabilidade e tracing. Frequentemente criticado por over-abstraction que dificulta debugging.

## Relevância para o vault

Referência de arquitetura para Michel ao desenhar agentes de vault. Os padrões do LangChain (chain, retrieval, memory) informam como skills e agentes são estruturados, mesmo sem usar o framework diretamente.

## Sources

- [[03-RESOURCES/entities/Flowise]]
