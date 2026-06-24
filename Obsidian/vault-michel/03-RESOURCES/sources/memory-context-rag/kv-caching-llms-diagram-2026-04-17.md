---
title: "KV Caching in LLMs — Diagram"
type: source
created: 2026-05-18
updated: 2026-05-18
source_file: .raw/images/kv-caching-llms-diagram-2026-04-17.md
source_type: diagram
origin: DailyDoseofDS.com
category: ai-agents
tags: [ai-agents, diagram, kv-cache, llm, transformer, attention]
triagem_score: 9
---

# KV Caching in LLMs — Diagram

## Tese central

Diagrama educacional em 3 seções que explica por que Key/Value vectors de tokens anteriores podem ser reutilizados em vez de recomputados — a base técnica do prompt caching em produção.

## Key insights

- **Forward pass básico:** tokens → Transformer Layers → Hidden States → Projection → Logits → ArgMax. A rede só precisa do último hidden state para prever o próximo token.
- **Mecanismo de atenção:** `Attention(Q, K, V) = softmax(QK^T / sqrt(d_k)) * V`. O último hidden state depende do query do último token e de todos os K/V vectors.
- **Cache em ação:** K e V de tokens anteriores não mudam — só os novos tokens precisam de computação. Reutilizar o cache elimina recomputação redundante.
- **Custo real:** aplica-se diretamente ao prompt caching do Claude ($0.02 vs $0.20/sessão quando system prompt é cacheado).

## Mecanismo técnico detalhado

### O problema sem cache

Em um Transformer decoder padrão, gerar cada token exige uma passagem completa pela atenção sobre todos os tokens anteriores. Para uma sequência de N tokens de entrada e M tokens de saída já gerados, o custo de computar o próximo token é proporcional a N+M — e cresce a cada passo. Para um system prompt de 10K tokens e 2K tokens de output já gerados, cada novo token exige atenção sobre 12K tokens, mesmo que os primeiros 10K não tenham mudado.

### Por que K e V não mudam

Na equação de atenção `Attention(Q, K, V) = softmax(QK^T / sqrt(d_k)) * V`, os vetores K e V são projeções lineares dos hidden states dos tokens de entrada. Uma vez que um token é processado, seu K e V são determinísticos e imutáveis — eles dependem apenas do embedding daquele token e dos pesos do modelo, não do que vem depois. Apenas o Q (query) do token atual muda, pois ele precisa "olhar" para todos os K/V anteriores.

O cache KV armazena os pares (K, V) computados de tokens anteriores. Ao processar o próximo token, apenas seu Q é computado do zero; os K/V cacheados são reutilizados diretamente.

### Custo de memória vs. custo de computação

O trade-off é explícito: KV cache troca memória por velocidade. Para um modelo com D dimensões de atenção, L camadas, e H cabeças de atenção, cada token na sequência ocupa aproximadamente `2 × L × H × D × bytes_por_elemento` de memória de cache. Para modelos grandes (70B+), isso é múltiplos GB para sequências longas.

Este é o motivo pelo qual serviços de inferência têm limites de contexto: não é apenas o custo de computação de processar N tokens, mas o custo de memória de manter o cache KV para N tokens por requisição simultânea.

### Prompt caching na prática (Claude)

O prompt caching do Claude funciona em nível de prefix: se o começo de um prompt (system prompt + primeiras mensagens) foi processado recentemente, o servidor reutiliza o cache KV armazenado em vez de recomputar. O cache tem TTL de 5 minutos (Claude 3.x) ou 1 hora (com cache_control explícito).

Custo: tokens em cache são cobrados a $0.30 por MTok de leitura (vs $3.00 por MTok de input sem cache para Sonnet 3.7 — 90% de desconto). A write do cache tem custo adicional de 25% sobre o preço normal de input.

Condição para hit: o prefix em cache deve ser idêntico ao prefix atual, byte a byte. Qualquer alteração no system prompt quebra o cache. Por isso a prática recomendada é manter o system prompt estável e colocar o conteúdo variável (pergunta do usuário, documentos de contexto) depois do prefix cacheado.

### Impacto em latency (TTFT)

Além do custo, o cache reduz Time-To-First-Token (TTFT) para prompts longos. Sem cache, processar 10K tokens de system prompt antes de gerar qualquer output leva tempo mensurável. Com cache, esse prefill é substituído por uma leitura de memória — ordens de magnitude mais rápido. Em aplicações interativas com contexto longo, a diferença é perceptível.

### Comparação: KV cache vs. embedding cache vs. semantic cache

| Tipo | O que cacheía | Granularidade | Hit rate |
|------|--------------|---------------|----------|
| KV cache | Vetores K/V por token | Exata (prefix match) | Alta para prompts estáveis |
| Embedding cache | Vetor de embedding de um texto | Exata | Alta para textos repetidos |
| Semantic cache | Resposta para query semanticamente similar | Aproximada (cosine sim) | Variável, depende do threshold |

KV cache é o mais fundamental — opera dentro do modelo. Embedding e semantic cache operam fora do modelo, em nível de aplicação.

### Relevância para o vault

O `04-SYSTEM/wiki/hot.md` do vault é o equivalente manual do KV cache: mantém os fragmentos de contexto mais usados em um arquivo que fica permanentemente no início da sessão. Quando qualquer skill ou agente do vault carrega `hot.md` primeiro, esses tokens são cacheados no servidor Claude e não são recomputados nas chamadas subsequentes da mesma sessão.

A métrica de eficiência do vault é: qual fração dos tokens consumidos por sessão vem de cache hits vs. novos tokens. Manter o system prompt e hot.md estáveis e colocar conteúdo variável no final maximiza o hit rate.

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/hot-cache]]
- [[03-RESOURCES/entities/claude-tradingview-full-guide]]
- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]]
