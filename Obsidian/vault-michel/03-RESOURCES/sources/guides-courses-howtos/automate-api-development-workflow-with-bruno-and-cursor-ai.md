---
title: "Automate API Development Workflow with Bruno and Cursor AI"
type: source
source: "https://blog.usebruno.com/how-to-automate-your-api-workflow-with-bruno-and-cursor-ai"
created: 2026-06-22
updated: 2026-06-22
tags: [guides-courses-howtos, bruno, cursor-ai, api-development, ci-cd, automation]
---

## Tese Central

Bruno (open-source, Git-first API client com collections em plain-text .bru/.yaml) + Cursor AI = generate, test, e CI/CD-drive API suites sem sair do editor. Plain-text files dão instant AI context sem export/import dance. Um prompt pode gerar full collection, environments, tests, e pipeline.

## Pontos-Chave

1. **Por que a combo funciona**: Collections em Git (diffable, reviewable, branchable). Plain-text = instant AI context. Cursor agents leem/escrevem Bruno specs como código. Um prompt → full collection + environments + tests + pipeline.
2. **Setup**: Install Cursor, abrir project root, criar `.cursor/agents.md` com official Bruno prompt para scaffoldar .bru files, environments, tests.
3. **Prompt 1 — Generate Collection from Routes**: "Create Bruno collection for every Express route inside src/routes. Infer RESTful methods from filenames. Set baseURL from env. Add port default 3000. Generate env files for local/prod."
4. **Prompt 2 — Generate CI/CD Pipeline**: GitHub Actions workflow que roda em push, starta app, executa Bruno collection, gera e uploada HTML report.
5. **Prompt 3 — Auto-Write Tests**: Para cada endpoint adicionar pre-request e test scripts: validate 200 OK, 400 for missing body, 401 for wrong token, check response schema against OpenAPI spec.
6. **Quick actions**: Convert Postman/Insomnia → Bruno, generate environment files, auto-document requests.

## Conceitos

- **Git-first API collections**: .bru/.yaml files diffable e reviewable
- **Plain-text AI context**: AI lê specs como código, sem export/import
- **Agent instruction file**: .cursor/agents.md com regras para scaffoldar Bruno artifacts

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/development]]
- [[03-RESOURCES/sources/guides-courses-howtos/bringing-agent-skills-to-bruno-workflows]]