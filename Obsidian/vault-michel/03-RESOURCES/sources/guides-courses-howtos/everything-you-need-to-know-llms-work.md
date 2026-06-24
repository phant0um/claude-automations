---
title: "Everything You Need to Know to Understand How LLMs Like ChatGPT Actually Work"
type: source
source: Clippings/Everything You Need to Know to Understand How LLMs Like ChatGPT Actually Work.md
author: "Neo Kim (newsletter #97), Louis-François Bouchard"
published: 2025-11-03
created: 2026-05-22
ingested: 2026-05-23
tags: [llm-foundations, education, ai-concepts]
score: 8
---

## Tese central
Guia sem matemática de 33 conceitos essenciais de LLMs: tokens, embeddings, alucinações, temperatura, contexto, RAG, agentes. Objetivo: vocabulário sólido para entender como LLMs funcionam na prática → melhores resultados, identificar falhas, escolhas sensatas.

## Argumentos principais
- Usuários que entendem o vocabulário base tomam decisões melhores sobre modelos/settings
- 33 conceitos cobertos sem matemática: suficiente para trabalho prático
- Alucinações: modo de falha mais comum — entender por que ocorrem permite mitigação
- Temperatura: controla "criatividade" vs "determinismo" — escolha depende do task

## Key insights
- **Tokens**: unidades atômicas que LLMs processam — não palavras, não caracteres
- **Embeddings**: representação vetorial de significado — similar meaning = similar vector
- **Context window**: limite do que o modelo "vê" em uma conversa
- **Temperature**: 0 = determinístico, 1 = criativo/aleatório
- **Hallucination**: modelo gera texto plausível mas factualmente incorreto — confidence não implica correção
- **RAG**: conectar LLM a conhecimento externo atualizado
- **Agents**: LLM + tools + loop de execução
- **Prompt engineering**: estrutura do input afeta dramaticamente o output

## Exemplos e evidências
- 33 conceitos: tokens, embeddings, context window, attention, temperature, top-k/top-p sampling, few-shot, chain-of-thought, RAG, agents, hallucinations, etc.
- Analogias simples para cada conceito

## Implicações para o vault
Referência didática para onboarding em LLMs. Útil como base para sessões de estudo FIAP + concurso público (onde AI/informática é tema crescente). Complementa [[03-RESOURCES/concepts/llm-ml-foundations/]].

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/llm-ml-foundations/tokenization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/rag]]
