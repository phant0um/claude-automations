---
title: "Prompt Caching Patterns"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Prompt Caching Patterns

Padrões de design para maximizar taxa de cache hit na API da Anthropic e economizar até 90% no custo de tokens repetidos.

## O que é

Prompt caching patterns são convenções de estruturação de prompts que exploram o KV cache da Anthropic. Quando um prefixo é cacheado, tokens subsequentes naquele prefixo custam 10% do preço normal. O desafio: o cache só funciona se o prefixo for idêntico entre chamadas.

## Como funciona

**3 regras fundamentais:**

1. **Conteúdo estável primeiro**: system prompt, documentos de referência, exemplos few-shot, e instruções fixas devem vir no início — antes de qualquer conteúdo que mude entre chamadas.
2. **Conteúdo dinâmico por último**: a mensagem do usuário, o documento específico da tarefa, a query de busca — tudo que varia vai no final. Qualquer mudança antes do ponto de cache quebra o hit.
3. **Mínimo 1.024 tokens para acionar cache**: prefixos curtos não são cacheados. System prompts ricos, documentos longos, ou contexto acumulado valem a pena para superar esse threshold.

**Cache-breaks a evitar:**
- Timestamps dinâmicos no system prompt
- IDs de sessão ou UUIDs inseridos no início
- Qualquer interpolação de variáveis antes do conteúdo estável

**Verificação de cache hits**: headers de resposta da API incluem `cache_read_input_tokens` e `cache_creation_input_tokens`.

**hot.md do vault como exemplo**: o arquivo `04-SYSTEM/wiki/hot.md` é um prefixo de contexto denso (>1024 tokens) com conteúdo estável — índice de entidades, convenções, estrutura do vault — projetado para entrar em cache na primeira chamada da sessão e ser reutilizado em todas as chamadas subsequentes.

## Por que importa

Para agentes e sessões longas com contexto repetido, caching correto pode reduzir 70–90% dos custos de tokens de entrada. Em produção, um agente com system prompt de 4k tokens e 1000 chamadas/dia economiza ~$50/dia com Claude Sonnet só em prompt caching.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-caching]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]]
