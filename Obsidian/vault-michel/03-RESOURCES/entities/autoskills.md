---
title: Autoskills
type: entity
entity_type: tool
created: 2026-04-24
updated: 2026-04-24
tags: [autoskills, cli, skills, claude-code, dx]
url: https://autoskills.sh
---

# Autoskills

**Autoskills** é uma CLI open-source que detecta automaticamente o tech stack de um projeto e instala as AI agent skills mais relevantes via [skills.sh](https://skills.sh/).

- **Comando:** `npx autoskills`
- **Differencial:** zero config — lê `package.json`, Gradle e configs sem configuração prévia
- **Integração Claude Code:** gera `CLAUDE.md` automaticamente quando `claude-code` é detectado
- **Skills instaladas em:** `.claude/skills/`

## Veja também

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — padrão SKILL.md que o autoskills instala
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — estrutura `.claude/` onde as skills são colocadas
- [[03-RESOURCES/sources/claude-code-skills/autoskills-auto-ai-skill-installer]] — resumo completo da fonte
