---
title: "Claude Enterprise Search"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# Claude Enterprise Search

Claude conectado a bases de conhecimento corporativo para busca semântica sobre documentação interna, sem expor dados fora do perímetro da empresa.

## O que é

Claude Enterprise Search é a capacidade de integrar Claude a repositórios de conhecimento interno: SharePoint, Confluence, Notion, Google Drive, e ferramentas como **Glean** (search engine corporativo unificado). O modelo responde perguntas usando documentos privados como contexto — não apenas seu treinamento.

## Como funciona

**Arquitetura geral (RAG pattern):**
1. Conector MCP (ou plugin) indexa a base de conhecimento e expõe uma ferramenta de busca
2. Claude recebe a query do usuário, chama a ferramenta de busca, recebe chunks relevantes
3. Resposta fundamentada nos documentos recuperados

**Glean:** search engine empresarial que indexa 100+ fontes (e-mail, docs, tickets, wikis) e expõe API. O conector Claude ↔ Glean permite que o modelo consulte o Glean como uma tool, retornando snippets rankeados por relevância semântica.

**Privacy-first:** documentos não saem do ambiente corporativo; apenas os chunks relevantes são enviados ao modelo como contexto da chamada de API.

## Por que importa

Padrão relevante para entender como o vault-michel funciona em miniatura: `hot.md` + `wiki-index` são o "enterprise search" do vault — contexto quente que o modelo consulta para responder com base no conhecimento acumulado, sem precisar ler todos os arquivos.

## Related
- [[03-RESOURCES/entities/Glean]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/claude-ecosystem]]
