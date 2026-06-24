---
title: "Teorema de Bayes no Trading"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, finance-trading]
status: developing
---

# Teorema de Bayes no Trading

Cada novo dado de mercado é evidência que deve atualizar — não substituir — a crença anterior sobre a probabilidade de um sinal ser válido.

## O que é

Aplicação do Teorema de Bayes para atualizar probabilidades de hipóteses de trading (ex: "estamos em regime de alta volatilidade") à medida que novos dados chegam, em vez de tomar decisões baseadas em sinais binários fixos.

## Como funciona

**Fórmula:**
```
P(H|E) = P(E|H) × P(H) / P(E)
```

- **P(H)** — prior: probabilidade inicial da hipótese (ex: 60% de chance de tendência de alta dado o contexto histórico)
- **P(E|H)** — likelihood: probabilidade de observar a evidência E se H for verdadeiro
- **P(H|E)** — posterior: crença atualizada após observar E

**Aplicações práticas:**
- _Detecção de regime_: atualizar probabilidade de "mercado em tendência" vs "mercado lateral" a cada novo candle
- _Filtragem de sinais_: um sinal técnico tem probabilidade inicial de acerto; evidências adicionais (volume, contexto macro) elevam ou reduzem o posterior
- _Gestão de risco adaptativa_: position sizing proporcional à confiança bayesiana no sinal

**Exemplo:** P(tendência de alta) = 0.6 (prior). Surge rompimento de resistência com volume 2× acima da média. P(esse evento|tendência de alta) = 0.8. O posterior sobe para ~0.75 — justificando maior exposição.

## Por que importa

Traders que operam com sinais binários (compra/não compra) ignoram a incerteza. Raciocínio bayesiano força calibração explícita: o quanto esta nova evidência realmente muda a aposta? Conecta-se à otimização de portfólio bayesiana via GBP.

## Related
- [[03-RESOURCES/concepts/gbp-optimization]]
- [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]]
