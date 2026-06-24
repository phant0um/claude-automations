---
title: "The Economics of AI Reasoning"
type: source
source: "Clippings/The Economics of AI Reasoning.md"
created: 2026-06-19
ingested: 2026-06-21
tags: [articles, model-benchmarks]
---

## Tese central
Thread mapeia a economia de "reasoning"/test-time compute desde o1 (2024) até modelos atuais: gastar mais tokens/tempo de computação melhora acurácia (~10-20%), mas custa 5-10x mais tokens de output — e há tensão direta com agentic workflows, onde reasoning longo "rouba espaço" de tool calling antes de compactar contexto.

## Argumentos principais
- Dados empíricos: ~6x mais tokens gastos em prompts técnicos com reasoning habilitado; 7-11x mais tempo de conclusão; 10-20% de melhora de performance.
- 3 tipos de reasoning: **interleaved** (padrão atual — pensa entre tool calls, decide próxima ação pesando histórico); **adaptive** (modelo decide sozinho quanto raciocinar); **configurable** (usuário escolhe nível: low/medium/high).
- Reasoning é bom para desafios single-shot complexos, puzzles, matemática/lógica, bater benchmarks — mas em trajetórias agênticas (que valorizam encadear tool calls rápido e preciso), raciocínio longo pode ser contraproducente.
- Mesmo modelos abertos pequenos (Qwen-3.6-27B, Gemma-4-31B) com reasoning superam o SOTA do ano anterior (Sonnet-4 com reasoning) — democratização de capacidade via test-time compute, não só parâmetros.

## Key insights
- A tensão "reasoning longo vs espaço para tool calling antes de compactar" é exatamente o trade-off que justifica reasoning **configurable/adaptive** em vez de sempre-máximo para qualquer agente deste vault que faça tool calling intensivo (ex.: ingest-agent processando 65 fontes) — relevante para decisões futuras de `model-router`.
- "10-20% de melhora custando 5-10x mais tokens" é um dado quantitativo direto para justificar (ou não) habilitar reasoning alto em tarefas de triagem/scoring de rotina vs tarefas de decisão crítica única.

## Exemplos e evidências
- Comparações de benchmark GPT-5.5 (xHigh vs low vs no-reasoning), e Qwen-3.6-27B/Gemma-4-31B com reasoning vs Sonnet-4.

## Implicações para o vault
Dado quantitativo de apoio à arquitetura de `model-router` (Ollama local/cloud por tier) já adotada — reasoning configurável por dificuldade de tarefa é exatamente a lógica do roteamento já em uso, agora com números concretos de custo/benefício.

## Links
- [[04-SYSTEM/agents/nexus-agent-system/model-router]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
