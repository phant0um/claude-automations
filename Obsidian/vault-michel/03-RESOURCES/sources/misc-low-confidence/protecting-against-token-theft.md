---
title: "Protecting Against Token Theft"
type: source
source: "Clippings/Protecting against token theft.md"
author: "Malte Ubl, Eric Dodds (Vercel)"
published: 2026-05-29
created: 2026-06-22
ingested: 2026-06-22
tags: [misc-low-confidence, security, inference-theft, vercel, botid]
score: B
---

## Tese Central

Inference theft lets attackers resell your paid AI calls. HTTP requests custam ~$2/million mas um único prompt a frontier model pode custar $2 — AI é 1 milhão de vezes mais cara. Rate limits e auth walls não bastam porque checks per-session se amortizam across thousands of stolen calls. Verificação precisa rodar em every AI request.

## Pontos-Chave

1. **Inference theft = unauthorized use de paid AI inference**: operador paga per call, atacante paga zero e resells tokens at discount. Não é rate-limit abuse, é resale de stolen resource em market.
2. **Endpoints at risk**: qualquer internet-facing endpoint que dá caller control sobre LLM prompt. AI playgrounds mais dangerous (max prompt/model/parameter control). Support bots menos exposed mas atacantes aprendem a talk around system prompts.
3. **Architecture of abuse**: atacante wrapa custom endpoint em OpenAI/Anthropic-compatible adapter, fan calls through residential proxies. Adapter = one-time engineering cost. Resale at 5-10% list price = generous margin. Exemplo: Chipotlai Max forked coding agent com proxy turning Chipotle's chatbot em OpenAI-compatible endpoint.
4. **Why web defenses fail**: rate limits built para attacks com dramatically lower per-call economics. Payoff de stolen inference alto enough que atacante compra residential proxy IPs by thousands + throwaway accounts at scale.
5. **Per-request verification**: check que roda per session amortiza bypass cost across stolen calls. Per-request gates forçam ratio down to 1. Cost asymmetry: inference é most expensive per call, verification é cheapest protection per call.
6. **BotID deep analysis**: invisible CAPTCHA com client-side ML distinguindo humans de bots sem visible challenge. Roda em every request. Detectou + blocked 10K+ bot requests em primeiros minutos de spike. 1,300 req/min at peak → $10K+/dia inference cost.
7. **Implementation**: `checkBotId()` server-side no route handler + `initBotId()` client-side. Declara route protegida.

## Conceitos

- Inference theft como business de high-margin para atacantes
- Per-request vs per-session verification (amortização de bypass cost)
- OpenAI/Anthropic-compatible adapter como attack vector
- Cost asymmetry: inference expensive, verification cheap

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/sources/ai-agents/introducing-opensigil-oversight-layer-ai-agents]]