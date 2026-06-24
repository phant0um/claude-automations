---
title: CLAUDE.md Self-Improvement Loop
type: concept
status: developing
tags: [claude-code, CLAUDE.md, self-improvement, lessons, workflow, autonomous-learning]
created: 2026-05-05
updated: 2026-05-19
---

# CLAUDE.md Self-Improvement Loop

Pattern for making Claude Code permanently encode user corrections into project behavior, so the same mistake is never repeated across sessions.

## Mechanism

1. User corrects Claude on any behavior or output
2. Claude updates `tasks/lessons.md` with the pattern that caused the correction
3. The rule is written as a self-directed prevention instruction
4. At session start, Claude reviews `tasks/lessons.md` for the relevant project
5. Mistake rate drops over time; behavior converges to the user's mental model

## Why it matters

Without this loop, every new session resets to default behavior. With it, Claude Code accumulates project-specific "muscle memory" — behavioral rules derived from the actual working relationship, not general training.

> "Next session it doesn't repeat the mistake. Next month it matches how you think. Next year you're not managing Claude. It's working like someone who's been on your team for years." — @srishticodes

## Implementation in CLAUDE.md

Add to your project's CLAUDE.md:

```
## Self-Improvement Loop
- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project
```

And maintain `tasks/lessons.md` as a living ruleset.

## Relation to this vault

This vault implements this pattern via `tasks/lessons.md` and the `CLAUDE.md` project instructions. See [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] for CLAUDE.md placement and limits.

## Evidências

- **[2026-06-19]** Swarm de agentes Kimi K2.6 transforma feedback do gate de verificação (Opus 4.8) em regras permanentes num CONSTRAINTS.md lido automaticamente a cada sessão — [[03-RESOURCES/sources/self-improving-loop-300-agent-swarm-kimi]]
- **[2026-06-19]** "Self-improving" honesto não é o modelo aprendendo, é o harness acumulando — fechar o loop: output → reviewer subagent → memória → lições destiladas em skills → próxima execução herda skills mais afiadas — [[03-RESOURCES/sources/ai-agents-harness/agent-harness-engineering-14-step-roadmap]]

## Related concepts

- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — CLAUDE.md as the container for these rules
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — EPCC workflow; lessons captured at Commit phase
- [[03-RESOURCES/concepts/agent-systems/autonomous-learning]] — broader concept of agents that learn from feedback
- [[03-RESOURCES/concepts/agent-systems/agent-error-correction]] — error correction in agentic systems

## Source

- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-claudemd-senior-engineer-srishticodes]] — attributed to [[03-RESOURCES/entities/Boris-Cherny]] (Anthropic)
