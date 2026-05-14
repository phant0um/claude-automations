---
title: "Your LLM Pipeline Is Slow Because Your Agents Do Too Much"
type: source
source_file: .raw/articles/Your LLM Pipeline Is Slow Because Your Agents Do Too Much.md
author: Muratcan Koylan & Amit Kumthekar (Sully.ai)
ingested: 2026-04-17
tags: [context-engineering, multi-agent, decomposition, clinical-ai, latency]
---

# Your LLM Pipeline Is Slow Because Your Agents Do Too Much

> [!summary]
> Sully.ai descreve como substituíram um pipeline monolítico com loop de correção iterativa por agentes especialistas paralelos com contexto focado. Resultado: latência p50 de 37s → 7.5s, qualidade mantida ou melhorada, validado em 100k+ notas clínicas de produção.

## Tese Central

**Context engineering e iteração são substitutos, não complementos.**

Quando você decompõe uma tarefa complexa em sub-tarefas focadas, cada componente vê um contexto radicalmente mais estreito. O modelo faz uma coisa ao invés de oito. O first pass fica confiável. O loop de correção torna-se desnecessário.

> [!insight]
> Pesquisa: instruction-following accuracy cai de 92% com 200 tokens de instruções para 60% com 4000 tokens (Gupta et al., 2025). Mesmo os melhores modelos frontier atingem apenas 68% de acurácia com 500 instruções simultâneas.

## Pipeline V1 vs V2

**V1 (monolítico):**
- 1 agente gera todo o documento + loop de judge/refinement
- Loop capturava erros reais (+11% qualidade sem ele)
- Mas cada ciclo adicionava 10-15s e o refinement introduzia novos erros em ~39% dos casos

**V2 (decomposto):**
- Agentes especialistas paralelos, cada um vê apenas seu contexto
- Contexto compartilhado (transcript, regras) + contexto focado (instruções da seção, schema de 1-2 keys)
- 1 QA agent single-pass ao final
- Latência: p50 = 7.5s (de 37s), p95 = 16.3s (de 100s+)

## Achado Secundário: Seleção de Modelos

Decomposição muda qual modelo é viável:
- Em tarefas monolíticas: modelos maiores dominam
- Em tarefas focadas: gap se fecha — modelo 1B fine-tuned matchou GPT-4.1 a 99% de acurácia com 18x throughput

## Design Patterns

1. **Uniform agent interface** — orquestrador não sabe o tipo do agente; troca topologia sem mudar agentes
2. **Dynamic output contracts** — schema gerado por request (2 keys vs 15 keys); fan-in determinístico
3. **Focused context** — shared context (transcript, regras de segurança) + focused context (instruções de seção específica)

## Conceitos Relacionados

- [[context-engineering]]
- [[multi-agent-orchestration]]
- [[claude-agent-harness-architecture]]

## Entidades Mencionadas

- [[Sully-ai]] — empresa de clinical AI; autores do artigo
- [[Andrej Karpathy]] — citado sobre context engineering
