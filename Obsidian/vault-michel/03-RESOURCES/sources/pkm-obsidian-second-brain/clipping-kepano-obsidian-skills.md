---
title: "kepano/obsidian-skills — Agent Skills for Obsidian"
type: source
source: "Clippings/kepanoobsidian-skills Agent skills for Obsidian. Teach your agent to use Markdown, Bases, JSON Canvas, and use the CLI..md"
author: "kepano (criador do Obsidian Minimal theme)"
published: 2026-05-22
created: 2026-05-23
ingested: 2026-05-23
tags: [ai-agents, clippings, obsidian, skills, pkm]
---

## Tese central

Skills oficiais para ensinar agentes a usar Obsidian: Markdown flavored, Bases (novo banco de dados nativo), JSON Canvas e CLI. Segue Agent Skills specification — compatível com Claude Code, Codex CLI, OpenCode e qualquer agent skills-compatible. Criado pelo kepano, criador do Minimal theme e membro da equipe Obsidian.

## Argumentos principais

- **Skills padronizadas**: seguem Agent Skills specification (agentskills.io) — funciona com qualquer agent compatível, não só Claude Code.
- **Cobertura completa do Obsidian**: 4 skills cobrindo todos os primitivos do Obsidian moderno — Markdown, Bases, JSON Canvas, CLI.
- **Instalação multi-agent**: marketplace (uma linha), npx skills (uma linha), ou manual para Claude Code / Codex / OpenCode.
- **Obsidian nativo**: kepano conhece os internos — skills refletem como Obsidian realmente funciona, não documentação genérica.

## Key insights

### Skills disponíveis

| Skill | O que ensina |
|-------|-------------|
| `obsidian-markdown` | Obsidian Flavored Markdown: wikilinks, embeds, callouts, properties, syntax específica |
| `obsidian-bases` | Bases: banco de dados nativo Obsidian (novo feature) — criar, consultar, filtrar |
| `obsidian-canvas` | JSON Canvas: criar, editar canvas interativos |
| `obsidian-cli` | Usar Obsidian via CLI (obsidian-cli, URI scheme) |

### Instalação por agent

```bash
# Marketplace
/plugin marketplace add kepano/obsidian-skills
/plugin install obsidian@obsidian-skills

# npx (qualquer agent)
npx skills add git@github.com:kepano/obsidian-skills.git

# Claude Code: copiar para /.claude na raiz do vault
# Codex: copiar skills/ para ~/.codex/skills/
# OpenCode: clone completo para ~/.opencode/skills/obsidian-skills/
```

### Por que importa para este vault
- Vault-michel usa Claude Code como agente principal — estas skills ensinam Claude como usar Obsidian corretamente.
- Bases (novo feature): skills cobrem database nativo que vault ainda não usa. Potencial para substituir algumas structures de índice.
- Obsidian Flavored Markdown: wikilinks, callouts, embeds têm sintaxe específica que skills standardizam.

## Exemplos e evidências

- kepano = criador do Minimal theme + membro equipe Obsidian. Skills têm autoridade técnica.
- Seguem mesma spec que claude-obsidian:wiki-ingest usa — compatibilidade garantida.
- OpenCode integration: clonar repo completo em `~/.opencode/skills/obsidian-skills/` — não copiar só `skills/`.

## Implicações para o vault

- **Ação imediata**: instalar `kepano/obsidian-skills` no vault-michel (colocar em `/.claude/` ou adicionar ao config de skills)
- Complementa [[03-RESOURCES/sources/pkm-obsidian-second-brain/i-connected-claude-obsidian-vault-damidefi]] — skills oficiais + CLAUDE.md como cognitive partner
- Bases skill: potencial para criar vault databases nativos — alternativa a índices manuais em MD

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/entities/Obsidian]]
