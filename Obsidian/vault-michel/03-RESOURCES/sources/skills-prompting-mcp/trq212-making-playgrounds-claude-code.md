---
title: "Making Playgrounds using Claude Code"
type: source
source_url: "https://x.com/trq212/status/2017024445244924382"
author: "[[@trq212 (Tariq)|trq212-tariq]]"
published: 2026-01-29
ingested: 2026-05-28
tags: [claude-code, plugins, html, playground, visualization, ux]
---

# Making Playgrounds using Claude Code

## Tese central

O plugin oficial `playground` para Claude Code gera arquivos HTML standalone que funcionam como interfaces visuais intermediárias entre humano e agente — substituindo a interação puramente textual por UIs interativas que permitem explorar, ajustar e realimentar o modelo.

## Key insights

- **Plugin `playground`** instalado via `/plugin install playground@claude-plugins-official` — parte do marketplace oficial da Anthropic.
- Playgrounds são HTML standalone; o output é um prompt pronto para colar de volta no Claude Code, fechando o loop.
- Casos de uso não cobertos por texto: visualizar arquitetura de codebase, ajustar layouts de design, balancear jogos, revisar texto inline com approve/reject.
- Sugestão de uso: "pense em uma forma única de interagir com o modelo e peça para ele expressar isso".
- Integra-se diretamente com Skills — prompt de exemplo: `"Use the playground skill to create a playground that helps me explore..."`

## Implicações para o vault

- Reforça [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] como veículo para carregamento dinâmico de contexto visual.
- Complementa [[03-RESOURCES/sources/skills-prompting-mcp/claude-code-unreasonable-effectiveness-of-html]] — HTML não só como artefato mas como interface de feedback.
- Candidato a skill para o vault: playground de visualização de arquitetura dos agentes em `04-SYSTEM/agents/`.

## Links

- [[03-RESOURCES/entities/trq212-tariq]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]]
