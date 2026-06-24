---
title: "+29k Stars, No Vectors: How PageIndex Replaces Embeddings With LLM Reasoning"
type: source
source_file: "clippings/+29k Stars, No Vectors How PageIndex Replaces Embeddings With LLM Reasoning 1.md"
author: "@AlphaSignalAI"
published: 2026-05-07
ingested: 2026-05-09
tags:
  - pageindex
  - retrieval
  - no-vectors
  - llm-reasoning
  - rag-alternative
  - embeddings
triagem_score: 8
---

# +29k Stars, No Vectors: How PageIndex Replaces Embeddings With LLM Reasoning

## Thesis

[[03-RESOURCES/entities/PageIndex]] eliminates vector embeddings from document retrieval entirely. Instead of cosine-similarity nearest-neighbor lookup, it builds a hierarchical tree from a document and lets an LLM reason over the tree structure to select which pages contain the answer. [[03-RESOURCES/entities/VectifyAI]]'s benchmark system Mafin 2.5 — built on PageIndex — hits 98.7% on the full 10,231-question FinanceBench set.

## How PageIndex Works

### Phase 1 — Tree Index Construction

1. PDF parsed per-page via PyPDF2 or PyMuPDF.
2. LLM scans first 20 pages to detect a table of contents.
3. Three processing modes: TOC with page numbers → TOC without page numbers → no TOC.
4. `verify_toc()` runs LLM-based fuzzy title matching on every TOC item; `fix_incorrect_toc_with_retries()` reattempts up to 3 times.
5. If accuracy < 60%, system falls back to next mode; after all three fail, raises `Processing failed`.
6. Nodes > 10 pages AND > 20,000 tokens are recursively split with the same LLM extraction.

### Phase 2 — Reasoning-Based Retrieval

Three agent tool functions: `get_document()` (metadata), `get_document_structure()` (tree without text), `get_page_content()` (specific pages). The LLM receives the tree, selects node IDs in JSON, system fetches text, LLM writes the answer.

**MCTS gap:** Docs reference value-function Monte Carlo Tree Search. The open-source code ships only the LLM-prompt tree-search variant. MCTS is cloud-only.

## Comparison vs. Vector RAG

| Dimension | Vector RAG | PageIndex |
|---|---|---|
| Retrieval mechanism | Cosine similarity on embeddings | LLM reasoning over structural tree |
| Failure mode | Syntactic neighbors, not semantic answers | Tree construction failure on complex PDFs |
| Long-doc performance | Degrades on 600-page docs | Designed for structured long docs |
| Setup cost | Embedding model + vector store | LLM API calls at index + query time |
| MCTS | N/A | Cloud-only (OSS ships prompt-search only) |

PageIndex wins on: long structured documents (10-Ks, compliance binders, contracts). Loses on: latency-sensitive short-doc chat, scanned PDFs without OCR, tight API budgets.

## Current Limitations

- MCTS retrieval is cloud-only.
- No OCR — scanned PDFs need preprocessing.
- TOC verification capped at 3 retries; complex PDFs can hit the failure path.
- No SECURITY.md; 6 open security issues (LiteLLM supply-chain patched via `litellm==1.83.7`).
- 89.3% of 281 commits from 2 contributors — bus factor risk.

## AlphaSignal Verdict

"Worth Watching, not yet production-grade." Moves to Production Ready when: MCTS in OSS, SECURITY.md + external audit, team-published latency benchmark, OSS OCR parser.

## Conexoes

- [[03-RESOURCES/entities/PageIndex]] — the framework itself
- [[03-RESOURCES/entities/VectifyAI]] — org behind PageIndex
- [[03-RESOURCES/concepts/llm-ml-foundations/no-vector-retrieval]] — core architectural concept
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-retriever]] — LLM doing retrieval reasoning instead of embedding lookup
- [[03-RESOURCES/concepts/pkm-obsidian/hierarchical-document-index]] — the tree-building phase
- [[03-RESOURCES/concepts/llm-ml-foundations/optical-context-retrieval]] — adjacent retrieval concept in wiki

---

## Por que o modelo de árvore funciona onde embeddings falham

