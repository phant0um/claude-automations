---
title: Agent Production Patterns
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, production, patterns, reliability]
---

# Agent Production Patterns

Patterns para construir agents que sobrevivem trabalho real: long tasks, weird input, running while you sleep, still right when you check.

## Core patterns

1. **Narrow job**: Um agent, um job repeatable. "Build five agents that each do one thing well before one that does five things badly."
2. **State file**: Markdown read at start, written at end. What's done, what's next, what learned.
3. **Separate verifier**: Checker knows only rubric + result, not who produced it. Author ≠ Reviewer.
4. **Hard stop**: Checkable end state verified by separate grader, not agent's opinion.
5. **Token budget**: Cap loops and tokens. Budget turns agent from scary to tool.
6. **Quarantine untrusted input**: Reader agent ≠ Actor agent. 30-line read-only removes prompt injection risk.
7. **Cost per accepted result**: The only metric that matters. If accepting <50%, agent is losing.
8. **Save as Skill**: Package prompt, rules, workflow, known failure modes. Every real failure folded back makes next run sharper.

## System prompt = operating manual

"Be helpful" is a wish. Write like onboarding a contractor: role, exact steps, hard rules (negative/specific), what done looks like. "Never touch billing" beats "be careful."

## Evidências

- [[03-RESOURCES/sources/ai-agents/how-to-build-claude-agent-trust-production-full-course]] — 14 passos canônicos
- [[03-RESOURCES/sources/ai-agents/how-to-build-claude-agent-trust-production]] — Versão resumida
- [[03-RESOURCES/sources/ai-agents/missing-piece-every-agent-loop]] — Validator externo como fix

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-loop-pattern]]
- [[03-RESOURCES/concepts/ai-agents/beautiful-nonsense]]
- [[04-SYSTEM/agents/core/verify]]
- **[2026-06-24]** 4 paradigms shifts em 10 anos de TiDB: técnico→produto, software→serviço, humano→AI-assistido,... — [[distributed-db-paradigm-migration]]
