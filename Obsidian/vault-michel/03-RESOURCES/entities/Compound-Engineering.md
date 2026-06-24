---
title: "Compound Engineering"
type: entity
category: tool
tags: [entity, tool, claude-code, skills, harness, open-source]
created: 2026-05-31
updated: 2026-06-01
---

# Compound Engineering

**GitHub:** github.com/everyinc/compound-engineering-plugin · por Trevin Chow (@trevin)

Plugin/framework de skills e agentes para harnesses de AI coding (Claude Code, Codex, Pi, Copilot), indexado no vault pela v3 com namespace unificado `ce-` e rastreabilidade de requisitos.

## Contribuições relevantes

- Namespace unificado `ce-`: ce-work, ce-commit, ce-setup, ce-code-review, ce-brainstorm, ce-plan
- Paper trail de requisitos: brainstorm → plan → work com IDs estáveis para rastreabilidade humana e dos agentes
- Cross-harness de primeira classe: Claude Code, Codex (marketplace), Pi, Copilot CLI/VSCode
- `question-tool` corrigido para funcionar em todos os harnesses (bloqueava em Codex Plan mode e Claude Code)

## Fontes no vault

- [[03-RESOURCES/sources/ai-agents-harness/compound-engineering-v3]] — release notes v3 com namespace, paper trail e cross-harness
