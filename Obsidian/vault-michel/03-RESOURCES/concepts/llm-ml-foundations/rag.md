---
title: "RAG — Retrieval-Augmented Generation"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# RAG — Retrieval-Augmented Generation

Combinar recuperação de uma base de conhecimento externa com geração de LLM para respostas fundamentadas em dados atuais e verificáveis.

## O que é

RAG é uma arquitetura que desacopla o conhecimento dos pesos do modelo. Em vez de depender do que o LLM memorizou durante pretraining, a resposta é construída a partir de trechos recuperados em tempo real de uma base de dados vetorial ou textual. O modelo vira um **raciocínio sobre evidências**, não uma memória.

## Como funciona

Pipeline básico em 4 etapas:

1. **Query** — a pergunta do usuário é processada (expandida, reformulada se necessário).
2. **Recuperação** — a query é transformada em vetor pelo **modelo de embedding** e comparada com os vetores do **vector store** (FAISS, Pinecone, Chroma, pgvector). Top-k chunks mais similares são retornados.
3. **Aumento** — os chunks recuperados são inseridos no prompt junto com a query original.
4. **Geração** — o LLM gera a resposta fundamentada nos chunks.

**Componentes críticos:**
- **Chunking strategy**: tamanho e sobreposição dos chunks afetam qualidade da recuperação. Chunks muito grandes perdem precisão; muito pequenos perdem contexto.
- **Reranking**: após recuperação por embedding (recall alto, precisão média), um reranker cross-encoder re-ordena os resultados por relevância (precisão alta, custo maior).
- **Embedding model**: all-MiniLM, BGE, Cohere Embed; cada um com tradeoffs de velocidade e qualidade.

## Por que importa

RAG supera fine-tuning para **conhecimento factual atualizado**: não exige re-treinar o modelo, permite citar fontes, e pode ser atualizado adicionando documentos. A limitação principal é o **teto de qualidade da recuperação** — se o chunk certo não for recuperado, o LLM não pode compensar. Para o vault Michel, RAG é o padrão por trás de qualquer "busque no meu vault".

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/rag-patterns]]
- [[03-RESOURCES/concepts/rag-architecture]]

## Evidências
- **[2026-06-24]** Skills for Real Engineers. Straight from my .claude directory. - skills/skills/in-progress/loop-me/SKILL.md at main · ma — [[skillsskillsin-progressloop-meskill-md-at-main-2]]

- **[2026-06-24]** 很多 AI 记忆系统，最后都会变成同一种形状：把聊天记录、用户信息、上传文档、工作流结果，全部切成 chunk，塞进向量库里，等下一次需要的时候再 RAG 出来。这当然有用。但问题是，“记得更多”不等于“记得更好”。真正难的是：不同类型的记 — [[wiki-reflection-agent-memory]]
- **[2026-06-24]** Learn how to architect an end-to-end pipeline that processes surgical video at the edge for de-identification, instrumen — [[edge-to-cloud-architecture-for-real-time-surgical-intelligence-with-aws-and-nvidia]]
- **[2026-06-24]** In this post, we walk you through how FRESH is translating cloud-enabled analytics into practical tools that support res — [[how-ntu-fresh-is-using-aws-to-build-predictive-food-safety-at-scale]]
- **[2026-06-24]** The session and run contract you touch: continuation tokens, stream handles, the NDJSON event stream, and reconnecting. — [[sessions-runs-streaming]]
- **[2026-06-24]** You finish a great book. Two weeks later you cannot remember a single chapter. Not because you are dumb. Because nobody — [[the-feynman-method-why-you-forget-90-of-what-you-read-and-the-4-prompts-that-fix-it]]
- **[2026-06-24]** How Kilo Security Agent uses AI reachability analysis to reduce false positives and prioritize exploitable vulnerabiliti — [[why-most-dependency-alerts-don-t-matter]]
- **[2026-06-24]** Svelte 5 binding that drives an eve agent session from the browser. — [[useeveagent-svelte]]
- **[2026-06-24]** Vue composable that drives an eve agent session from the browser. — [[useeveagent-vue]]
- **[2026-06-24]** tags: — [[world-models-in-pieces-structural-certification-for-general-agents]]
- **[2026-06-24]** Introduction Migration assessment and planning is rarely a single-pass exercise. Inventory data is incomplete; assumptio — [[accelerating-migration-assessments-and-planning-with-aws-transform]]
- **[2026-06-24]** Learn about the Apache Iceberg 1.11 release. Discover smarter REST catalog capabilities, LIMIT pushdown, and production- — [[apache-iceberg-1-11-features-rest-catalog-encryption]]