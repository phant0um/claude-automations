---
title: Matt Pocock
type: entity
category: pessoa
tags: [typescript, claude-skills, open-source, aihero]
created: 2026-04-15
updated: 2026-05-16
---

# Matt Pocock

Desenvolvedor TypeScript, criador de conteúdo educacional e fundador do AI Hero. Mantém o repositório de skills pessoais para Claude Code mais popular da comunidade.

## AI Hero

Newsletter e plataforma de skills para Claude Code. Em 2026-05-14 lançou 4 novos skills que atacam pontos de fricção específicos do workflow de desenvolvimento:

- **/handoff** — transfere contexto + vibe de uma sessão longa para um agente fresco; resolve context overflow sem perder o raciocínio acumulado
- **/prototype** — para "unknown unknowns": gera variações radicalmente diferentes de UI em paralelo (humano aplica taste) ou constrói app terminal interativo para explorar state machines / business logic
- **/review** (in-progress) — verifica código contra os padrões do repo AND a spec original; detecta code drift
- **/writing-*** (in-progress) — pipeline fragments → beats → shape; trata prototipagem como escrita e vice-versa

Ver [[03-RESOURCES/sources/claude-code-skills/aihero-new-skills-handoff-prototype-review-writing]] para análise completa.

## Repositório de skills (mattpocock/skills)

`github.com/mattpocock/skills` — **~40k+ estrelas** (trending: +2,987 em um dia em 2026-05-16; cresceu de 15k → 23k → 37k → 40k+)

Catálogo atual (README 2026-05-16) organizado em 3 categorias:

**Engineering:** `/diagnose`, `/grill-with-docs`, `/triage`, `/improve-codebase-architecture`, `/setup-matt-pocock-skills`, `/tdd`, `/to-issues`, `/to-prd`, `/zoom-out`, `/prototype`

**Productivity:** `/caveman`, `/grill-me`, `/handoff`, `/write-a-skill`

**Misc:** `/git-guardrails-claude-code`, `/migrate-to-shoehorn`, `/scaffold-exercises`, `/setup-pre-commit`

Filosofia central — 4 failure modes com fix específico:
1. **Misalignment** → `/grill-me` / `/grill-with-docs` + `CONTEXT.md` (linguagem ubíqua DDD)
2. **Verbosidade** → `CONTEXT.md` com jargon do projeto (concisão = naming consistency + menos tokens)
3. **Código que não funciona** → `/tdd` red-green-refactor + `/diagnose`
4. **Ball of mud** → `/improve-codebase-architecture` periódico + `/zoom-out`

Instalação:
```bash
npx skills@latest add mattpocock/skills
```

Ver [[03-RESOURCES/sources/claude-code-skills/mattpocock-skills-claude-code]] para catálogo completo e [[03-RESOURCES/sources/claude-code-skills/clipping-skills-for-real-engineering-matt-pocock]] para análise detalhada (2026-05-01).

## Conexões
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — conceito central
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — /handoff é solução direta para context rot
- [[03-RESOURCES/entities/Claude Code]] — plataforma
