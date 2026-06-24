---
title: "MCP"
type: entity
category: tool
tags: [entity, protocol, anthropic]
created: 2026-05-31
updated: 2026-06-01
status: developing
---

# MCP

Model Context Protocol — padrão aberto da Anthropic para conectar LLMs a ferramentas e fontes de dados externas.

## O que é / What it is

MCP usa arquitetura client-server onde o LLM (client) se conecta a servers que expõem três primitivas: tools (funções executáveis), resources (dados/arquivos) e prompts (templates reutilizáveis). Substitui integrações customizadas por um protocolo único e interoperável. Milhares de MCP servers existem: TradingView, Obsidian, filesystem, GitHub, Slack e outros.

## Relevância para o vault

Central para a extensibilidade do vault de Michel — `mcp__filesystem-vault__*`, `mcp__context-mode__*` e dezenas de outros servers usados em cada sessão são todos implementações de MCP. Permite que Claude Code acesse e manipule o vault diretamente sem integrações customizadas.

## Sources

- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/entities/Claude]]
