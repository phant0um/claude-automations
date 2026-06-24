---
title: "Perplexity Routine"
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-09
tags: [concept, perplexity, rotinas, produtividade, knowledge-management]
---

# Perplexity Routine

Padrão de uso do [[03-RESOURCES/entities/Perplexity-AI]] como motor de rotinas semanais estruturadas, substituindo browsing manual e newsletters avulsas por prompts recorrentes com saída padronizada.

## Princípio Central

Cada domínio de interesse recebe um slot fixo no calendário semanal e um prompt dedicado ≤ 2.000 caracteres. O resultado é previsível, comparável semana a semana e integrável ao [[03-RESOURCES/concepts/pkm-obsidian/weekly-knowledge-routine]].

## Diferenciação por Tipo de Consumo

**Consumível** (útil na semana, sem necessidade retroativa): briefing de notícias, cultura nerd, CrossFit, viagens, tech/IA, câmbio, automação Apple.

**Acumulável via NotebookLM** (conteúdo cresce em valor ao longo do tempo): julgados STF/STJ/TCU, agenda normativa, concursos públicos, radar de carteira, boletim AI Agents.

## Anatomia de um Prompt de Rotina

1. Persona: "Atue como [papel]"
2. Escopo temporal: "últimos 7 dias" / "última semana"
3. Seções fixas com headers Markdown
4. Regras de saída: tempo de leitura alvo, formato, omissão de seções vazias
5. Limite de caracteres (≤ 2.000)

## Referências

- [[03-RESOURCES/sources/guides-courses-howtos/prompts-perplexity-rotinas-semanais-otimizadas]] — coleção completa v3.0
- [[03-RESOURCES/concepts/pkm-obsidian/weekly-knowledge-routine]] — framework geral
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-templates-pt]] — templates reutilizáveis PT-BR

## Evidências
- **[2026-06-24]** 所有人都在比谁的 Deep Research AI 找得更多、更快、更全。但 2026 年的 benchmark 数据告诉你一件令人意外的事：头部产品在“找信息”上已经几乎打平，真正把系统拉开的，是另一件事：谁能在推理过程中，不积累错误。一 — [[]]
