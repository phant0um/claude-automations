---
title: MCP-CLI Bridge
type: concept
status: developing
tags: [mcp, cli, python, design-pattern, tooling, ai-agents, packaging]
created: 2026-05-09
updated: 2026-05-09
---

# MCP-CLI Bridge

Padrão de design onde um único pacote Python expõe a mesma funcionalidade por dois caminhos: uma CLI para uso humano direto (terminal, scripting) e um servidor MCP para uso por agentes IA.

## Motivação

Ferramentas de integração com serviços externos têm dois públicos naturais:
- **Humanos**: precisam de CLI ergonômica para scripting/automação
- **Agentes IA**: precisam de MCP server com tool definitions estruturadas

Manter dois pacotes separados cria drift de features e overhead de manutenção. O bridge unifica.

## Estrutura Típica

```
meu-pacote/
├── cli.py         → entrypoint `nlm` (Typer/Click)
├── mcp_server.py  → entrypoint `meu-mcp` (FastMCP / MCP SDK)
└── core/          → lógica compartilhada
```

```toml
# pyproject.toml
[project.scripts]
nlm = "notebooklm_mcp_cli.cli:app"
notebooklm-mcp = "notebooklm_mcp_cli.mcp_server:main"
```

Um `pip install` instala ambos os binários.

## Exemplo de Referência

[[03-RESOURCES/sources/memory-context-rag/jacob-bd-notebooklm-mcp-cli]] — `notebooklm-mcp-cli` de [[03-RESOURCES/entities/jacob-bd]]:
- `nlm` (CLI) + `notebooklm-mcp` (MCP server, 35 tools)
- Refatorado em janeiro 2026 a partir de dois pacotes legados separados

## Configuração MCP no Claude Code

```bash
claude mcp add --scope user notebooklm-mcp notebooklm-mcp
# ou via nlm:
nlm setup add claude-code
```

## Vantagens

- Uma instalação, dois modos de uso
- Lógica de negócio compartilhada — sem drift
- CLI serve como fallback e ferramenta de debug
- MCP serve agentes com tool definitions estruturadas

## Cuidados

- 35+ tools MCP = custo alto de context window; desabilitar quando não usar
- Upgrade: `uv tool install --force` para evitar constraint caching

## Relações

- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — protocolo do lado MCP
- [[03-RESOURCES/concepts/pkm-obsidian/notebooklm-integration]] — implementação concreta
- [[03-RESOURCES/entities/mcp]] — entity MCP
