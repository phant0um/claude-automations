---
title: "AmberLJC/LLMSys-PaperList: Large Language Model (LLM) Systems Paper List"
type: source
source: "Clippings/AmberLJCLLMSys-PaperList Large Language Model (LLM) Systems Paper List.md"
original_url: "https://github.com/AmberLJC/LLMSys-PaperList"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, llm-systems, research-papers, open-source, curated-list, training, serving, inference]
---

## Tese central

Lista curada e mantida ativamente de papers acadêmicos, artigos, tutoriais e projetos sobre sistemas de Large Language Models. Cobre o ciclo completo: training (pre-training, RLHF/post-training, fault tolerance), serving (LLM serving, agent systems, edge, efficiency/model co-design), multi-modal, e LLMs para sistemas. Inclui industrial technical reports de 2022 a 2026 e frameworks de training e serving.

## Argumentos principais

- **Cobertura temporal completa**: papers de "Before 2024" até 2026, com seções dedicadas por ano em cada categoria.
- **5 domínios principais**: LLM Systems (Training + Serving), LLM for Systems, Industrial Reports, LLM Frameworks, ML Systems/Surveys.
- **Serving é a área mais densa**: dezenas de papers sobre scheduling, KV cache management, speculative decoding, prefill/decode disaggregation, agent serving.
- **Agent Systems** é subcategoria própria em Serving (2024–2026), reconhecendo que sistemas agênticos têm requisitos de serving distintos.
- **Frameworks catalogados**: training (DeepSpeed, Megatron, veScale, LLaMA-Factory, Unsloth) e serving (vLLM, SGLang, TensorRT-LLM, Ollama, llama.cpp).
- **Industrial reports completos**: todos os principais modelos de GPT-4 (Mar 2023) até Qwen3.5-Omni (Abr 2026), incluindo Claude 3 Card e Claude 4 System Card.

## Key insights

- A seção Agent Systems (Serving) em 2026 inclui papers fundamentais: DualPath (DeepSeek), AIMS (cloud-edge), Hippocampus (memória eficiente para agentic AI), AgenticCache, FlashAgents, OpenHands SDK.
- Hippocampus (MLSys 2026): módulo de memória eficiente e escalável para agentic AI — relevante direto para design de sistemas de memória.
- AgenticCache (MLSys 2026): cache-driven asynchronous planning para agentic LLM systems — confirma que caching é central também para agentes, não só para serving simples.
- KV Cache papers: dezenas de papers em 2024-2026 sobre compressão, sharing, streaming e management de KV cache — confirma que é o gargalo central de eficiência.
- vLLM continua central: CacheBlend (EuroSys 2025, Best Paper), MineDraft integrado ao vLLM, aibrix como infraestrutura plugável para GenAI.
- FlashAttention evoluiu até FlashAttention-4 (MLSys 2026) para hardware Blackwell.
- Especulative decoding: consolidou como área própria com dezenas de papers (ReSpec, Beat the Long Tail, SwiftSpec, PRISM, MineDraft).
- Prefill/decode disaggregation: DistServe (OSDI 2024) como paper fundador, com dezenas de variantes em 2025-2026.
- Edge serving ganha tração em 2026: EuroSys 2026 e MLSys 2026 têm seções dedicadas (TZ-LLM, TailorLLM, scaling com mobile NPU).
- "Barbarians at the Gate" (2025): paper sobre como IA está transformando a própria pesquisa de sistemas.

## Exemplos e evidências

**Papers de referência por categoria:**
- Pre-training: Megatron-LM, MegaScale (ByteDance, 10.000+ GPUs), Llama 3 (Section 3)
- RLHF: HybridFlow, RLHFuse (NSDI 2025), AReaL (Ant Group)
- Serving: vLLM/PagedAttention (SOSP 2023), DistServe (OSDI 2024), CacheBlend (EuroSys 2025 Best Paper)
- Agent serving: Parrot (OSDI 2024), Autellix (UCB), KVFlow, AgenticCache (MLSys 2026)
- Edge: LLM in a flash (Apple), PowerInfer (SOSP 2024), prima.cpp
- Industrial: Claude 4 System Card (Anthropic, May 2025), Gemini 2.5, Kimi K2, DeepSeek-R1

**Frameworks:**
- Training: DeepSpeed (Microsoft), Megatron (NVIDIA), torchtitan/torchtune (PyTorch), veScale (ByteDance), LLaMA-Factory, Unsloth
- Serving: vLLM, SGLang, TensorRT-LLM (NVIDIA), Ollama, llama.cpp, LMDeploy, aibrix

**ML Conferences seção NeurIPS 2025**: papers em efficient attention, KV-cache systems, speculative decoding, VLM efficiency, RL training infrastructure.

**MLSys Courses**: Stanford (cs229s), UMich (eecs598), Georgia Tech (cs8803).

## Implicações para o vault

- Referência central para pesquisa acadêmica em LLM systems — índice de entrada para qualquer área específica
- A seção Agent Systems em Serving (2026) é especialmente relevante — papers como Hippocampus, AgenticCache e FlashAgents têm aplicação direta no design de agentes do vault
- Os industrial reports são um histórico completo de modelos — pode complementar entidades como [[03-RESOURCES/entities/Claude]] com referências aos model cards
- A lista de frameworks de serving (vLLM, SGLang) é referência para quando o vault precisar discutir infraestrutura de produção
- KV cache como gargalo central é confirmado por dezenas de papers — valida o foco do vault em hot.md e prefix caching

## Links
- [[03-RESOURCES/concepts/agent-systems/multi-agent-systems]]
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/sources/open-source-ecosystems/clipping-the-ultimate-open-source-dev-stack]]
