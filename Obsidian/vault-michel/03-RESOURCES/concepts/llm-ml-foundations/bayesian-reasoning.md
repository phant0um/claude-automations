---
title: Bayesian Reasoning
type: concept
status: developing
updated: 2026-04-16
tags: [bayes, probabilidade, prediction-markets, machine-learning, raciocinio]
---

# Bayesian Reasoning

Framework de atualização de crenças à medida que novas evidências chegam. A ideia central: probabilidades não são fixas — são estados de crença que devem ser revisados com cada nova informação.

## O Teorema de Bayes

**Thomas Bayes** (1701-1761) — ministro inglês. Notebooks póstumos; publicado pela Royal Society em 1763. Ignorado por ~200 anos. Redescoberto por: físicos nucleares, CIA (análise de mísseis soviéticos), Google (spam filter).

**Fórmula:**
```
P(A|B) = [P(B|A) × P(A)] / P(B)
```

| Termo | Significado |
|---|---|
| P(A) | **Prior** — crença antes de ver a evidência |
| P(B\|A) | Verossimilhança — quão provável é a evidência SE A for verdadeiro |
| P(B) | Evidência marginal — quão provável é a evidência no geral |
| P(A\|B) | **Posterior** — crença atualizada depois de ver a evidência |

## Como aplicar (passo a passo)

```python
def bayes_update(prior, p_evidence_given_true, p_evidence_given_false):
    """
    Atualiza probabilidade após observar nova evidência.
    
    prior: probabilidade inicial (0 a 1)
    p_evidence_given_true: P(evidência | hipótese verdadeira)
    p_evidence_given_false: P(evidência | hipótese falsa)
    """
    p_evidence = (p_evidence_given_true * prior) + \
                 (p_evidence_given_false * (1 - prior))
    posterior = (p_evidence_given_true * prior) / p_evidence
    return posterior
```

**Exemplo concreto (Polymarket):**
```python
# Mercado "Fed vai cortar em março?" em 42¢
prior = 0.42

# CPI quente chega — como isso muda a probabilidade?
p_cpi_quente_se_corte = 0.15   # raro se realmente vai cortar
p_cpi_quente_geral = 0.35      # aconteceu ~35% dos meses

posterior = (0.15 * 0.42) / 0.35  # = 0.18 (18%)
# Mercado ainda em 42¢. Modelo diz 18¢. Edge de 24 centavos.
```

## O poder do encadeamento

O posterior de uma atualização se torna o prior da próxima:

```python
# Múltiplas evidências sequenciais
prob = 0.65  # prior inicial
evidencias = [
    (0.20, 0.75),  # Poll ruim para o candidato YES
    (0.05, 0.40),  # Gerente de campanha renuncia
]
for (p_dado_sim, p_dado_nao) in evidencias:
    prob = bayes_update(prob, p_dado_sim, p_dado_nao)
# 0.65 → 0.33 → 0.11
```

**Por isso traders Bayesianos chegam à probabilidade correta horas antes do mercado.** Não são mais inteligentes — atualizam continuamente enquanto outros reagem emocionalmente.

## Intuição vs Bayesian

| Reação emocional | Reação Bayesiana |
|---|---|
| "CPI quente → Fed não corta → vende tudo" | Atualiza probabilidade de 42% para 18%; vende com base no math |
| "Pesquisa ruim → pânico" | Calcula: quão raro seria essa pesquisa se o candidato realmente ganhasse? |
| "Notícia boa → FOMO buy" | Verifica: essa evidência era esperada ou genuinamente nova? |

## Aplicações

### Prediction markets (Polymarket)
Parte do sistema Bayes + Kelly + Black-Scholes descrito em [[03-RESOURCES/sources/financial-trading/3-formulas-polymarket-trading]]. Dados de 72.1M trades: limit orders (Bayesianos) ganham +1.12%/trade vs market orders (emocionais) que perdem -1.12%/trade.

### Machine Learning — Naive Bayes
O algoritmo [[03-RESOURCES/concepts/dev-foundations/ciencia-de-dados]] "Naive Bayes" é a aplicação direta do teorema, assumindo independência entre features. Tipos: Gaussiano, Bernoulli, Multinomial.

### Diagnóstico médico, spam filter, RAG (retrieval-augmented generation)
Qualquer sistema que precisa atualizar probabilidades com evidências sequenciais.

## Fontes

- [[03-RESOURCES/sources/financial-trading/3-formulas-polymarket-trading]] — aplicação prática em prediction markets com Python
- [[03-RESOURCES/concepts/dev-foundations/ciencia-de-dados]] — Naive Bayes como algoritmo de ML
- [[03-RESOURCES/concepts/finance-trading/prediction-markets]] — contexto de mercados de predição
