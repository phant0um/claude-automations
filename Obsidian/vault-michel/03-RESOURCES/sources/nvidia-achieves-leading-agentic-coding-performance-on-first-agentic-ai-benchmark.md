---
title: "NVIDIA Achieves Leading Agentic Coding Performance on First Agentic AI Benchmark"
type: source
source: "Clippings/NVIDIA Achieves Leading Agentic Coding Performance on First Agentic AI Benchmark.md"
created: 2026-06-12
ingested: 2026-06-21
tags: [ai-agents, model-benchmarks]
---

## Tese central
Artificial Analysis lança AA-AgentPerf, primeiro benchmark multi-vendor de hardware desenhado especificamente para medir quantos agentes de IA concorrentes um sistema de inferência suporta sob SLOs de velocidade/latência definidos — NVIDIA reporta até 20x de melhora em performance de coding agêntico vs gerações anteriores via co-design extremo de hardware.

## Argumentos principais
- Workloads agênticos são não-determinísticos por natureza (decisões do LLM produzem sequências variáveis de tool calls) — medir performance exige capturar trajetórias representativas reais (sequência completa de ações/decisões/observações de início a fim de uma tarefa), não só latência de chamada única.
- Metodologia: trajetórias pré-gravadas de coding agêntico com raciocínio e tool use intercalados, simulando latência inter-turno com baseline representativo para chamadas de ferramenta no lado CPU; sequências de input/output de 5K a 131K tokens (média ~27K); conjunto de teste mantido privado para evitar otimização direcionada ao benchmark.
- Benchmark normaliza resultados por acelerador e por megawatt — permite comparação justa entre configurações de hardware diferentes, não apenas throughput bruto.

## Key insights
- A escolha de manter o test-set privado é uma resposta direta ao problema de "benchmark gaming" (otimizar para o teste, não para a tarefa real) — prática que deveria informar qualquer avaliação interna de agentes deste vault: medir desempenho com tarefas não vistas previamente pelo agente avaliado.
- Medir "quantos agentes concorrentes o sistema sustenta sob SLO" (não só 1 trajetória isolada) é a métrica certa para qualquer ambiente de produção multi-agente — relevante se o vault algum dia avaliar throughput de múltiplos subagentes rodando em paralelo (ex.: batch ingest).

## Exemplos e evidências
- Definição completa de SLO (threshold de velocidade de output + time-to-first-token); diagrama de trajetória de agente (Request → LLM Call → Tool Call → ... → Output).

## Implicações para o vault
Referência de metodologia de avaliação caso o vault precise medir/comparar desempenho de múltiplos subagentes rodando em paralelo (batch ingest) — o princípio "test-set privado, trajetórias representativas reais" é aplicável a qualquer self-spot-check de qualidade de agente (ex.: F3.5 deste próprio pipeline).

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
