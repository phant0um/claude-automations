---
title: "RL Scaling Laws for LLMs"
type: source
source: Clippings/RL Scaling Laws for LLMs.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 9
triagem_cat: ml-research
tags: [clipping, ml-research]
---

## Tese central

Scaling laws para RL pós-pretraining permitem prever o resultado de investimentos de compute antes de executá-los — cobrindo RLVR (RL with Verifiable Rewards), STaR, e InstructZero. Resultado prático: experimentos menores extrapolam para escala grande, acelerando iteração de pesquisa de RL.

## Key insights

- **Scaling Law Fundamentals aplicados a RL:** power laws que descrevem pre-training (Chinchilla, OpenAI) se estendem ao regime de RL pós-pretraining — com curvas diferentes mas previsibilidade similar. Performance ≈ C^α onde C é compute e α é expoente específico do regime
- **Compute investments se tornam previsíveis:** "significant compute investments are less daunting, as we know what the result of this invested compute will be" — scaling law converte decisão de "vamos tentar" para "esperamos ganho X com compute Y, investimento justificado se X > threshold"
- **Extrapolação de experimentos pequenos:** "iteration speed for experiments can be increased by running smaller scale experiments and extrapolating their results" — rodar experimento de RL em modelo 1B e extrapolar para 70B é mais rápido e barato que rodar diretamente em 70B. Aceleração de iteração de pesquisa
- **RLVR, STaR, InstructZero:** três paradigmas distintos de RL pós-pretraining com curvas de scaling distintas — não há lei única, mas família de leis por paradigma

## Scaling Laws: revisão dos fundamentos

### O que são

Relação empírica entre recursos (compute, dados, parâmetros) e performance do modelo. Forma geral:

```
L(C) = (C_min / C)^α
```

Onde L é loss, C é compute total, e α é expoente empírico. Descoberto pela OpenAI em 2020, refinado por DeepMind (Chinchilla) em 2022.

### Por que funcionam

LLMs são estimadores de máxima verossimilhança em dados de linguagem. A distribuição de competências linguísticas segue power law — muitas tarefas fáceis, poucas tarefas difíceis. À medida que modelo cresce, vai resolvendo dificuldades progressivamente maiores — curva power law natural.

### Extensão para RL

RL pós-pretraining opera em distribuição diferente — reward de tarefa específica, não verossimilhança de linguagem. Curvas de scaling são diferentes mas estrutura power law se mantém, com expoente α específico por paradigma.

## RLVR: RL with Verifiable Rewards

### Paradigma

Treinar com RL em tarefas onde reward é verificável deterministicamente — código (testes passam/falham), matemática (resposta correta/errada), lógica formal.

### Curva de scaling

RLVR tem curva de scaling mais íngreme que SFT (supervised fine-tuning) em benchmarks de raciocínio. Ganhos continuam escalando com compute mesmo após regime de diminishing returns de SFT.

Implicação: para tarefas formais, RL continuado é mais eficiente que mais dados de SFT além de certo ponto.

### Exemplos

- DeepSeek-R1: RLVR em matemática → ganhos em MATH de 79% → 91% com 100× mais compute de RL
- Gemini 2.0 Flash Thinking: curva de scaling similar em coding benchmarks

## STaR: Self-Taught Reasoner

### Paradigma

Gerar raciocínio (chain-of-thought), verificar se resultado final está correto, usar raciocínios corretos como dados de fine-tuning — loop bootstrapping.

### Curva de scaling

STaR tem scaling mais suave que RLVR mas funciona em domínios sem reward verificável (escrita, análise). Número de iterações do loop bootstrapping escala com qualidade.

## InstructZero

### Paradigma

Otimizar instruções (system prompts) usando LLM como otimizador — gradient-free, usa feedback de performance como sinal.

### Curva de scaling

InstructZero tem scaling em número de iterações de otimização × qualidade do modelo otimizador. Modelos maiores como otimizador produzem instruções melhores para modelos menores como executores.

## Implicações práticas

### Para pesquisa

Rodar grid search de hiperparâmetros de RL em escala 1B, identificar configuração ótima, extrapolar scaling para 70B antes de rodar experimento caro. Reduz custo de exploração em 50-100×.

### Para produto

"Quanto compute de RLVR precisamos comprar para melhorar benchmark X em Y pontos?" é agora uma pergunta respondível antes de executar — decisão de negócio com base em evidência, não intuição.

### Para design de agentes

Agentes que aprendem via RL continuado (como sistemas de melhoria contínua em produção) podem ter curvas de melhoria projetadas — expectativa realista de quando agente atingirá nível de performance desejado.

## Limitações das scaling laws de RL

- Generalização entre benchmarks é incerta — scaling em MATH não garante scaling em HumanEval na mesma taxa
- Mudanças de paradigma (novo algoritmo de RL) invalidam leis anteriores — requer re-calibração
- Leis medem performance média — comportamentos emergentes em escala não são previstos pelas leis

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]

## Fonte

Arquivo original: `Clippings/RL Scaling Laws for LLMs.md`
