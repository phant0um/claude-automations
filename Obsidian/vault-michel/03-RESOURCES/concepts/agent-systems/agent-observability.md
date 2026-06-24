---
title: "Agent Observability"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Agent Observability

Making agent internals visible — what tools were called, what state changed, and why things failed.

## O que é / What it is

Observability for agents extends classic software observability (logs, metrics, traces) to LLM-native primitives: tool calls, prompt inputs/outputs, reasoning spans, and token costs. Without it, a failing agent is a black box.

Three pillars:
- **Logs** — structured records of every tool call, input, and output
- **Metrics** — latency per step, token cost, success rate, retry count
- **Traces** — causal span tree: which agent called which tool, in what order, with what result

## Como funciona

**Trace spans:** Each agent turn opens a root span. Each tool call becomes a child span. Multi-agent runs produce a tree — orchestrator span with worker sub-spans. OpenTelemetry (OTEL) is the standard exporter; backends: Langfuse, Arize, Honeycomb.

**Key metrics to instrument:**

| Metric | Why |
|--------|-----|
| Tool call latency | Identifies slow external deps |
| Token cost per run | Budget control |
| Tool call success rate | Detects flaky tools |
| Retries / fallbacks triggered | Measures brittleness |
| End-to-end success rate | Overall health |

**State change logging:** Agents that read/write files or memory should log before/after diffs, not just "wrote file X."

**Debugging pattern:** Start from the leaf span (where failure occurred), inspect the input that caused it, trace back up the call tree. 90% of failures are bad inputs or missing tool permissions — not model reasoning errors.

## Por que importa

Without observability you cannot attribute cost to specific agent patterns, reproduce intermittent failures, or prove an improvement actually improved anything. OpenTelemetry + structured logs is the minimum viable setup. Claude Code `--debug` flag surfaces tool call logs inline.

## Paradigma: Harness-Observed vs Result-Binary

> "Stop asking whether the agent worked. Ask what the harness observed." — 2026-06-06

Avaliação binária (completou? sim/não) esconde 90% da informação útil. Um agente que "completou" por acidente é tão problemático quanto um que falhou. O harness precisa registrar rastro de percepção + decisão + ação.

O que registrar além dos logs clássicos:

| Tipo | O que registrar |
|------|----------------|
| **Perception** | Qual contexto o agente recebeu? Quais arquivos foram lidos? |
| **Decision rationale** | Por que chamou *este* tool com *estes* params? |
| **State delta** | Git diff ou manifest diff pós-execução |
| **Anomalias** | Loops, retries, params fora do esperado |

## Padrão de Verificação Adversarial em 2 Níveis

Documentado em "Feedback loops" + "A harness for every task":

- **Nível 1 — Inline:** agente verifica próprio output antes de continuar ("se eu mudar X, Y ainda funciona?")
- **Nível 2 — Pré-merge:** segundo agente independente revisa o diff — perspectiva fresh sem contexto acumulado do primeiro

## omarsar0 Pattern — Dashboard de Monitoramento

Primeiro caso documentado de Dynamic Workflows fora do Claude Code: omarsar0 (Elvis Saravia / DAIR.AI) reverse-engineered DW e construiu monitoring dashboard como HTML artifact gerado pelo próprio agente. Evidencia portabilidade do padrão. Ver [[03-RESOURCES/sources/thread-by-omarsar0-on-thread-reader-app]] e [[03-RESOURCES/entities/omarsar0]].

## Vault Michel — Gap Atual

Pipeline diário: logging mínimo (triagem report + hot.md summary). Gap: não registra o que cada subagent *viu* — apenas o que criou. Melhoria: implementar log de tool calls por batch em próxima versão do pipeline.

## Webhooks como camada de notificação event-driven (Managed Agents, jun/2026)

Documentação oficial mostra um padrão complementar à SSE event stream: **webhooks "magros"** que carregam só `type`+`id` e forçam o receptor a buscar o objeto via `GET` (evita stale data em retries, mantém entregas pequenas). 8 tipos de evento de sessão (`session.status_*`, `session.thread_*`, `session.outcome_evaluation_ended`); ordenação não garantida (usar `created_at`); auto-disable após ~20 falhas consecutivas, com proteção SSRF embutida (disable imediato se hostname resolve para IP privado). Ver [[03-RESOURCES/sources/subscribe-to-webhooks]] e [[03-RESOURCES/sources/reference]] (event types `user.*` complementares).

## Related
- [[03-RESOURCES/concepts/agent-systems/multi-agent-systems]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/ai-strategy-org/inference-optimization]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/observability-driven-evolution]]
- [[03-RESOURCES/sources/stop-asking-whether-the-agent-worked-ask-what-the-harness-observed]]
- [[03-RESOURCES/sources/feedback-loops-help-claude-code-complete-ambitious-tasks-with-less-babysitting]]
