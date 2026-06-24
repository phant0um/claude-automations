---
title: "ACP — Agent Client Protocol (Claude Code/Codex/Cursor interop)"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, ai-agents, acp, interop, harness, protocol, mcp]
score: 7
author: "@sitinme"
source_url: "https://x.com/sitinme/status/2057705568060797033"
domain: ai-agents-harness
---

# ACP — Agent Client Protocol (Claude Code/Codex/Cursor interop)

**@sitinme**: ACP resolve a fragmentação do ecossistema de AI coding tools — cada um um silo fechado.

## Problema

Claude Code, Codex, Cursor — cada um tem cliente próprio. Cursor Agent só roda em Cursor. Quer usar outro agent no Zed? Não dá. Quer fazer agents colaborar no mesmo projeto? Não dá.

Analogia histórica: antes do LSP (Language Server Protocol), cada editor implementava syntax highlight, autocompletion, error checking do zero. LSP unificou. VSCode ganhou força por isso.

## ACP = LSP para AI Coding Agents

**Agent Client Protocol**: protocolo padronizado de comunicação entre editor e AI agent.

Qualquer editor ACP-compatible pode usar qualquer agent ACP-compatible:
- Zed + Claude Code ✓
- VS Code + Gemini CLI ✓
- Qualquer combinação ✓

**Tecnologia**: JSON-RPC base. Dois modos:
- **Local**: agent como subprocess do editor, comunicação via stdio
- **Remote**: agent na cloud, comunicação HTTP/WebSocket

## ACP vs MCP

Complementares:
- **MCP** (Model Context Protocol): como o agent obtém tools e dados externos
- **ACP** (Agent Client Protocol): como o editor conversa com o agent

MCP = inputs do agent. ACP = outputs do agent para o editor.

## Harness no Ecossistema ACP

Conceito central: Harness = container do agent.

- Docker = container de apps (lifecycle: start/stop, network, storage)
- Harness = container de agents (lifecycle: start/stop, sessions, permissions, comunicação)

Harness gerencia: startup/stop do agent process, múltiplas sessões concorrentes, permissions, comunicação ACP.

## Compatibilidade

Zed implementação nativa. VS Code via extensão. Qualquer editor com ACP adapter.

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/entities/MCP]] (se existir)
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-claude-code-large-codebases]]
