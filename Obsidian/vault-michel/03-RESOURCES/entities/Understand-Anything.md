---
title: Understand-Anything
type: entity
categoria: tool/plugin
tags: [claude-code-plugin, knowledge-graph, codebase-analysis, open-source, multi-platform]
created: 2026-05-29
updated: 2026-05-29
---

# Understand-Anything (Lum1104)

Claude Code Plugin (e multi-platform) que converte qualquer codebase, knowledge base ou documentação em knowledge graph interativo explorável visualmente. "Graphs that teach > graphs that impress."

**GitHub:** https://github.com/Lum1104/Understand-Anything  
**Live demo:** https://understand-anything.com/demo/

## Instalação (Claude Code)

```
/plugin marketplace add Lum1104/Understand-Anything
/plugin install understand-anything
```

## Comandos principais

| Comando | Função |
|---------|--------|
| `/understand` | Analisa projeto, constrói knowledge graph |
| `/understand-dashboard` | Abre dashboard web interativo |
| `/understand-chat "pergunta"` | Perguntas em linguagem natural |
| `/understand-diff` | Impacto das mudanças antes de commitar |
| `/understand-explain <arquivo>` | Deep-dive em arquivo/função |
| `/understand-onboard` | Guia de onboarding para novos membros |
| `/understand-domain` | Extrai domínio de negócio do código |
| `/understand-knowledge <path>` | Analisa Karpathy-pattern LLM wiki |
| `/understand --auto-update` | Post-commit hook incremental |

## Arquitetura técnica

- **Tree-sitter (determinístico):** extrai estrutura — imports, funções, classes, call sites. Mesma entrada → mesma saída.
- **LLM (semântico):** produz resumos, tags, layer assignments, business-domain mapping — o que parsers não conseguem.
- **6 agents especializados:** project-scanner, file-analyzer, architecture-analyzer, tour-builder, graph-reviewer, domain-analyzer, article-analyzer
- **Incremental:** só re-analisa arquivos que mudaram; fingerprint-based change detection.
- File analyzers em paralelo: até 5 concorrentes, 20–30 arquivos por batch.

## Feature relevante para vault-michel

`/understand-knowledge` aponta para Karpathy-pattern LLM wiki e produz force-directed knowledge graph com community clustering + descoberta de relacionamentos implícitos + extração de entities. Transformaria `wiki/index.md` do vault em grafo navegável.

## Plataformas suportadas

Claude Code (nativo), Cursor, VS Code + Copilot, Codex, Gemini CLI, KIMI CLI, Cline, Hermes, OpenCode, e mais 5+.

## Sources

- [[03-RESOURCES/sources/open-source-ecosystems/understand-anything-code-knowledge-graph]]
