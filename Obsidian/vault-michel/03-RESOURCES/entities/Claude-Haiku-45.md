---
title: Claude Haiku 4.5
type: entity
subtype: model
created: 2026-05-14
updated: 2026-05-14
tags: [claude, anthropic, model, haiku, api, fast, low-cost]
---

# Claude Haiku 4.5

**Model ID:** `claude-haiku-4-5-20251001`  
**Família:** Claude 4  
**Tier:** Haiku (rápido, baixo custo, tarefas estruturadas)

## Uso no Fullstack Agent System

Modelo de rotina do [[Fullstack-Agent-System|Fullstack Agent System]] — usado por todos os agentes para tarefas repetitivas e de baixa complexidade:

| Agente | Usa Haiku para |
|---|---|
| Backend Dev | Testes unitários, docs OpenAPI, seeds |
| Frontend Dev | CSS utilities, testes E2E, Storybook stories |
| Infra & Cloud | Dockerfiles, manifests Kubernetes, runbooks |
| Data & AI | Relatórios de métricas, docstrings de pipelines |
| Security | Security headers, configs WAF, checklists |

## Regra de uso

Haiku para outputs < 500 tokens com padrão conhecido. Economia vs. Opus: ~75%.

## Relações

- Família: Claude 4 (Anthropic)
- Tier acima: [[Claude-Sonnet-46|Claude Sonnet 4.6]] — para código e análise
- Sistema: [[Fullstack-Agent-System]]
