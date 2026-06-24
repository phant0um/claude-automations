---
title: "Agent Memory Bottleneck"
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, agent-systems, memory, hardware, hbm, bottleneck]
---

# Agent Memory Bottleneck

## Definição

HBM (High Bandwidth Memory) é o bottleneck real de performance em workstations agentic — não tokens, não compute. KV cache escala super-linearmente com contexto. Agent memory evolui de arquivos flat (MEMORY.md) para vector DBs estruturados. Self-hosting de memória persistente é viável com ferramentas open-source.

## Evidências

- **[2026-06-23]** HBM é o bottleneck real, não compute. KV cache escala super-linearmente — [[how-much-memory-do-we-need]]
- **[2026-06-23]** Engram: continual learning via context scaling — [[introducing-engram-scaling-compute-context]]
- **[2026-06-23]** Tutorial: agent com memória permanente (cat/git/edit) — [[30-min-agent-permanent-memory-everos]]
- **[2026-06-23]** Agent offline com vector DB + persistent memory — [[i-built-private-ai-agent-runs-fully-offline]]
- **[2026-06-23]** Memory capacity is the real performance bottleneck in agentic AI workstations — [[why-memory-capacity-is-the-real-performance-bottleneck-in-agentic-ai-workstations]]

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-memory-architecture]]
- [[03-RESOURCES/entities/Engram]]
- [[03-RESOURCES/concepts/memory-context-rag/rag-patterns]]