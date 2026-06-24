---
title: "Vibe Coding Security"
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, agent-systems, security, vibe-coding, guardrails]
---

# Vibe Coding Security

## Definição

Vibe coding (coding por linguagem natural sem revisão manual) sem guardrails de segurança é uma bomba relógio. Agent loops que geram código sem authorization gates, sem CI, sem verification produzem débito técnico e vulnerabilidades. O antídoto é o self-cleaning codebase: agent loops que limpam automaticamente via testes + refactoring.

## Evidências

- **[2026-06-23]** Vibe coding sem authorization = bomba relógio — [[vibe-coding-is-a-ticking-time-bomb]]
- **[2026-06-23]** Self-cleaning codebase via agent loops — [[the-self-cleaning-codebase]]
- **[2026-06-23]** Security precisa rodar a machine speed — [[aws-continuum-security-at-machine-speed]]

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-runtime-security]]
- [[03-RESOURCES/concepts/ai-agents/beautiful-nonsense]]
- [[03-RESOURCES/concepts/software-engineering/verification]]