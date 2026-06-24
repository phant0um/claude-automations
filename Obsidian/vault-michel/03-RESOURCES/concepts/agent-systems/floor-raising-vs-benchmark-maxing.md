---
title: "Floor-Raising vs Benchmark-Maxing"
type: concept
status: active
created: 2026-05-28
updated: 2026-05-28
tags: [concept, ai-agents, eval, reliability, production]
aliases: [floor-raising, benchmark-maxing, eval-strategy]
---

## Definição

Dois paradigmas opostos de melhoria de agentes em produção:

**Benchmark-maxing**: otimizar para score médio em test suite. Métrica: pass rate agregada. Foco: cobertura, variantes sintéticas. Resultado: agente ótimo em distribuição de teste, frágil em produção.

**Floor-raising**: eliminar falhas de alto impacto nas trajetórias reais que mais importam. Métrica: ausência de falhas catastróficas. Foco: error analysis, golden cases, casos onde erros custam caro. Resultado: agente confiável onde confiabilidade importa.

## Critério de escolha

Pergunta diagnóstica: **"Qual o 1% que falha?"**

- Benchmark-maxxer responde: "não importa, pass rate é 99%"
- Floor-raiser responde: "o erro de autorização no módulo de pagamentos"

Se o pior erro do agente pode virar notícia → **floor-raising**.
Se precision é mais importante que recall em cauda → **benchmark-maxing** (casos raros: labs, research).

## Floor-raising na prática

1. **Review real traces**: user messages, agent responses, full trajectory — não só output final
2. **Golden cases** (5-10): casos críticos que o agente NUNCA deve errar. Se falhar → não sobe para produção
3. **Error analysis**: detectar padrão → fix the pattern, not the incident
4. **Teach to say "I don't know"**: recusa calibrada > resposta errada confiante
5. **Eval targets real failures**: lock in lessons from bugs, not synthetic coverage

## Relação com outras práticas

- [[agent-lifespan-engineering]] — aging metrics devem focar em floor (degradação que importa) não score médio
- [[agent-eval-framework]] — eval de produção = floor-raising por definição
- [[harness-engineering]] — harness de qualidade define "floor" do agente

## Fontes

- [[03-RESOURCES/sources/ai-agents-harness/how-to-eval-ai-agents-2026-guide]] — Ben Hylak (Raindrop), 2026
- [[03-RESOURCES/sources/ml-research-papers/agingbench-agent-lifespan-engineering-2026]] — convergência: AgingBench foca em degradação de floor, não score
