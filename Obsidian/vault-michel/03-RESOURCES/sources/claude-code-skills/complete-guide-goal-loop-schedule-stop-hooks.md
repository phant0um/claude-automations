---
title: "The Complete Guide to /goal, /loop, /schedule & Stop Hooks in Claude Code"
type: source
source_url: "https://x.com/sairahul1/status/2054820977226457301"
author: "[[@sairahul1]]"
published: 2026-05-14
ingested: 2026-05-14
tags: [claude-code, agentic, goal-command, stop-hooks, scheduling, loop, autonomy]
triagem_score: 9
---

# The Complete Guide to /goal, /loop, /schedule & Stop Hooks in Claude Code

Source: [@sairahul1 on X](https://x.com/sairahul1/status/2054820977226457301), published 2026-05-14.

## Core shift

Normal Claude Code: you are the loop — prompt, wait, review, prompt again. Autonomous Claude Code: you set the condition once, Claude works until it is met, a fast evaluator checks after every turn.

## /goal

Completion-condition command. After every turn a small fast model (Haiku by default) reads the conversation transcript and checks whether the condition is true. If not, Claude starts another turn automatically.

Template:
```
/goal [task] until [success condition], verified by [check], while [constraints], or stop after [limit]
```

- Status: `/goal` (shows condition, turns, tokens, evaluator reason)
- Stop early: `/goal clear` (aliases: off, cancel, reset, none)
- Non-interactive: `claude -p "/goal [condition]"` — runs to completion in one invocation, ideal for CI
- Session crash recovery: goal restores on `--resume`/`--continue`; turn count and timer reset

**Evaluator constraint** — the evaluator reads ONLY the Claude transcript. It cannot run commands or open files independently. The stop condition must be provable from Claude's own output. Bad conditions: "do your best", "looks clean", "improve the code". Good conditions: "npm test exits 0", "git status is clean", "every call site compiles with no errors".

**Always add a limit on non-trivial goals** — without one, an unachievable goal runs forever.
```
/goal fix checkout tests, or stop after 10 turns
/goal complete the migration, or stop after 30 minutes
```

**Fully unsupervised mode** — `/goal` removes per-turn prompts; Auto mode removes per-tool prompts. Together = Claude works completely unattended until condition met or limit hit.

## /loop

Runs Claude on a time interval — not until a condition, but on a cadence.

- `/goal` says "keep going until this is true"
- `/loop` says "keep going every N minutes until I stop you"
- Requires an **open session** — stops if you close Claude Code
- Best for: iterative refactors with review between passes, backlog burndown one item at a time, polling external state

## /schedule

Kicks off Claude on a fixed cadence **independent of any open session**. Runs whether or not Claude Code is open.

- `/goal` and `/loop` require an open session — if you close Claude Code, they stop
- `/schedule` runs completely independently on its own cadence, forever or until cancelled
- Use cases: nightly test runs posted to Slack, morning issue triage, weekly dead-code scan, daily standup prep
- This is how you turn Claude Code into **infrastructure**, not just a tool

**Key distinction: /loop vs /schedule**
- `/loop` = runs within an open session, interval-based
- `/schedule` = runs WITHOUT an open session (cron-style), Claude as infrastructure

## Stop Hooks

Programmatic, scriptable control over exactly when Claude is allowed to finish a turn. `/goal` uses a Stop hook under the hood (session-scoped, prompt-based). Custom Stop hooks give complete control.

### Script-based Stop hooks

Shell script as stop condition:
- `exit 0` → Claude may stop
- non-zero exit → Claude keeps going

Run actual test suite, hit a CI endpoint, check a file exists, query a database — any deterministic check. Most powerful pattern: Claude works, tests run, if tests fail Claude reads the output and retries. No human in loop.

### Prompt-based Stop hooks

A model evaluates a natural-language condition against the transcript — identical to how `/goal` works. Difference: Stop hooks live in the settings file and apply to **every session** in scope. `/goal` is session-only and disposable.

### When to use which

| Situation | Tool |
|-----------|------|
| One-off condition for this session | `/goal` |
| Same evaluation logic on every session | Stop hook (prompt-based, in settings file) |
| Deterministic checks a model can't evaluate from transcript | Stop hook (script-based) |
| Runs without open session | `/schedule` |
| Interval-based within open session | `/loop` |
| Fully unattended | `/goal` + Auto mode |

### Power combination

`/goal` + Auto mode + script-based Stop hook running your test suite = Claude works autonomously, tests run after every turn, green build = stop, failing tests = Claude reads output and retries. You come back to a green build or a clear explanation.

## A distinção semântica entre /goal, /loop, e /schedule

Os três comandos têm o mesmo efeito superficial — Claude continua trabalhando sem intervenção manual — mas com modelos mentais diferentes:

- **/goal** é orientado a resultado: "pare quando este estado for verdadeiro." O agente tem autonomia total sobre quantas iterações são necessárias. O risco é uma meta inalcançável sem limite explícito.
- **/loop** é orientado a cadência: "execute este processo a cada N minutos, independentemente do resultado." O agente não decide quando parar — o usuário para explicitamente. Útil para polling e workflows incrementais onde cada execução é um progresso parcial legítimo.
- **/schedule** é orientado a infraestrutura: "este processo existe independentemente de mim estar presente." A diferença com /loop é que /schedule sobrevive ao fechamento do Claude Code — é o mecanismo para transformar tarefas recorrentes em processos de background permanentes.

A distinção /loop vs /schedule é a mais importante na prática: equipes que usam /loop para workflows diários descobrem que ele para quando alguém fecha acidentalmente o terminal. /schedule resolve isso ao ser independente de sessão ativa.

## Stop hooks como mecanismo de qualidade gate

A diferença entre Stop hooks baseados em prompt e Stop hooks baseados em script é uma diferença de paradigma de verificação:

**Prompt-based Stop hook:** um modelo avalia uma condição natural-language contra o transcript. Permite verificar coisas que só o modelo consegue avaliar — qualidade de raciocínio, completude conceptual, coerência da resposta. A limitação é que o avaliador trabalha com o que o Claude escreveu no transcript, não com o estado do sistema.

**Script-based Stop hook:** código determinístico verifica o estado real. `npm test`, `git status`, verificação de arquivo, query de banco. Zero ambiguidade: pass é pass, fail é fail. A limitação é que requer que a condição de sucesso seja codificável — não serve para verificar qualidade subjetiva.

Para workflows de coding, o padrão de ouro é script-based com a test suite real: o agente trabalha, os testes rodam, resultado determina continuação. Isso fecha o loop entre intenção (o prompt) e realidade (o código que funciona ou não) sem depender do transcript como proxy.

## /schedule como infraestrutura de vault

Para o vault-michel, /schedule é o mecanismo para operacionalizar workflows como `ingest-report` (síntese semanal de Clippings), daily note generation, e manifests de verificação. A diferença entre "eu sei que essa tarefa deve acontecer toda semana" e "essa tarefa acontece toda semana independentemente de eu lembrar" é exatamente o que /schedule provê.

Combinado com Stop hooks baseados em script que verificam que os artefatos foram criados corretamente (arquivo existe, wikilinks válidos, hot.md atualizado), /schedule transforma operações manuais recorrentes em processos auditáveis de background.

## Related

- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/claude-code-tooling/cowork-scheduled-automations]]
