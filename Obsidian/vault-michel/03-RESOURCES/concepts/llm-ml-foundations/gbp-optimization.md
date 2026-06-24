---
title: "GBP Optimization — Generalized Bayes Portfolio"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, finance-trading]
status: developing
---

# GBP Optimization — Generalized Bayes Portfolio

Otimização de portfólio via atualização bayesiana de crenças — robusto a mudanças de regime porque não assume distribuição fixa de retornos.

## O que é

GBP (Generalized Bayes Portfolio) é uma abordagem de alocação de ativos que substitui a estimativa pontual de retornos esperados (como em Markowitz) por uma distribuição de crenças que é atualizada continuamente com novos dados de mercado.

## Como funciona

**Diferença do Markowitz clássico:** Markowitz usa médias e covariâncias históricas fixas — altamente sensível ao período de estimação e instável em mudanças de regime. GBP trata parâmetros como variáveis aleatórias com distribuições de probabilidade.

**Mecanismo bayesiano:**
1. _Prior_: crença inicial sobre retornos esperados (ex: baseada em CAPM ou dados históricos longos)
2. _Likelihood_: modelo de como os retornos observados são gerados dados os parâmetros verdadeiros
3. _Posterior_: distribuição atualizada após cada período de observação
4. _Alocação_: pesos do portfólio derivados da distribuição posterior (ex: maximizar utilidade esperada)

**Robustez a mudanças de regime:** quando o mercado muda de comportamento, o modelo atualiza rapidamente o posterior em vez de esperar que os dados históricos sejam "lavados" por novas observações.

**Conexão com Teorema de Bayes:** cada novo retorno diário é evidência E que atualiza P(parâmetros|dados) — exatamente a estrutura do [[03-RESOURCES/concepts/bayes-theorem-trading]].

## Por que importa

Portfólios clássicos quebram em crises porque os parâmetros estimados historicamente não refletem o novo regime. GBP oferece mecanismo formal para dizer "dado o que estou vendo agora, quanto devo confiar na minha visão anterior?" — útil para qualquer sistema quantitativo que opere por meses ou anos.

## Related
- [[03-RESOURCES/concepts/bayes-theorem-trading]]
- [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]]
