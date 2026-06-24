---
title: Markup Drift
type: concept
status: developing
tags: [html, llm-workflow, output-format, iteration, technical-debt]
created: 2026-05-09
updated: 2026-05-09
---

# Markup Drift

Fenômeno que ocorre quando um documento HTML é editado repetidamente por um LLM ao longo de 5–10 iterações: o arquivo acumula múltiplos sistemas de espaçamento, esquemas de cor e estruturas de markup incompatíveis, sem que nada pareça quebrado na superfície. Nomeado por [[03-RESOURCES/entities/the-smart-ape]] no thread "md or html?".

## Mecânica

Ao modificar uma frase em HTML styled, o LLM reescreve o markup circundante "para limpar" — classes mudam, spacing tokens mudam, SVGs são re-emitidos com coordenadas ligeiramente diferentes. Nenhuma mudança visível, mas tudo está se deslocando por baixo.

Resultado após v8 vs v1: metade do arquivo é noise não relacionado a mudanças de conteúdo.

Comparação:
- MD edit: ~5 linhas de diff
- HTML edit equivalente: 40–100 linhas de diff

## Por Que Ocorre

LLMs não editam HTML da forma que editam Markdown. O modelo "vê" o documento inteiro e tende a re-estabilizar o markup durante edições parciais — comportamento emergente do treinamento em código HTML completo.

## Consequência Prática

HTML é um **formato de publicação**, não um formato de iteração.

Regra de thumb: se o doc será editado mais de 2–3 vezes → MD ou padrão híbrido.

## Mitigações Parciais

- MDX e Markdoc separam conteúdo de markup, reduzindo drift.
- Padrão híbrido: manter fonte em MD, gerar HTML on-demand.

## Relação com outros conceitos

- [[03-RESOURCES/concepts/pkm-obsidian/format-decision-framework]] — markup drift é um dos critérios do lifecycle vote
- [[03-RESOURCES/concepts/dev-foundations/html-as-llm-artifact]] — limitação a considerar ao usar HTML como artefato primário
- [[03-RESOURCES/concepts/dev-foundations/single-file-html-pattern]] — o padrão throwaway mitiga drift pois o arquivo não é reutilizado

## Fontes

- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-md-or-html-format-decision]] — fonte que nomeou e quantificou o fenômeno
