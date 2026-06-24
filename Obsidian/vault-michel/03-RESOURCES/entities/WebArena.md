---
title: WebArena
type: entity
subtype: benchmark
created: 2026-04-19
updated: 2026-05-19
tags: [benchmark, web-agents, evaluation, self-hosted]
repo: https://arxiv.org/abs/2307.13854
---

# WebArena

**Benchmark** para avaliar agentes web autônomos em ambientes realistas self-hosted.

## Características

- **5 websites self-hosted:** Shopping (e-commerce), CMS (content management), Reddit (forum), GitLab (code hosting), Map (OpenStreetMap)
- **154 tasks** (subset limpo usado em benchmarks recentes; versão original maior)
- **Avaliação controlada:** ambiente determinístico, sem variação de CAPTCHAs ou mudanças de layout

## Criadores

Zhou et al. 2024 — Carnegie Mellon University

## Uso em pesquisa

Principal benchmark de controle para agentes web. Permite ablations e diagnósticos reproduzíveis — vantagem sobre WebVoyager (sites reais, dinâmicos).

## Resultados WebXSkill (2026)

| Model | Vanilla | WebXSkill (melhor) |
|-------|---------|-------------------|
| GPT-5 | 59.7% | **69.5%** (grounded) |
| Qwen-3.5-122B | 45.5% | **53.9%** (guided) |

## Conexões no vault

- [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]] — área de pesquisa
- [[03-RESOURCES/sources/claude-code-skills/webxskill-skill-learning-autonomous-web-agents]] — paper que usa este benchmark
- [[03-RESOURCES/entities/WebVoyager]] — benchmark complementar (sites reais)
