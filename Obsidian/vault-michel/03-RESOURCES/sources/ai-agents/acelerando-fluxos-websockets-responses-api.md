---
title: "Acelerando Fluxos de Trabalho com WebSockets na Responses API"
type: source
source: "Clippings/Acelerando fluxos de trabalho com agentes com WebSockets na Responses API.md"
author: "OpenAI"
published: 2026-06-22
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, websockets, api-optimization, openai, responses-api, latency]
score: B
---

## Tese Central

Loops de agentes usando a Responses API ficaram 40% mais rápidos de ponta a ponta. A inferência saltou de 65 para quase 1.000 tokens por segundo com GPT-5.3-Codex-Spark, mas a sobrecarga da API virou o gargalo. Solução: conexão persistente via WebSocket com cache em memória do estado reutilizável, em vez de chamadas síncronas com histórico completo a cada requisição.

## Pontos-Chave

1. **API como gargalo**: modelos anteriores (GPT-5, GPT-5.2) a 65 TPS — overhead da API era escondido pela inferência lenta. GPT-5.3-Codex-Spark meta: 1.000+ TPS (hardware Cerebras). Overhead cumulativo da API ficou perceptível.
2. **Problema estrutural**: cada requisição tratada como independente, processando estado da conversa e contexto reutilizável a cada requisição. Conversas longas = processamento repetido caro.
3. **WebSocket protótipo**: execução com agentes modelada como única Response de longa duração. `asyncio` bloqueia assincronamente no loop de amostragem após tool call. `response.done` enviado ao cliente. Cliente envia `response.append` com resultado → desbloqueia loop. Tratou tool call local como hosted tool call.
4. **Versão lançada (familiar)**: continuou usando `response.create` com mesmo body + `previous_response_id` para dar continuidade. Cache em memória com escopo da conexão: response object anterior, items de I/O, tool definitions, tokens renderizados reutilizáveis.
5. **Otimizações**: classificadores de segurança processam só nova entrada (não histórico completo). Cache de tokens renderizados. Reutilização de resolução/roteamento de modelos. Sobreposição de trabalho pós-inferência não bloqueante (cobrança) com requisições subsequentes.
6. **Resultados**: GPT-5.3-Codex-Spark atingiu 1.000 TPS, picos de 4.000 TPS. Codex direcionou maior parte do tráfego para WebSocket mode. Melhora de ~45% no TTFT (time to first token).

## Conceitos

- Conexão persistente (WebSocket) vs chamadas síncronas HTTP
- Cache em memória com escopo da conexão (vs reprocessar histórico)
- Tool call local como tool call hospedada (analogia)
- API overhead como bottleneck quando inferência acelera
- `response.create` + `previous_response_id` como formato familiar

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
- [[03-RESOURCES/sources/claude-code-cowork/de-modelo-a-agente-responses-api-ambiente]]