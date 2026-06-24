---
title: NotebookLM Integration
type: concept
status: developing
tags: [notebooklm, mcp, cli, integration, google, automation, python, ai-tools]
created: 2026-05-09
updated: 2026-05-09
---

# NotebookLM Integration

Padrão de acesso programático ao Google NotebookLM via APIs internas (não oficiais), exposto como CLI e/ou servidor MCP para automação e uso por agentes IA.

## O Padrão

NotebookLM não tem API pública. O acesso programático funciona via:
1. Extração de cookies do browser autenticado (CDP — Chrome DevTools Protocol)
2. Chamadas às APIs internas da aplicação web
3. Exposição dessas chamadas via CLI (`nlm`) ou MCP server (35 tools)

## Implementação de Referência

[[03-RESOURCES/sources/memory-context-rag/jacob-bd-notebooklm-mcp-cli]] — pacote `notebooklm-mcp-cli` de [[03-RESOURCES/entities/jacob-bd]].

```bash
uv tool install notebooklm-mcp-cli
nlm login
nlm setup add claude-code   # registra MCP no Claude Code
```

## Capacidades Expostas

- CRUD de notebooks e fontes (URL, texto, Drive, arquivo, YouTube)
- Queries com grounding nas fontes (persistem na UI web)
- Studio: áudio, vídeo, slides, flashcards, infográficos, mind maps
- Web research automático + import de fontes
- Batch operations, cross-notebook query, pipelines, tagging
- Compartilhamento (público / convite)

## Riscos

- API interna: pode quebrar sem aviso em updates do Google
- Cookies expiram em ~2-4 semanas
- Rate limit: ~50 queries/dia (free tier)
- Não testado em contas NotebookLM Enterprise

## Contexto Relacionado

- [[03-RESOURCES/concepts/claude-code-tooling/mcp-cli-bridge]] — padrão de unificar CLI + MCP num pacote
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — protocolo do servidor
- [[03-RESOURCES/entities/NotebookLM]] — produto integrado
- [[03-RESOURCES/entities/mcp]] — entity MCP

## Evidências
- **[2026-06-19]** notebooklm-mcp-cli (jacob-bd, 35 tools MCP) conecta Hermes ao NotebookLM via wrapper de browser automation (sem API pública); requer fallback explícito no SOUL.md do Analyst caso o wrapper quebre — [[hermes-agent-notebooklm-obsidian-3-agent-research-department]]
