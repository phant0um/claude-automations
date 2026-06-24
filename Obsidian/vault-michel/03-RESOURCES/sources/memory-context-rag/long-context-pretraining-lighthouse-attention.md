---
title: "Long Context Pre-Training with Lighthouse Attention"
type: source
source: Clippings/Long Context Pre-Training with Lighthouse Attention.md
created: 2026-05-17
ingested: 2026-05-17
tags: [ml-research, attention, long-context]
triagem_score: 9
---

## Tese central
Lighthouse Attention: mecanismo de atenção O(n) que substitui self-attention quadrática para sequências extremamente longas durante pre-training — viabiliza treinamento nativo com contextos de milhões de tokens sem custo computacional proibitivo. Nous Research consolida linha de pesquisa de eficiência.

## Key insights
- **Complexidade O(n) vs O(n²):** self-attention padrão é quadrática — dobrar comprimento de sequência quadruplica compute de atenção. Lighthouse é linear — dobrar sequência dobra compute. Em 1M de tokens, diferença é fator de 500.000x em compute de atenção
- **Pre-training nativo vs extensão post-hoc:** abordagem padrão para long context é treinar com sequência curta e depois estender (YaRN, RoPE scaling). Lighthouse permite treinar com contexto longo nativo — representações aprendidas são melhores para tarefas de long-context
- **Nous Research — linha coerente:** token superposition (comprimir sequência), Lighthouse Attention (escalar atenção linearmente) — cada paper ataca ponto diferente do custo de long-context. Stack combinado é potencialmente transformador
- **Alternativa a sparse attention e SSMs:** sparse attention (BigBird, Longformer) introduz heurísticas de quais tokens atender. SSMs (Mamba, RWKV) requerem arquitetura diferente. Lighthouse mantém arquitetura transformer com atenção aproximada de alta qualidade

## O problema de self-attention em sequências longas

### Crescimento quadrático

Para sequência de comprimento n, self-attention padrão requer:
- Compute: O(n²) — cada token atende a cada outro
- Memória: O(n²) — matriz de atenção n×n

Impacto prático:
- n=2048 (padrão): 4M de operações de atenção
- n=32768 (32K tokens): 1B de operações — 250x mais
- n=1M: 1T de operações — 244.000x mais que n=2048

Em treinamento, esse custo é pago em cada batch, em cada step, em cada GPU. Contexto longo nativo é economicamente inviável com self-attention padrão.

## Como Lighthouse Attention funciona

### Intuição: o farol

Nome vem da metáfora: em vez de cada token ver todos os outros igualmente, existe um "farol" que agrega informação global e cada token atende ao farol local + subset fixo de tokens próximos.

### Mecanismo

1. **Local attention window:** cada token atende plenamente a w tokens ao redor (ex: w=512). Captura dependências locais com alta fidelidade.

2. **Lighthouse tokens:** conjunto pequeno de k tokens especiais (ex: k=128) que agregam informação da sequência inteira via pooling ou atenção hierárquica.

3. **Global attention via lighthouse:** cada token atende ao local window + todos os k lighthouse tokens. Como lighthouse tokens têm informação global, token efetivamente "vê" sequência inteira via intermediários.

Custo resultante: O(n·w + n·k) = O(n) dado que w e k são constantes.

### Qualidade da aproximação

Trade-off central: lighthouse tokens não capturam toda a informação da sequência completa — é aproximação. Qualidade depende de:
- Quantos lighthouse tokens são usados (mais = melhor qualidade, maior custo)
- Como lighthouse tokens são posicionados na sequência (uniformes vs adaptativos)
- Como eles agregam informação (pooling simples vs atenção hierárquica)

Paper reporta que Lighthouse com k=256 atinge 95%+ da qualidade de full attention em benchmarks de long-context, com custo linear.

## Comparação com abordagens concorrentes

| Mecanismo | Complexidade | Qualidade long-ctx | Compat. transformer |
|-----------|-------------|-------------------|---------------------|
| Full attention | O(n²) | Perfeita | Sim |
| Sparse attention | O(n·√n) | Alta (depende de padrão) | Sim (com modificação) |
| SSM (Mamba) | O(n) | Alta em tarefas de sequência | Não (arquitetura diferente) |
| Lighthouse | O(n) | Alta (95%+) | Sim (modificação mínima) |
| Flash Attention | O(n²) compute, O(n) memória | Perfeita | Sim |

Flash Attention não resolve o problema — reduz uso de memória mas não o compute. Lighthouse reduz ambos.

## Por que long-context nativo importa (vs extensão post-hoc)

Abordagem dominante para long-context em 2024: treinar com sequência curta (4K-8K tokens), depois extender via técnicas de interpolação posicional (YaRN, NTK-aware scaling, LongLLaMA).

Problemas da extensão post-hoc:
- Modelo não viu exemplos longos durante pre-training — representações não são ótimas para esses comprimentos
- "Lost in the Middle": atenção degrada em conteúdo no meio de contextos muito longos
- Generalização incerta: modelo pode ser bom em benchmarks de long-context mas fraco em tarefas reais de longa duração

Lighthouse pré-training: modelo aprende desde o início a operar em contextos longos — representações são otimizadas para esse regime. Analogia: ensinar a nadar em piscina rasa e depois "extender" para piscina funda vs aprender em piscina funda desde o início.

## Aplicações habilitadas por contexto massivo nativo

Com contexto de 1M tokens nativo, casos de uso que se tornam viáveis:
- Análise de codebase completa (projeto de 500K linhas de código inteiro no contexto)
- Revisão de livro completo ou stack de papers relacionados em uma única sessão
- Agente de pesquisa com histórico de meses de trabalho sem compressão externa
- Auditoria de compliance em documentação legal extensa sem chunking

## Combinação com token superposition

Nos Research tem dois papers complementares:
- Token superposition: comprime sequência de n para n/k tokens antes da atenção
- Lighthouse Attention: escala atenção linearmente em vez de quadraticamente

Combinados: sequência de 1M tokens é comprimida para ~650K tokens, então atenção é executada em O(n) em vez de O(n²). Impacto total: viabiliza treinamento com contexto massivo nativo em hardware acessível.

## Links
- [[03-RESOURCES/sources/ml-research-papers/efficient-pretraining-token-superposition]]
- [[03-RESOURCES/entities/Nous-Research]]
