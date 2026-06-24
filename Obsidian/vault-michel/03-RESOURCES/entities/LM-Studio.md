---
title: LM Studio
type: entity
categoria: tool
tags: [local-ai, llm-runtime, privacy, obsidian, openai-compatible]
created: 2026-05-29
updated: 2026-05-29
---

# LM Studio

Aplicativo desktop gratuito para baixar e rodar grandes modelos de linguagem completamente offline em Mac, Windows ou Linux. Interface limpa, suporte à maioria dos modelos open-source, e roda servidor local que outros apps conectam como se fosse API da OpenAI ou Anthropic.

## Características principais

- **Servidor local em `http://localhost:1234`** — formato idêntico à API OpenAI; qualquer tool que suporta OpenAI pode usar sem mudanças de código
- **Modelos recomendados:** Mistral 7B (rápido/geral), Llama 3 8B (melhor all-round), Phi-3 Mini (máquinas antigas), DeepSeek Coder (código)
- **Download de modelos:** 4–8 GB por modelo, uso recorrente offline
- **Hardware mínimo:** MacBook M1/M2/M3 ou Windows/Linux 16GB RAM para modelos 7B

## Integração com Obsidian

- Smart Connections plugin → apontar para `http://localhost:1234/v1` → chat com vault 100% local
- BMO Chatbot plugin → interface Claude-like dentro do Obsidian, tudo local
- Copilot plugin → assistente inline, mesmo endpoint

## Casos de uso

- **Deep work offline:** zero internet, dados na máquina
- **Trabalho confidencial:** clientes, financeiro, pessoal — sem nenhum dado saindo
- **Modo híbrido:** vault local + Claude API para reasoning complexo

## Limitação

Modelos frontier cloud (Claude 3.7+, GPT-5) ainda superiores para reasoning muito complexo e tarefas criativas. LM Studio é tradeoff consciente: privacidade vs. capacidade máxima.

## Sources

- [[03-RESOURCES/sources/pkm-obsidian-second-brain/ai-workflow-offline-obsidian-lm-studio]]
