---
title: Local LLM Privacy
type: concept
created: 2026-05-29
updated: 2026-05-29
tags: [local-ai, privacy, lm-studio, obsidian, knowledge-work, data-sovereignty]
---

# Local LLM Privacy

A questão de privacidade em AI não é "posso confiar nas empresas de IA?" — é "meu pensamento mais importante deveria residir em servidor de terceiros?" Para knowledge work sério (consulting, legal, médico, financeiro, pesquisa profunda), rodar modelos localmente resolve o problema da soberania de dados sem sacrificar utilidade.

## O tradeoff em 2026

- **Cloud (Claude, GPT-5):** máxima capacidade de reasoning, mas dados saem do dispositivo
- **Local (Llama 3, Mistral via LM Studio):** privacidade total, capacidade 85-95% do frontier para a maioria das tarefas
- **Híbrido:** vault e contexto sensível local + cloud para heavy lifting genérico

## Hardware viável

- MacBook M1/M2/M3 → 7B–13B modelos suavemente
- Windows/Linux 16GB RAM → 7B bem
- Windows/Linux 32GB + GPU → 13B–34B confortavelmente

## Modos de operação

1. **Deep work (fully offline):** LM Studio + Llama 3 8B, nenhum byte sai
2. **Research/writing (hybrid):** vault local + API cloud para reasoning pesado
3. **Confidential (strict local):** cliente, financeiro, pessoal — zero cloud

## Stack mínimo (1 hora)

LM Studio → modelo 7B → start server em `localhost:1234` → Obsidian Smart Connections → apontar para endpoint.

## Limitação honesta

Modelos frontier (Claude 3.7+, GPT-5) ainda superiores para reasoning complexo e criatividade. Local é escolha consciente de privacidade, não upgrade de capacidade.

## Relacionado

- [[03-RESOURCES/entities/LM-Studio]]
- [[03-RESOURCES/concepts/ai-strategy-org/privacy-first-ai]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/ai-workflow-offline-obsidian-lm-studio]]
