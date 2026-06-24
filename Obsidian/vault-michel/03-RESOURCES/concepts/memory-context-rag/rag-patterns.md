---
title: "RAG Patterns"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# RAG Patterns

Quatro padrões distintos de RAG — da recuperação ingênua à iteração agêntica — cada um com trade-offs de custo, latência e qualidade.

## O que é

Padrões arquiteturais que definem como a etapa de recuperação interage com o modelo de linguagem. A escolha do padrão determina qualidade da resposta, custo por query e complexidade de implementação.

## Como funciona

**Naive RAG** — fluxo direto: query → chunked retrieval → geração. Simples, rápido, mas sensível à qualidade do chunk e ao vocabulário exato da query.

**Advanced RAG** — enriquece o fluxo em pré e pós-retrieval:
- _Query expansion_: reformula a query em múltiplas variantes antes de buscar
- _HyDE_ (Hypothetical Document Embeddings): gera documento hipotético e usa seu embedding para buscar
- _Reranking_: reordena chunks recuperados por relevância com um cross-encoder antes de passar ao LLM

**Modular RAG** — decompõe o pipeline em módulos trocáveis: roteador de fontes (qual index consultar), fusion (combinar múltiplos retrievals), compressor de contexto. Permite composição flexível para domínios complexos.

**Agentic RAG** — recuperação iterativa controlada pelo modelo: self-ask, tree of thought, reflexão. O LLM decide quando buscar mais informação, qual query emitir e quando parar. Maior qualidade; maior custo e latência.

## Por que importa

Naive RAG falha em perguntas multi-hop ou quando a query não corresponde ao vocabulário dos documentos. Advanced RAG resolve 80% desses casos a custo moderado. Agentic RAG é necessário para raciocínio profundo mas é 5–10× mais caro por resposta. Escolher o padrão certo evita over-engineering e custo desnecessário.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/rag]]
- [[03-RESOURCES/concepts/rag-architecture]]
- [[03-RESOURCES/concepts/agent-orchestration]]
