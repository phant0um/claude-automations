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
