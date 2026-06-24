---
title: "World Model"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations, agent-systems]
status: developing
---

# World Model

An agent's internal representation of how the environment works — used to predict the consequences of actions before taking them.

## O que é / What it is

A world model is the agent's **predictive map** of its environment: given current state S and action A, what will state S' look like? Agents with accurate world models can plan without executing, recovering from errors mentally before they happen in the real world.

## Como funciona

**Model-based agent (has world model):**
1. Agent predicts outcomes of candidate actions.
2. Selects the action with the best predicted outcome.
3. Executes. Observes real outcome.
4. Updates world model if prediction was wrong.

**Model-free agent (no explicit world model):**
1. Agent selects action based on policy (learned mapping from state to action).
2. No explicit prediction step.
3. Faster but less able to generalize to novel situations.

## World models in LLMs

LLMs implicitly develop world models during pretraining — they learn to predict tokens, which requires modeling the causal structure of the world. Evidence: GPT-class models track game state, object permanence, and social dynamics in narratives without explicit programming.

**Limitation:** LLM world models are learned from text, not grounded experience. They can be confidently wrong about physical or dynamic systems.

## Padrões / Patterns

- **Plan-with-world-model:** Before executing a destructive action, simulate it mentally using the world model. If the predicted outcome is bad, don't execute.
- **Model error detection:** When real observations diverge from predictions, flag for replanning.
- **Meta-world-modeling:** An agent that models its own world model uncertainty — knowing when not to trust its predictions.

## Por que importa

Understanding world models explains why LLM agents sometimes take surprising actions: their world model is incomplete or wrong. Designing agents to surface world-model uncertainty (rather than act on wrong predictions confidently) is a key robustness strategy.

## Related
- [[03-RESOURCES/concepts/ai-agents]]
- [[03-RESOURCES/concepts/agentic-execution]]
- [[03-RESOURCES/concepts/multi-step-planning]]
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]

## Evidências
- **[2026-06-19]** Padrão "modelos ajudam humanos → humanos ajudam modelos → modelos fazem sozinhos" replicado de cibersegurança para robótica física (Project Fetch) — [[03-RESOURCES/sources/project-fetch-phase-two]]
- **[2026-06-21]** Padrões de RL para agentes de terminal (GRPO-style) descartam o stream de feedback do ambiente (stdout, erros, logs) como sinal de treino, aplicando loss só em tokens de ação. ECHO (Environment Cross-entropy Hybrid Objective) adiciona um... — [[1-echo-turns-terminal-feedback-into-supervision-during-agent-rl]]
