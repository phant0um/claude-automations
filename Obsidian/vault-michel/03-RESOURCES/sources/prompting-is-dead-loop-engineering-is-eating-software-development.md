---
title: "Prompting Is Dead. Loop Engineering Is Eating Software Development."
type: source
source: "Clippings/Prompting Is Dead. Loop Engineering Is Eating Software Development..md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, loop-engineering]
---

## Tese central
O ponto de leverage mudou de "escrever o melhor prompt" para "desenhar o melhor loop" — roteiro de 14 passos para sair de prompter manual (escreve→espera→revisa→escreve de novo) para designer de sistemas autônomos que encontram trabalho, geram solução, verificam resultado e disparam a próxima ação sem humano no meio.

## Argumentos principais
- **Teste das 4 condições** antes de construir qualquer loop: tarefa repete com frequência; sucesso é mensurável por máquina; agente consegue reproduzir falhas (logs/testes/ambiente executável); economia de tokens compensa (loop+retry+verificação custam, se custo > valor é "hobby caro").
- Quem mais se beneficia: trabalho repetitivo e verificável por máquina (dependency updates, triagem de CI, lint, issue→PR). Quem mais perde: solo builders tentando automatizar tudo com orçamento limitado, ou trabalho criativo/exploratório que exige julgamento constante.
- **Check de 30 segundos** (5 perguntas) antes de converter workflow em loop — se qualquer resposta for "não", manter manual.
- Worktrees como infraestrutura central de paralelismo multi-agente: sem isolamento, paralelismo cria colisão; com isolamento, cria leverage.

## Key insights
- O "teste das 4 condições" e o "check de 30 segundos" são checklists diretamente aplicáveis antes de transformar qualquer rotina deste vault (ex.: triagem semanal) em loop autônomo total — útil como filtro de decisão antes de qualquer proposta de automação maior.
- "Um loop bom amplifica um processo bom; um loop ruim amplifica um processo ruim" é o argumento mais direto contra automatizar processos ainda não maduros/validados manualmente.

## Exemplos e evidências
- Roteiro de 14 passos em 3 tiers (Why → 5 Building Blocks → ...); exemplos concretos de tarefas boas para loop (dependency updates, lint fixes) vs más (trabalho criativo).

## Implicações para o vault
Esta fonte é o 3º exemplo independente de "loop engineering" nesta leva, reforçando lado convergente do meta-padrão "separar execução de avaliação" (ver páginas de loop engineering já ingeridas: `loop-engineering-build-an-ai-that-codes-while-you-sleep`, `loops-explained-claude-gpt-mira-and-what-actually-works`) — candidato a F3.6.

## Links
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/sources/loop-engineering-build-an-ai-that-codes-while-you-sleep]]
