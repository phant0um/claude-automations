---
title: "Optical Context Retrieval (OCR-Memory)"
type: concept
status: developing
created: 2026-05-01
updated: 2026-05-01
tags: [concept, agent-memory, context-compression, vision, long-horizon]
---

# Optical Context Retrieval (OCR-Memory)

**Definição:** Técnica que armazena trajetórias de agente como **imagens** em vez de texto, alcançando 10× compressão de tokens com fidelidade total. Na recuperação, usa Set-of-Mark para localizar e transcrever apenas a região relevante.

Paper: `Clippings/OCR-Memory Optical Context Retrieval for Long-Horizon Agent Memory.md`

## O Problema que Resolve

Em agentes de longo horizonte, o contexto acumula tokens massivos de trajetórias passadas:
- Trajectories completas → 3.980 tokens/step
- OCR-Memory → **596 tokens/step** (6.7× redução)

E com memória generativa (LLM summariza o que aconteceu), a fidelidade cai:
- Generativa: 84.3% faithfulness
- OCR-Memory Locate-and-Transcribe: **100% faithfulness**

## Como Funciona

```
Armazenamento:  agent trajectory → screenshot/rendering → image store
                                    (10x token compression)

Recuperação:    query → find relevant image region
                      → Set-of-Mark bounding box
                      → transcribe only that region
                      → inject into context (596 tokens vs 3.980)
```

### Locate-and-Transcribe via Set-of-Mark

1. **Locate:** dado query, encontra imagem relevante + região (bounding box)
2. **Mark:** aplica Set-of-Mark (etiquetas numéricas nos elementos visuais)
3. **Transcribe:** transcreve apenas a região marcada como texto
4. **Result:** texto exato, sem alucinação de summarização

Fidelidade 100% porque não há LLM no loop de recuperação — é OCR direto na região correta.

## Benchmarks

| Benchmark | OCR-Memory | AWM (baseline) |
|-----------|-----------|----------------|
| Mind2Web Ele Acc | **53.8%** | 49.1% |
| AppWorld | **58.1%** | 55.0% |

**AWM** (Agent Workflow Memory) é o baseline de memória generativa baseado em texto.

## Por que Importa

1. **Fidelidade > Compressão** em tarefas de longo horizonte onde erros cascateiam
2. Tokens salvos por step (6.7×) traduzem diretamente em:
   - Mais steps no mesmo context budget
   - Menor custo por sessão
   - Mais ferramenta calls disponíveis (ex: os 4K+ do Kimi K2.6)

3. Compatível com qualquer agente que use screenshots/renders no loop — especialmente web agents e computer-use agents

## Limitações

- Requer que o estado relevante seja **visualmente renderizável** — não funciona para estado interno de código ou dados não-visuais
- Custo de armazenamento de imagens vs texto puro (compensado pela redução em retrieval)
- Locate step tem custo computacional (image search/matching)

## Relacionado

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — OCR-Memory é uma implementação de episodic memory
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] — OCR-Memory é diretamente sobre otimizar uso do context window
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — compressão de trajetórias como técnica de engenharia de contexto
- [[03-RESOURCES/entities/Kimi-K2.6]] — escala de 4K tool calls se beneficia de compression como OCR-Memory
- [[03-RESOURCES/concepts/llm-ml-foundations/memory-transfer-learning]] — outro avanço em memory para coding agents (ICML)
