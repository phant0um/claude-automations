---
title: "Claude Code + NotebookLM + Obsidian: Research Monster"
type: source
source: "Clippings/Claude Code + NotebookLM + Obsidian Research Monster That Gets Smarter Every Time You Use It.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, obsidian, notebooklm, research-workflow, pkm]
---

## Tese central

Stack de pesquisa com 4 camadas (Claude Code + Skill Creator + NotebookLM + Obsidian) cria um sistema que fica mais inteligente com cada uso: Claude Code executa e orquestra, NotebookLM faz análise pesada com compute Google (sem consumir tokens Claude), Obsidian armazena outputs e ensina Claude a padrões do usuário ao longo do tempo.

## Argumentos principais

- **Divisão de responsabilidades por layer** — (1) Claude Code: execution engine + orquestração, (2) Skill Creator: customização em linguagem natural, (3) NotebookLM: análise pesada (Google compute, não tokens Claude), (4) Obsidian: memória persistente que ensina o sistema
- **NotebookLM como compute offload** — análises densas (summaries, infographics, flashcards, podcast scripts) delegadas ao NotebookLM; Claude economiza tokens para orquestração
- **Obsidian como feedback loop** — ao longo do tempo, Claude lê os arquivos Obsidian e aprende como o usuário pensa, o que importa, e como quer análises entregues
- **Setup em menos de 30 minutos** — stack é acessível, não requer programação com Skill Creator

## Key insights

- O vault já implementa a camada 4 (Obsidian como memória) — a novidade seria integrar NotebookLM para offload de análises pesadas
- "Gets smarter every time you use it" = feedback loop via Obsidian, não aprendizado do modelo em si
- Claude Code como orchestration engine + Obsidian como persistent memory = vault atual já tem esse padrão

## Implicações para o vault

- Considerar NotebookLM para análise de clippings longos em vez de processar via Sonnet
- O feedback loop Obsidian→Claude Code é o que o vault já faz via hot.md + memory/

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
