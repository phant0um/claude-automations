---
title: "CUDA Graph Implementation in LLM Inference Server"
type: source
source: Clippings/CUDA Graph implementation in LLM Inference server.md
created: 2026-06-20
ingested: 2026-06-21
tags: [cuda, llm-inference, source, score-B]
---

## Tese central
Implementação minimal de CUDA Graphs em LLM inference server (Tokn). Vale para entender core idea de como CUDA Graphs são usadas em vLLM e SGLang. FastAPI server + engine loop + scheduler queue + prefill/decode paths.

## Key insights
- CUDA Graphs reduzem overhead de kernel launch em inference
- Engine loop monitora scheduler queue, decide prefill vs decode
- Aplicável a vLLM, SGLang

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]]