---
title: "@godofprompt — Claude Code como Sistema de 7 Camadas"
type: source
source_url: "https://x.com/godofprompt/status/2058563825000149447"
author: "@godofprompt"
published: 2026-05-24
ingested: 2026-05-28
tags: [claude-code, harness, architecture, skills, mcp, lsp, subagents, hooks, plugins, mental-model]
---

# @godofprompt — Claude Code como Sistema de 7 Camadas

## Tese central

Claude Code não é uma caixa de chat mas um sistema de 7 camadas: a maioria dos usuários para na camada 1 (CLAUDE.md); a alavancagem real começa na camada 7 (Subagentes). Equipes que extraem o máximo constroem harnesses, não prompts.

## Key insights

Stack completo de baixo para cima:

1. **CLAUDE.md** — contexto persistente por sessão. Convenções, stack, problemas. Escreva uma vez.
2. **Hooks** — scripts que disparam em momentos-chave. Hook de parada pode revisar e propor atualizações automáticas para CLAUDE.md.
3. **Skills** — expertise sob demanda, carregada só quando relevante. Security skill ativa em auditorias; doc skill ativa quando código muda. Zero inchaço de sessão.
4. **Plugins** — empacota skills + hooks + MCP configs em pacote instalável. Onboarding de novos membros em dia 1.
5. **LSP (Language Server Protocol)** — precisão em nível de símbolo: segue definições entre arquivos em vez de pattern matching em texto.
6. **MCP Servers** — conecta Claude a ferramentas internas, DBs, ticket systems, APIs externas.
7. **Subagentes** — instância separada de Claude para explorar subsistema em paralelo ao agente principal. Contexto isolado.

- Citação: "As equipes que extraem o máximo do Claude Code não estão escrevendo prompts melhores. Estão construindo harnesses melhores."
- Referência a publicação da Anthropic na mesma semana confirmando o modelo de harness.

## Implicações para o vault

- Mapa mental perfeito para [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — as 7 camadas são uma taxonomia limpa.
- Hook de auto-atualização de CLAUDE.md é o ciclo de [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]].
- Confirma que LSP é camada infraestrutural ainda pouco explorada no vault.

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]]
