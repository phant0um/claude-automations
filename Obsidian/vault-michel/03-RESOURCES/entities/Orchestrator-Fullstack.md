---
title: Orchestrator (Fullstack Agent System)
type: entity
subtype: agent
created: 2026-05-14
updated: 2026-05-14
tags: [agent, orchestrator, multi-agent, fullstack, claude-opus-4-7, thin-planner]
---

# Orchestrator — Fullstack Agent System

Agente central do [[Fullstack-Agent-System|Fullstack Agent System]]. **Thin planner** — planeja e delega, nunca gera código ou implementa. Lê `progress.md`, decompõe tarefas com critério de done mensurável e distribui para especialistas.

**Modelo:** `claude-opus-4-7`  
**Arquivo:** `[[04-SYSTEM/agents/fullstack-agent-system/Orchestrator]]`

## Responsabilidades

1. Ler `docs/progress.md` — estado atual, bloqueios, último ciclo
2. Compreender tarefa em uma frase objetiva
3. Identificar domínio(s): Backend, Frontend, Infra, Data/AI, Security
4. Decompor em sub-tarefas com critério de done mensurável
5. Delegar com briefing enxuto (objetivo + contexto mínimo + done)
6. Verificar Evidence nos outputs recebidos
7. Atualizar `progress.md`

## Anti-padrões

- ❌ Gerar código — delega ao especialista
- ❌ Delegar sem critério de done
- ❌ Aceitar deliverable sem Evidence
- ❌ Ignorar `progress.md` ao iniciar sessão

## Relações

- Sistema: [[Fullstack-Agent-System]]
- Delega para: [[Backend-Dev-Fullstack]], [[Frontend-Dev-Fullstack]], [[Infra-Cloud-Fullstack]], [[Data-AI-Fullstack]], [[Security-Fullstack]]
- Coordenação: [[file-as-bus|File-as-Bus]]
