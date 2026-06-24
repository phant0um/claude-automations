---
title: "Bringing Agent Skills to Bruno Workflows"
type: source
source: "https://blog.usebruno.com/bringing-agent-skills-to-bruno-workflows"
created: 2026-06-22
updated: 2026-06-22
tags: [guides-courses-howtos, bruno, agent-skills, claude-code, chatgpt, api-testing]
---

## Tese Central

Agent Skills estendem a filosofia do Bruno (collections como files, Git-friendly, developer control) para AI-assisted development. Um skill dá ao agent um reusable playbook: o que fazer, que files referenciar, que conventions seguir, que output produzir. Bruno Skills Sample Pack inclui três skills: bruno-collection-generator, bruno-test-writer, bruno-ci-setup — packageados segundo o Agent Skills pattern, usable com qualquer AI Agent que suporta o standard.

## Pontos-Chave

1. **Skill = SKILL.md + supporting files**: SKILL.md é entry point com metadata e instructions. references/ (docs), scripts/ (helper scripts), assets/ (examples). Mantém prompts curtos e agent consistente.
2. **Bruno fits naturally agentic workflows**: Collections vivem como files, reviewable em PRs, generable/editable/testable via CLI ou AI agent.
3. **Three common workflows**: Generating collections from backend code, writing pre-request/test scripts/assertions, automating CI/CD pipelines/environment setup.
4. **Skill 1 — bruno-collection-generator**: Cria Bruno collections de API source material (backend routes, endpoint lists, OpenAPI snippets, cURL). Identifica endpoints, methods, paths, headers, auth. Grouping em folders, readable names, variables ao invés de hardcoded hostnames.
5. **Skill 2 — bruno-test-writer**: Pre-request scripts, test scripts, assertions. Valida responses contra schemas.
6. **Skill 3 — bruno-ci-setup**: CI/CD pipelines, environment setup, collection organization. GitHub Actions com Bruno CLI.
7. **Design**: agents/openai.yaml para ChatGPT-specific UI metadata. Packages usable com qualquer AI Agent que suporta o standard, staying Bruno-specific.

## Conceitos

- **Agent Skills pattern**: SKILL.md + references + scripts + assets como playbook reusável
- **Bruno Skills MVP**: três skills para generate collections, write tests, setup CI
- **Skill as reusable playbook**: não fumble com long prompt toda vez

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/sources/guides-courses-howtos/automate-api-development-workflow-with-bruno-and-cursor-ai]]
- [[03-RESOURCES/sources/guides-courses-howtos/how-to-sync-api-collections-with-openapi-bruno-openapi-sync]]