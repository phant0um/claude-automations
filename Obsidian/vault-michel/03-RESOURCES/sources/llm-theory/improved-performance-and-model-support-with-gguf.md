---
title: "Improved Performance and Model Support with GGUF"
type: source
source: Clippings/Improved performance and model support with GGUF.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ml-research, ollama, gguf, llama-cpp, performance, vulkan]
---

## Tese central

Ollama 0.30 traz performance up to 20% faster em NVIDIA, Vulkan habilitado por default (AMD/Intel GPU support), e expansão de compatibilidade GGUF (LFM, Prism, Unsloth fine-tunes). Augmenta MLX engine em Apple silicon via llama.cpp.

## Key insights

- 20% faster em NVIDIA (RTX 5090, Gemma 4 26B Q4_K_M)
- Vulkan default = AMD/Intel GPU acceleration out-of-the-box
- GGUF ecosystem: mais models rodam sem config manual
- Apple silicon: MLX + llama.cpp dual engine

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations]]