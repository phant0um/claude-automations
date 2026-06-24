---
title: "How GLM-5.2 Beat Fable 5 at Website Design"
type: source
source: "Clippings/How GLM-5.2 Beat Fable 5 at Website Design.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
GLM-5.2 (Z.ai, MIT-licensed, 744B parâmetros, sem visão) é o primeiro modelo a ultrapassar a linhagem Fable 5/Opus 4.6/4.7 no leaderboard single-turn de Design Arena (HTML Web Design não-agêntico) — feito com mesmo tamanho do GLM-5.1 enquanto concorrentes mais próximos seriam até 6,7x maiores, e a $1,40/$4,40 por milhão de tokens vs. $10/$50 da Fable 5 (nova fronteira de Pareto preferência-vs-preço).

## Argumentos principais
- GLM-5.2 não vence em tudo: fica em 2º lugar (atrás de Fable 5) em Game Dev, Data Visualization e 3D Design, e 4º em UI Component.
- **Comportamento 1 — templates "especialistas"**: análise de 1000 websites amostrados mostra que GLM-5.2 tende a produzir respostas templated/similares mesmo para prompts muito diferentes, mas os templates evitam antipadrões comuns (ex.: o clássico gradiente roxo que praga modelos de IA early). Fable 5 produz outputs mais diversificados/generalistas — técnica de template especializado do GLM-5.2 ainda não supera em todas categorias, mas é favorecida pelos usuários como piso de qualidade média mais alto.
- **Comportamento 2 — evita casos de erro comuns**: GLM-5.2 usa corretamente dependências como chart.js e three.js (outros modelos falham nisso), gerando +6,0pp de win rate nos 21% de sessões que usam essas libs — especialmente forte em Dashboard e 3D Design. Usa TailwindCSS em 91% das sessões e font-awesome em 51% (+1,2pp win rate); Opus 4.8 usa TailwindCSS em só 57% das sessões e aparentemente perde por isso.
- **Comportamento 3 — outputs mais intricados, ao custo de velocidade**: GLM-5.2 gera 25% mais caracteres/linhas de código, tempo médio de geração 304,7s — 2x mais lento que Fable 5. Fica na fronteira de Pareto Preferência-vs-Velocidade mas do lado errado (troca velocidade por preferência), com retorno decrescente — faixa ideal fica entre 46K-57K caracteres. Fable 5 gera 38% menos linhas e 29% menos caracteres que concorrentes — divergência significativa de estratégia. Em contexto agêntico, GLM-5.2 gera 11% mais arquivos e chama 17% mais tools que concorrentes, mas gera código levemente menor no total.

## Key insights
- "Mais tokens gerados" e "melhor design" não são a mesma variável — o ganho de GLM-5.2 vem de evitar erros de dependência e ter templates-base melhores, não simplesmente de gerar mais; o trade-off de velocidade é um custo separado e tem retorno decrescente além de 57K caracteres.
- O dado de uso correto de libs externas (chart.js/three.js/Tailwind) é um proxy mensurável de "harness/treino melhor" que vale mais que benchmark único de preferência — modelo que falha em usar dependência corretamente perde pontos mesmo com boa estética.

## Exemplos e evidências
- Pricing: GLM-5.2 $1,40/$4,40 por M tokens vs. Fable 5 $10/$50 por M tokens.
- 744B parâmetros (GLM-5.2) vs. concorrentes especulados em até 6,7x maiores.
- Fonte: Design Arena (designarena.ai/leaderboard/code), autor Anmay Gupta.

## Implicações para o vault
Mais um ponto de dado no cluster de comparações de modelo já mapeado no batch anterior (GLM/Kimi/MiniMax vs. Fable) — diferencia-se por trazer metodologia quantitativa real (amostra de 1000 sites, win-rate por categoria de dependência) em vez de benchmark único, valioso se o vault quiser cruzar os 3+ benchmarks numa tabela de síntese (gap já identificado no relatório de 2026-06-19).

## Links
- [[03-RESOURCES/sources/how-i-turned-minimax-into-fable-5-97-percent-cheaper]]
- [[03-RESOURCES/sources/kimi-k27-code-vs-claude-fable-5-landing-pages]]
