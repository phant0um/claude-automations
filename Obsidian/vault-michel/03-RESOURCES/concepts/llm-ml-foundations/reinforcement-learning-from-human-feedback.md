---
title: "Reinforcement Learning from Human Feedback"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Reinforcement Learning from Human Feedback

A técnica que transformou LLMs em assistentes úteis: alinhar o modelo com preferências humanas via RL.

## O que é

RLHF é o pipeline de treinamento que treina um LLM para produzir respostas que humanos preferem, usando sinais de feedback humano como recompensa. Foi o breakthrough central do ChatGPT (InstructGPT, 2022) e continua presente em Claude, GPT-4 e similares.

## Como funciona

**3 fases sequenciais:**

1. **SFT (Supervised Fine-Tuning):** fine-tune do modelo base em exemplos de alta qualidade escritos por humanos. Estabelece o comportamento base de "seguir instruções".

2. **Reward Model (RM):** humanos comparam pares de respostas (qual você prefere, A ou B?). Treina-se um modelo separado para prever a preferência humana — esse modelo vira o "júri" automático.

3. **RL contra o RM:** usa-se PPO para otimizar o LLM maximizando o score do reward model. **KL divergence penalty** impede que o modelo fuja demais do SFT baseline (evita colapso).

```
Base LLM → SFT → RM training (preference pairs) → PPO loop → Aligned LLM
```

## Variantes

- **Constitutional AI (Anthropic):** substitui parte do feedback humano por princípios escritos + auto-critique do próprio modelo (RLAIF)
- **GRPO:** elimina o critic separado, usa comparação de grupo para estimar vantagem — mais simples e barato
- **DPO (Direct Preference Optimization):** elimina o RM explícito, treina diretamente nas preferências — ver [[03-RESOURCES/concepts/rlhf-pipeline]]

## Por que importa

Sem RLHF, LLMs são bons em completar texto mas ruins em seguir instruções, recusar pedidos perigosos ou ser honestos. RLHF é o que separa um modelo base de um assistente. Limitação crítica: **reward hacking** — o modelo aprende a enganar o RM sem melhorar de verdade (Goodhart's Law aplicado a IA).

## Related
- [[03-RESOURCES/concepts/reinforcement-learning]]
- [[03-RESOURCES/concepts/rlhf-pipeline]]
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/reasoning-models]]
