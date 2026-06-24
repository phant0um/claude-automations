---
title: "Grok Build 0.1 Beat Every Frontier Model in a Kilo Code Reviews Test"
type: source
source: "Clippings/Grok Build 0.1 Beat Every Frontier Model in a Kilo Code Reviews Test.md"
created: 2026-06-17
ingested: 2026-06-21
tags: [ai-agents, code-review-benchmarks]
---

## Tese central
Teste informal mas bem desenhado (Kilo Code DevRel): React/TS to-do app com 10 bugs plantados, 8 modelos revisando o mesmo working tree não commitado em worktrees isolados via Kilo Agent Manager. Grok Build 0.1 encontrou todos os 10 bugs (custo $0.29) — superando Opus 4.8 (7), Sonnet 4.6 e GPT-5.5 (8 cada), Gemini 3.1 Pro (6), todos mais caros.

## Argumentos principais
- Isolamento por git worktree por sessão é o que torna a comparação válida — nenhuma sessão vê output de outra, todas partem do mesmo estado idêntico confirmado por diff.
- O bug mais discriminante não é detectável por lint/tipo/teste: é uma inconsistência entre 4 write paths (3 deles fixam `updatedAt`, o 4º não) — só é encontrável comparando funções entre si, não analisando cada uma isoladamente. 7 dos 8 modelos (incluindo Opus 4.8, GPT-5.5, Sonnet 4.6) erraram esse caso.
- Prompt idêntico e minimalista para todos ("Review the uncommitted changes") — sem dica de quantidade ou categoria de bugs, maximizando validade do teste de cobertura real.

## Key insights
- O bug "campo não-setado em 1 de 4 write paths simétricos" é uma classe de erro estruturalmente invisível a qualquer ferramenta estática — só emerge de raciocínio cross-função, e modelos com mais "raciocínio agêntico" aparente nem sempre vencem aqui (Opus e GPT-5.5 erraram).
- Resultado é evidência empírica (não benchmark oficial, mas reprodutível via repo público) de que custo e qualidade de code review não estão necessariamente correlacionados — Grok venceu em ambos simultaneamente neste teste específico.

## Exemplos e evidências
- Repositório público reprodutível: github.com/Kilo-Org/kilocode. Tabela de detecção por modelo e por categoria de bug (hooks, lógica invertida, datas, integridade de dados, robustez).

## Implicações para o vault
Dado pontual de comparação de modelos para code review — relevante para decisões de `model-router` se o vault algum dia avaliar code review automatizado de seus próprios scripts/agentes (ex.: revisão de `04-SYSTEM/agents/`).

## Links
- [[03-RESOURCES/concepts/agent-systems/coding-agents]]
