---
title: "Project Fetch: Phase two"
type: source
source: "Clippings/Project Fetch Phase two.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [articles]
---

## Tese central
Na segunda fase do "Project Fetch" da Anthropic, Claude Opus 4.7 operando sem assistência humana foi cerca de 20x mais rápido que o time humano mais veloz do experimento original (agosto de 2025) em todas as tarefas completadas, embora ainda não tenha resolvido a parte de controle motor fino (fetching propriamente dito) e o experimento não implique avanço em controle robótico de baixo nível.

## Argumentos principais
- No experimento original (Project Fetch, agosto 2025), Opus 4.1 não conseguia fazer as tarefas sozinho — travava até na etapa preliminar de conectar ao robô; agora, modelos mais novos não só conseguem como superam o desempenho humano.
- Comparando as 4 tarefas completadas por ambos os times humanos: Team Claude-less levou 361 minutos, Team Claude levou 181 minutos, Opus 4.7 sozinho levou 9 minutos e 35 segundos — 37.7x mais rápido que Team Claude-less e 18.9x mais rápido que Team Claude.
- Considerando o conjunto maior de 5 tarefas testadas na Fase 2: Team Claude-less não completou todas; Team Claude completou em 264 minutos; Opus 4.7, em média de 3 trials, completou em 12 minutos e 7 segundos.
- Opus 4.7 escreveu quase 10x menos código que Team Claude para atingir resultado igual ou melhor: Team Claude escreveu 10.309 linhas, Team Claude-less 1.136 linhas, Opus 4.7 sozinho 1.045 linhas.
- O papel do pesquisador humano foi limitado a plugar o laptop com Claude Code no robô, digitar o prompt inicial, aprovar comandos, e aprovar avanço para a próxima tarefa — nenhuma intervenção de engenharia.
- Onde Claude falhou: a parte de "fetching" propriamente dita (empurrar a bola de praia de volta com precisão) exige um loop fechado de percepção-ajuste rápido em que humanos se destacam após prática — Claude conseguiu posicionar o robô atrás da bola mas o controle foi malsucedido, assim como os humanos que tentaram a via autônoma.
- Um pesquisador com mais experiência em robótica conseguiu programar o fetching autônomo com sucesso — sugerindo que com mais tempo e scaffolding, gerações atuais de Claude provavelmente também conseguiriam.
- O progresso não resulta de esforço dedicado a melhorar capacidades robóticas dos modelos — emergiu de scaling geral, mesmo padrão observado em cibersegurança (red.anthropic.com/2026/mythos-preview).

## Key insights
- Padrão recorrente identificado pelos autores: primeiro modelos ajudam humanos, depois humanos ajudam modelos, finalmente modelos fazem a tarefa sozinhos — já visto em cibersegurança, agora também na interseção entre IA e mundo físico.
- A eficiência de código (quase 10x menos linhas que humanos com IA) é um sinal indireto de "entendimento" mais direto da tarefa, não apenas força bruta de geração.
- Pouca variância dentro de cada tarefa entre as 3 execuções — Claude é "razoavelmente confiável" dentro do envelope de capacidade testado, com exceção do caso em que escolheu um algoritmo de detecção de objeto desatualizado, aumentando o tempo daquele trial específico.
- Paralelo explícito traçado pelos autores entre a transição de Claude para ferramentas de edição de software existentes (ex.: string-replace em coding agêntico) e a transição equivalente esperada para ferramentas físicas off-the-shelf — "pode ser tolice descartar a mesma trajetória em hardware".

## Exemplos e evidências
- Gráfico de barras comparando tempo total nas 4 tarefas comuns aos 3 grupos (361 min vs 181 min vs 9min35s).
- Tabela comparando desempenho em 5 tarefas (conectar câmera de vídeo, conectar sensor lidar, detectar bola de praia, entre outras).
- Gráfico de barras de volume de código (10.309 vs 1.136 vs 1.045 linhas).
- Scatter plot de confiabilidade entre as 3 execuções de Opus 4.7 por tarefa.
- Nota de rodapé: usaram Opus 4.7 (não Mythos Preview) porque testes preliminares com Mythos não permitiam comparação direta, dado como o modelo foi servido e configurado o experimento.
- Correção registrada no rodapé: data da Fase 1 corrigida em 18 de junho.

## Implicações para o vault
Dado empírico relevante para o tópico de `long-horizon-agents` e `world-model` já presentes no vault — evidência concreta de que ganhos de capacidade física emergem de scaling geral, não de fine-tuning específico para robótica, reforçando a tese (já presente em outros concepts) de que capacidades "emergem" antes de serem alvo deliberado de treino.

## Links
- [[03-RESOURCES/concepts/agent-systems/long-horizon-agents]]
- [[03-RESOURCES/concepts/llm-ml-foundations/world-model]]
- [[03-RESOURCES/concepts/agent-systems/agentic-world-modeling]]
- [[03-RESOURCES/entities/anthropic]]
- [[03-RESOURCES/entities/Claude-Opus-4.7]]
