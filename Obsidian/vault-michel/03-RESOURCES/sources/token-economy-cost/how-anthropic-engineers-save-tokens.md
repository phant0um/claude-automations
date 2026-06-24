---
title: "How Anthropic Engineers Actually Save Tokens"
type: source
source: Clippings/How Anthropic Engineers Actually Save Tokens.md
author: "@nateherk"
published: 2026-05-21
created: 2026-05-22
ingested: 2026-05-23
tags: [token-economy, claude-code, prompt-caching, cost-optimization]
score: 8
---

## Tese central
91M tokens cached em um dia = 9M tokens cobrados (10% do custo). Prompt caching no Claude Code: 3 layers (system, project, conversation), TTL de 1 hora na subscription, 5 minutos na API. Entender e não quebrar o cache é a maior otimização de custo em Claude Code.

## Argumentos principais
- Cache hit = 10% do custo de token de input normal
- Sessões longas de Claude Code "parecem grátis" porque cache está funcionando
- Dois números críticos no dashboard: cache create (custo único de escrever no cache) + cache read (tokens reutilizados, 10× mais baratos)
- Mudança de modelo mid-session quebra o cache
- Sub-agents: sempre TTL de 5 minutos (não herdam TTL de 1 hora da subscription)

## Key insights
- **3 layers de cache:** system prompt (CLAUDE.md + tool definitions), project context (código/arquivos referenciados), conversation history
- **TTL Claude Code subscription**: 1 hora — sessions longas mantêm cache quente
- **TTL API default**: 5 minutos — mata cache entre calls com delay > 5min
- **Sub-agents**: sempre 5min TTL — se sub-agent processa >5min, paga token cheio no próximo call
- **Quebradores de cache**: switch de modelo (incluindo "opus plan" mode), mudança no system prompt, reordenação de mensagens
- Thariq (Anthropic): "declaramos SEV se hit rate de cache fica baixo" — indicador operacional crítico
- Cache create cost: pago uma vez, amortizado em múltiplas leituras

## Exemplos e evidências
- 91M cached → cobrado como 9M → ~82M tokens de economia em 1 dia
- 300M+ tokens economizados em uma semana via caching
- Impacto de "opus plan" mode: mata cache da sessão

## Implicações para o vault
Diretamente acionável: não usar "opus plan" mode durante sessions longas, manter CLAUDE.md estável (não editar mid-session), estruturar sub-agents para completar em <5min ou aceitar custo de cache miss. Pipeline-diario: agents devem ser projetados para TTL de 5min.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-caching]]
- [[04-SYSTEM/wiki/hot]]
- [[03-RESOURCES/concepts/agent-systems/token-economy]]
