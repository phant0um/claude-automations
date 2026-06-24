---
title: "Lessons from Building Claude Code: How We Use Skills"
type: source
source_type: article
source_url: https://claude.com/blog/lessons-from-building-claude-code-how-we-use-skills
author: Thariq Shihipar (Anthropic)
created: 2026-05-31
updated: 2026-06-10
tags: [claude-code, skills, anthropic-official]
status: seed
---

# Lessons from Building Claude Code: How We Use Skills

**Autor:** Thariq Shihipar, membro técnico da Anthropic (time Claude Code)

## Resumo

Skills são um dos extension points mais usados no Claude Code — Anthropic usa centenas internamente.

**Pontos-chave:**
1. **Skills não são "só markdown"** — são pastas que podem incluir scripts, assets, dados, etc. Markdown é só o entry point.
2. **Description é o gatilho, não o resumo** — ao iniciar sessão, Claude monta listagem de skills disponíveis com suas descriptions; é isso que o Claude varre pra decidir se há skill aplicável. A description descreve **quando disparar**, não o que a skill faz.
3. **Memória via skill** — skills podem armazenar dados dentro de si mesmas, funcionando como memória persistente entre eventos.

## Por que importa (vault)

Reforça padrão usado neste vault: `04-SYSTEM/skills/` com SKILL.md + description-as-trigger. Conecta com [[03-RESOURCES/concepts/agent-systems/skill-authoring]] e [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]].

## Notes
Conteúdo via WebSearch (2026-06-10) — Clippings original consumido.
