---
title: "How to Build an AI Second Brain With Claude and Obsidian (Full Course)"
type: source
source: "Clippings/How to Build an AI Second Brain With Claude and Obsidian (Full Course).md"
source_url: "https://x.com/eng_khairallah1/status/2060652660773314833"
author: "@eng_khairallah1 (Khairallah AL-Awady)"
published: 2026-05-30
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, pkm-obsidian-second-brain, second-brain, obsidian, claude, PARA, AI-first-notes]
---

## Tese central

A maioria das pessoas tira notas mas nunca as usa — o diferencial do Obsidian+Claude não é o note-taking mas a camada de inteligência que conecta notas e raciocina sobre elas, transformando arquivos passivos em um segundo cérebro que pensa junto com o usuário.

## Argumentos principais

- Obsidian vs. Notion/Apple Notes/Google Docs: markdown puro em disco = zero friction para AI; qualquer modelo pode ler .md sem export/conversão; sem lock-in proprietário; versionável com Git
- Bidirectional links como superpower: Claude pode seguir [[wikilinks]] e traçar conexões entre notas que o usuário nunca fez manualmente — padrões emergentes em centenas de notas
- Estrutura PARA como base: Inbox / Projects / Areas / Resources / Archive — categorias claras que Claude pode raciocinar sobre
- Três opções de conexão: (A) Claude.ai Projects — mais fácil, manual, sem sync; (B) Claude Code + vault direto + CLAUDE.md — mais poderoso, para devs e power users; (C) MCP Servers — melhor equilíbrio entre poder e facilidade
- MCP options: mcpvault (zero deps, BM25 search, 14 métodos), mcp-obsidian (3K+ stars, requer plugin REST), Obsidian-Skills by Steph Ango (12.9K stars, open Agent Skills spec, 5 skills)
- 5 workflows de alto valor imediato: Weekly Digest, Research Synthesizer, Idea Connector, Knowledge Gap Finder, Daily Briefing
- AI-first note design: frontmatter machine-readable, one-sentence preamble por nota, formatting consistente, fontes com URL+data+citação direta
- Claude como mantenedor do vault: scan de Inbox, move para Archive, encontra orphan notes, sugere links — elimina o gargalo de manutenção que mata sistemas PKM

## Key insights

- "Most people take notes. Almost nobody uses them." — o problema não é captura, é uso
- Obsidian cruzou 1,5 milhão de usuários em 2026 — o driver não é note-taking puro, é AI integration
- Diferença crítica: AI + notes = útil; AI + **connected** notes = superpoder — Claude segue wikilinks e encontra padrões que humano nunca encontraria manualmente
- Para Claude Code: adicionar ao CLAUDE.md → "My Obsidian vault is at ~/path. Use as persistent knowledge base. Search relevant notes first. Save summaries as new notes."
- Efeito composto: vault de 1 semana = app de notas; 1 mês = referência útil; 6 meses = knowledge engine que nenhum Google substitui
- "The person who builds this system now and maintains it for six months will have something that gives them a genuine, unreplicable advantage."

## Exemplos e evidências

- Obsidian: 1,5M usuários em 2026
- Obsidian-Skills by Steph Ango (CEO Obsidian): 12.900+ GitHub stars, open Agent Skills spec
- mcp-obsidian: 3.000+ GitHub stars
- Workflow Weekly Digest concreto: query sobre notas com tag #meeting-notes da última semana → Claude sintetiza key decisions, action items, open questions, patterns
- Workflow Idea Connector: busca notas relacionadas a [[Current Project]] mas não linkadas — surfaça buried knowledge de 6 meses atrás
- Frontmatter recomendado: tags, dates, project links, status

## Implicações para o vault

- Este vault **é** exatamente o sistema descrito — validação externa do design atual
- A recomendação de AI-first note design confirma as práticas já adotadas (frontmatter, wikilinks, PARA adaptado)
- A opção B (Claude Code + CLAUDE.md) é a configuração atual do vault — reforça que estamos no tier mais poderoso
- O conceito de "orphan notes" com zero incoming links é um audit útil a realizar periodicamente
- O Obsidian-Skills by kepano (12.9K stars) já está documentado em [[03-RESOURCES/sources/pkm-obsidian-second-brain/clipping-kepano-obsidian-skills]]

## Links
- [[03-RESOURCES/entities/Obsidian]]
- [[03-RESOURCES/entities/Khairallah-AL-Awady]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/claude-obsidian-second-brain-guide]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/clipping-kepano-obsidian-skills]]
- [[03-RESOURCES/concepts/pkm-obsidian/]]
