---
title: "ECHO: Terminal Agents Learn World Models for Free"
type: source
source: Clippings/1 ECHO turns terminal feedback into supervision during agent RL..md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, agentic-rl, world-model]
---

## Tese central
Padrões de RL para agentes de terminal (GRPO-style) descartam o stream de feedback do ambiente (stdout, erros, logs) como sinal de treino, aplicando loss só em tokens de ação. ECHO (Environment Cross-entropy Hybrid Objective) adiciona uma loss auxiliar que treina a policy a prever os tokens de observação do ambiente causados pela própria ação, reaproveitando o mesmo rollout — dobrando o pass@1 do GRPO em TerminalBench-2.0.

## Argumentos principais
- GRPO padrão é extremamente esparso: no setting Qwen3-8B, menos de 15% dos rollouts on-policy resolvem a tarefa, então a maioria da interação gera pouco sinal de gradiente de política.
- Mesmo trajetórias falhas contêm outputs reais do ambiente (file listings, logs, stack traces) que entram no forward pass mas nunca entram na loss em GRPO puro.
- ECHO reutiliza o mesmo forward pass — não exige rollouts adicionais — e transforma cada resposta do terminal num target de treino extra.
- O objetivo de previsão do ambiente, isoladamente, viabiliza self-improvement sem verificador em algumas configurações (aprender só de interações com o ambiente, em tarefas OOD).

## Key insights
- Qwen3-8B: pass@1 sobe de 2.70% para 5.17%; Qwen3-14B: de 5.17% para 10.79% em TerminalBench-2.0.
- ECHO reduz fortemente a cross-entropy em tokens de ambiente held-out — mesmo em trajetórias que não gerou — enquanto GRPO puro quase não muda essa métrica.
- A partir do Qwen3-8B base, ECHO recupera ~metade do benefício de inicialização que expert-SFT-then-GRPO dá, sem usar demonstrações de expert.
- Observações de ambiente não são apenas contexto para ações futuras — são um sinal de supervisão denso e on-policy já presente em todo rollout.

## Exemplos e evidências
- TerminalBench-2.0 benchmark, comparação direta GRPO-only vs GRPO+ECHO.
- ECHO atinge o pico de performance do GRPO substancialmente mais cedo no treino (eficiência de amostra).

## Implicações para o vault
Reforça `world-model` e `agentic-world-modeling`: aprender a prever consequências do ambiente é uma forma barata de aumentar densidade de sinal sem custo extra de rollout — relevante para qualquer harness que já loga stdout/stderr de agentes de terminal (ex.: Claude Code, Hermes).

## Links
- [[03-RESOURCES/concepts/agent-systems/world-model]]
- [[03-RESOURCES/concepts/agent-systems/agentic-world-modeling]]
- [[03-RESOURCES/concepts/llm-ml-foundations/reinforcement-learning]]
