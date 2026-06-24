---
title: "21 RL Concepts Explained Simply"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, reinforcement-learning, rl, llm-training, concepts]
score: 7
author: "Neo Kim / Ashish Bamania"
source_url: "https://newsletter.systemdesign.one/p/what-is-reinforcement-learning"
domain: ml-research-papers
---

# 21 RL Concepts Explained Simply

**Neo Kim** (System Design Newsletter #130) + **Ashish Bamania** como guest author. Guia plain-language de RL sem math equations pesadas.

## Tese

RL está voltando ao mainstream: robôs humanoides, game-playing AIs, LLMs — todos treinados com RL. Contrário a tutoriais que "parecem difíceis", RL é intuitivo.

## Os 21 Conceitos (estrutura)

**Fundamentos:**
- **RL**: aprendizado por trial-and-error via feedback (reward/punishment)
- **Agent**: entidade central que observa, decide, age, aprende (ex: LLM)
- **Environment**: tudo fora do agente — user inputs, system prompt, tools, tool results, context window, conversation history
- **Analogy**: deer (agent) forrageando em forest (environment), evitando cheetah

**Loop RL (para LLMs):**
- State → Action → Reward → Next State
- Agent não conhece a policy ótima a priori — aprende via experiência

**Conceitos chave (inferidos da estrutura do artigo):**
- Policy, Value Function, Q-Function, Reward Signal, Episode
- Exploration vs Exploitation, Discount Factor
- Model-based vs Model-free
- On-policy vs Off-policy
- RLHF aplicado a LLMs: humanos são o environment que fornece reward

## Relevância

Fundamento teórico para entender RLHF, GRPO, RLVR — usados em treino de Claude, Gemini, GPT.

## Ver Também

- [[03-RESOURCES/concepts/llm-ml-foundations/rl-training-llms]]
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/sources/ml-research-papers/rubric-based-rewards-for-rl]]
