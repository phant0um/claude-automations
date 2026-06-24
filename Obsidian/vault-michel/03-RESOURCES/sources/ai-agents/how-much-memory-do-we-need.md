---
title: "How much memory do we fucking need?"
type: source
source: "Clippings/How much memory do we fucking need?.md"
created: 2026-06-23
updated: 2026-06-23
score: A
tags: [ai-agents, source-page, hbm, memory-demand, kv-cache, agentic-sessions, inference, semiconductor, micron, hardware]
---

## Tese Central

Stocks de memória (Micron, SK Hynix) podem ainda 10x das valorizações atuais se o raciocínio não estiver ancorado em performance histórica ou all-time highs. A análise bottoms-up demonstra que a demanda por memória é várias ordens de magnitude maior do que o mundo consegue produzir hoje. O driver principal: sessões agentic (não chat casual) que consomem quantidades massivas de HBM via KV Cache.

## A Journey de Uma Mensagem de Chat

1. Mensagem é tokenizada, scheduled, roteada para GPU disponível
2. Vector run through bilhões de matrix multiplications → next word
3. Modelos pequenos (Llama 3.1-8B) cabem em 1 GPU — sem cross-GPU communication
4. Frontier models (bilhões/trilhões de params) precisam de cluster com tensor parallelism: weight matrices split across GPUs, cada forward pass troca intermediate activations via NVLink (mandatório, não opcional)

## The Memory Budget

HBM é soldada no chip, não expansível:
- H100 SXM5: 80GB
- H200: 141GB
- B200: 192GB
- B300 (upcoming): 288GB

**Dois componentes de memória:**
1. **Model weights** — tamanho fixo
2. **KV Cache** — per-session, cresce linearmente com context length, preocupa quando # de sessões concorrentes cresce

> "I introduce the concept of a 'Session' here purposefully. For most people, a 'Chat' is equivalent to a Session. But, in the world of agents, the vast majority of sessions are not controlled by or even visible to humans via a chat interface. They are programmed by software engineers, who are able to spin up and orchestrate thousands, if not hundreds of thousands of sessions in parallel."

## A Math: Llama 3.1-70B

```
KV Cache Per Token = 2 × Layers × KV Heads × Head Dimensions × 1 Byte
                   = 2 × 80 × 8 × 128 × 1
                   = 163,840 Bytes
                   = 160KB Per Token
```

- 1 sessão com 128K tokens de contexto = ~20GB de memória (1 usuário)
- 4 sessões concorrentes em max context = H100 inteira exausta
- Frontier models (Opus 4.8, GPT-5.5): KV cache 2-5x maior → 40-100GB para 128K token request

## Not All Sessions Are Equal

| Tipo de sessão | Memória | Sessions por GPU |
|---|---|---|
| Casual "what's the weather" | quase nenhuma | milhares |
| Indie dev debugging React | ~800MB | ~60 |
| Lawyer uploading 50-page contract | ~5GB | ~10 |
| **Agentic workload** (100K+ tokens) | massivo | muito poucas |

> "Agentic workloads, promised to us by Sam Altman and Jensen Huang, require a lot of memory. More importantly, this is where the world is moving."

## The Agentic Effect

Um exemplo de sessão agentic relativamente simples atinge 100K tokens rapidamente. O autor enxerga cada knowledge worker disparando dezenas dessas tasks, em paralelo, 8-10h por dia.

## Peak Concurrent Memory

Memória não é consumida cumulativamente — é alocada quando sessão começa e freed quando termina. O que importa é **peak concurrent memory**: quantas sessões vivas ao mesmo tempo.

- Knowledge worker rodando 10 agents concorrentes a 100K tokens cada = ~152GB
- 250M knowledge workers globalmente × # de sessões agentic concorrentes = demanda explode

## HBM Supply vs Demand

Estimativas de produção HBM 2026 trianguladas de:
- Method 1: Wafer capacity → GB output (effective output per HBM wafer: 1.1-1.4 TB)
- Method 2: Revenue ÷ ASP cross-check (HBM market 2025: ~$35B, 2026: $54.6B)

Market share Q1 2026: SK Hynix 58%, Samsung 21%, Micron 21%.

**Resultado:** 100 sessões agentic/knowledge worker/dia = 385 Bilhões de GB de HBM → **~60x mais** que produção 2026.

## Algorithmic Improvements

O 160KB/token é base case (multi-head attention, mid-size open source). Frontier models já usam:
- Grouped Query Attention (GQA): 4-8x redução
- Multi-Latent Attention (MLA) — DeepSeek é exemplo direto (China é GPU-constrained → scarcity breeds innovation)

**Por que a tese continua:** melhorias algorítmicas compram constant factors (4x, 8x, 16x). Demanda cresce 100-100x: agents substituem chat, context windows expandem 128K → 10M, knowledge workers 0 → 100 em uso de IA.

## Key Insights

- Sessões agentic dominam o memory budget — chat casual é noise
- KV Cache scales linearmente com context length e é per-session (não fixo como weights)
- "Session" ≠ "Chat" — agentes programados criam milhares de sessões invisíveis em paralelo
- 1 sessão 128K tokens (Llama 70B) = ~20GB; 4 concorrentes = H100 exausta
- Frontier models: 40-100GB para 128K token request
- Peak concurrent memory é o que importa, não cumulativo
- 10 agents concorrentes a 100K tokens = ~152GB por knowledge worker
- 250M knowledge workers × agentic sessions = 60x mais HBM que produção 2026
- Melhorias algorítmicas compram 4-16x; demanda cresce 100-100x
- "It turns out that we need a metric fuck ton of memory."

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-engines-hardware-first]]
- [[03-RESOURCES/concepts/llm-ml-foundations/token-compression]]
- [[03-RESOURCES/concepts/agent-systems/token-economy]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/finance/trading-systems]]

## Minha Síntese

**O que muda:** Este artigo reframes a tese de investimento em memória (HBM) através da lens técnica de KV Cache e sessões agentic. O insight chave é que "session ≠ chat" — agentes programáveis criam demanda invisível e massiva. A math é de uma ordem de magnitude: demanda é 60x a produção de 2026. Melhorias algorítmicas (GQA, MLA) compram 4-16x, mas demanda cresce 100-100x.

**Conexão pessoal:** Como investidor interessado em finança (vault tem `02-AREAS/finance/` e `finance-system`), este artigo fornece a base técnica para uma tese de investimento em memory stocks (Micron, SK Hynix). A math do KV Cache e o conceito de "peak concurrent memory" são building blocks para fazer order-of-magnitude analysis independentemente. A connection entre agentic AI (área de estudo principal do vault) e demanda de semiconductor é direta.

**Próximo passo:** Conectar esta source ao sistema de finança do vault. Criar ou atualizar conceito sobre HBM demand/supply com a math do KV Cache. Avaliar Micron (MU) como tese de investimento baseada em demanda agentic, não em performance histórica.