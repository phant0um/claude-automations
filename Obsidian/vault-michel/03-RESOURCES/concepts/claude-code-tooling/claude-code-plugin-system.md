---
title: "Claude Code Plugin System"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# Claude Code Plugin System

Plugins estendem o Claude Code empacotando Skills, Connectors, Commands e Subagents em um único bundle instalável.

## O que é

O plugin system do Claude Code permite empacotar e distribuir extensões de comportamento como unidades coesas. Um **cowork plugin** agrupa quatro artefatos:

- **Skills** — workflows reutilizáveis invocados por `/comando`
- **Connectors** — integrações com serviços externos (Slack, Jira, etc.)
- **Commands** — atalhos de CLI personalizados
- **Subagents** — agentes especializados com escopo restrito

A Anthropic mantém 11 plugins open-source oficiais (productivity, data, operations, etc.). Qualquer equipe pode criar e publicar plugins customizados.

## Como funciona

**Instalação:** via marketplace do Claude Code ou manual (colocando o diretório do plugin em `.claude/plugins/`). O harness carrega os arquivos de skill/hook automaticamente na inicialização.

**Ativação:** skills do plugin ficam disponíveis como `/namespace:skill`. Connectors registram permissões MCP. Subagents aparecem como agentes invocáveis via `@nome`.

**Escopo:** plugins de projeto vivem em `.claude/` local; plugins globais em `~/.claude/`. Projeto sobrescreve global em conflito.

## Por que importa

Para o vault-michel, plugins são o mecanismo que agrupa toda a camada SO (agents + skills + hooks) em unidades distribuíveis. O conjunto `michel-skills:*` é essencialmente um plugin não-empacotado. Entender o sistema permite evoluir o vault para um plugin formal e compartilhar comportamentos entre projetos.

## Related
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/_index]]
- [[03-RESOURCES/concepts/claude-ecosystem]]
