---
title: Fullstack Agent System — Claude Project Setup
type: project-setup
system: Fullstack Agent System
updated: 2026-05-31
---

# Fullstack Agent System — Claude Project Setup

Time de engenharia sênior. 6 agentes especializados + Orchestrator. Código compilável, evidência obrigatória, segurança com veto técnico.

## System prompt

Usar `00-SYSTEM-PROMPTS/Orchestrator.md` para sessões completas. Para trabalho focado:

| Sessão | Arquivo | Modelo |
|--------|---------|--------|
| Orquestração + planning | `Orchestrator.md` | opus-4-7 |
| APIs, DB, microserviços | `Backend-Dev.md` | sonnet-4-6 |
| UI/UX, React/Vue | `Frontend-Dev.md` | sonnet-4-6 |
| AWS, Terraform, CI/CD | `Infra-Cloud.md` | sonnet-4-6 |
| ML, ETL, LLMs, RAG | `Data-AI.md` | opus-4-7 |
| AppSec, OWASP | `Security.md` | opus-4-7 |
| Code quality + refactor | `Forge.md` | sonnet-4-6 |

## Documentos para upload

- `docs/Constitution.md` — 6 princípios (sempre)
- `docs/Standards-Anti-Patterns.md` — padrões técnicos
- `docs/progress.md` — estado atual do projeto (File-as-Bus)
- ADRs relevantes de `adr/`

## Refs

- Sistema completo: [[04-SYSTEM/agents/Fullstack Agent System/README]]
- Memory agents: [[04-SYSTEM/agents/memory/maestro]], [[04-SYSTEM/agents/memory/stratum]], [[04-SYSTEM/agents/memory/facet]]
