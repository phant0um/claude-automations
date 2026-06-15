---
name: regime-classifier
type: skill
version: 1.0.0
used-by: [nexo, macro, valor, quant, desafiante]
---

# Regime Classifier — Template de Output Padronizado

Skill consumida por Macro para produzir classificação de regime econômico em formato padronizado. Output governa premissas dos agentes downstream.

## Quando usar

Nexo invoca Macro com este template antes de análises de carteira/portfólio multi-ativo.
Qualquer agente pode incluir o bloco de regime no seu output quando relevante.

## Os 4 Regimes (Andrew Ang / BlackRock framework)

| Regime | Características BR + EUA |
|--------|--------------------------|
| **Expansão** | Crescimento PIB acima do potencial, crédito abundante, spreads comprimidos, SELIC em queda ou estável baixa, S&P em alta tendência |
| **Late-Cycle** | Crescimento ainda positivo mas desacelerando, inflação persistente, curva de juros flat ou invertida, spreads começando a abrir, mercado de trabalho ainda aquecido |
| **Recessão** | Contração de PIB, crédito restrito, spreads altos, desemprego subindo, ativos de risco em queda coordenada |
| **Recuperação** | Pós-recessão, estímulos ativos, crédito reabrindo, ativos de risco em recuperação, inflação ainda controlada |

## Template de Output

```
Regime: [Expansão | Late-Cycle | Recessão | Recuperação]
Confiança: [alta | média | baixa]
Sinal primário BR: [ex: SELIC em ciclo de alta + IPCA acima da meta = Late-Cycle]
Sinal primário EUA: [ex: Fed funds rate estável + spread 10y-2y positivo = Recuperação]
Risco de reclassificação: [qual sinal mudaria o regime? ex: IPCA ceder para 4.5% = Expansão]
Implicação para carteira BR+EUA: [1 linha — o que muda na alocação ideal]
```

## Implicações por Regime (referência para agentes downstream)

### Expansão
- Ações: overweight, múltiplos expandem
- Renda fixa: underweight, duration curta
- FIIs: neutro a positivo (cap rate cai com SELIC)
- Cripto: correlação positiva com risk-on

### Late-Cycle
- Ações: seletividade, preferir Quality + Low Vol
- Renda fixa: começar a montar duration (IPCA+)
- FIIs: cautela em FIIs de papel (risco SELIC subir)
- Cripto: volatilidade elevada, reduzir exposição

### Recessão
- Ações: underweight, preservar capital
- Renda fixa: overweight, Tesouro IPCA+ longo
- FIIs: cautela em FIIs de tijolo (vacância sobe)
- Cripto: correlação com ativos de risco; quedas severas

### Recuperação
- Ações: overweight agressivo, small caps outperform
- Renda fixa: duration longa (taxas caindo)
- FIIs: voltar posição, especialmente fundos de tijolo
- Cripto: recuperação agressiva após ciclo de baixa

## Exemplo de output

```
Regime: Late-Cycle
Confiança: média
Sinal primário BR: SELIC em 13.75% com IPCA acima de 6% — aperto monetário persistente sem recessão declarada
Sinal primário EUA: Fed funds em plateau + spread 10y-2y levemente invertido
Risco de reclassificação: se IPCA BR convergir para meta em 2 trimestres → Expansão
Implicação para carteira BR+EUA: reduzir duration em renda fixa, priorizar ações Quality/Low Vol, cautela em FIIs de papel
```
