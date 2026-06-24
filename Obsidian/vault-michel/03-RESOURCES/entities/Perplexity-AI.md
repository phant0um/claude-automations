---
title: "Perplexity AI"
type: entity
category: ai-company
created: 2026-05-01
updated: 2026-05-01
tags: [entity, ai-company, llm, post-training, search]
---

# Perplexity AI

Empresa de AI (San Francisco) conhecida pelo motor de busca conversacional com citações. Em 2026, ganhou destaque por revelar o **método de post-training** que permite ao Qwen3.5 superar GPT-5.4 em factualidade com 4x menos custo.

## Resultado Chave (Post-Training Qwen3.5)

| Métrica | Perplexity Qwen3.5-397B | GPT-5.4 |
|---------|-------------------------|---------|
| **FRAMES benchmark** | **73.9%** | 67.8% |
| **Custo/query** | **$0.020** | $0.085 |

Qwen3.5 com post-training da Perplexity: **+6.1pp de accuracy, 4x mais barato**.

## Método de Post-Training (SFT + GRPO com Gated Reward)

### Fórmula de Reward

```
R(τ) = r_base · s − pen_eff
```

Onde:
- `r_base` = reward base pela trajetória
- `s` = fator de escala de factual correctness
- `pen_eff` = penalidade por eficiência (tokens desnecessários)

**Insight crítico:** `r_base` é **multiplicado** por `s` (não adicionado). Correctness é um **gate** — se errado, zera o reward mesmo com boa eficiência. Previne reward hacking onde o modelo aprende a ser eficiente mas impreciso.

### Pipeline

1. **SFT** (Supervised Fine-Tuning) em exemplos de alta qualidade com citações corretas
2. **GRPO** (Group Relative Policy Optimization) com gated reward function
3. Avaliação em FRAMES (benchmark de factualidade com fontes múltiplas)

## Uso como Motor de Rotinas Semanais

Além da pesquisa ad-hoc, o Perplexity é usado como motor de **14 prompts recorrentes** organizados em calendário semanal fixo (Segunda a Domingo). Cada prompt ≤ 2.000 caracteres, cobrindo: briefing de notícias, julgados jurídicos, agenda normativa, tech/IA, AI Agents, finanças, concursos, viagens, câmbio, CrossFit e cultura nerd.

Ver [[03-RESOURCES/sources/guides-courses-howtos/prompts-perplexity-rotinas-semanais-otimizadas]] para a coleção completa v3.0.

## Relação com a Wiki

- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]] — o método geral que a Perplexity exemplifica
- [[03-RESOURCES/concepts/llm-ml-foundations/reward-hacking]] — gated reward é uma defesa contra reward hacking
- [[03-RESOURCES/concepts/pkm-obsidian/perplexity-routine]] — padrão de uso em rotinas semanais estruturadas
- [[03-RESOURCES/concepts/pkm-obsidian/weekly-knowledge-routine]] — framework de KM semanal implementado com Perplexity
- Fonte (post-training): `Clippings/How Perplexity Post-Trains Qwen3.5 to Beat GPT-5.4 at 4x Lower Cost on Factuality.md`
- Fonte (rotinas): [[03-RESOURCES/sources/guides-courses-howtos/prompts-perplexity-rotinas-semanais-otimizadas]]
