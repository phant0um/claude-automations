---
title: agent-tool-surface-hierarchy
type: concept
domain: agent-systems
created: 2026-05-31
updated: 2026-05-31
tags: [ai-agents, tool-design, reliability, personal-agents, codex]
---

# Agent Tool Surface Hierarchy

A confiabilidade de um agente é diretamente função da qualidade da superfície de ferramenta disponível. Hierarquia em ordem decrescente de preferência:

```
API e CLI
  >
arquivo local
  >
browser automation
  >
screen automation
```

## Princípio

Cada nível inferior é "aceitável mas não o happy path." Um comando como `gog gmail messages list` ou `wacli messages list --json` é muito mais fácil para o modelo inspecionar, fazer retry e raciocinar do que pedir ao modelo para clicar em um site.

## Regra prática

> Reduza ao máximo as camadas de abstração entre o modelo e as APIs.

- **API e CLI**: retorno em JSON/texto estruturado, IDs estáveis, sem estado visual, retry fácil
- **Arquivo local**: legível, editável, upload de volta sem cerimônia (Markdown, CSV preferidos)
- **Browser automation**: necessário quando não há API — brittle, mas funcional
- **Screen automation**: último recurso; depende de layout e estado visual

## Implicações para design de agente

1. Se uma ferramenta não tem API, construa um CLI wrapper antes de usar browser automation
2. Formatos agent-readable: Markdown, CSV, JSON — não Notion databases, não UI-native structures
3. IDs de arquivo estáveis (Drive file IDs) permitem search → download → edit → upload sem perda de proveniência

## Evidência

@nicbstme (mai 2026): agente Codex gerenciando emails, WhatsApp, Telegram, iMessage, Google Drive — a hierarquia é explícita na arquitetura do stack. A mesma lógica aparece em Hermes Agent, OpenClaw e Claude Code.

## Relacionado

- [[03-RESOURCES/sources/ai-agents-harness/my-agent-stack-personal-life-nicbstme]] — origem
- [[03-RESOURCES/concepts/pkm-obsidian/personal-corpus]] — fonte da verdade agent-readable
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — skills como procedimentos sobre essa hierarquia
