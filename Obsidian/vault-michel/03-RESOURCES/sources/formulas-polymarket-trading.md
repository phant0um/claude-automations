---
title: The 3 Old Math Formulas Quietly Powering Modern Polymarket Trading
type: source
source_file: .raw/articles/3-formulas-polymarket-trading-2026-04-16.md
author: Alex (@de1lymoon)
date_ingested: 2026-04-16
tags: [polymarket, prediction-markets, bayes, kelly, black-scholes, trading, python]
---

# The 3 Old Math Formulas Powering Polymarket Trading

Artigo de Alex (@de1lymoon) sobre os três frameworks matemáticos que o top 1% dos traders do Polymarket usa combinados. Fórmulas com 263, 70 e 51 anos de idade — nenhuma projetada para prediction markets.

## As 3 fórmulas

### 1. Teorema de Bayes (1763) — Atualização de probabilidade
**Origem:** Thomas Bayes, ministro inglês; notebooks póstumos enviados à Royal Society em 1763; ignorado por 200 anos até cientistas nucleares, CIA e Google descobrirem.

**Fórmula:** P(A|B) = [P(B|A) × P(A)] / P(B)

**Uso no Polymarket:** Tratar cada notícia como uma atualização, não um veredicto. Encadear atualizações — o posterior de uma se torna o prior da próxima. Enquanto o mercado processa uma manchete, o trader Bayesiano já está 3 atualizações à frente.

**Exemplo:** Mercado Fed cut em 42¢ → CPI quente chega → posterior = 18¢ → edge de 24 centavos ANTES do mercado mover.

### 2. Kelly Criterion (1956) — Dimensionamento de posição
**Origem:** John Kelly Jr., Bell Telephone Laboratories, NJ. Problema de teoria da informação → matematicamente idêntico ao sizing ótimo de apostas. Ed Thorp: "o princípio de aposta mais importante já descoberto."

**Fórmula:** f* = (bp - q) / b
- f* = fração do bankroll a apostar
- b = odds líquidas
- p = probabilidade de ganhar
- q = 1 - p

**Uso no Polymarket:** Tamanho da aposta escala automaticamente com o edge. Edge pequeno → aposta pequena. Edge grande → aposta grande, mas nunca tão grande a ponto de arruinar com uma sequência de perdas.

**Quarter-Kelly:** Maioria dos profissionais usa 0.25× para sustentabilidade emocional.

**Regra fundamental:** Apostar mais que Kelly diz matematicamente destrói retornos de longo prazo. Sempre. Sem exceção.

### 3. Black-Scholes (1973) — Precificação de volatilidade implícita
**Origem:** Fischer Black e Myron Scholes. Rejeitado 2 vezes antes de publicar. Ganhou Nobel. LTCM (fundo gerido pelos próprios criadores + 2 Nobel) usou a fórmula para alavancar $125 bilhões → quase colapsou o sistema financeiro global → bailout de $3.6B do Fed. A fórmula estava correta. O sizing estava insano.

**Adaptação para contratos binários (Polymarket):**
Price = e^(-rT) × N(d2)

**Uso no Polymarket:**
1. **Volatilidade implícita** — inverter Black-Scholes para encontrar o que o mercado está "precificando" de incerteza. IV baixa = mercado subprecifica risco. IV alta = mercado superprecifica certeza.
2. **Vol surface arbitrage** — mesmo evento em múltiplos timeframes (março vs junho). Black-Scholes define a relação que os preços DEVERIAM ter. Quando quebra → explorável.

## O sistema completo (3 fórmulas juntas)

```
1. Bayes → estima probabilidade real (atualiza com notícias)
2. Black-Scholes → confirma onde o mercado está errado na precificação de risco
3. Kelly → dimensiona a posição corretamente
```

Pipeline Python completo disponível na fonte bruta.

## Validação empírica

Jonathan Becker (2026) — análise de **72.1 milhões de trades** no Polymarket:
- **Limit orders** (calculado, Bayesiano): **+1.12% por trade**
- **Market orders** (emocional, reativo): **-1.12% por trade**
- Gap de 2.24pp estatisticamente robusto em todo o dataset

## Conexões com o vault

> [!key-insight] Conexão com Ciência de Dados
> Bayes' Theorem é o mesmo Teorema de Bayes que fundamenta o Naive Bayes no [[03-RESOURCES/concepts/ciencia-de-dados]]. A intuição é idêntica: atualizar probabilidades com novas evidências.

> [!key-insight] Conexão com prediction-markets
> Este artigo aprofunda o [[03-RESOURCES/concepts/prediction-markets]] com implementações quantitativas concretas — o "edge" em lag de dados que a página menciona é exatamente isso.

## Links internos

- [[03-RESOURCES/concepts/prediction-markets]] — conceito base; este artigo fornece o toolkit quantitativo
- [[03-RESOURCES/entities/Polymarket]] — plataforma onde estas estratégias são aplicadas
- [[03-RESOURCES/concepts/bayesian-reasoning]] — Bayes expandido
- [[03-RESOURCES/concepts/kelly-criterion]] — Kelly expandido
- [[03-RESOURCES/concepts/ciencia-de-dados]] — Naive Bayes usa o mesmo teorema
