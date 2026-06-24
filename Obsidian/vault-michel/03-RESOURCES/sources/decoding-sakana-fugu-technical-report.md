---
title: "Decoding Sakana Fugu Technical Report"
type: source
source: Clippings/Decoding Sakana Fugu Technical Report.md
created: 2026-06-22
ingested: 2026-06-22
tags: [articles]
---

## Tese central
Sakana Fugu é uma família de modelos orquestradores que não respondem perguntas diretamente — leem a pergunta e decidem qual modelo (ou time de modelos) da pool de frontier models deve resolvê-la, e como combinar as respostas. Duas variantes: Fugu (rápido, escolhe 1 worker via lightweight selection head) e Fugu-Ultra (alta qualidade, escreve workflows agênticos completos via Conductor).

## Argumentos principais
- **Lightweight selection head (Fugu)**: head extra sobre o hidden state do LM backbone, gera 1 score por worker model na pool — decide sem gerar texto, daí latência baixa (builds on Trinity, dropando o conceito de "roles" Thinker/Worker/Verifier).
- **Treino em 2 estágios**: SFT com soft target via softmax sobre rewards de cada worker (KL divergence loss) → depois evolutionary strategies (sep-CMA-ES, sem gradientes) para polir em tarefas end-to-end multi-turno.
- **Fugu-Ultra/Conductor**: escreve agentic workflow completo — lista de (subtask, worker_id, access_list) — permitindo chain, best-of-N, ou tree topology; escolhe dinamicamente até o agregador final por pergunta (ex: Gemini agrega trivia, GPT agrega math).
- **Treino via GRPO**: grupo de G workflows por pergunta, advantage = (r - mean)/std, reward 0/0.5/1 (malformed/correto-mas-errado/correto). Sem KL term nesse treino.
- **Isolamento intra-workflow + memória persistente inter-conversação**: evita "orchestration collapse" (todos copiam o primeiro agente) sem perder o reuso de fatos já descobertos.
- **Resultados**: Fugu-Ultra bate todos os modelos da própria pool em vários benchmarks (SWE Bench Pro 73.7 vs Opus 4.8 69.2; Terminal Bench 2.1 82.1 vs 78.2 GPT-5.5) — confirma orquestração como eixo de scaling além de treinar modelo maior.

## Key insights
- Mesma tese central de [[03-RESOURCES/concepts/agent-systems/rl-conductor-orchestration]] (Conductor, Sakana 2026) — Fugu/Fugu-Ultra é a evolução produtizada em 2 variantes (latência vs qualidade) do mesmo paradigma "small RL-trained orchestrator > self-orchestration via prompting".
- Estratégias emergentes não programadas (debate+aggregation, build-and-debug com Opus debugando código do GPT, "bringing in a specialist" por tarefa) replicam o padrão de emergent behaviors já catalogado no concept Conductor — reforça que esse comportamento é robusto ao re-treino/nova versão, não um fluke de uma run.
- Collective intelligence como "novo eixo de scaling": trocar/adicionar modelo na pool sem retreinar é o argumento prático mais forte para orquestração vs fine-tuning de modelo único.

## Exemplos e evidências
- Tabela de benchmarks (SWE Bench Pro, Terminal Bench 2.1, GPQA Diamond, HLE) com Fugu-Ultra liderando a maioria das linhas.
- Tarefas fora de benchmark padrão: Rubik's cube solver (Fugu-Ultra média 19.72 moves, ótimo=20), blindfold chess (4-0 incluindo vs engine), trading simulado (+19.43% em 50 semanas).

## Implicações para o vault
- Reforça diretamente [[03-RESOURCES/concepts/agent-systems/rl-conductor-orchestration]] com a versão produtizada/expandida (2 variantes, benchmarks atualizados) do mesmo framework Conductor já catalogado.

## Links
- [[03-RESOURCES/concepts/agent-systems/rl-conductor-orchestration]]
