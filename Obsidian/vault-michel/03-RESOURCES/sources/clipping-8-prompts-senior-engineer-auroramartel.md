---
title: "8 Prompts: Stop Treating Claude Like a Junior Intern"
type: source
source_type: social-media
platform: Thread Reader App
url: "https://threadreaderapp.com/thread/2050827278612103361.html"
author: "@AuroraMar1eL (Aurora Martel)"
created: 2026-05-05
updated: 2026-05-05
hash: 20424dc773bc95f87bfa89980eaadc9f
tags: [prompt-engineering, role-prompting, claude, coding-workflow, multi-agent]
---

# 8 Prompts: Stop Treating Claude Like a Junior Intern

Thread by [[03-RESOURCES/entities/Aurora-Martel]] (@AuroraMar1eL) on Thread Reader App. Central claim: framing Claude as a **senior engineer with a defined role** yields production-ready output, replacing the "do this / fix this" imperative style.

## Core Thesis

> "You're actually treating a senior AI like a junior intern."

Give Claude an expert identity + explicit deliverables instead of imperative commands. This is a direct application of [[03-RESOURCES/concepts/prompt-engineering-patterns#role-assignment|Role Assignment]] (Pattern #11).

## The 8 Prompts

| # | Title | Role Assigned | Key Deliverable |
|---|-------|---------------|-----------------|
| 1 | Complete App from Scratch | Senior full-stack engineer | Architecture + DB schema + API + UI + code |
| 2 | Codebase Understanding & Refactoring | Senior engineer new to codebase | Problem areas + refactoring strategies + improved code |
| 3 | Senior Debugging Engineer | Senior debugging engineer (production) | Root cause + edge cases + fixed code |
| 4 | System Design + Implementation | Senior systems architect | Architecture + data flow + caching + implementation |
| 5 | Performance Optimization | Performance engineer | Bottlenecks + optimization strategies + improved code |
| 6 | Clean Architecture Rebuild | Senior engineer (clean arch) | New folder structure + refactored code |
| 7 | Multi-Agent Workflow | 4 agents: Architect / Engineer / Reviewer / Optimizer | Architecture → implementation → review → optimized final |
| 8 | Production-level UI Component Builder | Senior frontend engineer | Reusable, accessible, responsive components + usage examples |

## Prompt 7 — Multi-Agent Pattern

The most technically significant: instructs Claude to embody **four collaborating agents in one context**, each with a distinct phase:
- **Architect** → Design
- **Engineer** → Build
- **Reviewer** → Quality control
- **Optimizer** → Performance improvement

This is a lightweight form of [[03-RESOURCES/concepts/multi-agent-orchestration|multi-agent orchestration]] executed within a single prompt session.

## Supplementary Threads (same author, same page)

- **9 daily productivity prompts** — weekly reflection, content ideation
- **12 financial model prompts** — DCF, three-statement model (Goldman Sachs / Morgan Stanley personas)
- **12 dividend portfolio prompts** — Berkshire/Vanguard personas; dividend safety scoring
- **11 resume/LinkedIn prompts** — Google recruiter 6-second rewrite, ATS optimizer
- **9 NotebookLM prompts** — PDF-to-lesson pedagogy

## Key Technique

All 8 prompts share the same structural pattern:

```
Think like a [expert role] [doing X].
[Specific analysis steps]
Result: [explicit list of deliverables]
```

This maps directly to [[03-RESOURCES/concepts/prompt-engineering-patterns]] Pattern #11 (Role Assignment).

## Related

- [[03-RESOURCES/concepts/prompt-engineering-patterns]] — Pattern #11 (Role Assignment), Pattern #12 (Persona Training)
- [[03-RESOURCES/concepts/prompt-engineering]] — core principles; Role field
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — Prompt #7 single-session multi-agent pattern
- [[03-RESOURCES/entities/Aurora-Martel]] — author
