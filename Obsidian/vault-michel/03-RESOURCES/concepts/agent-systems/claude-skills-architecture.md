---
title: Claude Skills Architecture
type: concept
created: 2026-05-24
updated: 2026-05-24
tags: [agent-systems, claude-code, skills, automation]
status: developing
---

# Claude Skills Architecture

Skill = **memória procedural legível**: define COMO o agente executa uma categoria de tarefa, persistindo entre sessões, máquinas, e agentes. Não é prompt — é job description + processo + exemplos codificados em markdown.

## Os 6 Componentes de Produção

| Componente | Função | Sem ele |
|------------|--------|---------|
| **Frontmatter** | `name`, `description`, trigger phrase — o que o model lê primeiro | Skill nunca é selecionada |
| **Trigger** | Sinal concreto de ativação ("quando usuário pede tweet draft") | Ativação inconsistente |
| **Role** | Qual especialista o model deve ser para esta task | Output genérico |
| **Process** | Passos que o especialista seguiria | Improviso, inconsistência |
| **Format** | Estrutura esperada do output | Reformatting manual toda vez |
| **Examples** | One-shot ou few-shot | Julgamento mal calibrado |

Skill sem todos os 6 → rota em semanas.

## Skill vs Prompt

| Dimensão | Prompt | Skill |
|----------|--------|-------|
| Duração | Uma sessão | Permanente |
| Portabilidade | Local | Cross-machine |
| Manutenção | Manual toda vez | Escreve uma vez |
| Uso por agentes | Não | Sim (wiki-ingest, nexus, etc.) |

## Como o vault carrega skills

1. `~/.claude/skills/` — skills globais (todas as sessões)
2. `.claude/skills/` — skills do projeto (vault-michel)
3. Symlinks em `.agents/skills/` — ativas automaticamente no Claude Code
4. Frontmatter + trigger = filtro de seleção no contexto

## Ecosystem (2026)

- Anthropic marketplace: 16 skills oficiais
- Lobehub: 500+ community skills
- ECC (Everything Claude Code): 232+ skills
- kepano/obsidian-skills: 5 skills (defuddle, json-canvas, obsidian-bases, obsidian-cli, obsidian-markdown)
- vault-michel: ~40 skills em `04-SYSTEM/skills/`

## Relação com vault

O sistema de skills do vault É uma implementação desta arquitetura. Auditoria checklist:
- [ ] Todo skill tem os 6 componentes?
- [ ] Triggers são concretos (não vagos)?
- [ ] Skills de agentes (nexus, hill) têm role explícito?

## Links

- [[03-RESOURCES/sources/claude-code-skills/anatomy-claude-skill-40-line-markdown]]
- [[03-RESOURCES/concepts/agent-systems/spec-driven-development]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[04-SYSTEM/wiki/skill-memory]]
