---
title: Fullstack Agent System
type: entity
subtype: multi-agent-system
created: 2026-05-14
updated: 2026-05-14
tags: [multi-agent, claude, fullstack, dev-team, orchestration, senior-engineers]
---

# Fullstack Agent System

Time de engenharia sênior composto por 6 agentes especializados usando Claude AI. Os agentes são profissionais de TI seniores — pensam, escrevem código compilável, fazem integrações e executam testes de validação.

**Versão:** 2.0.0  
**GitHub:** `agente-fullstack` (mchlcs)  
**Local:** `[[04-SYSTEM/agents/fullstack-agent-system/README|README]]`

## Arquitetura

```
Orchestrator (opus-4-7) — thin planner, nunca gera código
├── Backend-Dev (sonnet-4-6)    — APIs, DB, microsserviços
├── Frontend-Dev (sonnet-4-6)   — UI/UX, React/Vue, a11y
├── Infra-Cloud (sonnet-4-6)    — AWS, Terraform, CI/CD, K8s
├── Data-AI (opus-4-7)          — ML, ETL, LLMs, RAG
└── Security (opus-4-7)         — AppSec, OWASP, veto técnico
```

## Padrões centrais

- **[[file-as-bus|File-as-Bus]]** — estado em `progress.md`, artefatos em `workspace/`, evidência em `logs/`
- **[[mandatory-evidence-output|Evidence obrigatória]]** — todo deliverable tem Deliverable + Evidence + State Update
- **Security com veto** — bloqueia qualquer deploy sem review explícito
- **Modelos por atividade** — opus para decisões complexas, sonnet para código, haiku para rotinas

## Roteamento de modelos

| Tier | Modelo | Uso |
|---|---|---|
| Opus | claude-opus-4-7 | Arquitetura, threat modeling, RAG design |
| Sonnet | claude-sonnet-4-6 | Implementação de código, análise técnica |
| Haiku | claude-haiku-4-5-20251001 | Testes, docs, YAML, configs |

Economia estimada: ~60–75% vs. Opus em tudo.

## Agentes

- [[Orchestrator-Fullstack|Orchestrator]] — planejador central
- [[Backend-Dev-Fullstack|Backend Dev]] — APIs, DB, microsserviços
- [[Frontend-Dev-Fullstack|Frontend Dev]] — UI/UX, React/Vue
- [[Infra-Cloud-Fullstack|Infra & Cloud]] — AWS, Terraform, CI/CD
- [[Data-AI-Fullstack|Data & AI]] — ML, ETL, LLMs, RAG
- [[Security-Fullstack|Security]] — AppSec, compliance, veto

## Constituição (6 princípios)

1. Evidência antes de código
2. Segurança por padrão
3. Testes não são opcionais
4. Escopo fechado por padrão
5. Falhe cedo, falhe visível
6. O sistema melhora a cada ciclo

## Relações

- Baseado em: [[Nexus-Agent-System|Nexus Agent System]] (formato)
- Padrão de coordenação: [[file-as-bus|File-as-Bus]] (AiScientist)
- Fontes: [[multi-agent-orchestration]], [[agent-harness]]
- Evolução de: Professor Fullstack v1.0 (modelos 4.5, sem Evidence)
