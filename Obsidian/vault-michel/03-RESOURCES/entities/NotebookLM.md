---
title: NotebookLM
type: entity
category: product
created: 2026-05-09
updated: 2026-05-09
tags: [entity, product, google, notebooklm, ai, research, knowledge-management]
---

# NotebookLM

Produto de IA da Google para pesquisa e síntese de conhecimento. Permite criar notebooks com múltiplas fontes (URLs, PDFs, Google Drive, YouTube, texto) e interagir com elas via chat, além de gerar áudio (podcast), vídeo, slides, briefings, flashcards e infográficos.

**URL:** https://notebooklm.google.com

## Características

- Contexto grounding: respostas baseadas estritamente nas fontes adicionadas
- Studio: geração de conteúdo multimodal (áudio, vídeo, slides, infográficos, mind maps)
- Suporte Google Drive nativo
- Chat history persistente (incluindo queries vindas de CLI/MCP externos)
- Tier free (~50 queries/dia) e Pro/Ultra

## Acesso Programático

Dois wrappers não-oficiais documentados no vault:

**notebooklm-mcp-cli** (jacob-bd) — expõe CLI (`nlm`) e servidor MCP (`notebooklm-mcp`) com 35 ferramentas. Via [[03-RESOURCES/sources/memory-context-rag/jacob-bd-notebooklm-mcp-cli]].

**notebooklm-py** (teng-lin, v0.7.1+) — CLI (`notebooklm ask`, `notebooklm source add`, `notebooklm generate audio`). Login via `notebooklm login` (abre Chromium, importa cookies). Usado no stack Hermes+Obsidian+NotebookLM. Via [[03-RESOURCES/sources/hermes-obsidian-notebooklm-stack]].

> [!warning] API não oficial
> Ambos os wrappers usam APIs internas do NotebookLM (Playwright/CDP) — podem quebrar sem aviso. Enterprise tem API pública standalone. Para consumidor: ter fallback.

## Relações

- [[03-RESOURCES/entities/jacob-bd]] — desenvolvedor do wrapper CLI/MCP
- [[03-RESOURCES/concepts/pkm-obsidian/notebooklm-integration]] — padrão de integração
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — protocolo usado pelo servidor MCP
- [[03-RESOURCES/sources/memory-context-rag/jacob-bd-notebooklm-mcp-cli]] — fonte principal
