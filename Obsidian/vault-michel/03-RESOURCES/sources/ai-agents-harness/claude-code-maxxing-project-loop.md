---
title: "claude code-maxxing: treat claude code like a project loop"
type: source
source: "[@Voxyz_ai](https://x.com/Voxyz_ai/status/2066126725348532530)"
created: 2026-06-15
ingested: 2026-06-15
tags: [ai-agents]
---

## Tese central

Modo padrão (pedir mudança → ver diff → talvez testar → fechar sessão) "funciona, mas desperdiça a maior parte do que claude code pode fazer". Tratar o repo inteiro como o loop, com continuidade entre sessões, é o uso de alta performance.

## Argumentos principais

- **Tratar o repo inteiro como o loop**: sessões persistentes/resumíveis, CLAUDE.md/.claude/rules/skills/notes como memória de projeto que se lê e edita, browser/chrome para review visual real, HTML descartável quando markdown/screenshot não bastam, hooks/goal/loop/routines/scheduled tasks para follow-ups, **verificação antes de qualquer coisa contar como done**.
- Valor central = **continuidade**: projeto continua entre sessões em vez de resetar a cada abertura.
- "Standing instruction" sugerida como skill/CLAUDE.md — pontos relevantes pro vault-michel:
  - CLAUDE.md = regras estáveis (arquitetura, comandos, convenções, always-do); `.claude/rules/` = regras escopadas por path/subsistema.
  - "Quando aprender algo estável sobre o projeto, fazer update pequeno e revisável no arquivo certo em vez de deixar na conversa" — **exatamente o mecanismo de memory/hot.md/errors.md já em uso**.
  - "A file diff is not evidence it works" — rodar o menor gate significativo (test/lint/typecheck/build/smoke/preview/browser check/PR-CI).
  - "If a check must always happen, propose a hook instead of relying on memory or good intentions" — reforça uso de hooks vs convenção informal.

## Implicações para o vault

Artigo de "como usar Claude Code bem" mais do que design de agente — mas a frase "leave enough project state that the next session never starts from zero" é o resumo de 1 linha do propósito de `hot.md` + `.claude/todo.md` + memory. Reforça [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]. O ponto sobre hooks > convenção é candidato a `errors.md` se algum erro recorrente do vault puder virar hook (ex: dedup-gap do manifest, v4.3 — já é bash, não precisa hook, mas é o mesmo princípio).

Um dos artigos que convergem como confirmação (não novidade): ver também [[03-RESOURCES/sources/ai-agents-harness/fable5-self-improving-system-14-steps]], [[03-RESOURCES/sources/ai-agents-harness/anatomy-of-a-reliable-ai-agent]], [[03-RESOURCES/sources/ai-agents-harness/loop-driven-development-next-layer-ai-coding]] e [[03-RESOURCES/sources/ai-agents-harness/autonomous-long-running-coding-agents]] — tratar como triangulação de fontes, não como gaps.

## Links

- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[04-SYSTEM/wiki/errors]]
