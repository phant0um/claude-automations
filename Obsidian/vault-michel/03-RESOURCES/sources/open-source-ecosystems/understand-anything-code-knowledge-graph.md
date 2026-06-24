---
title: "Lum1104/Understand-Anything: Turn any code into an interactive knowledge graph"
type: source
source: "Clippings/Lum1104Understand-Anything Graphs that teach > graphs that impress. Turn any code into an interactive knowledge graph you can explore, search, and ask questions about. Works with Claude Code, Codex, Cursor, Copilot, Gemini CLI, and more..md"
source_url: "https://github.com/Lum1104/Understand-Anything"
author: "Lum1104"
published: 2026-05-28
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, knowledge-graph, claude-code-plugin, codebase-analysis, tree-sitter, multi-agent, rag]
---

## Tese central

Understand-Anything é um Claude Code Plugin (e multi-platform) que converte qualquer codebase, knowledge base ou documentação em um knowledge graph interativo explorável visualmente. O objetivo não é impressionar com a complexidade — é ensinar como cada peça se encaixa. Usa pipeline multi-agent com Tree-sitter (análise estática determinística) + LLM (semântica e intent) para construir um grafo que é simultaneamente reproduzível e expressivo.

## Argumentos principais

- **O problema que resolve:** "You just joined a new team. The codebase is 200,000 lines of code. Where do you even start?" — codebase reading é blind. Understand-Anything cria um dashboard interativo para explorar tudo visualmente.
- **Instalação (Claude Code nativo):**
  ```
  /plugin marketplace add Lum1104/Understand-Anything
  /plugin install understand-anything
  ```
- **Comandos principais:**
  - `/understand` — analisa projeto, extrai arquivos/funções/classes/dependências, constrói knowledge graph salvo em `.understand-anything/knowledge-graph.json`
  - `/understand-dashboard` — abre dashboard web interativo (pan, zoom, search, click em nós)
  - `/understand-chat "How does the payment flow work?"` — perguntas em linguagem natural sobre o codebase
  - `/understand-diff` — analisa impacto das mudanças atuais antes de commitar
  - `/understand-explain src/auth/login.ts` — deep-dive em arquivo ou função específica
  - `/understand-onboard` — gera guia de onboarding para novos membros
  - `/understand-domain` — extrai conhecimento de domínio de negócio (domains, flows, steps)
  - `/understand-knowledge ~/path/to/wiki` — analisa Karpathy-pattern LLM wiki (!)
  - `/understand --auto-update` — post-commit hook para incrementalmente atualizar o grafo
  - `/understand src/frontend` — escopo para subdiretório (monorepos grandes)
- **Features principais:**
  - **Structural graph:** cada arquivo, função e classe é um nó clicável com resumos em linguagem natural
  - **Business logic view:** como código mapeia para processos reais de negócio — domains, flows, steps em horizontal graph
  - **Analyze knowledge bases:** `/understand-knowledge` aponta para Karpathy-pattern LLM wiki e produz force-directed knowledge graph com community clustering. Parser determinístico extrai wikilinks e categorias do `index.md`, depois LLM agents descobrem relacionamentos implícitos, extraem entities, surfaceam claims — transformando wiki em grafo navegável de ideias interconectadas.
  - **Guided tours:** walkthroughs auto-gerados da arquitetura, ordenados por dependência
  - **Fuzzy & semantic search:** busca por nome ou por significado ("which parts handle auth?")
  - **Diff impact analysis:** veja quais partes do sistema suas mudanças afetam antes de commitar
  - **Persona-adaptive UI:** ajusta nível de detalhe baseado em quem você é (junior dev, PM, power user)
  - **Layer visualization:** agrupamento automático por camada arquitetural (API, Service, Data, UI, Utility) com legenda por cor
  - **Language concepts:** 12 padrões de programação (generics, closures, decorators, etc.) explicados em contexto onde aparecem
- **Multi-platform (não só Claude Code):** Codex, Cursor, VS Code + GitHub Copilot, Copilot CLI, Gemini CLI, KIMI CLI, Cline, Hermes, OpenCode, OpenClaw, Antigravity, Vibe CLI, Pi Agent, Trae.
  - One-line install para a maioria: `curl -fsSL https://raw.githubusercontent.com/Lum1104/Understand-Anything/main/install.sh | bash`
  - Cursor: auto-discovery via `.cursor-plugin/plugin.json`
  - VS Code: auto-discovery via `.copilot-plugin/plugin.json`
