---
title: Regulated Domain Agents
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags: [regulated-ai, agents, compliance, fintech, legal, healthcare, concept]
---

# Regulated Domain Agents

AI agents operating in domains subject to regulatory oversight (financial services, healthcare, legal, insurance) where outputs may have legal, fiduciary, or compliance consequences.

## Core Constraints vs. General Agents

| Property | General Agent | Regulated Domain Agent |
|----------|--------------|----------------------|
| Output approval | Optional | Mandatory before action |
| Audit trail | Nice-to-have | Required (full tool call log) |
| Data access | Open/broad | Governed connectors only |
| Credential handling | Inline | Managed vault, isolated |
| Error consequence | Recoverable | May be irreversible (filed, sent, traded) |

## Design Principles

1. **Human-in-the-loop as hard gate** — not advisory, but blocking. No output goes to a client, gets filed, or is acted on without explicit approval.
2. **Governed data access** — connectors enforce access controls; agents cannot reach data sources outside provisioned scope.
3. **Immutable audit log** — every tool call and decision recorded; accessible to compliance and engineering teams independently of the agent.
4. **Per-tool permissions** — principle of least privilege at the tool level, not just session level.
5. **Credential isolation** — managed vaults keep credentials out of agent sandboxes.

## Domain Examples

- **Financial services:** KYC, pitchbooks, model building, GL reconciliation — see [[03-RESOURCES/concepts/agent-systems/financial-services-agents]]
- **Insurance:** underwriting, claims analysis (Verisk connector pattern)
- **Legal/compliance:** document review, regulatory filing preparation

## Anthropic Implementation (2026)

[[03-RESOURCES/entities/Claude-Managed-Agents]] implements these patterns as infrastructure: long-running sessions with audit logs in Claude Console, per-tool permissions, credential vaults, and human approval flows. Described in [[03-RESOURCES/sources/financial-trading/agents-for-financial-services]].

## Related

- [[03-RESOURCES/concepts/agent-systems/financial-services-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/entities/Claude-Managed-Agents]]
- [[03-RESOURCES/entities/Claude-Cowork]]
