---
title: "obra/superpowers — Agentic Skills Framework"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, skills, agentic-framework, tdd, spec-driven, subagent, claude-code]
score: 7
author: "Jesse (obra)"
source_url: "https://github.com/obra/superpowers"
domain: skills-prompting-mcp
---

# obra/superpowers — Agentic Skills Framework

**obra/superpowers**: metodologia completa de software development para coding agents. Skills composáveis + instruções iniciais que garantem o agente as usa.

## O Que Faz

Quando o agente vê que você está construindo algo, *não* pula para escrever código. Em vez disso:

1. **Teases out spec** — pergunta o que você realmente quer fazer
2. **Mostra spec em chunks** — legível, confirmável por você
3. **Monta implementation plan** — claro o suficiente para "junior engineer entusiástico com mau gosto" seguir (ênfase em TDD vermelho/verde, YAGNI, DRY)
4. **Subagent-driven development** — lança subagents para cada task de engenharia, inspeciona/revisa o trabalho, continua
5. Claude trabalha autonomamente por horas sem desviar do plano

## Skills Composáveis

- `/brainstorm` — exploração inicial
- `/write-plan` — spec → plano executável
- `/tdd` — test-driven development por step
- Plus skills de review, merge, etc.

## Filosofia

Skills trigam automaticamente — você não precisa fazer nada especial. O coding agent "just has Superpowers."

Disponível via marketplace oficial: `/plugin install superpowers@claude-plugins-official`

## Popularidade

148K stars (maior no ecossistema conforme curadoria chinesa). Comunidade ativa — novos skills toda semana.

## Compatibilidade

Claude Code, Codex CLI, Codex App, Factory Droid, Gemini CLI, OpenCode, Cursor, GitHub Copilot CLI.

## Ver Também

- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-claude-plugins-official]]
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-anatomy-claude-skill]]
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-claude-code-repos-10-curated]]
