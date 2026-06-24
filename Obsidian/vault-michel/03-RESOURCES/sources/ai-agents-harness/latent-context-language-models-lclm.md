---
title: "What If LLMs Didn't Have to Read Raw Tokens at All?"
type: source
source: "[@AlphaSignalAI](https://x.com/AlphaSignalAI/status/2065098022451896814) — paper NYU/Columbia/Princeton et al., Latent Context Language Models (LCLM)"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

Paper propõe Latent Context Language Models (LCLM): compressão de contexto que ocorre **antes do prefill**, em vez de pós-prefill (KV cache eviction, token dropping), permitindo escalar muito além do que cabe em memória com baseline sem compressão.

## Argumentos principais

- **Diferença estrutural**: compressão pós-prefill (KV cache eviction, token dropping) ainda paga custo total de attention sobre o contexto completo — só reduz o que é mantido. LCLM comprime **antes do prefill**: encoder (0.6B params) converte tokens em vetores latentes (16 tokens → 1 vetor a 16x compressão), adapter (MLP) projeta para o espaço do decoder (4B params), que opera só sobre o contexto já comprimido.
- **Mistura comprimido + raw**: pode comprimir contexto histórico mantendo o prompt/query atual em tokens crus — viabiliza o caso agentic.
- **Generaliza out-of-the-box** (treino em 350B+ tokens, 2 estágios: pré-treino com reconstrução intercalada + SFT diversificado) — soft-token compressors anteriores só funcionavam após fine-tuning específico de tarefa.
- **Benchmarks a 8x**: 8.8x TTFT mais rápido no RULER, 5.2x no LongBench, mantendo acurácia vs. baseline sem compressão; resultados fortes também em LongHealth (QA clínico). A 1M tokens, todo baseline esgota memória num H200; LCLM não, porque memória escala com tamanho comprimido.
- **KV cache uniforme**: drop-in em vLLM/SGLang sem kernels customizados (diferente de eviction seletiva, que produz caches não-uniformes).
- **Hierarquia de memória de 2 níveis**: latentes comprimidos = "long-term storage" barato; tool `EXPAND(file, chunk_number)` descomprime chunk específico on-demand. No RULER needle-in-haystack, EXPAND melhora acurácia 17-20 pontos vs. LCLM sem expansão.
- **Implicação para RAG**: quando o corpus inteiro cabe em memória comprimida, retrieval se torna opcional (não mandatório) para tarefas de escala de codebase — RAG continua necessário para corpora verdadeiramente massivos.

## Implicações para o vault

Conecta diretamente com [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]], [[03-RESOURCES/concepts/agent-systems/prompt-caching]] e [[03-RESOURCES/concepts/memory-context-rag/_index]]. É research-stage (paper, não produto) — não há ação imediata, mas é referência futura para quando context-compression-as-architecture (vs. context-window maior) virar opção em harnesses de produção. O conceito "reasoning globally over compressed context, expand only what's needed" é uma reformulação útil do próprio padrão L1/L2/L3 de [[03-RESOURCES/sources/ai-agents-harness/building-a-good-vertical-agent]].

Uma das **2 ideias genuinamente novas/sub-cobertas** do cluster (a outra é [[03-RESOURCES/sources/ai-agents-harness/log-is-the-agent]]) — research-stage, sem ação imediata, referência futura.

## Links

- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/concepts/memory-context-rag/_index]]
