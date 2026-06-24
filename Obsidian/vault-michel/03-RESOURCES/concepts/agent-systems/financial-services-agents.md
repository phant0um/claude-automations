---
title: Financial Services Agents
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags: [financial-services, agents, anthropic, fintech, regulated-ai, concept]
---

# Financial Services Agents

AI agents purpose-built for financial industry workflows — front office (research, client coverage), middle office (underwriting, risk, compliance), and back office (reconciliation, operations, code modernization).

## What Makes Finance a Distinct Agent Domain

- **High-stakes outputs** require human-in-the-loop approval before client delivery or regulatory filing
- **Regulated data access** demands governed connectors with audit trails, not open API calls
- **Domain conventions** — modeling standards, risk policies, approval flows — must be baked into agent skills, not discovered at runtime
- **Multi-system orchestration** across ERP, data vendors (FactSet, Bloomberg, Moody's), and Microsoft 365

## Anthropic's Architecture (2026)

Each agent template = **Skills + Connectors + Subagents** (see [[03-RESOURCES/sources/financial-trading/agents-for-financial-services]]):
- Skills: domain knowledge and instructions for the task
- Connectors: governed real-time data access
- Subagents: specialist models for sub-tasks (comparables, methodology checks)

Two deployment modes: desktop plugin (analyst-assisted) or [[03-RESOURCES/entities/Claude-Managed-Agents|Managed Agent]] (autonomous, nightly/batch).

## Key Use Cases

- Pitchbook creation (Pitch Builder)
- KYC file assembly and compliance escalation (KYC Screener)
- Month-end close and GL reconciliation
- Earnings review, financial model building
- Valuation review against firm standards

## Compliance Patterns

- Full audit log of every tool call (Claude Console)
- Per-tool permissions + managed credential vaults
- Human approval gate before client-facing or filed output
- Connectors enforce governed access (not raw API)

## Benchmark

Vals AI Finance Agent benchmark (2026): Claude Opus 4.7 leads at 64.37%.

## Related

- [[03-RESOURCES/concepts/agent-systems/regulated-domain-agents]]
- [[03-RESOURCES/entities/Claude-Cowork]]
- [[03-RESOURCES/entities/Claude-Managed-Agents]]
- [[03-RESOURCES/sources/financial-trading/agents-for-financial-services]]
