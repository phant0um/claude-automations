---
title: "Design a Personal AI Chat Assistant"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, ai-architecture, personal-ai, customer-facing, privacy, rag, prompt-caching]
score: 6
author: "Neo Kim (System Design Newsletter #144)"
source_url: "https://newsletter.systemdesign.one/p/ai-chat-assistant"
domain: ai-agents-harness
---

# Design a Personal AI Chat Assistant

**Neo Kim** + **Louis-François Bouchard**: arquitetura de assistente AI próprio vs off-the-shelf. Quando construir seu próprio é obrigatório.

## Problema com Off-the-Shelf

ChatGPT/Claude/Gemini são ótimos para uso pessoal e prototipagem interna. Quando o assistente é customer-facing:

- Dados proprietários: muito grandes para context window, sensíveis para enviar a API de terceiro, dinâmicos demais para prompt estático
- Sem controle de comportamento além do que eles expõem
- Sem integração real com o produto (fica em aba separada)
- Custo escala linearmente sem otimização possível

## Quando Construir o Seu

**Privacy**: conversas ficam na sua infraestrutura. Healthcare, legal, finance, enterprise — compliance obrigatório.

**Control**: você tem o system prompt, persona, guardrails. Pode enforçar tom específico, restringir ao domínio, trocar o modelo, A/B testar configurações.

**Cost**: prompt caching + model routing (modelo barato para perguntas simples, caro para difíceis) + context management. Em milhares de conversas/dia = savings significativos.

**Integration**: assistente dentro do produto, não em aba separada. Compartilha auth, UI, user context.

**Security**: controla o full request path. Defesas contra prompt injection, output guardrails, content policies.

## Princípio

> "Off-the-shelf tools are great for personal use and internal prototyping. Building your own is for when the assistant is the product or a core feature."

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-9-agentic-patterns]]
