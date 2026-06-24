---
title: Gemini 2.5 Flash
type: entity
category: llm
created: 2026-04-19
updated: 2026-04-19
tags: [google, gemini, llm, model]
---

# Gemini 2.5 Flash

Modelo LLM do Google otimizado para velocidade e custo-eficiência, com capacidades de raciocínio avançado.

---

## Características

- **Família:** Gemini 2.5 (Google DeepMind)
- **Posicionamento:** Flash = velocidade + custo < Pro/Ultra
- **Capacidades:** reasoning, multimodalidade, contexto longo, agentic

---

## Uso no Auto-Diagnose (Google)

Empregado pelo [[03-RESOURCES/concepts/llm-ml-foundations/llm-test-failure-diagnosis|Auto-Diagnose]] para diagnóstico de falhas de integração:

- **Temperature:** 0.1 (quasi-determinístico para debugging)
- **Top-p:** 0.8
- Sem fine-tuning nos logs de teste — generalização zero-shot
- Média de 110.617 tokens de input por execução
- p50 de resposta: <56 segundos

---

## Referências

- Team et al. (2023) — "Gemini: a family of highly capable multimodal models" (arXiv:2312.11805)
- Comanici et al. (2025) — "Gemini 2.5: pushing the frontier with advanced reasoning, multimodality, long context, and next generation agentic capabilities" (arXiv:2507.06261)

---

## Relacionados

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-test-failure-diagnosis]]
- [[03-RESOURCES/sources/ml-research-papers/llm-automated-diagnosis-integration-tests-google]]
