---
title: "Coding Agents"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, software-engineering, coding]
status: developing
---

# Coding Agents

LLMs equipped with file system access, terminal execution, and test runners that can write, edit, debug, and ship code autonomously.

## O que é / What it is

A coding agent is an [[03-RESOURCES/concepts/ai-agents|AI agent]] specialized for software tasks. It differs from autocomplete or chat-based code assist because it **runs code, observes results, and iterates** — closing the read-plan-act loop inside a software environment.

Major examples: **Claude Code** (Anthropic), **Codex** (OpenAI, deprecated), **Devin** (Cognition), **SWE-agent** (Princeton), **Honk** (Spotify — background coding agent, 1,500+ merged PRs in production).

## Como funciona

The agent receives a task (bug fix, feature, refactor) and:
1. Reads relevant files and understands the codebase structure.
2. Plans a sequence of edits.
3. Applies edits using file-write tools.
4. Runs tests or linters to verify.
5. Iterates until tests pass or escalates to human.

**Benchmark: SWE-bench** — 2,294 real GitHub issues from 12 popular Python repos. State-of-the-art (2026): ~50–65% resolve rate on verified subset.

## Padrões / Patterns

- **Trust levels:** Read-only exploration → draft edits → auto-commit. Escalate trust incrementally.
- **Test-first coding:** Generate tests before implementation; use them as the agent's objective function. See [[03-RESOURCES/concepts/verification-driven-development]].
- **Code review integration:** Coding agent opens PR → review agent (or human) checks → merge gate.
- **Backpressure Loop:** Feedback (type checker, tests, linter, build, browser checks, traces) reaches the agent **before** it reaches the human. Loop: `agent changes → system pushes back → agent repairs → retry`. CI failure after the agent finishes = gate; failure the agent sees while working = backpressure. Layer fast checks in-session, slower checks pre-PR. See [[03-RESOURCES/sources/backpressure-loop-coding-agents]].
- **Sandboxing:** Execute generated code in isolated container; never run untrusted code on host. See [[03-RESOURCES/concepts/agent-security]].

## Produção em escala — Spotify Honk

Spotify's **Honk** agent (2025) integrou-se ao Fleet Management existente, substituindo apenas a etapa de transformação de código determinística por um agente LLM orientado por prompt. Resultado: 1,500+ PRs mergeados, 60–90% de saving de tempo em migrations complexas (Java Records, Scio upgrade, Backstage frontend). Lição principal: o harness pré-existente é o que torna o coding agent viável em escala — o modelo é intercambiável.

Ver [[03-RESOURCES/sources/spotify-honk-part1-background-coding-agents]].

## Por que importa

Claude Code is Michel's primary productivity tool. Understanding coding agent architecture — trust tiers, sandbox requirements, SWE-bench limitations — informs how to design reliable agent workflows and avoid dangerous autonomy patterns.

## Related
- [[03-RESOURCES/concepts/ai-agents]]
- [[03-RESOURCES/concepts/agentic-execution]]
- [[03-RESOURCES/concepts/agent-security]]
- [[03-RESOURCES/concepts/verification-driven-development]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/human-in-the-loop]]

## Evidências

- **[2026-06-21]** Análise da Anthropic de ~400.000 sessões de Claude Code (out/2025-abr/2026, ~235.000 pessoas) mostra divisão de trabalho estável: humanos decidem o quê fazer (planejamento), Claude decide como fazer (execução). Quanto mais expertise de d... — [[agentic-coding-and-persistent-returns-to-expertise]]
- **[2026-06-21]** Teste informal mas bem desenhado (Kilo Code DevRel): React/TS to-do app com 10 bugs plantados, 8 modelos revisando o mesmo working tree não commitado em worktrees isolados via Kilo Agent Manager. Grok Build 0.1 encontrou todos os 10 bugs... — [[grok-build-0-1-beat-every-frontier-model-in-a-kilo-code-reviews-test]]
