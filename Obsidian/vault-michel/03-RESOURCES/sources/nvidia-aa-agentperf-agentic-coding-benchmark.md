---
title: "NVIDIA Achieves Leading Agentic Coding Performance on First Agentic AI Benchmark (AA-AgentPerf)"
type: source
source: Clippings/NVIDIA Achieves Leading Agentic Coding Performance on First Agentic AI Benchmark.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, nvidia, benchmark, inference, source, score-A]
---

## Tese central

NVIDIA GB300 NVL72 entrega até 20x mais agentes concurrentes por megawatt que H200 no AA-AgentPerf, o primeiro benchmark multi-vendor para performance de inference systems em agentic coding workloads. O benchmark mede concorrência de agentes sob SLO tiers de output speed e TTFT.

## Argumentos principais

- **AA-AgentPerf**: benchmark de hardware que mede quantos agentes concurrentes um inference system suporta sob SLO predefinidos (output token speed + TTFT)
- **Agent trajectories**: non-deterministic sequences de requests e tool calls; o benchmark captura isto com trajectories prerecorded de agentic coding (5K-131K sequence lengths, mean 27K)
- **SLO tiers**: P25 output speed (30/100/300 tokens/s) e P95 TTFT (10/5/3s) — define max concurrency
- **GB300 NVL72 vs H200**: 61.4K vs 2.6K concurrent agents per MW; 57.5 vs 1.4 per GPU
- **Otimizações**: SGLang/TensorRT-LLM/vLLM com WideEP, DeepEP, DeepGEMM, Mega MoE (MXFP4/MXFP8), NVLink scale-up domain (72 GPUs)

## Key insights

- Agentic workloads têm características únicas: non-deterministic request sequences, interleave reasoning+tool use, interturn latency
- Power efficiency (agents/MW) é o métrico prático para data center capacity planning
- MoE expert execution spread across full NVL72 domain maximiza batch sizes efetivos
- Mean sequence length 27K tokens — agentic coding usa contextos muito maiores que chat simples

## Exemplos e evidências

- 61.4K concurrent agents per MW (GB300 NVL72) vs 2.6K (H200)
- DeepSeek-V4-Pro como modelo de teste
- 12+ programming languages nos trajectories
- Tool calls mapeados para CPU-side tasks com 1s median delay

## Implicações para o vault

- Relevante para [[03-RESOURCES/concepts/agent-systems/agent-model-routing]] — infraestrutura afeta qual modelo rotear
- Mean 27K tokens confirma que agentes precisam de context windows grandes — conecta com [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- Tool call latency (1s median) é bottleneck — relevante para design de pipelines com tool use

## Minha Síntese

**O que muda:** Agentic workloads não são apenas "chat mais longo" — são non-deterministic request sequences com interturn latency. A métrica de sucesso é quantos agentes concurrentes sob SLO, não apenas tokens/segundo.

**Conexão pessoal:** O pipeline-semanal roda como cron job — o conceito de SLO tiers (output speed + TTFT) aplica diretamente. Se o pipeline demora >30min, algo está errado. Definir SLOs explícitos melhoraria operational awareness.

**Próximo passo:** Nenhum próximo passo imediato — benchmark de hardware não é actionable no vault, mas conceito de SLO para cron jobs é absorvido.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/entities/Claude]]