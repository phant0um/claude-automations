---
title: "How ML Systems Actually Work — 38 Concepts"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, ml-systems, embeddings, feature-stores, recommendations, interview-prep]
score: 7
author: "Paolo Perrone (via Neo Kim Newsletter)"
source_url: "https://newsletter.systemdesign.one/p/machine-learning-system-design-interview"
domain: ml-research-papers
---

# How ML Systems Actually Work — 38 Concepts

**Paolo Perrone** (ML engineer, 8+ anos de production AI) em System Design Newsletter #146. Field guide plain-English para ML system design — vocabulário e building blocks.

## Objetivo

Prep para ML system design interview: não algoritmos ou LeetCode, mas como sistemas ML reais funcionam. Traced through Netflix recommendations, Uber ETA predictions, Spotify Discover Weekly.

## Conceitos-Chave (estrutura do guia)

**Foundation:**
- Embeddings → representações vetoriais de entidades (users, items, content)
- Feature Stores → repositório centralizado de features para training e serving
- Model drift → degradação de performance em produção por data shift

**Produção:**
- Training pipeline vs serving pipeline
- Online learning vs batch retraining
- A/B testing e experiment tracking

**Sistemas Reais Mapeados:**
- **Netflix**: recommendation via collaborative filtering + embeddings
- **Uber**: ETA predictions com feature store real-time + historical
- **Spotify Discover Weekly**: candidate generation → ranking → reranking pipeline

## Por Que Este Guia

Maioria do prep foca em algoritmos. Entrevistas de ML system design pedem como sistemas *funcionam juntos*: como feature store alimenta tanto training quanto inference, como evitar training-serving skew, como escalar embedding lookup.

## Contexto

Mesmo newsletter (#146) que mencionou AgentField / "harness-as-membrane" como sponsor — sinal de convergência entre ML engineering e agent engineering.

## Ver Também

- [[03-RESOURCES/concepts/llm-ml-foundations/rl-training-llms]]
- [[03-RESOURCES/sources/ml-research-papers/clipping-21-rl-concepts]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-engines-hardware-first]]
