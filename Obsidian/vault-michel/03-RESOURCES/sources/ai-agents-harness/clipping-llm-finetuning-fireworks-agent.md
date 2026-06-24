---
title: "Automating LLM Fine-Tuning with Fireworks Agent"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, fine-tuning, llm-training, fireworks-ai, self-improving-agents, karpathy]
score: 7
author: "@omarsar0 (DAIR.AI)"
source_url: "https://x.com/omarsar0/status/2057114824467792189"
domain: ai-agents-harness
---

# Automating LLM Fine-Tuning with Fireworks Agent

**@omarsar0** (DAIR.AI): do context window para weights — usando Fireworks Agent para automatizar fine-tuning completo.

## Ponto de Partida: Karpathy

Karpathy descreveu "personal LLM Wiki" como memory aid pré-AGI: repo curado de notas sobre papers e ferramentas, lido no context quando se quer que o modelo raciocine sobre eles.

Próximo passo natural (do próprio Karpathy): "synthetic data generation + finetuning to have your LLM 'know' the data in its weights instead of just context windows."

## O Que Fireworks Agent Faz

Interface: `firectl session create -n "<instruction>"`

Pipeline completo (um agente orchestrado):
1. Dataset inspection
2. Hyperparameter sweep
3. Full training
4. Deployment
5. Working inference endpoint

Decision gates: agente superficia decisões chave (plano proposto, HP sweep results) para aprovação humana. Resto é autônomo.

**Claude Code slash command**: `pilot-agent.md` wraps firectl commands — event streaming, gate detection, resume-from-last-timestamp.

## Por Que Output Style é o Target Certo para SFT

Para personal wiki, high-leverage = consistency de formato. Base model pode ser "coaxed" com system prompt mas reverte: muda headers, varia bullet count, adiciona marketing language.

SFT fixa no nível de parâmetros. Com 50-100 exemplos limpos, formato fica nos weights. System prompt vira uma frase.

## Bigger Picture: Self-Improving Agents

Quando fine-tuning é um callable step no agent loop, o mesmo coding agent que orquestra o workflow pode disparar fine-tuning para bake de padrões recorrentes (estilo do wiki, coding style, triage policy) no modelo — fechando o loop entre *usar* e *melhorar* o modelo.

## Ver Também

- [[03-RESOURCES/concepts/llm-ml-foundations/rl-training-llms]]
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/sources/ml-research-papers/clipping-21-rl-concepts]]
