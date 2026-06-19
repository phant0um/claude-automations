---
name: modelo-mental-von-neumann
title: Modelo Mental Von Neumann para Agentes
type: fundamento
updated: 2026-05-13
sources:
  - Anatomy of an Agent Harness
tags: [ai-agents, arquitetura, modelo-mental]
---

# Modelo Mental Von Neumann para Agentes

## Analogia

| Computador Von Neumann | Agente LLM |
|----------------------|------------|
| CPU | LLM (processador de linguagem) |
| RAM | Contexto da sessão (janela de tokens) |
| Disco | Memória persistente (vault, AGENTS.md, wiki) |
| Barramento | Protocolo de mensagens (stream-json, MCP) |
| Programa | Skill / system prompt |
| Interrupção | Hook (PreToolUse, PostToolUse) |

## Implicações Práticas

**RAM é limitada** → contexto tem limite. Use compaction, lazy loading, just-in-time retrieval.

**Disco é persistente** → `AGENTS.md`, `04-SYSTEM/wiki/hot.md`, `04-SYSTEM/wiki/memory.md` são o disco do sistema. Ler antes de agir.

**CPU é stateless** → cada sessão começa do zero sem o "disco". Por isso o harness carrega o contexto relevante antes de processar.

**Instrução ≠ Goal** → dar instruções mecânicas é programação imperativa (fraco). Dar um goal com constraints é programação declarativa (forte).

## 12 Componentes do Harness

1. Orchestration loop
2. Tool management
3. Memory systems
4. Context management
5. Input/output parsing
6. State management
7. Error handling
8. Guardrails
9. Verification
10. Subagent delegation
11. Logging/observabilidade
12. Cost tracking

## Relacionado

- [[04-SYSTEM/skills/foundational/fat-skill-thin-harness]]
- [[04-SYSTEM/wiki/principles]]
