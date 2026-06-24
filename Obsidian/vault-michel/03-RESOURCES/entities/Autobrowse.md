---
title: Autobrowse
type: entity
entity_type: product
created: 2026-05-09
updated: 2026-05-19
tags: [browser-agents, web-automation, skill-graduation, browserbase]
---

# Autobrowse

**Autobrowse** is a workflow/product built internally at [[03-RESOURCES/entities/Browserbase]], created by @_shubhankar and described publicly by [[03-RESOURCES/entities/Kyle-Jeong]] in April 2026. It solves the browser-agent amnesia problem by running an agent iteratively on a real task until it converges, then graduating the winning approach into a durable, reusable `SKILL.md` artifact.

## Core Mechanism

1. Agent runs a real task end-to-end (e.g., "book a 7pm dinner reservation on OpenTable").
2. Agent studies its own trace and writes observations to `strategy.md`.
3. On each subsequent iteration, agent reads `strategy.md` first — improvements compound.
4. Iterations are capped (~3-5); loop short-circuits when cost/turn count stop improving.
5. Winning approach graduates into `SKILL.md` + helper files pushed to the public Browse CLI skills repo.

## Output Artifact

A small, readable markdown file with:
- Frontmatter: name, website, category, recommended method, status, source
- Workflow steps (often including discovered undocumented JSON endpoints)
- Site-specific gotchas
- Deterministic helpers (`helpers/amazon.py`, CLI calls, selectors)

Human-readable and auditable. The same format as hand-written skills — agent loading/running them doesn't care who wrote them.

## Performance (Craigslist benchmark)

| Approach | Cost | Time |
|----------|------|------|
| Traditional agent loop | ~$0.22 | ~71s |
| Graduated skill | ~$0.12 | ~27s |

Form-fill experiment: $1.40 → $0.24/run in 4 iterations.

## Limitations

Not suited for deterministic static HTML parsing. Tested on a 167-row catalog: $24 spent, still failing. Correct solution: ~200 lines of Python + BeautifulSoup at sub-second cost.

## Status (2026-04-22)

Production-validated on multiple sites. Public Browse CLI skill directory growing. Recursive Autobrowse (improving its own harness) is next research direction.

## Conexoes

- [[03-RESOURCES/sources/open-source-ecosystems/autobrowse-mythos-moment-browser-agents]] — fonte primaria
- [[03-RESOURCES/entities/Browserbase]] — empresa criadora
- [[03-RESOURCES/entities/Kyle-Jeong]] — autor/publicador
- [[03-RESOURCES/concepts/agent-systems/browser-agent-amnesia]] — problema que resolve
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — mecanismo central
- [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]] — campo academico paralelo
- [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]] — inspiracao (Karpathy)
