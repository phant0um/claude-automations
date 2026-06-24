---
title: "Loop Engineering: The best skill what every AI builder needs NOW"
type: source
source: "Clippings/Loop Engineering The best skill what every AI builder needs NOW.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central

97% dos builders de IA estão fazendo a coisa errada inteira: prompting em vez de construir loops. Um prompt dá uma resposta; um loop dá um sistema que encontra a resposta, checa, corrige erros e avisa quando terminou — sem precisar de toque humano.

## Argumentos principais

- 4 partes de todo loop real: trigger, processo, verificação, stop condition. Falta de #3/#4 é a causa raiz da maioria das automações que falham.
- **Trigger**: 3 tipos — fixed interval (desperdiça tokens quando nada mudou), event-driven (melhor quando trabalho só precisa rodar em resposta a algo real), dynamic interval (agente decide o intervalo, escala para baixo se há falhas, para cima se não há — é o único que escala bem).
- **Processo**: escopo estreito sempre vence. 4 passos narrow > 1 mega-prompt fazendo tudo. Argumento real para arquitetura multi-agente: não é "mais agentes são melhores", é que escopo estreito torna verificação tratável (checklist em vez de julgamento difuso).
- **Verificação**: falha ingênua é o próprio agente que produziu o output julgar a qualidade dele. 3 padrões que funcionam: verificador separado (modelo/contexto diferente, instrução adversarial explícita), cross-reference contra ground truth (mecânico, não-julgamento), modelo mais forte verificando modelo mais fraco.
- **Stop condition** tem 3 estados: sucesso (explícito, com o que passou e por quê), retry limitado (com feedback específico do verificador, não do zero), escalação (budget de retry esgotado — 4 falhas na mesma tarefa estreita é sinal de que a definição da tarefa está errada, não que precisa de tentativa #5).
- **Memória** é o que faz loops compoundarem: loop sem memória rende a mesma qualidade no ciclo 100 que no ciclo 1; loop com memória melhora porque cada ciclo alimenta o contexto do próximo.
- 4 formas de loops morrerem: runaway recursion (2 agentes se alimentando indefinidamente), silent death (contexto cheio, loop trava mas reporta "progresso"), walking in circles (sem stop condition verificável, agente define "feito" como quiser), comprehension debt (loop escreve código mais rápido do que você consegue ler — você se distancia do próprio projeto).

## Key insights

- Boris Cherny: "Eu não prompto mais o Claude. Tenho loops correndo que promptam o Claude e decidem o que fazer."
- Gap de modelo está fechando (GLM 5.2 a 1% do Opus 4.8 em benchmarks agentic); o que não comoditiza é a arquitetura — trigger, verificação, stop conditions, memória. Habilidade diagnóstica de identificar "o problema não é o modelo, é uma verificação faltando" é a skill que escala.

## Exemplos e evidências

- Exemplo completo de loop de monitoramento de concorrente: trigger 2x/semana, processo de busca+comparação contra 6 semanas de notas acumuladas, verificação por "seria newsworthy + evidência de padrão vs. ponto isolado", stop por alerta ou ampliação de escopo após 3 ciclos nulos.
- Config de loop com circuit breaker: `max_turns: 50`, `max_budget_usd: 10`, `circuit_breaker: 3`, `heartbeat: STATUS.md`.
- STATUS.md como padrão de memória: seções Done / In Progress / Never Touch, lido no início e escrito no fim de cada ciclo.

## Implicações para o vault

Absorvido no conceito existente `[[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]` (F2.5) — quarto artigo do mesmo tema no batch; evita duplicação. Esta fonte é a mais detalhada do grupo em exemplos de configuração concreta (circuit breaker, heartbeat) e nas "4 formas de loops morrerem".

## Links

- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
