---
title: "Handoff File Pattern"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Handoff File Pattern

A structured markdown file that one agent (or session) writes so the next one can resume without losing context.

## O que é / What it is

When an agent session ends — due to context limit, task pause, or explicit handoff — the accumulated state lives only in the current context window. The handoff file pattern externalizes that state into a persistent file, enabling a fresh agent to pick up exactly where the previous one stopped.

## Como funciona

**Canonical handoff file structure:**
```markdown
# Handoff — [Task Name] — [Date]

## Current state
What has been done; what is true right now.

## Decisions made
Key choices and their rationale (prevents re-litigating).

## Next steps
Ordered list of what remains to do.

## Open questions
Unresolved issues requiring judgment or input.

## Relevant files
Paths to files that the next agent must read first.
```

**When to write:** Before `/compact`, before a long pause, before handing off to a different agent, or when the task spans multiple sessions.

**Where to store:** `.claude/todo.md` for task tracking; `04-SYSTEM/agents/` for agent-to-agent handoffs; `03-RESOURCES/sessions/` for session state in the vault.

## Por que importa

Without a handoff file, each new session starts cold — re-reading files already processed, re-making decisions already made, re-discovering context already established. A good handoff file compresses a 50k-token session into a 1k-token brief.

**Anti-pattern:** Handoff file that just says "we were working on X" without current state or next steps is worse than nothing — it implies completeness without providing it.

## Related
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-systems]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]

## Evidências
- **[2026-06-19]** Time de 5 agentes de GTM coordenados por um único registro por conta (memória compartilhada) que cada seat lê e escreve, sem orquestrador central — [[how-to-build-a-gtm-team-on-claude-code-you-can-run-alone]]
- **[2026-06-19]** Coordenação file-based com wakeAgent gates (inbox vazio = zero tokens) é mais simples e barata que Kanban para pipeline linear de 3 estágios — [[hermes-agent-notebooklm-obsidian-3-agent-research-department]]
- **[2026-06-19]** Markdown venceu banco de dados e estado em memória como meio de handoff entre passos de workflow por ser "chato e confiável"; cada passo escreve um arquivo de saída, o próximo lê — testado em pipeline real de ideação de conteúdo (Reddit→news→arXiv→síntese) — [[how-to-build-ai-workflows-when-youre-tired-of-optimizing-prompts]]
- **[2026-06-22]** Handoff que perde o campo certo (ID de fatura exato, path de módulo, instrução verbatim do usuário) faz o próximo turno "parecer confiante enquanto está errado" — argumento para compaction por política de segmento em vez de sumário único genérico — [[03-RESOURCES/sources/your-agent-does-not-need-one-summary-it-needs-a-compaction-plan]]
