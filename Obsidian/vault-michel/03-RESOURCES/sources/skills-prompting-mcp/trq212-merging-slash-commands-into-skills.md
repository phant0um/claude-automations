---
title: "Merging Slash Commands into Skills in Claude Code"
type: source
source_url: "https://x.com/trq212/status/2014836841846132761"
author: "[[@trq212 (Tariq)|trq212-tariq]]"
published: 2026-01-23
ingested: 2026-05-28
tags: [claude-code, skills, slash-commands, subagents, context-management]
---

# Merging Slash Commands into Skills in Claude Code

## Tese central

Slash Commands foram absorvidos pelo sistema de Skills no Claude Code. A unificação elimina redundância de ferramentas para o modelo e expande os casos de uso via suporte nativo a subagents dentro de skills.

## Key insights

- **Unificação:** qualquer skill pode ser invocada com `/` e qualquer slash command funciona como skill. Nenhuma migração necessária — `~/.claude/commands` continua funcionando.
- **Progressive disclosure:** Skills carregam contexto dinamicamente (lêem arquivos relevantes) vs. Slash Commands que eram estáticos. Multi-nível via referências dentro do SKILL.MD.
- **Flags de controle:** `user-invocable: false` impede invocação manual; `disable-model-invocation: true` impede invocação automática pelo modelo.
- **Subagents + Skills:** `agent: <nome>` spawna subagente com a skill em seu contexto. `context: fork` cria subagente com cópia do contexto atual — ideal para operações paralelas (ex: memory skill que sumariza a conversa sem poluir o contexto principal).
- Recomendação oficial: **prefira criar Skills em vez de Slash Commands daqui em diante**.

## Implicações para o vault

- Valida a arquitetura atual do vault: skills em `~/.claude/skills/` como veículo principal, não comandos slash.
- O padrão `context: fork` para memory skills é exatamente o que o vault usa para atualizações de `hot.md` — referência canônica.
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] deve incorporar a flag `context: fork` como padrão para operações de memória.

## Links

- [[03-RESOURCES/entities/trq212-tariq]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/sources/skills-prompting-mcp/trq212-making-playgrounds-claude-code]]
