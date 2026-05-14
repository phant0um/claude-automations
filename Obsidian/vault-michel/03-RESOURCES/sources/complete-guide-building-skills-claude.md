---
title: The Complete Guide to Building Skills for Claude
type: source
source_file: .raw/ebooks/The-Complete-Guide-to-Building-Skill-for-Claude.pdf
author: Anthropic
date_ingested: 2026-04-16
tags: [claude, skills, anthropic, oficial, guia]
---

# The Complete Guide to Building Skills for Claude

Guia oficial da Anthropic (33 páginas) sobre como criar, testar e distribuir skills para Claude. Cobre desde fundamentos até troubleshooting avançado.

## Estrutura do documento

6 capítulos:
1. **Fundamentals** — o que é uma skill, princípios de design, anatomia da pasta
2. **Planning and design** — casos de uso, 3 categorias, critérios de sucesso
3. **Testing and iteration** — manual, scripted, programmatic; skill-creator
4. **Distribution and sharing** — modelo de distribuição, API, open standard
5. **Patterns and troubleshooting** — 5 padrões arquiteturais, diagnóstico de problemas
6. **Resources and references** — links oficiais, quick checklist, YAML reference

## Conceitos principais

### O que é uma skill
Uma **pasta** contendo:
- `SKILL.md` (obrigatório) — instruções em Markdown com YAML frontmatter
- `scripts/` (opcional) — código executável (Python, Bash)
- `references/` (opcional) — documentação carregada conforme necessário
- `assets/` (opcional) — templates, fontes, ícones

### Progressive Disclosure (3 níveis)
1. **YAML frontmatter** — sempre carregado no system prompt; apenas metadados de trigger
2. **SKILL.md body** — carregado quando Claude decide usar a skill
3. **Linked files** — descobertos pelo Claude conforme necessário

### Anatomia do SKILL.md
```yaml
---
name: skill-name-kebab-case   # obrigatório
description: [O que faz] + [Quando usar] + [Frases de trigger]  # obrigatório, <1024 chars
license: MIT                   # opcional
compatibility: Claude.ai, Claude Code  # opcional
metadata:                      # opcional
  author: Nome
  version: 1.0.0
  mcp-server: nome-servidor
---
```

### 3 categorias de casos de uso
1. **Document & Asset Creation** — outputs de alta qualidade (docs, apresentações, designs)
2. **Workflow Automation** — processos multi-step com metodologia consistente
3. **MCP Enhancement** — guidance de workflow sobre tool access de MCP server

### Analogia da cozinha
- **MCP** = a cozinha profissional (acesso a ferramentas e ingredientes)
- **Skills** = as receitas (como criar algo valioso com esses recursos)

## Insights chave

> [!key-insight] Description field é o mais crítico
> O campo `description` é como Claude decide se deve carregar a skill. Deve incluir WHAT + WHEN + trigger phrases. Vago = skill nunca carrega. Sem triggers = usuários precisam ativar manualmente.

> [!key-insight] Skill won't upload — causa mais comum
> `SKILL.md` é case-sensitive. `SKILL.MD`, `skill.md` → upload falha.

> [!key-insight] Regra dos 5.000 palavras
> Manter SKILL.md abaixo de 5.000 palavras. Documentação detalhada vai em `references/`.

## 5 padrões arquiteturais

| Padrão | Use when |
|---|---|
| Sequential workflow orchestration | Multi-step em ordem específica |
| Multi-MCP coordination | Workflows abrangem múltiplos serviços |
| Iterative refinement | Output melhora com iteração |
| Context-aware tool selection | Mesmo resultado, ferramentas diferentes por contexto |
| Domain-specific intelligence | Skill adiciona conhecimento especializado além do acesso a ferramentas |

## Distribuição (modelo atual — janeiro 2026)

**Individual:** download folder → zip → upload Settings > Capabilities > Skills, ou coloca na pasta skills do Claude Code.

**Organizacional:** admins fazem deploy workspace-wide (disponível desde dez/2025); updates automáticos.

**API:** endpoint `/v1/skills`; parâmetro `container.skills` nas Messages API requests.

**Open standard:** Anthropic publicou Agent Skills como padrão aberto — funciona em outros AI platforms.

## Troubleshooting rápido

| Sintoma | Causa provável | Solução |
|---|---|---|
| Skill não faz upload | `SKILL.md` não existe ou nome errado | Renomear exatamente para `SKILL.md` |
| Skill nunca dispara | Description vaga ou sem triggers | Revisar description com WHAT+WHEN |
| Skill dispara demais | Description ampla demais | Adicionar negative triggers |
| Instructions não seguidas | Verboso demais / instruções enterradas | Conciso + instruções críticas no topo |
| MCP calls falham | MCP não conectado ou tool names errados | Verificar Settings > Extensions |

## Recursos oficiais

- `anthropics/skills` — repositório público com skills da Anthropic
- `skill-creator` skill — builtin no Claude.ai e disponível no Claude Code; gera skills a partir de descrições
- Partner Skills Directory — Asana, Atlassian, Canva, Figma, Sentry, Zapier e mais

## Relevância para o vault

Complementa [[03-RESOURCES/concepts/claude-skills]] e [[03-RESOURCES/sources/67-claude-skills-full-dev-team]]. Esta é a fonte **oficial da Anthropic** — mais autoritativa que curadoria de terceiros.

## Links internos

- [[03-RESOURCES/concepts/claude-skills]] — conceito central; este source expande com anatomia detalhada
- [[03-RESOURCES/sources/67-claude-skills-full-dev-team]] — curadoria de skills existentes
- [[03-RESOURCES/sources/20-agentic-skills-claude-chatgpt-gemini]] — skills portáteis modelo-agnósticas
- [[03-RESOURCES/entities/SEI-Automation-Agent]] — projeto onde aplicar estes padrões