- **Arquitetura técnica — Tree-sitter + LLM hybrid:**
  - **Tree-sitter (determinístico):** parses source em concrete syntax tree, extrai imports/exports/definições de funções e classes/call sites/herança. Pre-resolução em `importMap` durante scan phase. Mesma entrada → mesma saída, toda run. Também usada para fingerprint-based change detection (updates incrementais).
  - **LLM (semântico):** lê estrutura parseada + source original para produzir o que parsers não conseguem: resumos em linguagem natural, tags, atribuição de camada arquitetural, mapeamento de domínio de negócio, guided tours, callouts de conceitos de linguagem.
  - "This split is why the graph is reproducible on the structural side while still capturing intent on the semantic side (what a file is *for*, not just what it imports)."
- **Pipeline multi-agent (6 agents especializados):**
  | Agent | Função |
  |-------|--------|
  | `project-scanner` | Descobrir arquivos, detectar linguagens e frameworks |
  | `file-analyzer` | Extrair funções, classes, imports; produzir nós e edges do grafo |
  | `architecture-analyzer` | Identificar camadas arquiteturais |
  | `tour-builder` | Gerar walkthroughs de aprendizado guiado |
  | `graph-reviewer` | Validar completude e integridade referencial do grafo |
  | `domain-analyzer` | Extrair domínios de negócio, flows e process steps |
  | `article-analyzer` | Extrair entities, claims e relacionamentos implícitos de artigos wiki |
  - File analyzers rodam em paralelo (até 5 concorrentes, 20–30 arquivos por batch). Suporta updates incrementais — só re-analisa arquivos que mudaram desde a última run.
- **Git integration:**
  - O grafo é JSON — **commitar uma vez e teammates pulam o pipeline** (útil para onboarding, PR reviews, docs-as-code).
  - O que não commitar: `intermediate/` e `diff-overlay.json` (scratch local).
  - Para grafos grandes (10MB+): usar git-lfs.
- **`/understand-knowledge` e Karpathy-pattern wikis:** Esta feature é especialmente relevante — aponta para qualquer LLM wiki no padrão Karpathy e produz grafo com clustering comunitário, descoberta de relacionamentos implícitos e extração de entities. Transforma wiki textual em grafo navegável.
- **Live demo:** https://understand-anything.com/demo/

## Key insights

- "The goal isn't a graph that wows you with how complex your codebase is — it's a graph that quietly teaches you how every piece fits together."
- A divisão Tree-sitter/LLM é a arquitetura ideal: determinismo onde estrutura importa, semântica onde intent importa.
- `/understand-knowledge` com Karpathy-pattern wikis é especialmente relevante para o vault-michel: transformaria o `wiki/index.md` em grafo navegável com clustering e descoberta de relacionamentos implícitos.
- Multi-platform agnostic: mesmo plugin funciona em Claude Code, Cursor, VS Code, Gemini CLI — não há lock-in.
- Incremental updates via post-commit hook: grafo sempre atualizado sem re-run completa.
- Persona-adaptive UI: o mesmo grafo apresenta informação diferente para júnior dev vs PM vs power user.

## Exemplos e evidências

- Trending no Trendshift (repositório #23482).
- Exemplo de referência: GoogleCloudPlatform/microservices-demo (fork) — Go/Java/Python/Node com grafo commitado.
- Community walkthrough por Better Stack (YouTube): https://www.youtube.com/watch?v=VmIUXVlt7_I
- 15+ plataformas de AI coding suportadas oficialmente.

## Implicações para o vault

- **Alta relevância para vault-michel:** `/understand-knowledge` apontado para o wiki do vault produziria grafo de todos os concepts e entities com clusters de comunidade — visualização do segundo cérebro.
- Instalação no Claude Code é trivial: dois comandos. Vale experimentar em sessão dedicada.
- `article-analyzer` agent extrai entities e claims implícitas de artigos wiki — complementaria o processo de ingestão existente.
- O pattern Tree-sitter + LLM é inspiração para a arquitetura do `ingest-report` agent: análise determinística de estrutura + LLM para semântica.
- Post-commit hook (`/understand --auto-update`) poderia manter mapa do vault sempre atualizado após cada commit.

## Links

- [[03-RESOURCES/entities/Understand-Anything]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/claude-code-tooling/knowledge-graph-code]]
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/concepts/pkm-obsidian/self-writing-vault]]
