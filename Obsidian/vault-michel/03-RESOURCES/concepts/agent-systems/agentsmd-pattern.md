---
title: AGENTS.md Pattern
type: concept
status: developing
tags: [AGENTS.md, agentic-dev, repo-docs, ai-agents, conventions, claude-code, openhands]
created: 2026-05-14
updated: 2026-05-19
---

# AGENTS.md Pattern

## O que é

`AGENTS.md` é um arquivo de documentação no repositório escrito **para agentes de IA**, não para desenvolvedores humanos. É o equivalente do `README.md` para workers de IA que vão tocar o código.

Tendência emergente: repositórios maduros estão adicionando `AGENTS.md` como parte do workflow agentic, ao lado de `CLAUDE.md` (regras do projeto para Claude Code) e `README.md` (documentação humana).

## Distinção crítica

| Arquivo | Audiência | Propósito |
|---------|-----------|-----------|
| `README.md` | Humanos | Entender o projeto, como instalar, como contribuir |
| `CLAUDE.md` | Claude Code | Regras operacionais, estilo, permissões, anti-patterns |
| `AGENTS.md` | Agentes de IA em geral | Como rodar, testar, o que não tocar, procedimentos obrigatórios |

`CLAUDE.md` foca em **regras de comportamento** do Claude Code especificamente. `AGENTS.md` foca em **procedimentos e contexto do repositório** para qualquer agente que vá trabalhar no código.

## O que incluir em AGENTS.md

Com base no exemplo do OpenHands (repositório de referência):

### 1. Visão geral do repositório
```
This repository contains the code for OpenHands,
an automated AI software engineer.
It has a Python backend (in the openhands directory)
and React frontend (in the frontend directory).
```

### 2. Como rodar a aplicação
Instruções explícitas de setup, variáveis de ambiente, dependências.

### 3. Como testar
Separado por camada (backend, frontend, e2e). Com comandos exatos.

### 4. O que não tocar
Arquivos ou diretórios que o agente não deve modificar sem instrução explícita.

### 5. Regras de lockfile
```
Do NOT modify package-lock.json or poetry.lock directly.
Run `npm install` or `poetry install` to update.
```

### 6. Pre-commit hooks — regra obrigatória
```
IMPORTANT: Before making any changes to the codebase,
ALWAYS run `make install-pre-commit-hooks`
```

### 7. Convenções de PR
Como formatar PRs, o que incluir na descrição, como nomear branches.

### 8. Linting por camada
```
If you've made changes to the backend, run pre-commit.
If you've made changes to the frontend,
run npm run lint:fix && npm run build
```

## Por que importa

Agentes com total liberdade fazem escolhas ruins. `AGENTS.md` é o mecanismo de **guardrails procedurais**:
- O agente segue os mesmos procedimentos toda vez que toca o código
- Sem necessidade de re-explicar contexto a cada nova sessão
- Reduz erros silenciosos (lockfiles corrompidos, hooks ignorados, PRs mal formatados)

> "You're not just writing code. You're writing instructions for AI workers who will be touching that code."

## Quando criar

Se agentes vão trabalhar regularmente em um repositório, `AGENTS.md` é parte do job. Não é opcional em produção agentic.

## Ecossistema relacionado

Com 14,000+ MCP servers disponíveis e 131+ subagentes especializados (via VoltAgent/awesome-claude-code-subagents), o AGENTS.md se torna o ponto de entrada que unifica como todos esses agentes devem se comportar em um repositório específico.

## Relação com .claude/agents/

`AGENTS.md` (arquivo no root do repo) documenta procedimentos. `.claude/agents/` (diretório de definições de subagentes) define quais especialistas existem e como se comportam. São complementares.

## Ver também

- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — estrutura .claude/ incluindo agents/ dir
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — como orchestrator delega para subagentes
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — ferramentas que os agentes usam
- [[03-RESOURCES/entities/OpenHands]] — repositório de referência com AGENTS.md maduro
- [[03-RESOURCES/entities/VoltAgent]] — biblioteca de 131+ subagentes especializados
- [[03-RESOURCES/sources/ai-agents-harness/from-one-chatbot-to-131-specialists-agentsmd]] — fonte original deste padrão

## Evidências
- **[2026-06-19]** eve (Vercel): agente = diretório de arquivos (agent.ts, instructions.md, tools/, skills/, subagents/, channels/, schedules/) — convenção sobre configuração — [[03-RESOURCES/sources/introducing-eve-open-source-agent-framework]]
