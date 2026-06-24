---
title: "CUDA Graph Implementation in LLM Inference Server"
type: source
source: Clippings/CUDA Graph implementation in LLM Inference server.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, llm-infra]
---

## Tese central
Walkthrough de código de implementação de CUDA Graphs num servidor de inferência LLM próprio: em vez de lançar kernels um a um a cada passo de decode, captura-se o padrão de execução fixo de cada batch size num grafo e o replay substitui o overhead de launch repetido.

## Argumentos principais
- CUDA Graphs exigem padrão de execução fixo para captura — por isso o engine cria buffers/contexto dummy (endereços congelados pela vida do grafo) antes de gravar o grafo real.
- Para decode, o batch size relevante é majoritariamente 1 (cada passo de decode processa um token por sequência); o engine ainda assim captura grafos para um conjunto de batch sizes (1,2,3,4 + max_bs) para cobrir variação de carga.
- Warmup run (lazy allocs/autotune) acontece fora do bloco `torch.cuda.graph(...)` — captura limpa só do forward pass em si, sem efeitos colaterais de alocação dinâmica.
- Arquitetura assíncrona: `/completions` endpoint dispara `asyncio.gather` sobre múltiplos prompts, e o engine roda um `run_loop` em background task desde o startup do servidor.

## Key insights
- A escolha de pré-capturar grafos por batch size discreto (não para todo batch size possível) é trade-off memória/cobertura — replay é rápido mas exige grafo já existente para aquele tamanho exato.
- `self.graph_pool` compartilhado entre grafos de diferentes batch sizes economiza memória de alocação de CUDA Graph pool.

## Exemplos e evidências
- Código Python/PyTorch completo: startup do FastAPI engine, `capture_cudagraph()`, estrutura de buffers estáticos, loop de captura por batch size reverso.

## Implicações para o vault
Aprofunda `inference-optimization` com exemplo de implementação real (não apenas teoria) de uma técnica concreta de redução de overhead de kernel launch em servidores de inferência — referência técnica caso o vault explore build de inference server próprio.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-engines-hardware-first]]
