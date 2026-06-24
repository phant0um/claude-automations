---
title: "Harness Engineering in AI (Amit Shekhar / Outcome School)"
type: source
created: 2026-05-28
ingested: 2026-05-28
tags: [harness-engineering, ai-agents, orchestration, evaluation, production, outcome-school]
source_url: "https://outcomeschool.com/blog/harness-engineering-in-ai"
author: "Amit Shekhar"
published: 2026-04-01
---

# Harness Engineering in AI

## Tese Central

O harness é a camada de controle ao redor do modelo de IA — tudo que o transforma de motor bruto em produto utilizável em produção. Um ótimo modelo com harness fraco produz experiência fraca; um modelo mediano com ótimo harness produz experiência excelente.

## Key Insights

- **Definição operacional:** Harness = prompt management + tool orchestration + memory management + error handling + input/output processing + guardrails.
- **Analogia do motor:** LLM = motor; harness = carroceria, volante, freios, painel. O motor sozinho não leva a lugar algum.
- **O modelo não executa tools:** O modelo decide qual tool chamar; o harness executa a tool e devolve o resultado ao modelo. Distinção crítica para design de sistemas.
- **Loop do agente gerenciado pelo harness:** Prepare prompt → Send to model → Check for tool call → Execute tool → Send result back → Repeat → Present final result.
- **Harness para avaliação:** Framework que carrega dataset, envia cada questão ao modelo, compara com resposta correta, calcula score. Para outputs abertos: LLM-as-a-Judge. Para agentes: avaliar trajetória + tool calls + plano, não só resposta final.
- **Boas práticas:** (1) harness modular; (2) log everything; (3) guardrails desde o primeiro dia; (4) tools confiáveis com fallback; (5) testar o harness como software, não só o modelo; (6) monitorar em produção (latency, errors, cost, quality).
- **Citação-chave:** "O código do harness é muitas vezes maior que o código de integração com o modelo em aplicações reais."

## Implicações para o Vault

- Visão introdutória/pedagógica do harness — útil como referência de onboarding para novos contexts sobre o tema.
- Confirma taxonomia já presente em `harness-engineering.md`: componentes de produção alinhados com os 12 de Akshay Pachaar.

## Links

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — conceito central expandido por este artigo
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — implementação prática
- [[03-RESOURCES/sources/ai-agents-harness/anatomy-agent-harness-akshay-pachaar]] — 12 componentes detalhados
