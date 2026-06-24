---
title: "When AI builds itself"
type: source
source: "Clippings/When AI builds itself.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, recursive-self-improvement, anthropic, ai-safety, future-of-work]
---

## Tese central

A Anthropic está delegando uma parcela crescente do desenvolvimento de IA para os próprios sistemas de IA, acelerando o progresso em direção à melhoria recursiva autônoma — um estado onde AI sistemas podem projetar e desenvolver seus próprios sucessores. O artigo apresenta evidências internas e públicas desse progresso, além de discutir três cenários futuros e as implicações para governança e segurança.

## Argumentos principais

- Mais de 80% do código mergeado na codebase da Anthropic em maio de 2026 foi autorado por Claude; engenheiros típicos mergiam 8x mais código por dia em Q2 2026 versus 2024.
- O horizonte de tarefas que Claude consegue completar com 50% de confiabilidade dobrou a cada 4 meses: de 4 minutos (Claude Opus 3, março 2024) para 1h30 (Sonnet 3.7, 2025) para 12 horas (Opus 4.6, 2026).
- SWE-bench (engenharia de software real) foi de low single digits para saturação em 2 anos. CORE-Bench (reprodução de pesquisa) foi de 20% para saturação em 15 meses.
- Claude Mythos Preview operou por "pelo menos" 16 horas no benchmark METR — "no limite superior do que o METR consegue medir sem novas tarefas."
- Na tarefa de otimização de código de treinamento: Claude Opus 4 atingiu ~3x speedup em maio de 2025; Claude Mythos Preview atingiu ~52x em abril de 2026. Um humano habilidoso leva 4–8 horas para atingir 4x.
- Claude Mythos Preview superou a escolha humana em 64% dos próximos passos de sessões de pesquisa open-ended (vs. 51% do Opus 4.5 em novembro de 2025).

## Key insights

- A brecha que separa Claude de substituição total humana é "research taste" — escolher quais problemas vale trabalhar, quando confiar nos resultados, e quando uma abordagem é dead-end.
- O experimento de pesquisa autônoma de safety (abril 2026): agentes recuperaram 97% do gap de performance em 800 horas acumuladas e $18k de compute; dois humanos recuperaram 23% em uma semana. Porém o resultado não transferiu para modelos em escala de produção.
- Amdahl's Law aplica a organizações: acelerar código gerou code review humano como novo gargalo; aceleração de pesquisa gerou gargalo em decidir quais experimentos rodar.
- Revisão automatizada por Claude de cada mudança na codebase teria capturado ~1/3 dos bugs históricos de incidentes no claude.ai antes de chegar em produção.
- Três cenários: (1) trend estagna, capacidades atuais se difundem — mais tempo para adaptação; (2) ganhos compostos continuam, humanos mantêm direção estratégica — revolução do trabalho do conhecimento; (3) melhoria recursiva total — ritmo determinado por compute disponível, humanos em papel de supervisão e validação.

## Exemplos e evidências

- Em abril 2026, Claude entregou mais de 800 fixes que reduziram uma classe de erros de API por fator de mil; um humano levaria estimados 4 anos.
- Poll interno (março 2026, 130 funcionários): mediana estima 4x mais output com Mythos Preview vs. sem IA. (Nota: METR research sugere que estimativas de desenvolvedores sobre uplift de produtividade tendem a ser superestimadas.)
- GitHub viu ~1 bilhão de commits em 2025; até meados de 2026, 275 milhões por semana — pace de ~14 bilhões no ano.

## Implicações para o vault

Confirma e quantifica com dados internos da Anthropic as tendências de aceleração de agentes que permeiam vários outros sources desta ingestão. A ideia de "research taste" como último bastião humano conecta com o conceito de julgamento editorial e curadoria no vault. O cenário de Amdahl's Law aplicado a organizações é diretamente aplicável ao design de pipelines de agentes neste vault.

## Links

- [[03-RESOURCES/concepts/ai-agents/recursive-self-improvement]]
- [[03-RESOURCES/concepts/ai-agents/agent-autonomy]]
- [[03-RESOURCES/entities/anthropic]]
- [[03-RESOURCES/entities/claude-mythos-preview]]
