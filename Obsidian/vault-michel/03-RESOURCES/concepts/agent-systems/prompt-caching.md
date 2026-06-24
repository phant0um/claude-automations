---
title: "Prompt Caching (Agent Systems)"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Prompt Caching (Agent Systems)

Reusing cached KV states across agent turns to reduce latency and cost — 90% cheaper reads, 92% hit rate in Claude Code, 5-min TTL.

## O que é / What it is

Every time the model processes a prompt, it computes a key-value (KV) representation of each token (the "prefill"). Prompt caching stores this KV state after the first computation and reuses it on subsequent turns that share the same prefix — skipping the compute entirely for cached tokens.

At Anthropic: cache reads cost ~10% of standard input token price; cache writes cost ~125%. The break-even is one reuse within the 5-minute TTL window.

## Como funciona

**Architecture:** The KV cache lives server-side. When a request arrives, the server computes a hash of the prompt prefix. If the hash matches a cached entry and TTL has not expired, the cached KV state is injected — the model skips prefill for those tokens entirely.

**3 rules for cache-friendly prompt design:**

1. **Stable prefix first** — put everything that doesn't change (system prompt, CLAUDE.md, hot.md) at the *beginning* of every turn. The cache key is a prefix hash; even one changed token at position N invalidates everything after N.
2. **Variable content last** — user message, tool outputs, and turn-specific context go at the end, after the stable prefix.
3. **Minimize prefix churn** — avoid timestamps, UUIDs, or dynamic content inside the stable prefix. A `# Current date: 2026-06-01` line in CLAUDE.md breaks the cache daily.

**Vault mapping — hot.md as cache anchor:**
`hot.md` is designed as the stable prefix header: a compact (~2k token) summary of the most-accessed vault state, always prepended before variable content. This is why cache hit rates are high in long vault sessions.

**TTL:** 5 minutes on Anthropic's API. For agents with turns more than 5 minutes apart, the cache will miss and the prefill cost is paid again.

## Por que importa

In an agentic session with 50 turns, all sharing a 2k-token system prompt + 1k-token hot.md = 3k tokens × 50 turns = 150k tokens of prefill avoided per session. At standard pricing, this is 90% cheaper than uncached. Claude Code achieves ~92% hit rate in practice because CLAUDE.md is always the prefix.

## Doc oficial — mecânica de cache de prefixo (jun/2026)

A referência oficial da Anthropic confirma e aprofunda os números acima: hash cumulativo do prefixo (`tools→system→messages`), janela de **lookback de 20 blocos**, até **4 breakpoints explícitos**, TTL de 5min (default) ou 1h (2x preço), e mínimo cacheável de **1.024 tokens** em Opus 4.8/Sonnet 4.6 (4.096 em modelos mais antigos). Documenta também o anti-padrão "breakpoint em conteúdo que muda a cada request" — exatamente o erro que `hot.md`/pipeline poderiam cometer se um timestamp ficasse antes do breakpoint. Ver [[03-RESOURCES/sources/prompt-caching]].

**Mid-conversation system messages** (Opus 4.8) é o complemento direto: permite injetar instruções de operador no fim da conversa sem invalidar o prefixo cacheado — ver [[03-RESOURCES/sources/mid-conversation-system-messages]].

## Caching sob compactação (jun/2026)

A documentação de [[03-RESOURCES/sources/compaction]] confirma e operacionaliza a regra "stable prefix first" para o cenário de compactação server-side: um breakpoint `cache_control: ephemeral` no **final do system prompt** mantém esse cache válido e separado da conversa — assim, quando uma compactação ocorre, só o novo bloco `compaction` precisa ser escrito no cache (não o system prompt inteiro reescrito junto com o sumário). Particularmente relevante para system prompts longos que sobrevivem a múltiplos eventos de compactação.

Em [[03-RESOURCES/sources/context-editing]], a interação com cache varia por estratégia: **tool result clearing invalida** prefixos cacheados no ponto de limpeza (use `clear_at_least` para garantir que a invalidação valha o custo de reescrita); **thinking block clearing preserva** o cache quando blocos são mantidos (`keep`) e o invalida só quando são limpos — tornando `keep` uma alavanca direta entre performance de cache e espaço de contexto disponível.

## Related
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness]]
- [[03-RESOURCES/concepts/ai-strategy-org/inference-optimization]]
- [[03-RESOURCES/concepts/agent-systems/inference-time-boosting]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/sources/prompt-caching]]
- [[03-RESOURCES/sources/mid-conversation-system-messages]]
- [[03-RESOURCES/sources/compaction]]
- [[03-RESOURCES/sources/context-editing]]
