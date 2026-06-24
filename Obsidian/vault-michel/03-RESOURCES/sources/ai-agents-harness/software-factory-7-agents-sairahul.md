---
title: "Software Factory: 7-Agent System for Shipping Features While You Sleep"
type: source
source_url: "https://x.com/sairahul1/status/2058832033628241931"
author: "@sairahul1"
published: 2026-05-25
ingested: 2026-05-28
tags: [ai-agents, claude-code, multi-agent, software-factory, vibe-coding, spec-driven]
---

# Software Factory: 7-Agent System

**Tese central:** O problema do "vibe coding" com Claude Code não é o AI — é estrutural. Colapsar product analyst, architect, backend eng, frontend eng, QA, e reviewer em uma única sessão faz erros se propagarem silenciosamente. A solução é uma "fábrica de software": 7 agentes especializados com contextos limpos, ferramentas limitadas, e 3 checkpoints humanos obrigatórios.

## Key insights

- **Vibe coding tem um teto**: prompt → generate → patch → hope. Funciona no dia 1, vira dívida no dia 30.
- **Os 7 agentes**:
  1. **Codebase Researcher** — mapeamento read-only antes de qualquer código
  2. **Story Writer** — transforma ideia em user story com acceptance criteria (Read only)
  3. **Spec Writer** — brief técnico: models, APIs, componentes, riscos (Read only)
  4. **Backend Builder** — API, services, jobs, unit tests (backend folders only)
  5. **Frontend Builder** — components, pages, hooks (frontend folders only)
  6. **Test Verifier** — acceptance tests contra o user story (test files only)
  7. **Implementation Validator** — compara implementação vs brief, reporta gaps por severidade (Read only)
- **3 checkpoints humanos**: aprovar a story, aprovar o brief, aprovar o PR. Tudo entre esses pontos roda sozinho.
- **CLAUDE.md como memória permanente**: 100–300 linhas; regras de arquitetura, comandos, anti-padrões. Cresce com cada erro corrigido.
- **Context drift é silencioso**: uma premissa errada contamina todo o downstream. Solução: jogar fora a sessão e recomeçar com a premissa correta — não corrigir inline.
- **Setup em 2–3 horas**: pasta `.claude/agents/`, skills de orquestração, hook de pre-commit para bloquear `.env`/`.key`.

## Implicações para o vault

- Reforça e detalha [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] com nomenclatura concreta dos 7 papéis.
- O padrão Researcher-first (read-only antes de escrever) é extensão de [[03-RESOURCES/concepts/agent-systems/spec-driven-development]].
- CLAUDE.md como memória autoevolutiva: veja [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]].
- Validator separado do builder = princípio do [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]].

## Links

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/spec-driven-development]]
- [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[03-RESOURCES/entities/Claude Code]]
