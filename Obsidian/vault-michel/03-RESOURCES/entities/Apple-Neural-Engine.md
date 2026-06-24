---
title: "Apple Neural Engine"
type: entity
created: 2026-06-23
updated: 2026-06-23
tags: [entity, hardware, apple, neural-engine, inference]
---

# Apple Neural Engine

## Descrição

Acelerador neural fixed-function presente em todos os dispositivos Apple recentes (iPhone, iPad, Apple Silicon Mac). No Apple Silicon, é o bloco de compute com menor consumo de energia para workloads que aceita. Único acesso sancionado: CoreML, que trata o ANE como opção de scheduling (não garantida) — o modelo pode silenciosamente rodar no CPU/GPU sem diagnóstico.

## ANEForge

[[aneforge-python-for-direct-computation-on-the-apple-neural-engine]] — Python package que programa o ANE diretamente, sem CoreML:
- 58 operadores fused (incluindo attention)
- 19 operadores nativos via bridge (não emitidos pelo toolchain público)
- Weight compression: int8 (2x), int4 LUT (4x), sparse
- On-engine training: data, gradients, optimizer state no device
- Validado em M5 Pro e M1 Max, macOS 26.5

## Relevância para o vault

- Apple Silicon é a plataforma de execução do Hermes Agent e do vault
- ANE como recurso para inference local de modelos small (não LLMs, mas embeddings/classifiers)
- Compreensão dos limites (half precision dataplane, sem fp32) informa decisões de deployment

## Evidências

- **[2026-06-23]** ANEForge: Python for direct computation on the Apple Neural Engine — [[aneforge-python-for-direct-computation-on-the-apple-neural-engine]]
- **[2026-06-23]** ANE reachable only through CoreML which treats it as scheduling option — same source

## Links

- [[03-RESOURCES/entities/Apple]]
- [[03-RESOURCES/concepts/llm-ml-foundations/gpu]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]