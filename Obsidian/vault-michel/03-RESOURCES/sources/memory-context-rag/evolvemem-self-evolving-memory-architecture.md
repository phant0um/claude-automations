---
title: "EvolveMem: Self-Evolving Memory Architecture via AutoResearch for LLM Agents"
type: source
source: Clippings/EvolveMem Self-Evolving Memory Architecture via AutoResearch for LLM Agents.md
created: 2026-05-22
ingested: 2026-05-23
tags: [memory, ai-agents, self-evolving, automl, research-paper]
institutions: [UNC-Chapel Hill, UC Berkeley, UCSC]
score: 9
---

## Tese central
EvolveMem: arquitetura de memória self-evolving que expõe sua configuração completa de retrieval como action space, otimizado por módulo de diagnóstico LLM-powered. Sistema conduz AutoResearch sobre sua própria arquitetura — eliminando tuning manual de configuração. Memória e mecanismo de retrieval co-evoluem.

## Argumentos principais
- Sistemas de memória existentes: conteúdo evolui, mas scoring functions/fusion strategies/políticas de geração permanecem congeladas
- EvolveMem: expõe configuração de retrieval como structured action space → diagnóstico LLM lê failure logs → identifica root causes → propõe ajustes → meta-analisador aplica com revert-on-regression e explore-on-stagnation
- AutoResearch: ciclos iterativos autônomos de pesquisa sobre a própria arquitetura
- Diferentes tipos de perguntas requerem estratégias diferentes: factual lookups → keyword matching, temporal reasoning → time-aware filtering, multi-hop → query decomposition
- Configurações evoluídas transferem entre benchmarks com positive transfer (não catastrophic) → princípios universais de retrieval, não heurísticas específicas de benchmark

## Key insights
- "Truly adaptive memory requires co-evolution at two levels: stored knowledge AND retrieval mechanism"
- Diagnóstico: lê failure logs por questão, identifica root causes, propõe targeted configuration adjustments
- Guarded meta-analyzer: aplica mudanças com auto-revert se performance regride
- explore-on-stagnation: explora novas dimensões de configuração não presentes no action space original
- Emerge: sistema descobre estratégias efetivas incluindo dimensões de configuração inteiramente novas

## Exemplos e evidências
- LoCoMo: +25.7% relativo vs strongest baseline; +78.0% relativo vs minimal baseline
- MemBench: +18.9% relativo vs strongest baseline
- Transfer cross-benchmark: positive transfer → princípios universais confirmados

## Implicações para o vault
Valida o conceito de hill-climbing em agentes (ver [[04-SYSTEM/agents/core/hill]]). O mecanismo de diagnóstico + revert é exatamente o que o pipeline de self-improvement do vault deveria implementar. EvolveMem = blueprint para um sistema de memória que melhora seu próprio retrieval.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-memory-layers]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-systems]]
- [[04-SYSTEM/agents/core/hill]]
- [[03-RESOURCES/sources/memory-context-rag/framework-agent-memory-remember-cite-forget]]
