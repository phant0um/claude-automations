---
title: "ECHO: Terminal Agents Learn World Models for Free"
type: source
source: Clippings/1 ECHO turns terminal feedback into supervision during agent RL..md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, agentic-rl, world-modeling, terminal-agents, source, score-B]
---

## Tese central

ECHO (Environment Cross-entropy Hybrid Objective) adiciona auxiliary loss que treina o policy para prever environment observation tokens resultantes de suas próprias ações. Reuses same forward pass as GRPO, zero rollouts extras. Dobras pass@1 no TerminalBench-2.0 (Qwen3-8B: 2.70%→5.17%, Qwen3-14B: 5.17%→10.79%). Falhas tornam-se signal — mesmo rollouts falhos ensinam como o terminal responde.

## Argumentos principais

- **Environment stream como supervision**: terminal output (stdout, errors, file contents, traces) é dense supervision signal descartado por GRPO padrão
- **Hybrid loss**: L_ECHO = L_GRPO(actions) + λ × L_Env(observations). Mesma forward pass, targets diferentes
- **On-policy self-evolving curriculum**: conforme agente melhora, visita novos terminal states, environment produz novas responses
- **Verifier-free self-improvement**: em alguns settings, environment prediction loss alone enable self-improvement em unseen OOD tasks

## Key insights

- "Predicting terminal output well = understanding terminals" — good prediction implies good understanding
- Failed rollouts não são uninformative — contêm actual outputs de tudo que o agente rodou
- ECHO matches expert-SFT-then-GRPO sem expert demonstrations
- Complementa PaW: ambos exploram next-observation supervision, ECHO para terminal agents, PaW para language agents

## Links

- [[03-RESOURCES/concepts/agent-systems/world-model]]
- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]
- [[03-RESOURCES/sources/paw-policy-world-modeling-co-training]]