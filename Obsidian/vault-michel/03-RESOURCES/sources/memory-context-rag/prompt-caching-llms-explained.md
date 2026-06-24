---
title: "Prompt caching in LLMs, clearly explained"
type: source
source_file: .raw/articles/Prompt caching in LLMs, clearly explained.md
author: Avi Chawla (@_avichawla)
ingested: 2026-04-17
tags: [prompt-caching, kv-cache, cost-optimization, claude-code, tokens]
triagem_score: 9
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
- [[04-SYSTEM/agents/claude-code-agent]] — caso de estudo principal; 92% hit rate

---

## Por que O(n²) → O(n) é o número mais importante

Sem cache, cada token gerado na decode phase requer que todos os tokens de contexto anteriores sejam reprocessados para computar atenção. Para um contexto de 20.000 tokens gerando 1.000 tokens de output: 20.000 × 1.000 = 20 milhões de operações de atenção — cobradas ao preço cheio.

Com cache: os 20.000 tokens de prefix são computados uma vez e os KV values são persistidos. A decode phase lê do cache em vez de recomputar. O custo do prefix cai de O(n) por token gerado para O(1) — a amortização é total para todas as gerações que reutilizam o mesmo prefix.

Isso é especialmente crítico para agentes multi-turn: um agente com system prompt de 15.000 tokens rodando 100 turnos de 100 tokens gerados cada paga pelo prefix **uma vez** em vez de 100 vezes. A economia composta é o que explica o 92% de hit rate do Claude Code — sessions longas beneficiam proporcionalmente mais do cache.

---

## Implementação com a API da Anthropic

Para forçar cache em um prefix específico, a Anthropic API usa o campo `cache_control` no content block:

```python
import anthropic

client = anthropic.Anthropic()

response = client.messages.create(
    model="claude-opus-4-5",
    max_tokens=1024,
    system=[
        {
            "type": "text",
            "text": "Você é um assistente especializado em análise de código...\n\n" + 
                    long_codebase_context,  # 15.000+ tokens
            "cache_control": {"type": "ephemeral"}  # marca o breakpoint de cache
        }
    ],
    messages=[
        {"role": "user", "content": user_query}
    ]
)

# Verificar hit rate
usage = response.usage
cache_efficiency = usage.cache_read_input_tokens / (
    usage.cache_read_input_tokens + usage.cache_creation_input_tokens
)
print(f"Cache efficiency: {cache_efficiency:.1%}")
```

O `cache_control: ephemeral` instrui o servidor a persistir o KV cache para esse breakpoint por **5 minutos** (padrão) ou **1 hora** se usar extended caching (2x o custo de escrita).

---

## O Custo da Cache Write e quando vale

Cache writes custam 1.25x o preço de input normal — um prêmio de 25%. Isso significa que o cache só começa a pagar a partir do segundo uso:

- **Uso 1**: write (1.25x) — custo maior que sem cache
- **Uso 2+**: read (0.1x) — desconto de 90%

Break-even: se um prefix de 20.000 tokens é usado apenas 1 vez, o cache é prejudicial. A partir de 2 usos, a economia é de aproximadamente 79% por uso adicional.

Para workflows de sessão longa (agentes, multi-turn, analysis), o break-even é atingido na segunda mensagem da sessão. Para workflows de single-shot (uma pergunta, uma resposta), o cache não ajuda.

---

## Cache TTL e estratégia para sessões longas

O TTL padrão de 5 minutos é suficiente para sessões interativas normais. O extended caching de 1 hora serve para:
- Background agents que processam em batch com pausas entre requests
- Workflows orquestrados com múltiplos sub-agents acessando o mesmo prefix
- Sessões com `sleep` ou aguardando input humano entre turns

Para o vault-michel com workflows noturnos (N8N crons), o extended caching garante que o system prompt + CLAUDE.md + hot.md — carregados no início da sessão — permaneçam cacheados durante toda a janela de processamento.

---

## Diagnóstico de cache miss

Os três maiores causadores de miss inesperado em produção, além dos listados:

**Model switching implícito**: alguns frameworks de agente selecionam modelo diferente para sub-agents sem que o usuário perceba. Caches são model-specific — qualquer troca de modelo invalida o cache inteiro do prefix.

**Encoding de caracteres especiais**: strings que parecem idênticas podem ter representações UTF-8 diferentes (NFD vs NFC normalization). Especialmente relevante para prompts copiados de documentos com caracteres acentuados.

**Response object recycling**: em alguns SDKs, reusar o objeto de mensagem anterior e adicionar o próximo turno via mutation em vez de criar um novo objeto pode quebrar o prefix hash se a serialização mudar.

**Diagnóstico**: sempre verificar `cache_creation_input_tokens` vs `cache_read_input_tokens` no objeto `usage` da response. Se `cache_creation_input_tokens` for alto em todos os requests, há um miss sistemático — inspecionar o prefix para mudanças entre requests.

---

## Aplicação no vault-michel

O vault opera com CLAUDE.md (>3.000 tokens) + hot.md + skills index carregados em cada sessão. Com cache configurado:

- **SessionStart**: cache write do prefix completo (CLAUDE.md + hot.md + skills) — ~4.000 tokens × 1.25x
- **Todos os turns seguintes**: cache read — ~4.000 tokens × 0.1x
- **Em uma sessão de 20 turns**: cache write amortizada em 19 reads → saving de ~85% no prefix

A regra crítica para o vault: **nunca injetar timestamp dinâmico no CLAUDE.md ou hot.md** durante uma sessão ativa. Atualizar hot.md ao final da sessão (Stop hook), não durante — cada atualização mid-session cria um novo hash e invalida o cache.
