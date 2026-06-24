---
title: WebVoyager
type: entity
subtype: benchmark
created: 2026-04-19
updated: 2026-05-19
tags: [benchmark, web-agents, evaluation, real-world]
paper: https://arxiv.org/abs/2401.13919
---

# WebVoyager

**Benchmark** para agentes web em sites reais do mundo — complemento ao [[03-RESOURCES/entities/WebArena]] (self-hosted).

## Características

- **Sites reais:** Amazon, Apple, ArXiv, BBC, Cambridge, Coursera, ESPN, GitHub, Google Maps, Hugging Face, Wolfram Alpha (11 sites estáveis usados em 2026)
- Sites excluídos por instabilidade: Allrecipes, Booking, Google Flights, Google Search
- **Desafios:** CAPTCHAs, mudanças de layout, tasks que ficam desatualizadas

## Criadores

He et al. 2024 — ACL 2024

## Resultados WebXSkill (2026, GPT-5)

| Method | Overall |
|--------|---------|
| Vanilla | 71.9% |
| Vanilla + MAP | 74.4% |
| WebXSkill (Grounded) | **86.1%** |
| WebXSkill (Guided) | 82.7% |

**+14.2pp sobre Vanilla** com grounded mode.

## Conexões no vault

- [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]] — área de pesquisa
- [[03-RESOURCES/sources/claude-code-skills/webxskill-skill-learning-autonomous-web-agents]] — paper principal
- [[03-RESOURCES/entities/WebArena]] — benchmark complementar (controlado)
