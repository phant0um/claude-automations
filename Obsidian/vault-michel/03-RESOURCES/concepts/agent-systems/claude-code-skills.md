---
title: "Claude Code Skills"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Claude Code Skills

Reusable `.md` files that extend Claude Code behavior — the plugin system of the agentic harness.

## O que é / What it is

A skill is a markdown file loaded into Claude Code's context that gives it a new capability, workflow, or persona. Skills are triggered by keywords, slash commands (`/skill-name`), or explicit invocation. They compound: as the skill library grows, Claude Code becomes progressively more capable without model changes.

## Como funciona

**Anatomy of a skill:**
```
# Skill Name
Trigger: <keywords or /command>

## Steps
1. ...
2. ...

## Tools
- Read, Write, Bash, ...

## Output
What the skill produces
```

**Skill types by function:**
- **Workflow skills** — multi-step processes (e.g., `ingest-source`, `pipeline-diario`)
- **Reasoning skills** — cognitive frameworks (e.g., `heavy-think`, `hill-climb`)
- **Persona skills** — role-specific behavior (e.g., `caveman`, `guard`)
- **Utility skills** — reusable sub-tasks (e.g., `commit`, `resumo`)

**Skills vs. prompts vs. hooks:**
| | Scope | Persistence | Trigger |
|-|-------|-------------|---------|
| Skill | Single capability | File in repo | Keyword / command |
| Prompt | One-shot instruction | None | Manual |
| Hook | Pre/post-tool side effect | settings.json | Automatic |

**SkillOpt:** After multiple uses, a skill should be reviewed for dead steps, redundant instructions, and unclear triggers. The `skill-creator` and `create-skill` skills handle creation; periodic linting keeps the library lean.

## Composability

Skills can invoke other skills. A `pipeline-diario` skill calls `ingest-source` for each item. This lets complex workflows be assembled from tested primitives rather than monolithic prompts.

## Related
- [[03-RESOURCES/concepts/agent-systems/agentic-harness]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/agent-systems/agentic-engineering-levels]]
- [[03-RESOURCES/concepts/agent-systems/_index]]

## Evidências
- **[2026-06-19]** SKILL.md como nível intermediário entre copiar-colar um role e promovê-lo a sub-agent isolado — carregado automaticamente quando a tarefa encaixa — [[03-RESOURCES/sources/how-to-run-claude-as-a-team-not-a-tool]]
- **[2026-06-19]** Extração de vocabulário compartilhado (codebase-design, domain-modeling) de skills individuais para skills base reutilizáveis — DRY aplicado a skills — [[03-RESOURCES/sources/release-mattpocock-skills-1-0-0]]
- **[2026-06-19]** Regra "se você lembra o agente como trabalhar mais de duas vezes, isso é uma skill" — 7 skills Hermes cobrindo design, identidade, memória, ferramentas externas, diagramas, e meta-criação de skills — [[03-RESOURCES/sources/ai-agents-harness/7-skills-serious-hermes-agent]]
- **[2026-06-19]** Skill roda na mesma janela de contexto (vs. subagente isolado); gatilho de criação: notar-se colando as mesmas instruções repetidamente — [[03-RESOURCES/sources/ai-agents-harness/agent-harness-engineering-14-step-roadmap]]
- **[2026-06-24]** Hermes é um runtime persistente, não um workflow — os prompts que você dá no dia 1 é que transformam o repo em... — [[17-prompts-that-make-hermes-run-while-you-sleep-copy-paste-inside]]
- **[2026-06-24]** Default harness = agent loop + built-in tools (bash, read_file, write_file, glob, grep, web_fetch, web_search, todo,... — [[the-harness-eve-default]]
- **[2026-06-24]** claude-obsidian implementa LLM Wiki de Karpathy: raw (生肉) + wiki (熟肉, AI-maintained) com bidirectional links. 15... — [[claude-obsidian-second-brain]]
