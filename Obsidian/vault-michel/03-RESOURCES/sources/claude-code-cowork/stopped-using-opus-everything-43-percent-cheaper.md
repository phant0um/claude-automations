---
title: "I stopped using Opus for everything — AI costs dropped 43% overnight"
type: source
source: "[@0xDepressionn](https://x.com/0xDepressionn/status/2065044012793201001) — Factory Droids/Router"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

"O modelo caro não é a escolha segura, é só a cara." O gap de qualidade em
trabalho rotineiro fechou o suficiente para a economia não fechar mais a
favor do default único (sempre Opus).

## Argumentos principais

- **Caso ilustrativo**: 3 tasks (reset de senha, copyright header, refactor
  de billing) — tudo em Opus = $2.87. Roteado por complexidade (rotina →
  modelo eficiente, refactor → frontier) = $1.62. Mesmo output, 43% menos.
- **15 regras** (resumo): classificar tasks em frontier-worthy (arquitetura,
  auth, payments, segurança, refactors >100 linhas) vs rotina (docs,
  config, testes em funções existentes, boilerplate); medir gasto real
  antes de rotear; escrever descrições de task que sinalizem complexidade
  (descrições vagas → roteamento conservador para frontier); calcular ROI
  anual (`N × baseline × routine% × 0.85`); documentar o que é
  "frontier-only" por escrito como política; configurar pool de modelos por
  tier; revisão mensal de política de roteamento.

## Key insights

### Números de escala

5.000 sessões/mês a 40% rotina = $58.548/ano recuperados; 50.000
sessões/mês = $585.480/ano. Terminal-Bench 2: 99% do pass rate do Opus a
20% menos custo.

## Implicações para o vault

Diretamente relevante a [[04-SYSTEM/wiki/model-routing|Model Routing Tiers]]
já adotado (Ollama local/cloud + Claude para decisões críticas, triagem
Claude-only por [[04-SYSTEM/wiki/adr/adr-nx-003-reverter-ollama-cloud-pipeline|ADR-003]]).
A "regra 5" (documentar por escrito o que é frontier-only) é o padrão que o
ADR-003 já formaliza para triagem. A "regra 3" (descrições de task sinalizam
complexidade — vago → frontier por padrão) é um argumento a favor de prompts
de subagente mais específicos no pipeline-diario, reduzindo escalonamento
desnecessário a modelos caros.
