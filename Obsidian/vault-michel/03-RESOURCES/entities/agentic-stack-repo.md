---
title: agentic-stack (Repo)
type: entity
category: repository
tags: [open-source, agent-stack, memory, skills, harness]
created: 2026-04-18
updated: 2026-04-18
---

# agentic-stack

Repositorio open-source criado por [[Avid-Builder]] (@Av1dlive) com estrutura `.agent/` completa para construir agents de producao.

- **GitHub:** github.com/codejunkie99/agentic-stack
- **Arquitetura:** 4 camadas — thin harness, 4 tipos de memoria, fat skills com self-rewrite hooks, protocolo de permissoes

## Estrutura

```
.agent/
├── AGENTS.md
├── harness/       # conductor.py ~200 LOC + hooks
├── memory/        # working / episodic / semantic / personal + auto_dream.py
├── skills/        # _index.md + _manifest.jsonl
├── protocols/     # permissions.md + delegation.md
└── tools/
```

## Conceitos implementados

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — 4 tipos de memoria + dream cycle
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — thin harness pattern
- [[03-RESOURCES/concepts/agent-systems/resolver-pattern]] — protocols/delegation.md

## Onde aparece no vault

- [[03-RESOURCES/sources/ai-agents-harness/ai-agent-stack-2026]]
