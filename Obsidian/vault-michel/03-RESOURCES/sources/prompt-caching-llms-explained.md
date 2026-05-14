---
title: "Prompt caching in LLMs, clearly explained"
type: source
source_file: .raw/articles/Prompt caching in LLMs, clearly explained.md
author: Avi Chawla (@_avichawla)
ingested: 2026-04-17
tags: [prompt-caching, kv-cache, cost-optimization, claude-code, tokens]
---

# Prompt caching in LLMs, clearly explained

> [!summary]
> Avi Chawla explica como funciona o KV cache dos transformers, a economia do prompt caching (90% de desconto em cache reads), e como o Claude Code atinge 92% de cache hit rate com 81% de redução de custo. Inclui regras práticas para não quebrar o cache.

## O Problema

Sistema com 20.000 tokens de prompt rodando 50 turnos = 1 milhão de tokens de computação redundante, cobrado ao preço cheio. Para agentes de longa duração, isso é o maior custo de infraestrutura de AI.

## Como o KV Cache Funciona

**Prefill phase** (compute-bound): o transformer processa todo o prompt de entrada, computando vetores Query, Key e Value para cada token.

**Decode phase** (memory-bound): gera tokens um por um.

Os vetores K e V para um dado token dependem apenas dos tokens antes dele e, uma vez computados, **nunca mudam**. Sem caching, são descartados após cada request. Com caching, são persistidos no servidor indexados por hash criptográfico da sequência de tokens.

Isso reduz complexidade computacional de O(n²) por token gerado para O(n).

## Economia

| Tipo | Preço relativo |
|------|---------------|
| Cache reads | 0.1x (desconto de 90%) |
| Cache writes | 1.25x (prêmio de 25%) |
| Extended caching (1h) | 2.0x |

## Claude Code: 92% de Cache Hit Rate

**Sessão de 30 minutos:**
- Minuto 0: carrega system prompt + tool definitions + CLAUDE.md (>20k tokens) — custo máximo, pago uma vez
- Minutos 1-5: Explore Subagent usa cache; prefix a 90% de desconto
- Minutos 6-15: Plan Subagent recebe brief resumido (não raw output) para não inflar suffix dinâmico
- Minuto 28: `/cost` mostra 81% de redução — de $6.00 para $1.15 em 2M tokens

## A Fragilidade do Hash

**"1 + 2 = 3" funciona, mas "2 + 1" é um cache miss.**

O hash é da sequência completa de tokens desde o início. Qualquer mudança invalida o prefix inteiro.

**O que quebrou caches em produção:**
- Timestamp injetado no system prompt → hash único por request
- JSON serializer que ordenava chaves diferente entre requests
- AgentTool com parâmetros atualizados mid-session → cache de 20k tokens perdido

**3 Regras:**
1. Não modifique tools durante uma sessão
2. Nunca troque de modelo mid-session (caches são model-specific)
3. Nunca mute o prefix para atualizar estado — appende uma reminder tag na próxima mensagem do usuário

## Estrutura de Prompt para Cache

```
1. System instructions e behavioral rules (topo — nunca mude)
2. Tool definitions (upfront — não adicione/remova)
3. Contexto retrived e documentos de referência (estáveis)
4. Conversation history e tool outputs (suffix dinâmico)
```

## Métricas para Monitorar

```
cache_efficiency = cache_read_input_tokens / (cache_read_input_tokens + cache_creation_input_tokens)
```

Monitore como uptime.

## Conceitos Relacionados

- [[prompt-caching]]
- [[context-engineering]]
- [[claude-agent-harness-architecture]]
- [[hot-cache]]

## Entidades Mencionadas

- [[Avi-Chawla]] — autor (@_avichawla)
- [[Claude Code]] — caso de estudo principal; 92% hit rate
