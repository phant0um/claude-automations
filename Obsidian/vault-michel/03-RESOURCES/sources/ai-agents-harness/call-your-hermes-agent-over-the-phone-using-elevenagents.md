---
title: "Call Your Hermes Agent over the phone using ElevenAgents"
type: source
source: "Clippings/Call Your Hermes Agent over the phone using ElevenAgents.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, hermes, elevenlabs, voice-agents, phone-integration]
---

## Tese central
Integrando Hermes (agente com memória/skills via OpenClaw) com ElevenLabs Conversational AI via protocolo OpenAI-compatible Chat Completions, é possível fazer o agente de código atender ligações telefônicas — tornando interação com agentes acessível off-desk via voz.

## Argumentos principais
- Hermes já suporta TTS/STT com ElevenLabs, mas ElevenAgents adiciona turn-taking, phone integration e síntese de voz conversacional completa
- A arquitetura separa responsabilidades: ElevenLabs cuida de voice/phone, OpenClaw cuida de tools/memory/skills
- Comunicação entre sistemas usa o protocolo padrão `POST /v1/chat/completions` — Hermes responde como LLM OpenAI-compatible, mas por trás está o runtime completo do agente
- ngrok como tunnel temporário permite expor o servidor local Hermes para ElevenLabs; Twilio para número de telefone real

## Key insights
- Hermes expõe API server via gateway com configuração simples em `~/.hermes/.env` (5 variáveis)
- A separação de planos (voice plane = ElevenLabs; tools/memory plane = Hermes/OpenClaw) é o padrão arquitetural correto para agentes com capacidade de voz
- Qualquer agente que implemente a interface OpenAI chat completions pode ser conectado ao ElevenLabs desta forma — é um padrão generalizável
- O setup completo é automatizável: o próprio coding agent pode fazer as chamadas à API ElevenLabs para criar secrets e configurar o agente

## Exemplos e evidências
- Setup técnico completo documentado: `hermes gateway install` + `hermes gateway start` + ngrok + ElevenLabs dashboard → Custom LLM
- Verificação de saúde: `curl http://127.0.0.1:8642/health` retorna `{"status": "ok", "platform": "hermes-agent"}`
- Dois métodos de configuração: manual via dashboard ElevenLabs ou programático via curl à API (step 1: criar secret; step 2: criar agent com custom LLM URL)
- Integração Twilio: comprar número → copiar Account SID + Auth Token → conectar no ElevenLabs → attach ao agent

## Implicações para o vault
Amplia o ecossistema Hermes com capacidade de voz/telefone — padrão arquitetural relevante para qualquer agente que precise de interface vocal. Complementa as páginas existentes sobre Hermes e adiciona o conceito de voice plane vs. capability plane como separação de responsabilidades.

## Links
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/hermes]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/sources/hermes-agent-complete-guide]]
