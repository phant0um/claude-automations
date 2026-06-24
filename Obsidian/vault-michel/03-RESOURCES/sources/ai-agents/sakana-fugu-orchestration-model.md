---
title: "Sakana Fugu: Multi-Agent Orchestration as a Single Model API"
type: source
source_url: "https://sakana.ai/fugu"
author: "Sakana AI"
published: 2026-06-21
created: 2026-06-22
score: B
category: ai-agents
tags: [source, ai-agents, multi-agent, orchestration, sakana, model-routing, ai-sovereignty]
---

# Sakana Fugu: Multi-Agent System as A Model

Sakana AI's Fugu é um modelo LLM treinado para orquestrar múltiplos LLMs em um agent pool — incluindo instâncias de si mesmo recursivamente. Acessível via single OpenAI-compatible API.

## Tese Central

O futuro de AI não é modelos monolíticos maiores, mas **ecossistemas colaborativos**. Fugu trata orquestração não como otimização técnica mas como imperativo geopolítico e operacional — dependência de um único vendor é vulnerabilidade material.

## Arquitetura

### Orchestration Model
- Fugu é **ele mesmo um LLM** treinado para chamar outros LLMs
- Gerencia: model selection, delegation, verification, synthesis automaticamente
- Resolve tasks diretamente quando suficiente, ou coordena team de expert models quando preciso
- Complexidade do multi-agent **nunca alcança o código do usuário** — abstraído num único endpoint

### Dois Tiers
- **Fugu**: performance + baixa latência para everyday work (Codex, chatbots, interactive services)
- **Fugu Ultra**: flagship para hard multi-step problems (AI research, cybersecurity, patent investigations)
- Opt agents out of pool para data compliance

### AI Sovereignty Argument
- Export controls (Fable, Mythos models) mostram que acesso pode desaparecer overnight
- Collective intelligence = hedge contra concentration of power
- Pool de swappable agents permite **route around vendor restrictions**
- "Resilient blueprint for true AI sovereignty"

## Por que é Score B

- Thread/Twitter resumido — não inclui blog post completo nem paper técnico
- Conceito (orchestration model) é forte e diretamente relevante ao vault
- AI sovereignty argument adiciona dimensão geopolítica útil
- Limitado por ser announcement não deep-dive

## Conexões Vault

- [[03-RESOURCES/entities/Sakana-AI]] — Sakana como entity
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]] — Fugu = model routing como produto
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]] — orchestration pattern
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]] — recursive self-call pattern

## Notas

Fugu é essencialmente [[03-RESOURCES/concepts/agent-systems/agent-model-routing|model routing]] comercializado como produto. O vault já implementa isso no pipeline-semanal (Haiku para triagem, Sonnet para ingest/report). A inovação é treinar o router em si mesmo como LLM em vez de regras determinísticas.

AI sovereignty argument é importante para o vault: usar models open-source (Qwen, GLM, DeepSeek) como fallback para Claude/Anthropic é mesma estratégia em menor escala.