---
title: "Agent Governance"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems, governance, safety]
status: developing
---

# Agent Governance

The policies, authorization levels, and oversight mechanisms that determine when an autonomous agent may act and when it must pause for human confirmation.

## O que é / What it is

Agent governance answers: **who authorized this action, to what scope, and who audits it?** It moves agent deployment from "trust by default" to "trust by design" — embedding accountability into the agent's architecture rather than bolting it on afterward.

## Como funciona

**Authorization levels (typical tiers):**
1. **Read-only** — agent may observe but not modify
2. **Draft** — agent may propose changes; human confirms before apply
3. **Auto-commit (reversible)** — agent may execute reversible actions autonomously
4. **Auto-commit (irreversible)** — requires explicit elevated authorization + audit log

**Audit trails:** Every tool call logged with timestamp, parameters, result. Enables post-hoc review and rollback.

## Padrões / Patterns

- **The Bike Method (gradual autonomy):** Start with full human oversight; remove checkpoints one at a time as trust is established. Never jump to full autonomy cold.
- **Blast-radius budgeting:** Before each run, estimate max damage if agent misbehaves. If blast radius is unacceptable, add a confirmation gate.
- **Confirmation heuristics:** Confirm when (a) action is irreversible, (b) intent is ambiguous, (c) action affects >N files, (d) external side-effect (send email, push to remote).
- **Trust tiers by agent role:** Read-only agents (search, summarize) get broader tool access; write agents (edit files, run code) operate under stricter scope.

## Por que importa

The vault CLAUDE.md encodes a governance model explicitly: destructive ops and visible-outside-vault actions require confirmation. Formalizing this as governance lets Michel reason about where to tighten or relax controls as the agent system matures.

## Evidências
- **[2026-06-19]** "Rails" de permissão opt-in por categoria de acesso (escrita em banco, leitura em banco, egress de rede, acesso a PII) propostos como mecanismo para acelerar iteração sem perder controle de risco em código gerado por agente — [[03-RESOURCES/sources/fable-class-models-as-code-interpreters]]
- **[2026-06-24]** According to Gartner, the average Global Fortune 500 enterprise will have over 150,000 AI agents in  — [[aws-genaiic-partner-agent-factory-new-ai-agents-now-in-aws-marketplace]]
- [[03-RESOURCES/sources/who-holds-ai-s-off-switch]] — Commerce Department forced Anthropic to disable Fable 5; AI sovereignty como risco P0 para boards

## Related
- [[03-RESOURCES/concepts/agent-security]]
- [[03-RESOURCES/concepts/human-in-the-loop]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/agentic-execution]]
- [[03-RESOURCES/concepts/ai-agents]]
- **[2026-06-24]** Agent Memory evoluiu de 'guardar chat' para uma arquitetura de 5 camadas: regras (constituição),画像 (常驻), histórico... — [[agent-memory-architecture-panorama]]
