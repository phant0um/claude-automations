---
title: Local AI
type: concept
status: developing
created: 2026-05-16
updated: 2026-05-19
tags: [local-ai, privacy, on-device, inference, self-hosted, ollama]
---

# Local AI

**Local AI** refers to running AI models entirely on the user's own hardware, with no data leaving the device. Inference, memory, and tool calls all execute locally. Eliminates cloud dependency, vendor lock-in, and data egress risk.

## Why it Matters

- **Privacy:** prompts, documents, and outputs never leave the device
- **Cost:** no per-token billing for inference (after hardware cost)
- **Latency:** no network round-trip; especially valuable for high-frequency tool calls
- **Control:** model version pinned; no silent API updates breaking behavior
- **Offline capability:** works without internet

## Common Runtimes

| Runtime | Use case |
|---------|---------|
| Ollama | Desktop-friendly model server; one-command install |
| llama.cpp | Low-level GGUF inference; CPU + GPU |
| LM Studio | GUI wrapper around llama.cpp |
| MLX | Apple Silicon optimized inference |

## Tradeoffs

Local AI trades compute cost and setup friction for privacy and control. Consumer hardware (M-series Mac, NVIDIA RTX) can run 7B–70B parameter models effectively; frontier-scale models (400B+) still require cloud or specialized clusters.

## Pattern: Hybrid Routing

Many production harnesses use local AI for fast/cheap tasks and cloud models for reasoning-heavy tasks. [[03-RESOURCES/entities/openhuman]] implements this via its built-in model router: local Ollama for on-device workloads, cloud for reasoning and vision.

## Frameworks

- [[03-RESOURCES/entities/OpenJarvis]] — v1.0 (2026-05): agentes pessoais local-first com presets (morning briefing, deep research, code); suporte nativo a Ollama; foco em "Intelligence Per Watt" (energia como métrica de 1ª classe)

## Conexoes

- [[03-RESOURCES/entities/openhuman]] — implements local AI via optional Ollama backend
- [[03-RESOURCES/concepts/llm-ml-foundations/self-hosted-ai]] — broader infrastructure pattern
- [[03-RESOURCES/concepts/ai-strategy-org/privacy-first-ai]] — primary motivation
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]] — harness must support local inference backends
- [[03-RESOURCES/concepts/dev-foundations/rust-systems]] — Rust tooling commonly used in local AI runtimes
