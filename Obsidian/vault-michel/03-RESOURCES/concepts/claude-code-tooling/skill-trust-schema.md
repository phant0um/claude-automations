---
title: Skill Trust Schema
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [skill-security, hitl, trust-schema, supply-chain, biconditional, agent-security, skill-verification, enclawed]
---

# Skill Trust Schema

## Core Problem

Skills (SKILL.md files) are **untrusted code** until verified. A signature on a skill's manifest proves a signer endorsed the artifact — it proves nothing about whether the artifact's behavior matches its manifest claims. Current harnesses collapse the distinction: signature + clearance = trust. This is wrong.

> "Treating a signed-and-cleared skill as trusted is no more defensible than treating a code-signed Windows executable as malware-free because Microsoft signed it."

## The Four Verification Levels

| Level | What it means | HITL behavior |
|---|---|---|
| **unverified** (default) | No behavioral claim | Every irreversible call → HITL |
| **declared** | Signer attests caps ⊆ M.caps | HITL only outside declared caps |
| **tested** | Passes adversarial-ensemble; biconditional verified | No per-call HITL for declared caps; biconditional checked per session |
| **formal** | Machine-checkable proof of behavior bounds | Same as tested; proof is offline artifact |

**Critical constraint:** Verification is set at bootstrap and immutable for the session. A skill's verification level cannot be elevated by the agent at runtime.

## Biconditional Correctness Criterion

For any audit log L of an agent run:

```
D = observed corpus delta (start state → end state)
S = set of approved-and-executed records in L
```

**Biconditional passes iff:** `multiset(D) = multiset(S)`

Every corpus change is explained by an approved+executed record, AND every approved+executed record corresponds to a matching corpus change. Either direction broken = fail.

### What This Catches

- Gate bypass (side-effect with no request/decision pair)
- Audit forgery (approved record with no corpus change)
- Silent host failures (approved+executed but host silently failed)
- Wrong-target execution (approved for t1, landed on t2)

## Immutability Rule

Once a skill is loaded, its content and manifest are **immutable** for the session. Any agent attempt to modify a skill:
- Intercepted as an irreversible capability call
- Walked through HITL
- Written to hash-chained audit log regardless of approval/denial
- If approved: produces a *new* skill artifact that must be re-verified before next session

## HITL as Sustainable Pattern

Without verification: HITL on every irreversible call → operator rubber-stamping at scale → security theater.

With verification: HITL fires only for unverified calls → tractable, meaningful human oversight.

Verification is the path from operationally untenable HITL to sustainable HITL.

## Reference Implementation

**enclawed** — open-source hardened AI assistant gateway implementing:
- Bell-LaPadula classification scheme
- Ed25519 signed-module loader with clearance-bounded trust root
- Hash-chained audit log
- Egress guard + regex DLP scanner
- HITL controller with checkpointable session state machine
- Transaction buffer with rollback

## Normative Guidelines (summary)

G1: Lock trust root before any external input  
G2: Deny-by-default at every boundary  
G10: **No bypass switch** — no way to disable HITL, audit, or trust root  
G11: Skills untrusted by default — signature ≠ trust  
G12: Verification bootstrap-only; skills immutable in-session; mutation attempts audited

## Lacuna: Fase Pré-Carregamento

> [!warning]
> O trust schema atual cobre verificação pós-carregamento (signature, biconditional, HITL). Saha et al. (arXiv 2605.11418) demonstram que ataques de **discovery** e **selection** operam antes do carregamento: SKILL.md manipulado influencia qual skill é rankeada e escolhida, independentemente de verificação comportamental posterior. O trust schema precisa ser extendido para cobrir a fase de roteamento.

Ver [[03-RESOURCES/sources/ml-research-papers/skill-md-semantic-supply-chain-attacks]] para defesas concretas (full-file review, evidence-based selection, anti-assertive-cue filtering).

## Sources

- [[03-RESOURCES/sources/claude-code-skills/skills-verifiable-artifacts-biconditional-correctness]] — Alfredo Metere (arXiv 2605.00424)
- [[03-RESOURCES/sources/ml-research-papers/skill-md-semantic-supply-chain-attacks]] — Saha, Faghih, Feizi (arXiv 2605.11418)

## Related Concepts

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — SKILL.md as the artifact being secured
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — broader skill ecosystem
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — the runtime enforcing the schema
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — HITL governance in orchestration contexts
