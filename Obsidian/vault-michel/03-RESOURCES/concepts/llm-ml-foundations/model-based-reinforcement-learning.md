---
title: "Model-Based Reinforcement Learning"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Model-Based Reinforcement Learning

RL onde o agente aprende um modelo interno do mundo e planeja usando esse modelo antes de agir.

## O que é

Em model-based RL, o agente constrói uma **world model** — uma função que prediz `(próximo estado, recompensa)` dado `(estado atual, ação)`. Com esse modelo, pode planejar sequências de ações virtualmente antes de executar no ambiente real.

Contrasta com model-free RL (Q-learning, PPO), que aprende direto da experiência sem modelo explícito.

## Como funciona

**Loop básico:**
1. Agente age no ambiente → coleta experiência real
2. Treina world model nos dados coletados
3. Usa world model para gerar experiências sintéticas (rollouts imaginados)
4. Treina política nas experiências reais + sintéticas

**Algoritmos chave:**
- **Dyna (Sutton):** alterna entre experiência real e rollouts do modelo — referência teórica fundacional
- **MuZero (DeepMind):** aprende modelo latente implícito + planeja com MCTS — dominou Go/Chess/Atari sem regras codificadas
- **Dreamer (Hafner):** world model em espaço latente com RSSM, treina política por backprop através do modelo

**Trade-off principal:** alta eficiência amostral (menos interações reais) vs risco de **model error compounding** — erros do modelo se acumulam em rollouts longos, gerando planos inválidos.

## Variantes

| Sistema | Modelo | Aplicação |
|---------|--------|-----------|
| Dyna | Tabular/simples | Referência teórica |
| MuZero | Rede latente + MCTS | Jogos de tabuleiro |
| Dreamer v3 | RSSM latente | Controle contínuo |
| LLM + simulator | LLM como world model | Agentes de linguagem |

## Por que importa

LLMs como world models é fronteira ativa: usar o LLM para simular consequências de ações antes de executá-las (planning ahead). Projetos como LATS (language agent tree search) e WebAgent usam LLMs para rollouts imaginados de navegação web. Limitação: LLMs são world models imprecisos — hallusinam consequências com confiança aparente.

## Related
- [[03-RESOURCES/concepts/reinforcement-learning]]
- [[03-RESOURCES/concepts/meta-world-modeling]]
- [[03-RESOURCES/concepts/reasoning-models]]
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
