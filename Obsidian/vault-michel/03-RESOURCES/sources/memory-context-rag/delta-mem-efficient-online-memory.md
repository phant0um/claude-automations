---
title: "δ-mem: Efficient Online Memory for Large Models"
type: source
source: Clippings/## δ-mem Efficient Online Memory for Large.md
created: 2026-05-17
ingested: 2026-05-17
tags: [ai-agents, research, memory, llm]
triagem_score: 10
---

## Tese central
Online memory layer (δ-mem) permite LLMs operarem com contexto longo sem inflar custo computacional — atualiza memória incrementalmente via delta updates em vez de re-processar todo histórico a cada turno. Paper de NTU + Fudan + SJTU endereça o gargalo fundamental de agentes de longa duração.

## Key insights
- **Delta updates vs full re-encoding:** abordagem padrão processa contexto inteiro a cada turno — custo O(n²) com self-attention. δ-mem mantém estado de memória e aplica apenas diferença (delta) do novo input — custo O(k) onde k é tamanho do update, não do histórico total
- **Online = sem batch offline:** atualização acontece durante inferência, não em processo separado de consolidação. Memória evolui em tempo real conforme agente opera
- **Multi-institution authorship:** NTU + Fudan + SJTU indica pesquisa com rigor amplo e perspectivas complementares — não paper de grupo único com viés de implementação própria
- **Complemento a memory architecture existente:** δ-mem opera na camada de contexto ativo, não substitui memória externa (wiki/vector store). Camadas se complementam: δ-mem para contexto recente eficiente, external memory para recall de longo prazo

## Problema que δ-mem resolve

### Custo de contexto longo em agentes

Agente de longa duração (horas ou dias de operação) acumula histórico extenso. Opções tradicionais:
1. **Truncar contexto:** perder informação antiga — recall degradado
2. **Contexto completo a cada turno:** custo quadrático de atenção — inviável economicamente
3. **RAG em histórico:** latência de retrieval + qualidade dependente de embeddings — boa para busca, ruim para continuidade de raciocínio

δ-mem resolve com quarta opção: manter estado comprimido de memória, atualizar incrementalmente.

## Arquitetura δ-mem

### Estado de memória M_t

Representação comprimida do histórico até turno t. Não é lista de turnos — é representação vetorial densa que captura informação semântica acumulada.

### Update incremental

```
M_t = δ(M_{t-1}, x_t)
```

Onde x_t é o novo input no turno t e δ é função de update aprendida. Função δ é treinada para:
1. Incorporar informação relevante de x_t em M_{t-1}
2. Comprimir/decay informação antiga menos relevante
3. Preservar informação crítica com alta fidelidade

### Atenção com memória

No forward pass, modelo atende não só ao contexto recente mas ao estado de memória M_t:

```
Attention(Q, K_recent ∪ K_memory, V_recent ∪ V_memory)
```

Memória contribui como "contexto virtual" sem ocupar espaço em context window real.

## Comparação com alternativas

| Abordagem | Custo por turno | Recall qualidade | Continuidade |
|-----------|----------------|-----------------|--------------|
| Contexto completo | O(n²) | Perfeita | Alta |
| Truncação | O(k²) | Degradada | Baixa |
| RAG em histórico | O(k²) + retrieval | Boa para facts | Média |
| δ-mem | O(k²) + O(update) | Alta | Alta |

## Limitações e trade-offs

- Treinamento de δ requer dados de sessões longas — custo de fine-tuning para domínio específico
- Estado M_t é representação opaca — interpretabilidade baixa (o que está sendo retido é difícil de inspecionar)
- Compressão inevitavelmente perde alguma informação — recall pode falhar para detalhes específicos antigos

## Relevância prática para agentes do vault

Agentes que operam por sessões longas (nexus em sessões de trabalho, ingest-report processando batch grande) se beneficiariam de δ-mem para manter contexto sem custo explosivo. Implementação atual usa context window + hot.md como proxy — δ-mem seria upgrade arquitetural.

## Comparação com outras abordagens de memória online

**Versus hot.md (abordagem vault atual):**
Hot.md é wiki estática atualizada entre sessões — equivalente a snapshot de memória, não memória online contínua. δ-mem atualiza durante inferência, sem necessidade de sessão acabar. Hot.md é mais simples e suficiente para uso atual; δ-mem seria vantajoso apenas para sessões contínuas de horas.

**Versus RAG em histórico:**
RAG faz retrieval semântico em histórico armazenado externamente. δ-mem mantém representação comprimida in-model. Diferença fundamental: RAG recupera chunks específicos (good for facts), δ-mem mantém estado acumulado (good for continuity). Para agente que precisa de ambos, usar δ-mem + RAG complementarmente.

**Versus sliding window de contexto:**
Sliding window é truncação simples — os últimos N tokens ficam, os anteriores são descartados. δ-mem comprime toda a história em estado denso — sem truncação, com perda controlada. Em sessões longas, δ-mem retém significativamente mais informação relevante por token de contexto usado.

## Estado atual do campo (2026)

δ-mem está em fase de pesquisa aplicada — implementações existem em PyTorch mas integração em modelos de produção (Claude, GPT-4) ainda não é padrão. Tendência: infra de memória online vai se tornar feature padrão de APIs de agentes nos próximos 1-2 anos conforme custo de tokens pressiona otimização.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
- [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]]
- [[03-RESOURCES/concepts/llm-ml-foundations/memory-transfer-learning]]
