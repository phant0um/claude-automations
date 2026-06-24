---
title: "Human-in-the-Loop"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, safety, governance]
status: developing
---

# Human-in-the-Loop

Confirmation checkpoints in agentic systems that pause execution and surface decisions to a human before proceeding — the primary lever for balancing autonomy with safety.

## O que é / What it is

Human-in-the-loop (HITL) is an architectural pattern where an agent **stops and asks** before taking an action that is irreversible, high-stakes, or outside its authorization scope. It is not a last resort; it is a first-class design choice.

## Quando pausar / When to pause

| Condition | Reason to pause |
|-----------|-----------------|
| Irreversible action | Deleting files, force-pushing, sending emails |
| Ambiguous intent | Goal is unclear; two valid interpretations exist |
| High blast radius | Action affects >N files or external systems |
| Scope expansion | Agent needs capabilities it wasn't granted |
| Novel situation | No prior example in training or memory |

## Como implementar / How to implement

- **Approval gates:** Agent outputs a proposed action; human types "yes/no/modify" before execution.
- **Tool restrictions:** Irreversible tools require an explicit `allow` permission in `settings.json`. Missing permission = automatic pause.
- **Dry-run mode:** Agent describes what it would do before doing it. Human reviews the plan, not individual actions.
- **Escalation hierarchy:** Minor ambiguity → clarifying question. Major ambiguity or risk → full pause + summary of options.

## Balancing autonomy vs safety

HITL checkpoints add friction. The goal is to place them surgically:
- Remove checkpoints for well-understood reversible actions (reading files, running read-only queries).
- Maintain them for any action that "can't be undone in 30 seconds."
- Use the Bike Method (see [[03-RESOURCES/concepts/agent-governance]]): start with more checkpoints; remove as trust is earned.

## Por que importa

Michel's CLAUDE.md already encodes HITL explicitly for destructive ops and external actions. Formalizing the pattern helps extend this model to new agents and calibrate where autonomy is safe to expand.

## Related
- [[03-RESOURCES/concepts/agent-governance]]
- [[03-RESOURCES/concepts/agent-security]]
- [[03-RESOURCES/concepts/agentic-execution]]
- [[03-RESOURCES/concepts/long-horizon-agents]]
- [[03-RESOURCES/concepts/agent-systems/_index]]

## Evidências
- **[2026-06-19]** "Zero humanos nos 95% chatos, atenção total nos 5% que carregam risco" — fronteiras de risco definidas uma vez nas instruções do loop, não revisitadas a cada execução — [[03-RESOURCES/sources/how-to-set-up-claude-loops]]
- **[2026-06-22]** "Comprehension debt" — repo cresce mais rápido do que o humano entende, virando aprovador de diffs cego; cura é gate de leitura humana obrigatório que o loop nunca pode pular — [[03-RESOURCES/sources/loop-engineering-the-anatomy-of-an-autonomous-loop]]
