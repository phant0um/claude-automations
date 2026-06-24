---
title: "MeMo: Memory as a Model"
type: source
source: "Clippings/MeMo Memory as a Model.md"
author: "Ryan Wei Heng Quek, Sanghyuk Lee, Alfred Wei Lun Leong, Arun Verma et al. (NUS, MIT CSAIL, A*STAR, Singapore-MIT Alliance)"
created: 2026-05-24
ingested: 2026-05-28
tags: [ai-agents, memory, rag, arxiv, source, ml-research]
url: "https://arxiv.org/html/2605.15156v2"
---

## Tese central

MeMo propõe um quarto paradigma de integração de conhecimento em LLMs: treinar um *Memory model* dedicado e pequeno (1.5B–14B) em um corpus-alvo via QA sintético de "reflections", mantendo o LLM principal (Executive model) completamente congelado. Resultado: recuperação de custo constante e independente do tamanho do corpus, compatível com qualquer LLM incluindo closed-source.

## Argumentos principais

Os três paradigmas existentes têm limitações fundamentais:
1. **Non-parametric (RAG/ICL)**: limitado por janela de contexto, sensível a ruído de recuperação, fraco em síntese cross-document.
2. **Parametric (CPT/SFT)**: caro computacionalmente, catastrofic forgetting, não funciona com modelos fechados.
3. **Latent memory** (AutoCompressor, Gist tokens): *representation coupling* — memória presa ao modelo que a produziu, não transferível.

MeMo resolve todos com uma separação limpa: Executive model (raciocínio) + Memory model (conhecimento) comunicando via linguagem natural.

## Key insights

- **Reflections**: o conceito central. QA derivado do corpus que não contém watermarks ou IDs de documentos — força o Memory model a internalizar conhecimento parametricamente, não a copiar de contexto recuperado.
- **Pipeline de 5 etapas** para gerar reflection QA dataset: (1) fact extraction, (2) consolidation de QA redundantes, (3) verification/rewriting de self-containment, (4) entity surfacing, (5) cross-document synthesis. Nenhuma etapa require queries futuras.
- **Inferência em 3 estágios**: Grounding (decomposição em sub-queries atômicas) → Entity Identification (narrowing de candidatos) → Answer Seeking + Synthesis. Custo de retrieval = constante (independente do tamanho do corpus).
- **Model merging para integração contínua**: múltiplos Memory models treinados em corpora distintos podem ser mesclados via task vectors (ϕᵢ - ϕ₀) sem retreinar no conjunto completo.
- **Plug-and-play**: Executive model é black-box; MeMo não requer acesso a pesos, gradientes, ou logits. Compatível com Gemini, Qwen, qualquer API.

## Exemplos e evidências

Benchmarks (NarrativeQA, MuSiQue, BrowseComp-Plus):
- NarrativeQA com Gemini-3-Flash: MeMo 53.58% vs HippoRAG2 23.21% (+130% relativo)
- MuSiQue com Qwen2.5-32B: MeMo 48.30% vs HippoRAG2 42.17%
- Robustez a ruído: MeMo +0.55% ao adicionar 1×N documentos distratores; HippoRAG2 -6.22%
- Memory model 1.5B já supera todos os baselines RAG no NarrativeQA
- Performance é robusta à arquitetura do Memory model (Qwen/Gemma/LFM2.5 similares em ~1-2B)

## Implicações para o vault

- MeMo é a versão parametric do conceito de "memória como modelo" — contrasta fortemente com [[03-RESOURCES/sources/memory-context-rag/clipping-ram-framework-reasoning-alignment-memory]] e RAG tradicional.
- A distinção Executive/Memory split é arquiteturalmente similar ao padrão [[03-RESOURCES/concepts/agent-systems/resolver-pattern]] (raciocínio separado de armazenamento).
- Para o vault-michel: implementação de MeMo estilo exigiria fine-tuning de modelo pequeno no corpus do vault — out-of-scope agora, mas relevante para [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]].
- A robustez a retrieval noise é o argumento mais forte vs. RAG convencional em corpora grandes com muito ruído.

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/no-vector-retrieval]] — paradigma alternativo a RAG
- [[03-RESOURCES/concepts/llm-ml-foundations/vector-search]] — baseline RAG que MeMo supera
- [[03-RESOURCES/concepts/llm-ml-foundations/memory-transfer-learning]] — conceito relacionado
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — arquitetura de memória de agentes
- [[03-RESOURCES/sources/memory-context-rag/contextual-agentic-memory-is-a-memo]] — contexto adjacente
