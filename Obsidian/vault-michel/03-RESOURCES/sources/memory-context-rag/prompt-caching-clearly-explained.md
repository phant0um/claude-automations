---
title: "Start With What Changes and What Doesn't"
type: source
source: Clippings/Prompt caching, clearly explained.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 8
triagem_cat: claude-code
tags: [ai-agents, claude-code, clipping]
---

## Tese central

Prompt caching — começar com o que muda vs o que não muda no prompt — permite atingir 92% de cache hit-rate em produção. Artigo explica mecanismo de prefill/decode, context tax real, e como calcular breakeven para decidir quando cachear faz sentido economicamente em sistemas multi-agente.

## Key insights

- **Phase 1: Prefill:** processar todos os tokens do prompt (system prompt, contexto, instrução) para gerar os KV cache values. Custo pago uma vez; cache reutilizado nas próximas N requisições dentro da janela de TTL
- **Phase 2: Decode:** gerar tokens de resposta um por um. Não é cacheável — cada token depende dos anteriores gerados. Custo de decode domina latência percebida, não custo financeiro
- **Three numbers to internalize:** (1) cache write cost ≈ 25% a mais que input normal; (2) cache read cost ≈ 10% do custo de input normal; (3) TTL da Anthropic é 5 minutos — contexto que não é reutilizado dentro de 5 min paga write sem ganhar read

## Mecanismo de prompt caching

### Como KV cache funciona

Transformer processa tokens de prompt gerando Key e Value matrices para cada camada. Essas KV matrices são o "estado processado" dos tokens de input.

Em requisição normal: calcular KV para todos os tokens a cada requisição — custo O(n) por requisição.

Com caching: calcular KV uma vez, armazenar no servidor da Anthropic, reutilizar em requisições subsequentes — custo O(n) na primeira requisição, custo mínimo nas seguintes.

### O que é cacheável

Apenas prefixo imutável do prompt:
```
[CACHEÁVEL] System prompt (instruções, persona, contexto)
[CACHEÁVEL] Documentos de referência (código, wiki, guidelines)
[NÃO CACHEÁVEL] Mensagem do usuário (muda por definição)
[NÃO CACHEÁVEL] Output do modelo
```

Para maximizar hit-rate: colocar tudo que não muda no início do prompt, antes de qualquer input variável.

### Estrutura de prompt otimizada para cache

```
[SYSTEM PROMPT — estático — 5000 tokens]
  → Persona do agente
  → Instruções de comportamento
  → Documentos de referência
  → Guidelines de output
[USER MESSAGE — variável — 100-500 tokens]
  → Instrução específica do turno atual
```

System prompt de 5000 tokens cacheado: primeira requisição paga write premium (~25% extra), todas as seguintes pagam apenas 10% do custo normal dos 5000 tokens.

## Context tax e breakeven

### Context tax

Em multi-agent systems onde cada agente recebe contexto longo (instruções, memória, tools), custo de input pode dominar o custo total mesmo com caching.

Context tax = custo de input tokens / custo total da operação.

Sem cache: context tax pode chegar a 70-80% do custo (tokens de contexto muito maiores que tokens de output).

Com cache + 90% hit-rate: context tax cai para ~10-15%.

### Cálculo de breakeven

```python
def cache_breakeven(context_tokens, requests_per_day, ttl_minutes=5):
    """
    Quantas requisições por janela de TTL para cache ser vantajoso?
    """
    write_cost = context_tokens * 1.25  # 25% premium
    read_cost = context_tokens * 0.10   # 10% do normal
    normal_cost = context_tokens * 1.0
    
    # Breakeven: quando total com cache < total sem cache
    # write_cost + n * read_cost < (n+1) * normal_cost
    # Resolvendo para n:
    breakeven_n = (write_cost - normal_cost) / (normal_cost - read_cost)
    return breakeven_n  # se > 1, cache compensa com 2+ requisições na janela
```

Para contexto de 5000 tokens: breakeven em ~1.4 requisições. Na prática, qualquer sistema com 2+ requisições por 5 minutos compartilhando o mesmo system prompt se beneficia.

## Case study: 92% hit-rate

Arquitetura que atingiu 92%:
- System prompt de 8000 tokens (instruções + documentação de API + exemplos) — estático por deployment
- Requisições chegam a ~3/minuto por usuário ativo — múltiplas dentro da janela de TTL
- Resultado: 92% das requisições pagam apenas 10% do custo de input dos 8000 tokens

Economia: sem cache, custo de input/mês = X. Com 92% hit-rate, custo cai para ~17% de X.

## Multi-agent budgeting

Em sistema com 10 agentes paralelos (como Paperclip+Hermes), cada agente com system prompt de 5000 tokens:

Sem cache: 10 × 5000 tokens por rodada de requisições = 50.000 tokens de input por rodada.
Com cache compartilhado (mesmo system prompt): primeira requisição escreve, as 9 seguintes leem — 10% de custo para 90% das requisições.

Implicação: paralelismo de agentes é muito mais econômico quando system prompts são idênticos ou quase idênticos. Investir em system prompt unificado paga dividendos em escala.

## Boas práticas

- **Colocar estático antes de variável:** garante que prefixo cacheável seja o mais longo possível
- **Versionar system prompts:** mudança de system prompt invalida cache — não mudar sem necessidade
- **Monitorar hit-rate:** Anthropic retorna `cache_read_input_tokens` e `cache_creation_input_tokens` por requisição
- **TTL de 5 minutos:** em sistemas de baixa frequência, cache pode não compensar — calcular breakeven antes de implementar

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]

## Fonte

Arquivo original: `Clippings/Prompt caching, clearly explained.md`
