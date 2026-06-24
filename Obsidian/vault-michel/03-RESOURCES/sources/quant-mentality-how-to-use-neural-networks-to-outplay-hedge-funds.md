---
title: "Quant Mentality: How to Use Neural Networks to Outplay Hedge Funds"
type: source
source: "Clippings/Quant Mentality How to Use Neural Networks to Outplay Hedge Funds.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [articles]
---

## Tese central

Uma rede neural não prevê o futuro — ela aprende a função de expectativa condicional E[Y|X] escondida nos dados históricos. Entender essa distinção (expectativa vs. previsão pontual) é o que separa o framework quantitativo real (Renaissance, Two Sigma) de quem aplica ML a preços e falha sistematicamente.

## Argumentos principais

- **O que a rede aprende de fato**: ao minimizar squared error, a função aprendida é exatamente f*(X) = E[Y|X] — a média ponderada de todos os desfechos consistentes com os inputs observados, não "o próximo valor". Analogia: rede treinada em 10.000 rolagens de dado prevê 3.5 (impossível como resultado individual, mas correto como expectativa).
- **Por que previsão de preço falha**: séries financeiras são não-estacionárias — média, variância, autocorrelação e comportamento de cauda mudam entre regimes (2008 ≠ 2021). Modelo treinado em um regime aprende a estrutura condicional daquele período e erra sistematicamente quando o regime muda. Solução: engenharia de features para inputs quase-estacionários — log returns em múltiplas janelas, volatility ratio, momentum normalizado por volatilidade, z-score de volume.
- **Arquitetura LSTM para dados sequenciais**: mantém hidden state (memória de trabalho) e cell state (memória de longo prazo) controlados por 3 portões aprendidos — forget gate (decide o que esquecer do estado anterior), cell state update (combina esquecimento + nova informação via multiplicação elemento-a-elemento), output gate (filtra o que do cell state se torna hidden state exposto). Resolve o problema de vanishing gradient que quebra RNNs básicas, permitindo capturar padrões a centenas de timesteps de distância.
- **Treino disciplinado exige split sequencial em 3**: treino (gradient descent) → validação (early stopping, nunca usado para medir generalização) → teste (usado exatamente 1 vez, após todas as decisões de arquitetura/feature/hiperparâmetro já fechadas). Randomizar o split introduz lookahead bias que garante que o backtest parece melhor que a performance live.
- **Acurácia direcional esperada de um modelo bem construído: 52-57%** — parece pouco, mas um sinal direcional de 54% com Sharpe > 1.0, aplicado consistentemente em centenas de trades com Kelly-derived position sizing, composta retornos que superam a maioria dos traders discricionários.
- **Sinal sem sizing não é estratégia**: Kelly criterion dá a fração matematicamente ótima de capital por trade (f* = (p·b − q)/b). Na prática, usar half-Kelly (0.5×f*) — Kelly cheio trata a probabilidade estimada como verdade absoluta e sobre-aposta sistematicamente; half-Kelly cede ~25% do crescimento de longo prazo mas corta drawdown máximo em mais da metade. Nunca arriscar mais que 2% do capital por sinal, independente do que Kelly recomende.
- **Monitoramento de regime**: estatística KS comparando previsões live vs. validação histórica — acima de 0.1, retreinar na janela de 90 dias mais recente; em prediction markets, retreinar no mínimo a cada 30 dias (regimes mudam mais rápido e mais violentamente que em equities).

## Key insights

- "A rede está certa. A maioria dos traders está fazendo a pergunta errada" — o erro não é do modelo, é interpretar E[Y|X] como previsão pontual em vez de expectativa condicional.
- Prediction markets são o "laboratório mais limpo" para testar esse framework: todo contrato resolve em exatamente $1 ou $0, todo preço é uma estimativa de probabilidade, todo mercado resolvido é um ground-truth data point — ausente a ambiguidade que existe em equities.

## Exemplos e evidências

- Classe `TradingLSTM` completa em PyTorch (hidden_size=64, num_layers=2, dropout=0.2) e função `train_model` com early stopping (patience=10) e gradient clipping (`clip_grad_norm_`, max_norm=1.0) para evitar exploding gradients em sequências longas.
- Exemplo numérico de Kelly: contrato Polymarket a 30¢ (b=2.33), modelo estima 40% de probabilidade de vitória → f* = 14.2% do bankroll; half-Kelly aplicado na prática.
- Renaissance Technologies: 66% de retorno anual por 30 anos. Two Sigma: 10.000+ sinais ML rodando simultaneamente; pesquisador entry-level ganha $650.000/ano — usado como prova de que o framework é real, não teórico.

## Implicações para o vault

F2.5 Concept Absorption em `[[03-RESOURCES/concepts/finance-trading/kelly-criterion]]` (recebe a aplicação half-Kelly + exemplo de sinal de rede neural alimentando o sizing) e `[[03-RESOURCES/concepts/finance-trading/algorithmic-trading]]` (recebe a categoria ML-based já mencionada no concept, agora com framework LSTM completo e disciplina de split treino/validação/teste). Não cria concept novo — os 2 conceitos existentes em `finance-trading/` cobrem exatamente os dois pilares desta fonte (sizing e estratégia algorítmica).

## Links

- [[03-RESOURCES/concepts/finance-trading/kelly-criterion]]
- [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]]
