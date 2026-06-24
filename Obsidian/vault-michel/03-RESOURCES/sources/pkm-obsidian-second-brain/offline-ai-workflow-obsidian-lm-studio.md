---
title: "How I Moved My Entire AI Workflow Offline: Obsidian + LM Studio + Local LLM Plugins"
type: source
created: 2026-05-28
ingested: 2026-05-28
tags: [local-ai, obsidian, lm-studio, privacy, offline, smart-connections, rag, llm-plugins]
source_url: "https://x.com/KanikaBK/status/2059177736648987072"
author: "@KanikaBK (Kanika)"
published: 2026-05-26
---

# How I Moved My Entire AI Workflow Offline: Obsidian + LM Studio + Local LLM Plugins

## Tese Central

Stack de três ferramentas (Obsidian + LM Studio + plugins locais) replica completamente um workflow de IA em nuvem sem enviar um byte para fora do dispositivo. Em 2026, a gap de capacidade entre modelos locais (Llama 3, Mistral) e cloud frontier estreitou o suficiente para uso sério em knowledge work.

## Key Insights

- **Trigger real:** Colar brief confidencial no Claude e perceber que saiu do dispositivo. Questão não é confiança em empresas de IA — é se o pensamento mais importante deve estar em servidor alheio.
- **Stack mínimo viável:**
  - LM Studio: executa servidor local em `http://localhost:1234` (formato idêntico à API da OpenAI). Modelos: Mistral 7B (rápido), Llama 3 8B (melhor geral), Phi-3 Mini (máquinas antigas), DeepSeek Coder (código).
  - Smart Connections: cria embeddings de todas as notas do vault, chat com vault inteiro via LM Studio local.
  - BMO Chatbot: interface Claude/ChatGPT dentro do Obsidian, tudo local.
  - Copilot Plugin: assistente inline — seleciona texto, solicita transformação.
- **Hardware real:** MacBook M1/M2/M3 → modelos 7B–13B suaves. Windows/Linux 16GB RAM → 7B bem. 32GB + GPU → 13B–34B.
- **Pipeline Mini-RAG:** Embeddings locais → busca semântica → contexto passado ao modelo local → resposta 100% on-device.
- **Modos de operação:** (1) Deep work — tudo offline, LM Studio + Llama 3; (2) Hybrid — vault local, cloud para reasoning pesado; (3) Confidential — estritamente local para trabalho de cliente.
- **Limitação honesta:** Modelos cloud frontier (Claude 3.7+, GPT-5) ainda superiores para reasoning complexo e tarefas criativas.

## Implicações para o Vault

- LM Studio pode ser backend alternativo para Smart Connections no vault-michel (privacy mode para material confidencial).
- Confirma que o stack atual (Claude via API) é um tradeoff consciente, não única opção.
- Setup em 1 hora: LM Studio → baixar Llama 3 8B → start server → Obsidian Smart Connections → apontar para localhost:1234.

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/local-ai]] — conceito base; LM Studio como runtime
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]] — vault como interface para AI local
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/obsidian-most-powerful-ai-workflow-tool]]
