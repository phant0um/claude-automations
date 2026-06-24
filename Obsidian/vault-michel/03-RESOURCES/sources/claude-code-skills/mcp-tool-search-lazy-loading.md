---
title: "Tool Search now in Claude Code"
type: source
author: "@trq212 (Tariq)"
published: 2026-01-14
ingested: 2026-05-28
tags: [source, claude-code, mcp, tool-search, context-management, lazy-loading]
source_url: "https://x.com/trq212/status/2011523109871108570"
---

# Tool Search now in Claude Code

## Tese central

MCP Tool Search resolve o problema de servidores MCP com 50+ ferramentas consumindo grandes porções do contexto. Em vez de pré-carregar todas as descrições de tools, Claude Code carrega tools dinamicamente via busca quando necessário.

## Key insights

- **Threshold de ativação:** Tool Search ativa quando descrições de MCP tools consumiriam mais de 10% do contexto
- **Funcionamento:** tools carregadas via search em vez de pré-carregadas; quando não ativado, MCP funciona exatamente como antes
- **Resolve GitHub issue mais solicitado:** lazy loading para MCP servers; usuários relatavam setups com 7+ servers consumindo 67k+ tokens
- **Para criadores de MCP servers:** o campo "server instructions" se torna mais importante — ajuda Claude a saber quando buscar as tools
- **Para clientes MCP:** recomendado implementar `ToolSearchTool` com função de busca customizada
- **Programmatic tool calling:** foi explorado (composição de MCP tools via código) mas não chegou nesta release; futuro

## Implicações para o vault

- Impacto direto nos MCPs configurados no vault: servidores com muitas tools agora são viáveis sem overhead de contexto
- Complementa a estratégia de [[03-RESOURCES/sources/claude-code-skills/stop-installing-plugins-builtin-commands]] de manter contexto lean
- Documenta feature lançada por [[03-RESOURCES/entities/trq212-tariq]]

## Links

- Docs ToolSearchTool: https://platform.claude.com/docs/en/agents-and-tools/tool-use/tool-search-tool
- Issue GitHub original: anthropics/claude-code#7336
- Relacionado: [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- Relacionado: [[03-RESOURCES/concepts/claude-code-tooling/mcp-server-curation]]

## Relações
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]] — lazy loading resolve context-budget constraint antes do roteamento
- [[03-RESOURCES/sources/claude-code-skills/anthropic-prompt-caching-is-everything]] — padrão: context budget como constraint primária
