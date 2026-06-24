---
title: "How to Eval AI Agents — The 2026 Guide"
type: source
source: "Clippings/How to Eval AI Agents — The 2026 Guide.md"
url: "https://www.howtoeval.com/"
author: ["Ben Hylak"]
published: 2026-05
created: 2026-05-27
ingested: 2026-05-28
tags: [ai-agents, source, eval, harness-engineering, production]
---

## Tese central

Avaliar agentes em produção não é construir benchmarks — é fazer **análise de erros**. A distinção fundamental é entre **benchmark-maxxing** (maximizar métricas em suítes de teste) e **floor-raising** (eliminar os piores casos que importam). Para a maioria dos produtos de agentes, floor-raising é a estratégia correta.

## Argumentos principais

1. **Benchmark-maxxer vs. floor-raiser.** Benchmark-maxxers buscam taxa de aprovação máxima. Floor-raisers perguntam "qual 1% falha?" — porque uma resposta errada confiante é pior que uma recusa honesta. Produtos de agentes que substituem humanos precisam de confiança, não de demonstração de capacidade.

2. **Floor-raising é análise de erros.** Processo: ler interações reais → encontrar padrões → classificar → decidir quais merecem esforço de engenharia → corrigir o padrão, não o incidente. "A eval suite de floor-raising é uma memória de bugs que você recusa a reintroduzir."

3. **Evals offline devem ser code-aware.** Testar prompts isolados não faz sentido quando o agente está entrelaçado com código, tools, retrieval, permissões e estado do produto. A eval correta roda o caminho real do agente e faz assert no resultado: output, tool calls, arquivos modificados, estado final. Analogia: pytest/vitest, não dashboard de pontuação de prompt.

4. **Escalar o review de produção com volume.**
   - 1–100 runs/dia: ler logs brutos (Stumbles)
   - 100–1.000: patterns recorrentes → Issues formalizados
   - 1.000+: monitorar Signals de longo prazo (recusas, context loss, frustração)
   - 5.000+: A/B tests com feature flags em tráfego real

5. **O loop correto.** `falha em produção → reproduzir localmente → adicionar como golden case → corrigir → verificar que eval passa → shipar`. Não o inverso (construir suítes especulativas antes de ver falhas reais).

6. **Futuro: colapso do harness.** À medida que modelos se tornam mais agênticos (Claude Code, Cursor Agent SDK), a distinção entre "modelo" e "agente" borra. O harness colapsa no modelo. Implicação: evals end-to-end tornam-se o único jogo — golden cases + monitoramento de produção.

## Key insights

- **"Ask your agent"**: reconstruir o run exatamente como foi passado ao agente e perguntar diretamente o que aconteceu. O agente pode usar o trace, contexto e mensagens anteriores como evidência para explicar seu próprio comportamento — o mais próximo de perguntar ao agente "o que você estava pensando."
- **Suítes grandes são distração.** 20 casos de alto sinal batem 200 de baixo sinal. Heurística: se um eval case não falhou em 3 meses, questione se ele está lá por razão real.
- **Self-diagnostics são superestimados.** Injetar uma tool oculta que o agente usa para reportar seus próprios problemas funciona menos do que parece — exige muito trabalho de calibração e produz muito ruído.
- A empresa do autor é **Raindrop** — disclosure explícito no guia; abordagem neutra em teoria mas citações diretas do produto são frequentes.

## Exemplos e evidências

- Código de exemplo com `vitest-evals` da Sentry: `describeEval`, harness local, `expect(toolCalls(...))` — eval code-aware concreto.
- A/B test exemplo: GPT-5.3 nano vs Claude 4.5 Sonnet → 88% vs 76% task completion (p<0.001).
- Clientes citados: Framer, Clay, Vercel, GC.AI.

## Implicações para o vault

- Enriquece [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]] com a distinção floor-raiser vs. benchmark-maxxer e o loop produção→golden-case.
- Enriquece [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] com o modelo de escalamento por volume (Stumbles → Issues → Signals → Experiments).
- O conceito de **harness collapse** é novo e relevante: à medida que os modelos avançam, o harness explícito desaparece → impacto direto em como Michel pensa sobre o futuro do vault de agentes.
- Valida a abordagem de evals code-aware já referenciada em [[03-RESOURCES/concepts/agent-systems/harness-engineering]].

## Links

- URL: https://www.howtoeval.com/
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]
