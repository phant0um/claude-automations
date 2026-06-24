---
title: "+29k Stars, No Vectors How PageIndex Replaces Embeddings With LLM Reasoning 1"
type: source
source_type: clipping
source_path: clippings/+29k Stars, No Vectors How PageIndex Replaces Embeddings With LLM Reasoning 1.md
created: 2026-05-09
ingested: 2026-05-09
tags: [ai-agents, clipping]
triagem_score: 7
---

## Resumo

![Imagem](https://pbs.twimg.com/media/HHu-hfQWoAAqX42?format=jpg&name=large)

## VectifyAI's tree-based RAG hits 98.7% on FinanceBench. The MCTS the docs mention isn't in the open-source code.

**PageIndex** is a vectorless RAG framework that builds a hierarchical tree from a document and lets the LLM reason which pages answer a query.

**VectifyAI** open-sourced it on April 1, 2025. The repo has crossed +29k GitHub stars and hit #1 of the day on GitHub Trending.

**Mafin 2.5**, a financial-QA system built on top of PageIndex, hit 98.7% on FinanceBench's full 10,231-question set, with the eval

## Origem

- Path: `clippings/+29k Stars, No Vectors How PageIndex Replaces Embeddings With LLM Reasoning 1.md`
- Categoria: ai-agents
- Ingerido: 2026-05-09

## Cross-links

_Pendente — autoresearch/lint cycle._

---

## O que é PageIndex

**PageIndex** é um framework de RAG (Retrieval-Augmented Generation) que elimina completamente o uso de embeddings vetoriais e bancos vetoriais. Em vez de converter documentos em vetores e buscar por similaridade cosseno, ele constrói uma **árvore hierárquica** sobre o documento e usa o próprio LLM para raciocinar sobre quais páginas contêm a resposta.

A ideia central: embeddings aproximam semântica por similaridade de distribuição estatística de tokens. LLM reasoning entende semântica de forma contextual. Para documentos estruturados (financeiros, jurídicos, técnicos), raciocínio contextual supera similaridade vetorial.

## Mecanismo técnico

1. **Indexação**: o documento é dividido em páginas/chunks e uma árvore hierárquica é construída — sumários de alto nível referenciam chunks de baixo nível
2. **Busca**: ao receber uma query, o LLM percorre a árvore top-down, decidindo em cada nó se os chunks filhos são relevantes
3. **Retrieval sem vetor**: nenhuma embedding é computada; a decisão de relevância é feita por raciocínio do modelo

O repo menciona MCTS (Monte Carlo Tree Search) para navegação da árvore — mas esta implementação não está no código open-source público, apenas nos resultados do paper.

## Resultado: 98.7% no FinanceBench

**Mafin 2.5**, sistema construído sobre PageIndex, atingiu 98.7% de precisão no FinanceBench — conjunto de 10.231 questões sobre documentos financeiros reais. Este é o benchmark padrão para QA financeiro baseado em documentos.

Para comparação, sistemas RAG tradicionais com embeddings tipicamente ficam entre 45-65% no FinanceBench. A diferença é atribuída à capacidade do LLM de entender estrutura de tabelas, notas de rodapé e referências cruzadas em documentos financeiros — algo que embeddings de texto plano não capturam bem.

## Por que 29k stars

O repo foi lançado em 1 de abril de 2025 pela VectifyAI e atingiu #1 no GitHub Trending no dia do lançamento. O crescimento orgânico se explica por três fatores:

1. **Timing**: 2025 foi o ano de saturação de pipelines RAG baseados em vetores — a comunidade buscava alternativas
2. **Resultados mensuráveis**: 98.7% é um número concreto em benchmark público, não uma claim vaga
3. **Simplicidade conceitual**: "sem vetores" é uma proposta de valor que se explica em uma frase

## Comparação: PageIndex vs RAG tradicional

| Dimensão | RAG vetorial | PageIndex |
|---|---|---|
| Indexação | Embedding por chunk | Construção de árvore |
| Busca | kNN por similaridade cosseno | LLM reasoning top-down |
| Custo de indexação | Alto (embedding calls) | Médio (LLM para sumarizar) |
| Custo de query | Baixo (kNN rápido) | Alto (LLM por nó da árvore) |
| Acurácia em docs estruturados | Média | Alta |
| Acurácia em docs longos | Cai com chunks | Preserva estrutura hierárquica |
| Dependência de infra | Banco vetorial | Apenas LLM API |

## Limitações e ressalvas

- **Custo por query**: cada busca consome múltiplas chamadas ao LLM para percorrer a árvore. Em alto volume, o custo pode superar pipelines vetoriais
- **MCTS não open-source**: a técnica que gerou os 98.7% não está no código público — o repo open-source é uma versão simplificada
- **Latência**: reasoning top-down é sequencial; sistemas vetoriais com kNN são paralelos e mais rápidos
- **Domínio**: os resultados são excepcionais para documentos financeiros estruturados; desempenho em documentos menos estruturados não está documentado

## Relevância para o vault

O princípio do PageIndex — usar LLM reasoning em vez de similaridade vetorial — é diretamente relevante para o design de agentes de pesquisa no vault. O agente `claude-mem` e o sistema de wiki usam lógica similar: em vez de embeddings, o contexto é carregado hierarquicamente via hot.md e wikilinks estruturados.

Um sistema de busca no vault baseado em PageIndex seria: construir uma árvore sobre o vault (wiki-index → conceitos → entidades → fontes) e deixar o modelo raciocinar sobre qual nó explorar, em vez de buscar por similaridade de embedding.

## Links

- [[03-RESOURCES/concepts/rag-architecture]] — comparação com pipelines RAG tradicionais
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — memória baseada em grafos vs vetores
- [[03-RESOURCES/entities/VectifyAI]] — organização por trás do PageIndex
- Repo: https://github.com/VectifyAI/PageIndex
