---
title: "How Jim Simon's RL Engine Cuts Execution Costs by 47% (The Exact DQN Framework)"
type: source
source: "Clippings/How Jim Simon's RL Engine Cuts Execution Costs by 47% (The Exact DQN Framework).md"
created: 2026-06-22
ingested: 2026-06-22
tags: [articles]
---

## Tese central
Algoritmos de execução estáticos (TWAP, VWAP) são previsíveis e exploráveis por HFT predatório porque seguem um cronograma pré-computado que não reage a choques de liquidez em tempo real. O artigo apresenta a arquitetura completa (com código) de um agente DQN (Deep Q-Network) que trata execução ótima de ordens como um problema de decisão sequencial (MDP), reduzindo implementation shortfall em ~23-26% versus TWAP num desk de execução de fundo sistemático.

## Argumentos principais
- **Por que TWAP/VWAP falham**: TWAP divide a ordem igualmente no tempo — totalmente previsível, exploráveis por quem sabe quando e quanto você vai comprar em cada período. VWAP melhora dimensionando proporcional ao volume esperado, mas ainda é um cronograma pré-computado, incapaz de reagir a: secagem súbita de liquidez no order book, movimento de preço adverso durante a execução, ou information leakage do próprio padrão de trading.
- **Formulação MDP da execução ótima**: State Space = inventário restante, tempo restante na janela de execução, imbalance do order book (proporção bid/ask nos top 5 níveis), divergência de preço em relação ao preço de chegada. Action Space = discreto (negociar 0, Qmin, 2Qmin, 3Qmin ou 4Qmin shares no período) ou contínuo (fração do inventário restante). Reward = penalidade por market impact (preço de execução - preço médio × shares negociados), penalidade por inventário não-executado no fim do horizonte, pequena penalidade por trading excessivamente agressivo. Transition dynamics = desconhecida e não-estacionária — motivo pelo qual é necessário RL model-free.
- **Arquitetura DQN**: rede neural simples (Linear 4→128→64→5 com ReLU e Dropout) mapeando estado (4 dims) para Q-values sobre 5 ações discretas. Treino via Double DQN com replay buffer (capacidade 100k), epsilon-greedy decaindo de 1.0 a 0.01 ao longo de ~10k episódios, target network atualizada a cada 1000 steps, gradient clipping (norm 10).
- **A reward function é "onde mora o alfa de execução"**: o termo de "inventory urgency" (penalidade que cresce conforme o tempo se esgota, proporcional ao inventário restante × time_pressure) é descrito como crítico — sem ele, o agente aprende a esperar indefinidamente por preços melhores e nunca completa a execução. O coeficiente de pressão temporal força trading progressivamente mais agressivo conforme o horizonte se aproxima do fim.
- **Ambiente de treino simplificado**: simulador de limit order book com impacto temporário (proporcional à raiz quadrada do tamanho da ordem) e impacto permanente (linear no tamanho), mais ruído gaussiano no preço. Em produção, recomenda-se substituir por dados reais de LOB (LOBSTER, Nasdaq ITCH) ou simulador de alta fidelidade (ABIDES, PyMarketSim).
- **Considerações de produção**: (1) expansão do espaço de estado (profundidade do order book, fluxo recente de trades, regime de volatilidade, preços de ativos correlacionados); (2) ações contínuas via DDPG/PPO em vez de discretas (ações discretas são "rodinhas de treino"); (3) validação em replay histórico de mercado antes de capital real; (4) limites de risco rígidos (posição máxima, tamanho máximo de ordem, taxa máxima de participação nunca > 20% do volume) — o agente opera dentro de guardrails, não livre; (5) multi-objetivo — minimização pura de custo pode gerar comportamento estranho, então se adiciona tracking error vs. TWAP, certeza de conclusão, e máximo drawdown durante a execução.

## Key insights
- O ponto mais transferível do artigo é que a engenharia de reward (especialmente o termo de "urgência de inventário") é o verdadeiro diferencial de um agente de execução bem-sucedido — a arquitetura de rede em si é deliberadamente simples (MLP de 2 camadas), reforçando que em RL aplicado a domínios financeiros, reward shaping > complexidade de modelo.
- O artigo é honesto sobre o limite do método: "isto não transforma uma estratégia ruim em boa. Otimização de execução vale 5-15 bps por trade. Se seu sinal é lixo, 5 bps não vai salvá-lo" — mas em escala (ex: fundo de $500M AUM girando 5.000×/ano), 5 bps equivalem a $1.25M/ano em alfa, o que é "a diferença entre um bônus e nenhum bônus".
- A tabela de resultados mostra que o agente não só reduz custo médio, mas comprime a cauda (worst-case IS no percentil 95 cai de 9.1 para 6.4, -30%) — para retornos ajustados a risco, a cauda comprimida importa mais que a média.
- Risk limits explícitos (max participation rate nunca >20% do volume) são tratados como guardrail hard-coded fora do agente, não como algo que o RL deveria aprender por si — separação clara entre "o que o RL otimiza" e "o que a engenharia de risco impõe externamente".

## Exemplos e evidências
- Caso citado: desk de execução de fundo sistemático implantou agente DQN em produção no final de 2024; em 3 meses, implementation shortfall caiu 23% vs. TWAP.
- Tabela de resultados (TWAP vs. DQN Agent): Mean Implementation Shortfall 4.2→3.1 (-26%); Std Dev de IS 2.8→1.9 (-32%); Worst-case IS (p95) 9.1→6.4 (-30%); ordens não-finalizadas 0%→0.3% (gerenciável).
- Código Python completo: `DQNExecutionAgent` (rede), `ReplayBuffer`, `ExecutionTrainer` (Double DQN), `execution_reward` (função de reward com 3 componentes), `ExecutionEnvironment` (simulador de LOB simplificado), `train_execution_agent` (loop de treino completo).

## Implicações para o vault
Conecta diretamente com [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]] e [[03-RESOURCES/concepts/finance-trading/market-microstructure]] — fornece uma implementação concreta e completa (incluindo código) de RL aplicado a execução de ordens, indo além da camada teórica já presente nessas notas. Também relevante para [[03-RESOURCES/concepts/llm-ml-foundations/reinforcement-learning]] como caso de uso de DQN fora do domínio de LLMs — útil como contraponto prático ao RL aplicado a treino de modelos de linguagem documentado em outras fontes do vault.

## Links
- [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]]
- [[03-RESOURCES/concepts/finance-trading/market-microstructure]]
- [[03-RESOURCES/concepts/llm-ml-foundations/reinforcement-learning]]
