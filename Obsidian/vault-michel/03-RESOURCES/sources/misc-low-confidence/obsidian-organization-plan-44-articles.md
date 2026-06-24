---
title: "Obsidian Organization Plan — AI Agents Knowledge Base"
type: source
source_file: Clippings/OBSIDIAN_ORGANIZATION_PLAN.md
origin: documento local gerado (Maio 2026)
author: interno
published: 2026-05
ingested: 2026-05-14
tags: [obsidian, vault-organization, ai-agents, moc, knowledge-base, plano]
triagem_score: 6
---

# Plano de Organização Obsidian — 44 Artigos

Plano gerado para incorporar aprendizados de 44 artigos/notas sobre AI agents em uma base de conhecimento Obsidian estruturada.

## Estrutura de Pastas Proposta

```
AI-Agents/
├── 00-MOCs/          ← Maps of Content (índices navegáveis)
├── 01-Fundamentos/   ← Filosofia, Fat-Skill-Thin-Harness, Von Neumann
├── 02-Docs/          ← CLAUDE.md, MEMORY.md, HANDOFF.md, ERRORS.md templates
├── 03-Skills/        ← Anatomia de skill, HeavySkill, SkillOS
├── 04-Agentes/       ← Papéis, Auto-Think-Auto-Build loop, Hermes setup
├── 05-Harness/       ← Hook-Lock-File-Fix, Spec-Driven, Context-Reset
├── 06-Custos/        ← Token traps, redução 80%, roteamento de modelos
├── 07-Produção/      ← Auto-Improving Platform, observabilidade
├── 08-Context-Engineering/
├── 09-Comandos/      ← Slash commands, Codex /goal
├── 10-Templates/     ← CLAUDE.md starter, Skill YAML template
├── 11-Experimentos/
└── 12-Changelog/
```

## Arquivos de Alta Prioridade Identificados

| Arquivo | Fontes principais |
|---------|-----------------|
| `Anatomia-de-uma-Skill.md` | Meta-Meta-Prompting + SkillOS |
| `Hook-Lock-File-Fix.md` | 34% token waste article |
| `Context-Engineering-Fundamentos.md` | Context Engineering Full Course |
| `Auto-Think-Auto-Build-Loop.md` | Buildroom pattern |
| `HeavySkill-Raciocinio-Paralelo.md` | arXiv HeavySkill paper |
| `SkillOS-Auto-Evolucao.md` | Google SkillOS paper |

## Melhorias Identificadas para CLAUDE.md

21 itens do artigo "21 Things most claude users have Never Set Up":
- Kill the filler, Show options before acting, Be honest when you don't know
- Match length to complexity, Ask before big changes, Stay focused
- Tell me what you changed, Never act without asking, Tell Claude who you are
- Project context block, Lock in your voice/style, MEMORY.md maintenance
- Session-end summary, ERRORS.md log, Permanent facts block
- Scope control for code, Confirm before destructive actions, Hard stops block
- Tech stack lock, Files changed summary, Karpathy 4 rules

## Protocolo de Atualização Contínua

Cada nota deve conter frontmatter com `updated`, `version`, `sources`, `status: draft|active|archived`.

Quando artigo novo chega:
1. Identificar nota existente afetada
2. Adicionar seção `## Atualização [Data]`
3. Registrar no CHANGELOG.md
4. Atualizar MOC correspondente

## Notas

Este arquivo é um plano de organização gerado automaticamente de 44 artigos. Serve como referência de roadmap para estruturar o vault de AI agents — **não** substituiu o vault atual do Michel (que usa estrutura diferente). Referência cruzada com a estrutura atual em [[03-RESOURCES/wiki-index]].

## Conexões

- [[04-SYSTEM/wiki/hot]] — vault atual
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — harness concepts
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — hook patterns
