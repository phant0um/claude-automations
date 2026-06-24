---
title: 10 Lifehacks for Using Claude
type: source
source: Clippings/10 Lifehacks for Using Claude.md
created: 2026-06-01
ingested: 2026-06-02
tags: [ai-agents, claude, workflows, prompt-engineering]
author: "@0xMoysei"
---

## Tese central
10 táticas práticas extraídas do time de engenharia da Anthropic para extrair qualidade consistente do Claude: controlar o que ele lê e dar-lhe mecanismos de auto-verificação.

## Argumentos principais
- CLAUDE.md carrega no início de cada sessão — escrever build commands, gotchas, regras não-negociáveis (Claude ignora arquivo bloated)
- Context window se degrada à medida que enche: /clear entre tarefas não relacionadas, reescrever prompt com o que foi aprendido
- Exploit > plan > code: plan mode lê arquivos relevantes e escreve plano antes de alterar qualquer coisa
- Skills = pastas .claude/skills/ com SKILL.md — Gotchas section é o mais valioso (erros reais do Claude no seu código)
- Dar ao Claude mecanismo de auto-verificação (test suite, screenshot): sem isso o desenvolvedor vira o harness de testes
- Subagents para pesquisa: cada um usa sua própria janela de contexto, reporta resumo — contexto principal permanece limpo para build
- Hooks disparam em 100% dos runs (vs 70% das instruções CLAUDE.md) — usar para regras invioláveis: auto-format, block push to main
- Front-load prompts: Claude Opus raciocina mais por turn → empacotar tarefa + constraints na primeira mensagem reduz round trips
- CLI tools custam menos tokens: gh CLI para PRs/issues sem rate limits; Claude aprende tools desconhecidas via --help
- Interview mode: pedir ao Claude para entrevistar sobre edge cases → salvar em SPEC.md → nova sessão constrói a partir do spec

## Key insights
- Qualidade > comprimento: sessão curta e limpa produz código melhor que sessão longa e poluída
- Hooks são garantias de execução (100%), instruções são sugestões (70%) — usar cada coisa para o que foi feita
- Front-loading elimina round trips desnecessários em tarefas longas — especialmente crítico com Opus 4.8 que raciocina mais por turn
- O "Gotchas section" das skills captura erros reais → força Claude a não repetir os mesmos erros

## Exemplos e evidências
- Anthropic roda "hundreds" de skills em produção
- Pattern: Explore → Plan → Code evita construir a coisa errada de primeiro
- Interview mode → SPEC.md → fresh session: separação entre briefing e execução melhora output final

## Implicações para o vault
- Confirma o design atual do vault: CLAUDE.md curto, hooks para regras críticas, subagents para ingest paralelo
- Lacuna identificada: Gotchas section nas skills do vault pode ser expandida com erros reais observados
- Front-load strategy alinha com abordagem de contexto atual (hot.md + nexus gate antes de qualquer ingest)

## Links
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[04-SYSTEM/agents/nexus]]
- [[04-SYSTEM/wiki/hot.md]]
