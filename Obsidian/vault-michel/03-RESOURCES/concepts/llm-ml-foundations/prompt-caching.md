---
title: prompt-caching
type: concept
status: developing
tags: [prompt-caching, kv-cache, cost-optimization, tokens, claude-code]
created: 2026-04-17
updated: 2026-05-19
---

# Prompt Caching

Técnica de infraestrutura que persiste os tensores Key-Value (KV) do prefill phase de um transformer, permitindo que requests subsequentes com o mesmo prefix pulem a computação e leiam do cache.

## Como Funciona

**Prefill phase** (compute-bound): transformer processa todo o prompt, computando vetores Q/K/V para cada token. Os vetores K e V nunca mudam para um dado token.

**Com caching**: esses tensores são indexados por hash criptográfico da sequência de tokens. Próximo request com mesmo prefix → hash combina → skip do prefill daqueles tokens.

Complexidade: O(n²) → O(n) por token gerado.

## Economia (Anthropic/Claude)

| Tipo | Preço relativo |
|------|---------------|
| Cache reads | 0.1x (desconto de 90%) |
| Cache writes | 1.25x (prêmio de 25%) |
| Extended caching 1h | 2.0x |

**Exemplo real**: Claude Code, sessão de 30 min, 2M tokens → de $6.00 para $1.15 com 92% de cache hit rate (81% de redução).

## Estrutura Correta de Prompt

```
1. System instructions e behavioral rules    ← prefix estático
2. Tool definitions (upfront)                ← prefix estático
3. Contexto retrieved e documentos           ← prefix estático
4. Conversation history e tool outputs       ← suffix dinâmico (cresce)
```

O cache funciona até o "breakpoint" — tudo à esquerda do breakpoint é cacheado.

## O que Quebra o Cache

O cache é hash da sequência completa de tokens. Qualquer mudança = cache miss.

**Quebras comuns em produção:**
- Timestamp no system prompt (hash único por request)
- JSON serializer que ordena chaves diferente entre requests
- Tool atualizado mid-session (invalida todo o prefix downstream)
- Troca de modelo mid-session (caches são model-specific)

**3 Regras:**
1. Não modifique tools durante uma sessão
2. Nunca troque de modelo mid-session
3. Nunca mute o prefix — appende ao suffix

## Como Claude Code Preserva o Cache

- Não passa raw tool output ao orquestrador (inflaria suffix desnecessariamente)
- Subagentes recebem briefs resumidos
- Para atualizar estado: appenda reminder tag no próximo user message (prefix intacto)
- Auto-caching no Anthropic API avança o breakpoint automaticamente

## Métrica de Cache

```
cache_efficiency = cache_read_input_tokens / (cache_read_input_tokens + cache_creation_input_tokens)
```

Monitore como uptime. Claude Code atinge 92%.

## Relação com Context Engineering

Prompt caching é uma implementação prática de [[context-engineering]]:
- O prefix estático é o contexto que nunca muda → cachear
- O suffix dinâmico é o que cresce → apenas isso é cobrado ao preço cheio

## Ver também

- [[context-engineering]]
- [[hot-cache]]
- [[claude-agent-harness-architecture]]

## Exemplo de Aplicação: Investment Analyst System Prompt v2

O [[03-RESOURCES/sources/financial-trading/investment-analyst-system-prompt-v2|Investment Analyst v2]] usa a arquitetura de cache explicitamente:
- **Bloco estável** (cacheado com `cache_control ephemeral`): identidade + disclaimer + protocolo + limites + padrões de qualidade — imutável por sessão
- **Bloco dinâmico** (não cacheado): 5 modos de operação — adaptado ao modo ativo da sessão

Isso é uma implementação em produção do padrão prefix estático / suffix dinâmico descrito acima.

## Fontes

- [[03-RESOURCES/sources/memory-context-rag/prompt-caching-llms-explained]]
- [[03-RESOURCES/sources/financial-trading/investment-analyst-system-prompt-v2]] — exemplo prático com cache_control ephemeral
