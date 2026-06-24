---
title: "Reinforcement Learning"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Reinforcement Learning

Aprendizado por tentativa e erro: um agente maximiza recompensa acumulada interagindo com um ambiente.

## O que é

RL é o paradigma em que um **agente** observa um **estado** do ambiente, executa uma **ação**, recebe uma **recompensa** e transita para um novo estado. O objetivo é aprender uma **política** (estado → ação) que maximize a recompensa esperada ao longo do tempo.

Formalizado como **Markov Decision Process (MDP)**: tupla (S, A, P, R, γ) — estados, ações, transições, recompensas e fator de desconto.

## Como funciona

**Conceitos centrais:**
- **Política π(a|s):** distribuição de probabilidade de ações dado o estado
- **Função de valor V(s):** recompensa esperada a partir do estado s
- **Q-valor Q(s,a):** recompensa esperada ao tomar ação a no estado s
- **Equação de Bellman:** relação recursiva entre valores de estados adjacentes

**Duas famílias principais:**

| Abordagem | Exemplos | Característica |
|-----------|----------|----------------|
| Model-free | Q-learning, PPO, GRPO | Aprende direto da experiência |
| Model-based | Dyna, MuZero, Dreamer | Constrói modelo do ambiente e planeja |

**Exploration vs exploitation:** dilema central — explorar ações novas (ε-greedy, UCB) vs explotar o que já funciona.

## Variantes

- **Q-learning / DQN:** off-policy, tabular ou com rede neural
- **PPO (Proximal Policy Optimization):** on-policy, clipping para estabilidade — padrão em RLHF
- **GRPO (Group Relative Policy Optimization):** variante mais leve, sem critic separado — usado no DeepSeek-R1
- **Actor-Critic:** combina política (actor) e estimador de valor (critic)

## Por que importa

RL é a espinha dorsal do alinhamento de LLMs modernos. **RLHF** usa PPO para ajustar o modelo contra preferências humanas. **GRPO** viabilizou modelos de raciocínio (o1, DeepSeek-R1) com menor custo computacional. Entender RL é pré-requisito para entender por que Claude, GPT-4 e similares se comportam como se comportam.

## Related
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/reinforcement-learning-from-human-feedback]]
- [[03-RESOURCES/concepts/rlhf-pipeline]]
- [[03-RESOURCES/concepts/model-based-reinforcement-learning]]
- [[03-RESOURCES/concepts/reasoning-models]]

## Evidências

- **[2026-06-21]** Padrões de RL para agentes de terminal (GRPO-style) descartam o stream de feedback do ambiente (stdout, erros, logs) como sinal de treino, aplicando loss só em tokens de ação. ECHO (Environment Cross-entropy Hybrid Objective) adiciona um... — [[1-echo-turns-terminal-feedback-into-supervision-during-agent-rl]]
- **[2026-06-21]** Tratar uma trajetória agêntica como um único token sequence crescente (visão padrão em RL) é inadequado — torna a evolução de contexto rígida e cria mismatch de representação entre rollout e treino. Agent-R1 propõe representação step-lev... — [[agent-r1-a-unified-and-modular-framework-for-agentic-reinforcement-learning]]
- **[2026-06-21]** RL multi-turn multi-task em agentes LLM trava em infraestrutura não-escalável e algoritmos instáveis. AgentRL (Tsinghua/Z.AI) resolve com pipeline geração-treino totalmente assíncrono, API unificada baseada em function-call, ambientes co... — [[agentrl-scaling-agentic-reinforcement-learning-with-a-multi-turn-multi-task-fram]]

- **[2026-06-23]** We present HAAS Studio, a simulation and decision-support tool implementing the HAAS framework for policy-aware adaptive task allocation between human — [[haas-studio-a-tool-for-simulating-benchmarking-and-governing-human-ai-work-alloc]]
- **[2026-06-23]** A single regularized PPO policy with EMA and top-advantage filtering reaches superhuman play in Generals.io under sparse win/loss reward, no league or behavior cloning needed — [[superhuman-ai-for-generalsio-using-self-play-reinforcement-learning]]
- **[2026-06-23]** WebCQ formulates multi-agent web GUI testing as a Dec-POMDP and uses QTRAN (cooperative MARL with CTDE) for scalable parallelized exploration — [[webcq-cooperative-multi-agent-deep-reinforcement-learning-for-scalable-web-gui-t]]
## Perspectivas

- **[2026-06-21]** Mascarar trajetórias com falha atribuída ao simulador de usuário (não ao agente) é técnica de denoising de sinal de recompensa generalizável a qualquer ambiente simulado — AutoForge. — [[autoforge-automated-environment-synthesis-for-agentic-reinforcement-learning]]
