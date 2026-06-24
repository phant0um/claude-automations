---
title: "Loop Engineering Clearly Explained"
type: source
source: "Clippings/Loop Engineering Clearly Explained.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central

Loop engineering é a disciplina de desenhar os quatro componentes de um sistema autônomo — trigger, processo, verificação, condição de parada — e é isso, não o modelo, que separa sistemas que escalam de automações que falham silenciosamente.

## Argumentos principais

- Todo loop real tem 4 partes: **trigger** (o que inicia o ciclo), **processo** (o que o agente faz), **verificação** (como o loop checa o próprio output), **stop condition** (quando termina). A maioria das "automações" que falham está faltando #3 e #4.
- Verificação é o componente mais pulado e o que mais separa qualidade real de atividade vazia — agente que produziu o output não deve ser o mesmo que o julga.
- Stop condition real tem 3 estados, não 2: sucesso, retry limitado, escalação — escalação é o estado que quase ninguém constrói, e é o mais importante.
- O que não comoditiza é a arquitetura em torno do modelo: design do trigger, lógica de verificação, condições de parada, estrutura de memória.

## Key insights

- Boris Cherny (criador do Claude Code): "Eu não prompto mais o Claude. Tenho loops correndo que promptam o Claude e decidem o que fazer. Meu trabalho é escrever loops."
- Memória transforma loop de "atividade plana" em algo que melhora a cada ciclo — números de context engineering documentados (41% → 3% taxa de erro) não vêm do modelo ficando mais inteligente, vêm do contexto acumulado ficando melhor.

## Exemplos e evidências

- Engenheiro shippou 259 PRs em um mês sem abrir editor de código — loop bem desenhado.
- Loop sem brakes rodou 11 dias sem supervisão e queimou $47.000 antes de alguém notar — mesma tecnologia, mesmas ferramentas, diferença foi ausência de stop condition.

## Implicações para o vault

Absorvido no conceito existente `[[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]` (F2.5) — evita duplicar o tema já catalogado (5 padrões, pitfalls, fontes). Esta fonte reforça a formulação canônica dos 4 componentes e a citação de Boris Cherny.

## Links

- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
