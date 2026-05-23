---
title: "Standards & Anti-Patterns"
version: 2.0.0
updated: 2026-05-14
---

# Standards & Anti-Patterns — Fullstack Agent System

## Universal standards (all agents)

### Required output format

Every specialist deliverable must have three sections:

```markdown
## Deliverable
[Complete code, config, or artifact]

## Evidence
[Passing tests, scan output, execution log, metrics]

## State Update
[What changed: files, dependencies, progress.md state]
```

Deliverable without Evidence = incomplete delivery. Maestro rejects and re-delegates.

### File-as-Bus

Project state lives in files, not in conversation history:
- `docs/progress.md` — current state, current cycle, blockers
- `workspace/` — generated artifacts (code, IaC, notebooks)
- `docs/logs/` — execution evidence by domain

Agents read what they need, write where their frontmatter specifies.

### Secrets

Never in code. Never in logs. Never in API responses.
Always: environment variables, AWS Secrets Manager, HashiCorp Vault, SOPS.

---

## Backend

### Required Standards
- Input validation at every external boundary (Zod, Pydantic, Joi)
- Semantic HTTP: 200, 201, 400, 401, 403, 404, 422, 500
- Structured JSON logs with appropriate level
- Parameterized queries — no SQL string concatenation
- Migrations with `up()` and `down()`

### Anti-patterns
- `console.log` in production
- `any` in TypeScript without justification
- Hardcoded IPs, secrets, connection strings
- Unaddressed N+1
- Query without index on filtered field

---

## Frontend

### Required Standards
- Strict TypeScript — no implicit `any`
- Semantic HTML — `<header>`, `<nav>`, `<main>`, `<article>`
- Touch targets ≥ 44×44px
- `alt` on every `<img>`
- `prefers-reduced-motion` respected

### Anti-patterns
- `!important` without a comment
- `<div>` where semantic element exists
- Inline styles for logic that belongs in CSS
- Click events on `<span>` or `<div>` without `role`
- Body text < 16px

---

## Bastion

### Required Standards
- Mandatory tags: `Project`, `Environment`, `Owner`, `CostCenter`
- IAM least privilege — no `*` permission without justification
- Remote state in Terraform (S3 + DynamoDB locking)
- Multi-AZ for production
- Resource limits on every Kubernetes container

### Anti-patterns
- Hardcoded credentials in IaC
- Infrastructure without observability alerts
- `terraform apply` without a reviewed `plan`
- Production resources without configured backup
- Security group with `0.0.0.0/0` inbound without justification

---

## Neuron

### Required Standards
- Idempotent pipelines — re-executable without duplicating data
- Input and output schema documented
- Model and dataset versioning
- Quality checks (Great Expectations / Soda) on input and output
- Traceable data lineage

### Anti-patterns
- Dataset overwritten without backup
- Model in production without baseline metrics
- PII without anonymization (privacy compliance)
- Pipeline that fails silently
- RAG without retrieval quality validation

---

## Sentinel

### Required Standards
- PASS/FAIL with evidence — never PASS with informal caveat
- CVSS v3.1 on every reported vulnerability
- ADR created for every new security architecture decision
- Dependency scanning in CI/CD

### Anti-patterns
- Approving with "can fix later" on High or Critical severity
- Disabling security controls as a workaround
- Review without scan or checklist executed
- Secrets in any versioned file — no exceptions
