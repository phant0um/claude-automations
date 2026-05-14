---
title: "notebooklm-mcp-cli — Programmatic Access to Google NotebookLM"
type: source
source_file: "clippings/jacob-bdnotebooklm-mcp-cli.md"
author: "Jacob (jacob-bd)"
ingested: 2026-05-09
tags: [notebooklm, mcp, cli, claude-code, integration, python, google, ai-tools]
---

# notebooklm-mcp-cli — Programmatic Access to Google NotebookLM

GitHub: https://github.com/jacob-bd/notebooklm-mcp-cli

Unified Python package that exposes **Google NotebookLM** programmatically via two interfaces: a CLI (`nlm`) and an [[03-RESOURCES/entities/mcp|MCP]] server (`notebooklm-mcp`). Refactored in January 2026 from two separate packages into one.

---

## O que faz

Dá acesso programático ao NotebookLM — criação de notebooks, adição de fontes (URL, texto, Drive, arquivo), queries, geração de áudio/vídeo/slides/flashcards/infográficos, compartilhamento e pesquisa web — tudo via terminal ou agente IA.

---

## Instalação

```bash
# Recomendado
uv tool install notebooklm-mcp-cli

# Alternativas
pip install notebooklm-mcp-cli
pipx install notebooklm-mcp-cli

# Sem instalar (on-the-fly)
uvx --from notebooklm-mcp-cli nlm --help
```

Pós-instalação: dois binários disponíveis — `nlm` (CLI) e `notebooklm-mcp` (servidor MCP).

---

## Autenticação

Usa cookies internos extraídos do browser (API não oficial):

```bash
nlm login              # Auto: abre browser, extrai cookies
nlm login --check      # Verifica status
nlm login --profile work  # Multi-conta Google
```

Cookies duram ~2-4 semanas; CSRF token e session ID renovados automaticamente a cada request.

---

## Uso CLI (`nlm`)

```bash
nlm notebook list
nlm notebook create "Research Project"
nlm source add <notebook> --url "https://..."
nlm audio create <notebook> --confirm
nlm download audio <notebook> <artifact-id>
nlm share public <notebook>
nlm research start        # Web research → importa fontes
nlm batch query/create/delete
nlm cross query           # Query cross-notebook
nlm pipeline run/list     # Workflows multi-step
nlm tag add/list/select   # Smart tagging
```

---

## Uso MCP (agentes IA)

Configuração automática para Claude Code, Cursor, Gemini CLI, GitHub Copilot, Windsurf:

```bash
nlm setup add claude-code
nlm setup add gemini
nlm setup add cursor
```

Adicionar manualmente no Claude Code:
```bash
claude mcp add --scope user notebooklm-mcp notebooklm-mcp
```

Config JSON (uvx, sem instalar):
```json
{
  "mcpServers": {
    "notebooklm-mcp": {
      "command": "uvx",
      "args": ["--from", "notebooklm-mcp-cli", "notebooklm-mcp"]
    }
  }
}
```

Expõe **35 ferramentas MCP**: `notebook_list`, `notebook_create`, `source_add`, `notebook_query`, `studio_create`, `download_artifact`, `research_start`, `notebook_share_*`, `batch`, `cross_notebook_query`, `pipeline`, `tag`, etc.

> [!warning] Context Window
> 35 tools MCP = custo alto de contexto. Desabilitar quando não usar NotebookLM. Em Claude Code: `@notebooklm-mcp` para toggle.

---

## AI Skills (opcional)

Instala guia especialista para o agente usar as ferramentas efetivamente:

```bash
nlm skill install claude-code
nlm skill install codex
nlm skill install cline
```

---

## Pontos Técnicos Chave

- **API interna** do NotebookLM (não oficial) — pode mudar sem aviso
- Autenticação via extração de cookies do browser (CDP — Chrome DevTools Protocol)
- Suporte multi-browser: Chrome, Arc, Brave, Edge, Chromium, Vivaldi, Opera
- Multi-perfil Google (contas simultâneas isoladas)
- Queries do CLI/MCP **persistem no chat history da UI web** do NotebookLM
- Upgrade: `uv tool install --force notebooklm-mcp-cli` (evita constraint caching)
- Rate limit free tier: ~50 queries/dia
- HTTP transport suportado (além de stdio padrão)

---

## Capacidades por Categoria

| Categoria | Exemplos |
|-----------|----------|
| Notebooks | list, create, query, share, delete |
| Fontes | URL, texto, YouTube, Google Drive, arquivo local |
| Studio | áudio (podcast), vídeo, briefing, flashcards, infográfico, slides, mind map |
| Research | web research automático, Drive search, import top N |
| Gestão | tags, pipelines, batch ops, cross-notebook query |
| Auth | multi-perfil, auto-refresh, headless browser |

---

## Conexoes

- [[03-RESOURCES/entities/mcp]] — protocolo base do servidor MCP
- [[03-RESOURCES/concepts/mcp-model-context-protocol]] — como MCP conecta agentes a ferramentas
- [[03-RESOURCES/entities/jacob-bd]] — autor do projeto
- [[03-RESOURCES/entities/NotebookLM]] — produto Google integrado
- [[03-RESOURCES/concepts/notebooklm-integration]] — padrão de integração programática ao NotebookLM
- [[03-RESOURCES/concepts/mcp-cli-bridge]] — padrão de unificar CLI + MCP num único pacote
