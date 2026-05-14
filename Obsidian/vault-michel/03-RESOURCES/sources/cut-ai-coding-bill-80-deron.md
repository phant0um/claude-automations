---
title: "How To Cut Your AI Coding Bill by 80% (FULL GUIDE)"
type: source
source_file: Clippings/How To Cut Your AI Coding Bill by 80% (FULL GUIDE).md
origin: artigo
author: "@DeRonin_"
published: 2026-05-12
ingested: 2026-05-14
tags: [token-economics, cost-optimization, model-routing, prompt-caching, kimi, ai-coding]
---

# How To Cut Your AI Coding Bill by 80% (FULL GUIDE)

> [!key-insight] Core insight
> O problema não é o preço dos modelos — é contexto desnecessário. O fix real é context discipline + routing multi-model, com Kimi 2.6 como workhorse diário no lugar de Sonnet (6x mais barato, qualidade equivalente em 90% das tarefas).

## Os 4 Tipos de Tokens

| Tipo | Custo relativo | Nota |
|---|---|---|
| Input | Base | O que você envia |
| Output | 3–5x mais caro | O que o modelo retorna |
| Cached | ~10% do input | Prefixo imutável cacheado |
| Reasoning | Igual output | Invisível mas cobrado |

## As 5 Armadilhas de Token

1. **Re-sending entire repo** — auto-context carrega 50 arquivos a cada turno; fix: grep before fetch, turn off auto-context for stable files
2. **Tool call loops que espiralam** — cada "let me check" paga contexto completo novamente; fix: batch tool calls, deterministic helpers
3. **Premium model para tasks triviais** — Opus para "fix this typo"; fix: routing por task type
4. **Streaming vs batching errado** — streaming derrota prompt caching em alguns workflows; fix: batch para background agents
5. **Context bloat "just in case"** — incluir arquivos que talvez sejam necessários; fix: grep first, agent requests files it needs

## Routing Decision Tree

```
Task de arquitetura/segurança? → Opus 4.6 / GPT-5 (10% do trabalho)
Implementação seria / refactor / debug? → Kimi 2.6 (90% do trabalho)
Lint / format / edits triviais? → Haiku 4.5
Boilerplate / autocomplete? → Ollama local (gratuito)
```

## Kimi 2.6 como Workhorse

- Preço: ~$0.50/$2 por M tokens (vs Sonnet $3/$15 = 6x mais barato)
- Qualidade: match com Sonnet em refactors, debugging, implementação, loops longos
- Contexto: 256k window, coerência equivalente ao Sonnet em long-context
- Rate limits: mais generosos que Sonnet
- Benchmark: Refactor 500 linhas → Kimi $0.04 / qualidade 9.2 vs Sonnet $0.12 / qualidade 9.0

## 7 Técnicas Práticas

1. Enable prompt caching everywhere (90% de redução em tokens estáveis)
2. Grep before fetching (`rg "symbol" --type ts -B 5 -A 20`)
3. Profile tool calls (`--verbose-tools`, analisar top 3 loops)
4. Graduated skill pattern (salvar workflows como SKILL.md elimina fase de discovery)
5. Local models (Ollama + Qwen3 para autocomplete = $0)
6. Summarize aggressively (200k tokens → 5k summary a cada 10–15 turns)
7. Batch small requests (10 perguntas em 1 prompt = 70–90% de saving em input)

## Plano de 30 Dias

- Semana 1: caching + desligar auto-context + instalar ripgrep → −30–40%
- Semana 2: switch default para Kimi 2.6 → −40–55% adicional
- Semana 3: profile + fix top 3 tool loops → −10–20% adicional
- Semana 4: SKILL.md + Ollama local → −5–10% adicional

Resultado: $4.200/mês → $312/mês (7.5% do custo original)

## Conexões

- [[03-RESOURCES/entities/Kimi-K2.6]] — modelo workhorse recomendado; atualizar com dados de preço
- [[03-RESOURCES/concepts/prompt-caching]] — técnica #1 de saving
- [[03-RESOURCES/concepts/claude-skills]] — SKILL.md pattern para graduação de workflows
- [[03-RESOURCES/concepts/context-engineering]] — context discipline é o lever real
- [[03-RESOURCES/entities/DeRonin]] — autor; @DeRonin_ no X
- [[03-RESOURCES/concepts/model-routing]] — novo conceito; ver abaixo
