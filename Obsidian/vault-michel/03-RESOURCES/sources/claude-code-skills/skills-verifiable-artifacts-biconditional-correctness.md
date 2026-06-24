---
title: "Skills as Verifiable Artifacts: Trust Schema and Biconditional Correctness for HITL Agent Runtimes"
type: source
source_type: clipping
source_file: "Clippings/Skills as Verifiable Artifacts A Trust Schema and a Biconditional Correctness Criterion for Human-in-the-Loop Agent Runtimes.md"
source_url: "https://arxiv.org/html/2605.00424v1"
author: "Alfredo Metere (Metere Consulting, LLC)"
created: 2026-05-14
tags: [skill-trust, hitl, skill-verification, supply-chain, biconditional, agent-security, skill-manifest, audit-log, enclawed]
triagem_score: 9
---

# Skills as Verifiable Artifacts

**Author:** Alfredo Metere — Metere Consulting, LLC  
**Reference implementation:** [enclawed](https://github.com/metereconsulting/enclawed)

## Central Thesis

> A skill is *untrusted code* until it is verified. The runtime that loads it must enforce that default rather than infer trust from a signature, a clearance, or a registry of origin.

Without skill verification, a HITL gate must fire on every irreversible call — which degrades into rubber-stamping at scale. Skill verification allows HITL to fire only for unverified actions, making the system sustainable.

## Skill Trust Schema

A skill artifact is a tuple: `Skill = (M, content, σ)` where M is a manifest, content is the SKILL.md + scripts, and σ is an Ed25519 detached signature.

### Manifest Mandatory Fields

| Field | Purpose |
|---|---|
| `M.label` | Bell-LaPadula classification label (rank, compartment, releasability) |
| `M.caps` | Declared capability set (finite vocabulary) |
| `M.signer` | Key identifier in trust root |
| `M.version` | Monotone integer (replay protection) |
| `M.verification` | Verification level |

### Four Verification Levels

| Level | Meaning | HITL policy |
|---|---|---|
| **unverified** (default) | No behavioral claim | Every irreversible call → HITL |
| **declared** | Signer attests caps bounded by M.caps | HITL only for calls outside M.caps |
| **tested** | Passes adversarial-ensemble verification (biconditional check) | No per-call HITL for M.caps; per-session biconditional check |
| **formal** | Machine-checkable proof | Same as tested; trust is offline |

**Key rule:** Verification is set at bootstrap. It can never be elevated during a session. A signature + clearance ≠ trusted.

## Capability Gate

### Capability Vocabulary (minimal)

| Capability | Side-effect class |
|---|---|
| `fs.write.rev(path)` | Write that can be rolled back |
| `fs.write.irrev(path)` | Delete, overwrite, truncate |
| `net.egress(host)` | DNS-resolved network reach |
| `pay(token, amount)` | Transfer of fungible value |
| `publish(channel)` | Post to external channel |
| `spawn.proc(cmd)` | External process spawn |

**Load-bearing distinction:** reversible vs. irreversible. Reversible calls use a transaction buffer with rollback. Irreversible calls walk the four-state HITL lifecycle.

### HITL Lifecycle (for irreversible calls)

1. **request** — agent emits tool-call; audit record appended
2. **decide** — broker (human/policy/webhook) returns approve/deny
3. **execute** — if approved, side-effect performed; audit record appended
4. **audit** — all records linked by shared request-id

## Biconditional Correctness Criterion

**Definition:** Audit log L passes the biconditional iff:  
`multiset(D) = multiset(S)`  
where D = observed corpus delta, S = set of approved-and-executed records in L.

### Failure Modes Detected

- **F1 Gate bypass** — side-effect with no request/decision pair
- **F2 Audit forgery** — approved record with no matching corpus change
- **F3 Silent host failure** — approved+executed but host call silently failed
- **F4 Wrong-target execution** — approved against t1 but landed on t2

### Failure Modes NOT Detected

- Read-only exfiltration (requires DLP/egress-aware gate)
- TOCTOU races (external mutation between snapshot and action)
- Overlapping malicious effect on same target as legitimate approval

## 12 Normative Guidelines (G1–G12)

1. Capability bootstrap — lock trust root before reading any external input
2. Deny-by-default at every boundary
3. Mandatory classification — every artifact must carry a label
4. Clearance-bounded signing — signers cannot sign above their clearance
5. Hash-chained audit at gate-event granularity
6. Reversible/irreversible split with HITL for irreversible
7. Biconditional post-hoc verification as runnable check
8. Adversarial test corpus in CI covering F1–F4 + 8 attack families
9. Named configuration profiles (strict vs. dev, no feature-flag continuum)
10. **No bypass switch** — no env var or API to disable HITL, audit, egress, or trust root
11. Skills untrusted by default — signature ≠ trust
12. Verification is bootstrap-only; skills immutable in-session; mutation attempts audited

## Reference Implementation: enclawed

Hard-forks a single-user AI assistant gateway with: Bell-LaPadula scheme, Ed25519 signed-module loader, hash-chained audit log, egress guard, regex DLP scanner, HITL controller with checkpointable session state machine, transaction buffer with rollback.

## Connections

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — SKILL.md as the artifact this paper secures
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — broader skills ecosystem
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — the runtime that must enforce the schema
- [[03-RESOURCES/sources/ai-agents-harness/heavyskill-heavy-thinking-agentic-harness]] — companion paper on skill capability
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — HITL governance in orchestration
