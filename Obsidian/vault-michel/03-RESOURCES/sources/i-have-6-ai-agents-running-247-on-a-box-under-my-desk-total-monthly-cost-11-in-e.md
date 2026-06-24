---
title: "I HAVE 6 AI AGENTS RUNNING 24/7 ON A BOX UNDER MY DESK. TOTAL MONTHLY COST: $11 IN ELECTRICITY"
type: source
source: "Clippings/I HAVE 6 AI AGENTS RUNNING 24-7 ON A BOX UNDER MY DESK.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, inference-optimization]
---

## Tese central
Hardware local (Minisforum MS-S1 Max, ~$3.000, chip AMD Ryzen AI Max+ 395 com 128GB de memória unificada CPU+GPU) torna viável rodar 6 agentes de IA 24/7 com custo operacional de ~$11/mês em eletricidade — o argumento central não é "o modelo local é tão bom quanto a nuvem", é que inferência grátis muda o comportamento: sem custo por token, você deixa de otimizar cada prompt e passa a deixar agentes rodando por horas sem culpa.

## Argumentos principais
- Memória unificada (128GB compartilhados entre CPU e GPU, ~96GB usáveis como VRAM no Linux) é o mesmo truque arquitetural que torna Apple Silicon bom para IA local — aqui em chassi Linux com 10GbE duplo, USB4 80Gbps e slot PCIe x16.
- Tabela de throughput real com modelos quantizados Q4: Qwen3-Coder 30B (~40-50 tok/s, bom para coding diário), Llama 3.3 70B (~20-25 tok/s, raciocínio complexo), DeepSeek-V3 (~10-12 tok/s, pesquisa profunda), Qwen3-235B MoE (~6-8 tok/s, tarefas frontier-class, comparável a Claude Sonnet em benchmarks, mais lento mas sem custo por token).
- Clustering: 2 unidades rodam Qwen3-235B a ~11 tok/s; 4 unidades rodam DeepSeek-R1 671B completo (380GB) — localmente, sem datacenter.
- Mudança comportamental central: pagar por token faz você pensar antes de prompt, otimizar queries, encerrar experimentos cedo, nunca deixar um agente rodar 8h — inferência grátis remove esse freio.

## Key insights
- "Inferência grátis muda comportamento, não só custo" é confirmação empírica e concreta do racional já adotado pelo `model-router` deste vault (Ollama local para tarefas de rotina/triagem, cloud para decisão crítica) — agora com números reais de hardware e throughput.
- A tabela de throughput por modelo é referência prática direta para qualquer decisão futura de qual tier local usar para qual tipo de tarefa (coding rápido vs raciocínio complexo vs pesquisa profunda).

## Exemplos e evidências
- Specs completas do Minisforum MS-S1 Max; tabela de performance por modelo; caso de clustering com 2 e 4 unidades.

## Implicações para o vault
Reforça a arquitetura de `model-router` (tiers Ollama local/cloud) já adotada — referência concreta de hardware/throughput caso o vault avalie expandir capacidade de inferência local própria no futuro.

## Links
- [[04-SYSTEM/agents/nexus-agent-system/model-router]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
