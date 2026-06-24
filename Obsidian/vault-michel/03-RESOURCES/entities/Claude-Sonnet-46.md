---
title: Claude Sonnet 4.6
type: entity
subtype: model
created: 2026-05-14
updated: 2026-05-14
tags: [claude, anthropic, model, sonnet, api]
---

# Claude Sonnet 4.6

**Model ID:** `claude-sonnet-4-6`  
**Família:** Claude 4  
**Tier:** Sonnet (workhorse — equilíbrio custo/qualidade)

## Uso no Fullstack Agent System

Modelo primário de 3 dos 6 agentes do [[Fullstack-Agent-System|Fullstack Agent System]]:
- [[Backend-Dev-Fullstack|Backend Dev]] — APIs, DB, microsserviços, refatoração
- [[Frontend-Dev-Fullstack|Frontend Dev]] — componentes, performance, a11y
- [[Infra-Cloud-Fullstack|Infra & Cloud]] — IaC, CI/CD, observabilidade

Também usado por [[Data-AI-Fullstack|Data & AI]] para ETL/análise e por [[Security-Fullstack|Security]] para SAST/IAM.

## Quando usar

- Geração de código com complexidade moderada a alta
- Análise técnica com raciocínio estruturado
- Tarefas que exigem qualidade mas não raciocínio sistêmico de nível Opus

## Relações

- Família: Claude 4 (Anthropic)
- Tier acima: [[Claude-Opus-47|Claude Opus 4.7]] — para decisões críticas
- Tier abaixo: Claude Haiku 4.5 — para rotinas e configs
