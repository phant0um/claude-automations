---
title: "Gemma 4 on Cerebras — The Fastest Inference is Now Multimodal"
type: source
source: "Clippings/Gemma 4 on Cerebras — The Fastest Inference is Now Multimodal.md"
created: 2026-06-18
ingested: 2026-06-21
tags: [ai-agents, inference-hardware]
---

## Tese central
Gemma 4 31B (Google DeepMind, denso, Apache 2.0) entra em preview na Cerebras Inference rodando a mais de 1.500 tokens/s — 15x mais rápido que Claude Haiku (~100 tok/s) em qualidade comparável — e é o primeiro modelo multimodal (visão) na plataforma wafer-scale da Cerebras.

## Argumentos principais
- Velocidade compensa o gargalo real de loops agênticos/multimodais: eles chamam o modelo repetidamente (inspecionar → raciocinar → produzir saída estruturada → chamar ferramenta → verificar → repetir), e a 100 tok/s esse loop é lento demais para input em tempo real; a 1500+ tok/s aplicação e usuário trabalham em paralelo.
- Modelo denso (não MoE) escolhido deliberadamente por trade-off: atinge boa inteligência (score 29, quase igual ao Haiku 30) sem footprint de memória de MoE.
- Primeira vez que a Cerebras suporta entendimento de imagem — habilita computer use e workflows de captura de tela/documento/gráfico/diagrama na velocidade wafer-scale.

## Key insights
- A relação "throughput alto = mais tentativas de verificação/retry cabem no mesmo orçamento de tempo" é um argumento de design de sistemas agênticos generalizável — throughput de inferência não é só sobre latência percebida, é sobre quantos ciclos de auto-correção um agente pode rodar antes do usuário notar lentidão.

## Exemplos e evidências
- Casos de uso citados: screenshot-to-insight, sumarização de contexto longo, screenshot-to-patch (UI quebrada + código fonte + erro de console → patch mínimo).

## Implicações para o vault
Relevante para `inference-optimization`/`inference-engines-hardware-first` como exemplo de hardware especializado (wafer-scale) trocando flexibilidade por throughput — referência se o vault avaliar providers de inferência para workloads agênticos de alto volume.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-engines-hardware-first]]
