---
title: "Agent Patterns"
type: reference
created: 2026-05-31
updated: 2026-05-31
tags: [reference, agent-systems, design-patterns, orchestration]
status: developing
---

# Agent Patterns

Índice de padrões recorrentes de design para agentes — execução, orquestração, anti-patterns, e aplicações no vault.

## Padrões de Execução

| Padrão | Core idea | Vault use |
|--------|-----------|-----------|
| **ReAct** | Reason → Act → Observe, loop | wiki-ingest: decide qual tool antes de agir |
| **Tool Use** | LLM → structured call → resultado determinístico | Todos os agentes via MCP |
| **Reflection** | Agente avalia próprio output antes de entregar | review, verify |
| **Planning** | Plano explícito antes de execução | plan mode + `.claude/todo.md` |
| **Memory Retrieval** | Busca contexto em memória externa antes de responder | hot.md, MEMORY.md |

## Padrões de Orquestração (7 Topologias)

| Topologia | Estrutura | Vault use |
|-----------|-----------|-----------|
| **Sequential** | A → B → C | Pipeline diário: captura → ingest → hot |
| **Parallel** | A + B + C → merge | Batch ingest: N sub-agents simultâneos |
| **Hierarchical** | Orquestrador → sub-agents | Nexus → agentes especializados |
| **Peer-to-peer** | Agentes se chamam mutuamente | Debate/revisão cruzada |
| **Fan-out/Fan-in** | 1 → N → 1 | wiki-ingest: 1 orq, N agents, 1 commit |
| **Kanban** | Fila compartilhada de tasks | Cross-day persistence via `07-QUEUE/` |
| **Event-driven** | Trigger → agente específico | Hooks: UserPromptSubmit → caveman |

## Sub-agents = Compressão de Contexto

Ganho principal não é paralelismo — é context compression. Sub-agent processa N tokens → retorna ~200 ao orquestrador. Janela do orquestrador fica limpa.

**Heurística:** 7/10 tasks de produção vencem com sub-agents.

## Anti-patterns

| Anti-pattern | Sintoma | Fix |
|--------------|---------|-----|
| **Context flooding** | Sub-agent recebe contexto completo quando summary basta | Brief com só o necessário |
| **Over-orchestration** | Agente para cada micro-task | Threshold: task < 5 min → inline |
| **Silent failure** | Sub-agent falha sem sinal ao orquestrador | Success conditions explícitas |
| **God agent** | Um agente faz tudo | Especializar; Nexus orquestra, não executa |
| **Stale memory** | Agente usa memória antiga como se fosse atual | Citation order + timestamps |

## Vault Patterns Específicos

- **Ingest loop**: `.raw/` → wiki-ingest agent → `03-RESOURCES/` → hot.md update
- **Self-improvement**: hill detecta gaps → extend propõe → review valida
- **Guard**: erro encontrado → `errors.md` → nunca repetir
- **Audit**: audit-agentes-mensal → cada agent avaliado → report

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-patterns]] — conceito detalhado
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]] — arquitetura por camadas
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — thin harness pattern
- [[04-SYSTEM/agents/agentic-reasoning]] — como agentes raciocinam
- [[04-SYSTEM/AGENTS]] — aplicação concreta no vault
