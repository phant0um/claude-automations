---
title: Fat Skill, Thin Harness
type: fundamento
updated: 2026-05-13
sources:
  - Meta-Meta-Prompting (OBSIDIAN_ORGANIZATION_PLAN)
  - Anatomy of an Agent Harness
tags: [ai-agents, harness, skills, arquitetura]
---

# Fat Skill, Thin Harness

## Princípio

**A skill é o valor. O harness é a infraestrutura.**

- **Fat skill** = instrução rica, contexto denso, comportamento específico
- **Thin harness** = orquestração mínima, sem lógica de negócio
- O modelo (LLM) não muda. O que muda é o que você coloca em torno dele.

## Por que isso importa

| Abordagem | Resultado |
|-----------|-----------|
| Fat harness + thin skill | Frágil, difícil de manter, não transferível |
| Thin harness + fat skill | Robusto, reutilizável, compounding |

Exemplo real: Opus 4.5 sem harness = $9 fail.
Com harness = $200 success. O modelo não mudou. O harness mudou.

## 3 Contextos da Skill

1. **Identidade** — quem é o agente, qual seu papel, o que NUNCA faz
2. **Workflow** — passo-a-passo do processo, com checkpoints
3. **Guardrails** — limites explícitos, condições de parada

## Regra de Ouro

> Se você pode resolver com uma skill bem escrita, não crie um novo agente.
> Se você precisa de identidade + ciclo de vida + guardrails, crie um agente.

## Relacionado

- [[04-SYSTEM/wiki/principles]]
- [[04-SYSTEM/agents/00-MOCs/MOC-Skills]]
- [[04-SYSTEM/agents/00-MOCs/MOC-Agentes]]
