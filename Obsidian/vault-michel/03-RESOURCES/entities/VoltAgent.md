---
title: VoltAgent
type: entity
tags: [subagents, claude-code, ai-team, open-source, curated-library]
created: 2026-05-14
updated: 2026-05-19
---

# VoltAgent

Organização/repositório que mantém `awesome-claude-code-subagents` — coleção curada de 131+ agentes especializados para Claude Code, cobrindo todo o espectro de desenvolvimento de software.

## Repositório

`VoltAgent/awesome-claude-code-subagents`

Instalação:
```bash
claude plugin marketplace add VoltAgent/awesome-claude-code-subagents
```

Instalação por categoria:
```bash
claude plugin install voltagent-lang    # especialistas de linguagem
claude plugin install voltagent-infra   # infraestrutura
```

## Agentes disponíveis (131+)

**Core Development**
- api-designer, backend-developer, frontend-developer
- fullstack-developer, graphql-architect
- microservices-architect, mobile-developer, websocket-engineer

**Infrastructure & DevOps**
- cloud-architect, docker-specialist, kubernetes-engineer, terraform-expert

**Security**
- security-auditor, penetration-tester, auth-specialist

**Meta-orchestration**
- task-decomposer, agent-selector, workflow-coordinator

## Formato de um subagente

Cada subagente é um arquivo markdown que define:
- Papel e especialidade
- Skill set específico
- Comportamento esperado em tasks do seu domínio

Não é um prompt — é um especialista com comportamento consistente e previsível.

## Deploy por escopo

| Local | Escopo |
|-------|--------|
| `.claude/agents/` | Projeto-local — ativa apenas naquele codebase |
| `~/.claude/agents/` | Global — disponível em todos os projetos |

## Ver também

- [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]] — como documentar repos para esses agentes
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — como orquestrador delega para subagentes
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — estrutura .claude/agents/
- [[03-RESOURCES/sources/ai-agents-harness/from-one-chatbot-to-131-specialists-agentsmd]] — contexto de uso