A falha fundamental dos embeddings em documentos longos não é técnica — é epistemológica. Um embedding captura a semântica local de um chunk, mas não captura **a posição desse chunk no argumento do documento**. Para um relatório financeiro de 600 páginas, saber que o capítulo 7 discute "receita líquida" não diz ao sistema se essa discussão é o valor principal, uma comparação histórica, uma projeção ou uma nota de rodapé contábil.

O índice hierárquico do PageIndex resolve isso porque preserva a **estrutura de intenção** do documento: a tabela de conteúdo não é metadado decorativo — é o esquema de como o autor organizou o raciocínio. O LLM que navega a árvore raciocina sobre posição e relevância relativa, não apenas similaridade semântica de strings.

Esse insight vale para qualquer domínio com documentos longos estruturados: contratos jurídicos, bulas de remédio, manuais de engenharia, relatórios regulatórios. Todos têm hierarquia intencional que embeddings destruem no processo de chunking.

---

## Mecanismo detalhado: as três funções de tool

O LLM de retrieval opera com apenas três ferramentas, o que é intencionalmente minimalista:

**`get_document(doc_id)`** — retorna metadados: título, autores, data, número de páginas, tamanho em tokens. Permite ao LLM decidir se o documento é relevante antes de explorar sua estrutura.

**`get_document_structure(doc_id)`** — retorna a árvore de nós (seções, subseções, capítulos) sem o texto de conteúdo. Essa é a etapa de planejamento: o LLM recebe o mapa e decide quais ramos explorar.

**`get_page_content(doc_id, page_ids)`** — fetches o texto real de páginas específicas. O LLM só chama essa função para páginas que a navegação da estrutura identificou como relevantes.

Esse design de três etapas (metadata → structure → content) imita como um humano usa um livro: verifica se é o livro certo, vai ao índice, abre as páginas relevantes. A diferença é que o LLM pode processar estruturas muito mais complexas em paralelo do que um humano.

---

## O gap MCTS: o que a versão OSS não tem

O **Monte Carlo Tree Search** mencionado na documentação é a versão premium do motor de retrieval. No MCTS, o sistema não seleciona nós da árvore com uma passagem linear — ele simula múltiplos caminhos de exploração, avalia o valor esperado de cada subárvore com uma função de valor, e escolhe o caminho com maior valor esperado para expansão.

Na versão OSS, o LLM faz uma passagem de raciocínio sobre a estrutura da árvore e seleciona nós por julgamento direto — o que funciona bem para árvores simples, mas pode subperformar em documentos com hierarquias profundas e múltiplos ramos plausíveis.

Para contextos de uso no vault-michel, a ausência do MCTS é aceitável: os documentos ingestionados não têm 600 páginas. Para uso em financial analysis com 10-Ks completos, o MCTS seria o diferencial.

---

## Comparação com abordagens alternativas de retrieval

| Abordagem | Mecanismo | Melhor para | Pior para |
|---|---|---|---|
| BM25 | Frequência de termos (TF-IDF) | Queries de keyword exatas | Sinônimos, queries semânticas |
| Vector RAG padrão | Cosine similarity em chunks | Short docs, queries semânticas | Long docs, posição no argumento |
| HyDE (hypothetical document) | Embed query hipotética | Queries sem overlap lexical | Documentos estruturados |
| PageIndex (OSS) | LLM navega árvore | Long docs com TOC claro | PDFs escaneados, docs sem estrutura |
| PageIndex (cloud + MCTS) | Monte Carlo sobre árvore | Long docs complexos | Latência-sensitivo, orçamento apertado |

---

## Aplicabilidade no vault-michel

O vault-michel não opera com documentos de 600 páginas, mas o princípio do índice hierárquico é aplicável diretamente:

- A estrutura de `03-RESOURCES/concepts/` e `03-RESOURCES/entities/` funciona como uma árvore navegável.
- O `hot.md` é o equivalente funcional ao TOC verificado — um mapa das páginas mais acessadas que o LLM usa para orientação antes de explorar o vault.
- Queries complexas sobre o vault ("que conceitos se relacionam com context engineering e foram ingeridos nos últimos 30 dias?") se beneficiariam de raciocínio sobre a estrutura de diretórios antes de abrir arquivos individuais — exatamente o padrão que o PageIndex formaliza.
