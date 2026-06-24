---
title: kepano (Stephan Ango)
type: entity
category: person
created: 2026-05-28
updated: 2026-05-28
tags: [entity, person, obsidian, pkm, agent-skills]
aliases: [Stephan Ango, kepano]
---

# kepano — Stephan Ango

CEO e co-criador da [[03-RESOURCES/entities/Obsidian|Obsidian]]. Autor do repositório `kepano/obsidian-skills` — as skills *oficiais* para agentes interagirem com Obsidian.

**GitHub:** kepano  
**Cargo:** CEO, Obsidian

## Contribuição principal: obsidian-skills

Repositório `kepano/obsidian-skills` (licença MIT) — skills para ensinar agentes a usar Obsidian corretamente.

**Por que importa:** LLMs foram treinados em Markdown genérico, não em Obsidian-flavored Markdown. Sem correção explícita, agentes criam links quebrados, frontmatter inválido e callouts mal formatados.

### As 5 skills oficiais

| Skill | O que ensina |
|-------|-------------|
| `obsidian-markdown` | Wikilinks (`[[note]]`), callouts (`> [!tip]`), embeds (`![[note]]`), frontmatter YAML correto |
| `obsidian-bases` | Obsidian Bases (banco de dados embutido lançado 2025): filtros, views, queries |
| `obsidian-cli` | Comandos CLI do Obsidian: abrir vault, navegar, executar comandos |
| `json-canvas` | Criação de canvas `.canvas` com JSON estruturado |
| `defuddle` | Extração limpa de conteúdo web para Markdown sem ruído |

**Compatibilidade:** Claude Code, Codex CLI, OpenCode e qualquer agente com suporte a agent skills (arquivos Markdown de instrução).

## Relevância para este vault

As skills do kepano são base direta do sistema de skills deste vault:
- `obsidian-markdown` → adotada como padrão de formatação
- `defuddle` → usada no pipeline de ingest de clippings
- Filosofia "skills = instruções em Markdown" → influenciou arquitetura de `04-SYSTEM/skills/`

## Relacionado

- [[03-RESOURCES/concepts/pkm-obsidian/self-writing-vault|Self-Writing Vault]] — visão que as obsidian-skills habilitam
- [[03-RESOURCES/sources/claude-code-skills/clipping-kepanoobsidian-skills-agent-skills-for-obsidian-teach-your-a|Source — kepano/obsidian-skills]]
- [[03-RESOURCES/concepts/agent-systems/browser-skills-agents|Browser Skills Agents]] — extensão do padrão de skills para web
