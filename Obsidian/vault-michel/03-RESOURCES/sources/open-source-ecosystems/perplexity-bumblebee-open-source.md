---
title: "Perplexity Is Open-Sourcing Bumblebee"
type: source
source_url: "https://www.perplexity.ai/hub/blog/perplexity-is-open-sourcing-bumblebee"
author: "[[Perplexity-AI]]"
published: 2026-05-21
ingested: 2026-05-28
tags: [security, supply-chain, developer-tools, open-source, mcp, go, endpoint-scanner]
---

# Perplexity Is Open-Sourcing Bumblebee

## Tese central

Bumblebee é um scanner read-only open-source (Go) que verifica máquinas de desenvolvedores em busca de pacotes, extensões e configs de ferramentas de IA expostos a vulnerabilidades de supply-chain — com suporte explícito a configs MCP.

## Key insights

- **Read-only por design:** nunca executa install scripts, nunca invoca npm/pip/bun, nunca lê source files. Previne que o scan seja o próprio vetor de ataque (postinstall worms).
- **Superfícies cobertas:** language package managers (npm, PyPI, Go, Ruby, etc.), configs de AI agents (MCP), extensões de editor (VS Code family), extensões de browser (Chromium + Firefox).
- **Três perfis:** Baseline (scan rotineiro), Project (repo/workspace específico), Deep (resposta a incidentes ativos).
- **Pipeline interno da Perplexity:** threat signal → Perplexity Computer cria catalog update → human review → PR mergeado → Bumblebee roda nos endpoints → findings enviados ao security team.
- **MCP como superfície de segurança:** Bumblebee inclui MCP configs explicitamente — reconhecimento de que MCP servers são vetor de supply-chain.
- **Disponível:** Go open-source para macOS e Linux. https://github.com/perplexityai/bumblebee

## Implicações para o vault

- Relevante para `04-SYSTEM/agents/guard` — Bumblebee é uma implementação de referência de security scanning para ambientes com MCP.
- Confirma que MCP configs são superfície de ataque reconhecida pela indústria — argumento para auditoria periódica dos MCPs do vault.
- Complementa [[03-RESOURCES/sources/skills-prompting-mcp/clipping-mcp-a-deep-dive]] sobre riscos de MCP.

## Links

- [[03-RESOURCES/entities/Perplexity-AI]]
- [[03-RESOURCES/entities/Perplexity-Computer]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
