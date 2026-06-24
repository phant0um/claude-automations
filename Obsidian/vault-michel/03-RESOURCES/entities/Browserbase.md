---
title: Browserbase
type: entity
entity_type: company
created: 2026-05-09
updated: 2026-05-19
tags: [browser-agents, web-automation, browserbase, infrastructure]
---

# Browserbase

**Browserbase** is a company building infrastructure for browser agents, including the `browse` CLI (an internal generalist agent) and [[03-RESOURCES/entities/Autobrowse]] (a skill-graduation workflow). The team runs every internal workflow — feature requests, session investigations, PRs, sales triage — through one agent that loads small markdown skills on demand.

## Products / Tools

- **Browse CLI (`bb`):** internal generalist agent; loads SKILL.md files on demand; used for feature requests, session investigations, PR triage, sales triage.
- **[[03-RESOURCES/entities/Autobrowse]]:** workflow for iterative browser task learning → skill graduation.
- **browse fetch / browse search / browse snapshot:** primitives used inside skills for efficient site interaction.

## Public Skills Repo

Autobrowse-graduated skills are pushed to a public Browse CLI skills ecosystem. The hand-written skills inside `browse` and auto-graduated skills share the same artifact format.

## Key People

- [[03-RESOURCES/entities/Kyle-Jeong]] — wrote the Autobrowse article (@kylejeong)
- @_shubhankar — created Autobrowse internally

## Conexoes

- [[03-RESOURCES/entities/Autobrowse]] — produto principal documentado
- [[03-RESOURCES/sources/open-source-ecosystems/autobrowse-mythos-moment-browser-agents]] — fonte primaria
- [[03-RESOURCES/concepts/agent-systems/browser-agent-amnesia]] — problema que a empresa endenca
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — mecanismo de producao de skills
