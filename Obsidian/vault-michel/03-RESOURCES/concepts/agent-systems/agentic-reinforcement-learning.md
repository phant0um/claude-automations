---
title: "Agentic Reinforcement Learning"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, reinforcement-learning, training]
status: developing
---

# Agentic Reinforcement Learning

RL training where the agent is an LLM operating with tools — optimizing for task-level success via rubric-graded rewards rather than human preference labels.

## O que é / What it is

Agentic RL applies reinforcement learning to LLMs that take sequences of tool-use actions. Unlike RLHF (which optimizes for human preferences on single responses), agentic RL rewards **successful task completion** across a full execution trajectory.

## Como funciona

**Reward signal:**
- Tasks are graded with a 0–1 rubric (partial credit for subgoals).
- Verifier (often another LLM or deterministic test) scores the final state.
- Reward is sparse (only at end) or shaped (intermediate subgoal rewards).

**Optimizer — GRPO (Group Relative Policy Optimization):**
- Sample N trajectories per task.
- Score all N.
- Update model to favor trajectories above the group mean.
- No critic network needed; group comparison provides the baseline.

**Fully simulated environments:**
- Agent runs inside a sandboxed environment (browser, terminal, code executor).
- Actions are cheap, parallel, and safe to fail.
- Enables thousands of rollouts per training step.

## Dual-data flywheel

```
RL training → better agent → harder tasks solvable →
new successful trajectories → SFT on those → stronger base →
more RL headroom → repeat
```

This loop is how frontier models (DeepSeek-R1, Claude 3.5+) acquire extended reasoning and tool-use skills.

## Por que importa

Understanding agentic RL helps Michel evaluate claims about agent capability improvements and explains why newer Claude models handle longer, more complex tasks than predecessors. It also informs the design of reward structures for custom fine-tuning, if that becomes relevant.

## Related
- [[03-RESOURCES/concepts/long-horizon-agent-training]]
- [[03-RESOURCES/concepts/long-horizon-agents]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/agentic-execution]]

## Evidências

- **[2026-06-21]** Tratar uma trajetória agêntica como um único token sequence crescente (visão padrão em RL) é inadequado — torna a evolução de contexto rígida e cria mismatch de representação entre rollout e treino. Agent-R1 propõe representação step-lev... — [[agent-r1-a-unified-and-modular-framework-for-agentic-reinforcement-learning]]
- **[2026-06-21]** RL multi-turn multi-task em agentes LLM trava em infraestrutura não-escalável e algoritmos instáveis. AgentRL (Tsinghua/Z.AI) resolve com pipeline geração-treino totalmente assíncrono, API unificada baseada em function-call, ambientes co... — [[agentrl-scaling-agentic-reinforcement-learning-with-a-multi-turn-multi-task-fram]]
- **[2026-06-21]** RL agêntico em ambientes simulados escala bem mas trabalho anterior usava síntese semi-automática ou tarefas pouco difíceis. AutoForge (Alibaba/Tongyi Lab) propõe pipeline unificado de síntese automatizada de ambientes com tarefas difíce... — [[autoforge-automated-environment-synthesis-for-agentic-reinforcement-learning]]
- **[2026-06-21]** Introdução didática a World Models: um agente que aprende uma cópia interna aproximada de como o ambiente se comporta, permitindo prever o próximo estado dado o estado atual + ação, sem precisar agir de fato no ambiente real (rollout ima... — [[how-do-world-models-work]]
- **[2026-06-21]** "Loop engineering" é a skill emergente que substitui prompting direto: em vez de instruir um agente passo a passo, você projeta um pequeno sistema que encontra trabalho, entrega ao agente, verifica o resultado e decide o próximo moviment... — [[loop-engineering-build-an-ai-that-codes-while-you-sleep]]
- **[2026-06-21]** Um prompt dá uma resposta e espera você decidir o próximo passo; um loop roda o ciclo completo sozinho (Discover → Plan → Execute → Verify → Iterate) até atingir um objetivo definido uma vez. Das 5 etapas, Verify, State e regra de parada... — [[loops-explained-claude-gpt-mira-and-what-actually-works]]
- **[2026-06-21]** Paper (PaW) propõe treinar policy e world model juntos, no mesmo processo de RL, sem simulador separado nem estágio de treino extra — observação central: rollouts on-policy já contêm o par ação→próxima-observação necessário para supervis... — [[policy-and-world-modeling-co-training-for-language-agents]]
- **[2026-06-21]** Paper propõe StarPO (State-Thinking-Actions-Reward Policy Optimization), framework geral para RL de agente em nível de trajetória, e RAGEN, sistema modular para treinar/avaliar agentes LLM — estudo em 4 ambientes revela 3 achados centrai... — [[ragen-understanding-self-evolution-in-llm-agents-via-multi-turn-reinforcement-le]]
- **[2026-06-21]** Identifica "template collapse": modelos em RL multi-turn podem manter entropia estável (sinal tradicionalmente lido como "saudável") enquanto, na prática, recorrem a templates fixos de raciocínio que parecem diversos mas são input-agnost... — [[ragen-2-reasoning-collapse-in-agentic-rl]]
- **[2026-06-21]** On-policy distillation (sinal denso, token a token, de um professor melhor) funciona e é muito mais eficiente em compute que RL — mas "self-distillation ingênua" (tentar obter o professor de graça injetando informação privilegiada no pro... — [[why-on-policy-distillation-works-and-naive-self-distillation-doesn-t]]

## Perspectivas

- **[2026-06-21]** Desacoplar 'unidade de transição' (passo) de 'estratégia de otimização' (token vs passo) é o insight arquitetural reaproveitável fora do paper Agent-R1 — separa modelagem de algoritmo. — [[agent-r1-a-unified-and-modular-framework-for-agentic-reinforcement-learning]]
