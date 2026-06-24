---
title: "anthropics/skills: Public Repository for Agent Skills"
type: source
source: "Clippings/anthropicsskills Public repository for Agent Skills.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, skills, anthropic, agent-skills-standard]
---

## Tese central

Repositório oficial da Anthropic de Agent Skills — skills são pastas de instruções, scripts e recursos que Claude carrega dinamicamente para melhorar performance em tarefas especializadas. O repositório serve como referência de patterns e exemplos de skills production-grade, incluindo as skills de criação de documentos que alimentam os recursos nativos do Claude.

## Argumentos principais

- **Skills = pastas com SKILL.md** contendo instruções e metadata que Claude usa para execução especializada
- **Skills são autocontidas** — cada skill em sua própria pasta com SKILL.md; Claude carrega sob demanda
- **Scope**: de criatividade (arte, design) a técnico (webapp testing, MCP server generation) a enterprise (communications, branding)
- **Skills de documento incluídas como referência** — docx, pdf, pptx, xlsx que alimentam os recursos nativos do Claude; source-available (não open source), compartilhadas como referência para devs

## Key insights

- O vault implementa o mesmo padrão SKILL.md — confirma alinhamento com standard oficial
- Skills "source-available" das capacidades nativas = posso analisar como as skills mais complexas em produção são estruturadas
- agentskills.io como padrão open para skills, independente do harness

## Implicações para o vault

- Auditar skills do vault contra os padrões do repositório oficial
- As skills de documento (docx, pdf, pptx) são referências para skills que lidam com artefatos complexos

## Links

- [[03-RESOURCES/sources/anthropic-knowledge-work-plugins]]
- [[03-RESOURCES/sources/ecc-agent-harness-system]]
- [[04-SYSTEM/skills]]
