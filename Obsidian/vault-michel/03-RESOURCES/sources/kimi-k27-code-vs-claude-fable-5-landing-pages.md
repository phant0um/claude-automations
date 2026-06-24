---
title: "Kimi K2.7 Code vs Claude Fable 5: Landing pages that cost 94% less"
type: source
source: "Clippings/Kimi K2.7 Code vs Claude Fable 5 Landing pages that cost 94% less.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
Num experimento com 12 landing pages cada, Kimi K2.7 Code (open-source) custou ~94% menos (16x mais barato) que Claude Fable 5 e entregou qualidade similar — especialmente depois que receberam contexto de design correto via um MCP server customizado de inspiração visual.

## Argumentos principais
- Baseline (prompt puro, sem contexto de design): ambos os modelos produziram páginas "reconhecivelmente geradas por IA" — layout genérico independente do modelo.
- A virada veio de um MCP server customizado de design inspiration, com screenshots de landing pages bem desenhadas e elementos de UI isolados; como Kimi K2.7 Code é multimodal, as imagens entraram diretamente no prompt junto com texto.
- Com inspiração de design, os resultados mudaram significativamente: hierarquia mais forte, tipografia melhor, composição mais intencional — páginas carregaram mais rápido, evitaram placeholders de imagem quebrada, tipografia mais legível.
- Custo por página: exemplo de B2B SaaS custou 4 centavos com Kimi vs US$ 1.09 com Claude Fable (quase 27x mais caro). Em média, Kimi K2.7 Code ficou ~16x mais barato que Fable 5 e ~8x mais barato que Opus 4.8.
- Em workflows generativos reais raramente se gera uma única versão — gera-se várias variações e itera-se nas promissoras; a diferença de preço se acumula rápido mesmo numa tarefa simples como landing page.
- Avaliação de qualidade: GPT-5.5 recebeu uma rubrica para revisar screenshots e código-fonte de cada página e atribuir nota final de 0 a 100 — Claude Fable pontuou mais alto nos dois exemplos comparados, mas a diferença foi relativamente pequena.

## Key insights
- O fator decisivo de qualidade não foi o modelo em si, mas o contexto fornecido (visual references via MCP) — confirma que contexto > capacidade bruta do modelo para tarefas de design.
- Se gerar 100 páginas, a economia com Kimi K2.7 Code seria de ~US$94 comparado a Claude Fable 5 — número usado para ancorar a economia em escala.
- A conclusão prática dos autores: modelos open-source já são capazes de gerar landing pages úteis, mas prompts sozinhos são só parte da equação — o ganho maior veio de melhor contexto, não de troca de modelo.

## Exemplos e evidências
- Site publicado com todos os resultados, custos, uso de tokens e tempo de geração: ovsc.vercel.app — inclui variantes geradas por Claude Opus 4.8, Claude Fable 5 e Kimi K2.7 Code.
- Prompts de teste cobrindo categorias diferentes: dev tool de SQL para gráficos, speakeasy art-deco, SaaS B2B de gestão de projetos.
- Caso "antes/depois" específico mostrado para a landing page do Rooftop Speakeasy.

## Implicações para o vault
Relevante para o tema de model-routing e custo de tokens já documentado no vault (`token-economy`, `model-selection-patterns`): reforça que a decisão de modelo deve considerar contexto fornecido tanto quanto capacidade nominal — um modelo mais barato com bom contexto pode rivalizar com um modelo caro sem contexto. Ponto de comparação útil para decisões futuras de roteamento de modelo no próprio vault (RTK, ctx-mode).

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/model-selection-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/token-economy-cost/token-economy]]
- [[03-RESOURCES/entities/Kimi-K2.6]]
- [[03-RESOURCES/entities/Claude]]
