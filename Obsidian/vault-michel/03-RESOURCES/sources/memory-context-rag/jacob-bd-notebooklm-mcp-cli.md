---
title: "notebooklm-mcp-cli — Programmatic Access to Google NotebookLM"
type: source
source_file: "clippings/jacob-bdnotebooklm-mcp-cli.md"
author: "Jacob (jacob-bd)"
ingested: 2026-05-09
tags: [notebooklm, mcp, cli, claude-code, integration, python, google, ai-tools]
triagem_score: 7
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

## Por que NotebookLM precisa de acesso programático

NotebookLM sem automação tem um problema de escala. A interface web permite criar notebooks, adicionar fontes, e fazer queries — mas tudo manualmente, um por um. Para workflows de pesquisa sérios (100+ fontes, queries cross-notebook, geração em batch de áudio/slides), a interface web é o gargalo.

O `notebooklm-mcp-cli` resolve isso expondo as mesmas capacidades como chamadas de terminal ou chamadas MCP. Um agente pode criar 10 notebooks, adicionar 50 fontes via URL, fazer 20 queries paralelas, e baixar os resultados — sem interação humana na interface.

O custo desse poder: é uma API *não oficial*, construída em cima da API interna do NotebookLM via CDP (Chrome DevTools Protocol). Google pode quebrar a compatibilidade a qualquer momento. Usar em produção requer aceitar esse risco.

## Padrão CLI + MCP em um pacote — design pattern

A decisão de empacotar CLI e servidor MCP juntos (um `pip install` dá os dois binários) é um pattern de design bem pensado:

**Para exploração**: `nlm` CLI permite testar funcionalidades interativamente — `nlm notebook list`, `nlm source add`, `nlm audio create`. Você entende o que o sistema pode fazer sem escrever código de agente.

**Para automação**: `notebooklm-mcp` expõe as mesmas capacidades como ferramentas que o agente Claude chama autonomamente. A mesma lógica, dois modos de acesso.

Esse pattern (CLI para humanos, MCP para agentes) é a arquitetura certa para ferramentas que servem tanto usuários interativos quanto agentes autônomos. O repositório `ToolSearch` deste vault usa lógica similar.

## Autenticação via cookies — implicações de segurança

O sistema de login usa CDP para extrair cookies da sessão do Google do browser local. Isso funciona porque o NotebookLM não tem API pública com OAuth — a única forma de autenticar programaticamente é interceptar a sessão web.

**Implicações:**
- Cookies ficam armazenados localmente (diretório de configuração do `nlm`)
- Qualquer processo com acesso ao sistema de arquivos pode ler os cookies
- Em ambientes compartilhados (CI/CD, servidores), isso é um risco de segurança real
- Em máquina pessoal local-first (como este vault), o risco é aceitável

Para uso local com Obsidian + Claude Code em máquina pessoal, o modelo de segurança é compatível. Para automação em servidores ou pipelines de equipe, evitar.

## Cross-notebook query — capacidade diferenciadora

A maioria das integrações com NotebookLM trata notebooks como silos isolados. O `notebooklm-mcp-cli` expõe `cross_notebook_query` — a capacidade de fazer uma query que atravessa múltiplos notebooks simultaneamente.

Para workflows de pesquisa, isso é transformador. Cenário: você tem notebooks separados para cada paper de um tema de pesquisa. Sem cross-notebook query, você faz a mesma query em cada notebook manualmente. Com `nlm cross query "qual a metodologia de coleta de dados usada"`, você recebe síntese cross-notebook em uma chamada.

Aplicação no vault: notebooks de pesquisa por tema (`ia-agentica`, `arquitetura-llm`, `concurso-logica`) podem ser consultados em conjunto para sínteses cross-tema.

## Rate limit do tier gratuito — planejamento de uso

O free tier do NotebookLM tem limite de ~50 queries/dia. Para uso casual, isso é suficiente. Para workflows automatizados (Daily Brief, cross-notebook synthesis, batch processing), 50 queries podem ser consumidas em uma única automação.

Estratégias para manter dentro do limite:
- Usar `nlm cross query` para queries que precisam de múltiplos notebooks (1 chamada em vez de N)
- Agendar automações para fora do horário de uso manual
- Usar o CLI para queries interativas e reservar MCP para automações de alto valor

O NotebookLM Plus (~$20/mês) remove o rate limit. Para usuários que integram NotebookLM em pipelines de pesquisa sérios, o custo é justificado.

## Integração com este vault

O workflow descrito em `clippings-batch-2026-04-27.md` (Claude Code → NotebookLM → Obsidian) usa exatamente este pacote como bridge. O `notebooklm-mcp-cli` permite:

1. Claude Code envia fontes ao NotebookLM via `source_add`
2. Faz queries via `notebook_query`
3. Resultados retornam com citações de passagem
4. Claude Code escreve wikilinks no vault apontando para as fontes

O `@notebooklm-mcp` toggle no Claude Code (mencionado no warning de context window) é exatamente isso: desabilitar o MCP quando não está sendo usado para não inflar o contexto com 35 definições de ferramentas.

## Conexoes

- [[03-RESOURCES/entities/mcp]] — protocolo base do servidor MCP
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — como MCP conecta agentes a ferramentas
- [[03-RESOURCES/entities/jacob-bd]] — autor do projeto
- [[03-RESOURCES/entities/NotebookLM]] — produto Google integrado
- [[03-RESOURCES/concepts/pkm-obsidian/notebooklm-integration]] — padrão de integração programática ao NotebookLM
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-cli-bridge]] — padrão de unificar CLI + MCP num único pacote
