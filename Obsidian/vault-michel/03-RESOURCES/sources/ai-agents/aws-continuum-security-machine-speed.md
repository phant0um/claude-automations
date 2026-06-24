---
title: "Introducing AWS Continuum: Security at Machine Speed"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - ai-agents
  - security
  - aws
  - vulnerability-management
  - automated-remediation
  - source
---

# Introducing AWS Continuum: Security at Machine Speed

**Source:** [AWS Security Blog](https://aws.amazon.com/pt/blogs/security/introducing-aws-continuum-security-at-machine-speed/) · Published 2026-06-17
**Author:** Chet Kapoor

## Central Thesis

The operating model that served enterprise security for the past decade — collect telemetry, store it, query it, build dashboards to watch it — is no longer keeping pace. The shift needed: from **telemetry** to **telemetry + context + reasoning + actions** — an approach that produces outcomes. Frontier cybersecurity models (like Claude Mythos) can now find vulnerabilities and reason through complex attack paths at machine speed, creating an exponentially increasing backlog. AWS Continuum addresses the full lifecycle of a code vulnerability at machine speed: from discovery through actions.

## Key Arguments

### What Has Changed

- Frontier models can now find software vulnerabilities and reason through complex attack paths at **machine speed**
- This creates an exponentially increasing backlog of vulnerabilities
- The old "collect → store → query → dashboard" model cannot keep pace
- Security teams need tools that **earn trust and take action**, not just report

### AWS Continuum for Code Vulnerabilities

Now available in gated preview. Model-agnostic — uses multiple frontier models where each performs best, built to incorporate the latest and most capable models as they emerge.

Built on lessons learned from running security across AWS and Amazon.com — businesses in different industries required a system that understands **business context** rather than applying generic rules uniformly.

### How It Works — Four Continuous Phases

#### 1. Discovery
- Ingests existing vulnerability backlog
- Performs its own vulnerability scan of your environment
- Creates a comprehensive view of vulnerabilities and associated attack paths

#### 2. Prioritization
- Uses context to evaluate, enrich, and prioritize every finding
- Questions answered: Is the component deployed? Is it reachable? Is it in a production path? What would the business impact be if exploited?
- Result: evidence-backed list of priorities

#### 3. Validation
- Validates findings to surface false positives before wasting team's time
- Contextualizes vulnerabilities against your environment
- Constructs working exploit examples in a **sandboxed environment** — concrete, reproducible evidence of the issue

#### 4. Mitigation and Remediation
- Assesses existing defenses (blocking/compensating controls + detection mechanisms)
- Draws on understanding of codebase, context, and findings to recommend mitigation or remediation:
  - Network change
  - Policy change
  - Code patch
- Patch recommendation validated using the same system that confirmed the vulnerability
- Provides **blast radius visibility** and **rollback paths** where feasible

### Trust Is Graduated

- Starts in **learn mode** with a human in the loop
- Every recommendation includes the reasoning behind it
- As confidence grows, can graduate to **enforce mode** — enabling remediation that can be increasingly automated based on categories and risk profiles you define

### Continuum Capabilities (Beyond Code Vulnerabilities)

- **Continuum pen testing** and **Continuum code scanning** (Preview) — formerly AWS Security Agent
- **Continuum threat modeling** (Preview) — automatically generates comprehensive threat models from design documents or source code, outputs in STRIDE format
- These serve as detection and analysis sources feeding into the broader Continuum loop of discovery → prioritization → validation → remediation

### Starting Point

Starting with code (1st and 3rd party), then expanding to other aspects of security.

Working with customers across financial services, automotive, and technology.

## Key Insights

1. **Telemetry → Actions**: The shift from passive observation (dashboards) to active intervention (automated remediation) mirrors the shift from "prompting" to "loop engineering" in development — both move from human-in-the-loop-at-every-step to human-setting-policy-and-system-executing

2. **Graduated trust as a design pattern**: Learn mode → enforce mode is a trust calibration system. This is the same pattern described in [[03-RESOURCES/sources/ai-agents/foundation-engineering]] as "校准回路" (calibration loop) — the system must earn trust through validated predictions before being given autonomy

3. **Model-agnostic architecture**: Using multiple frontier models where each performs best is the "model chaining" concept from [[03-RESOURCES/sources/ai-agents/glm-52-open-source-ai-setup]] applied to security

4. **Sandboxed validation**: Constructing working exploits in a sandbox to validate findings is the "maker/checker separation" principle from [[03-RESOURCES/sources/ai-agents/loop-engineering-delegating-judgment-not-code]] — the system that finds the vulnerability is not the same system that confirms it's real

5. **Business context over generic rules**: The recognition that security must understand business context rather than apply generic rules uniformly is the security equivalent of dashen.wang's thesis that "what counts as correct" must be defined per-project, not generically