---
title: "xai-org/x-algorithm — For You Feed Open-Sourced (May 2026)"
type: source
category: ai-research
author: "xAI / X Engineering"
source_url: "https://github.com/xai-org/x-algorithm"
published: 2026-05-15
ingested: 2026-05-18
tags: [source, ai-research, recommendation-system, xai, grok, transformer, ranking]
triagem_score: 4
---

# xai-org/x-algorithm — For You Feed Open-Sourced (May 2026)

## Tese central

xAI open-sourceou o algoritmo completo do feed "For You" do X: sistema retrieval → ranking baseado em transformer Grok com eliminação total de features hand-engineered, e a atualização de Maio 2026 adiciona pipeline de inferência end-to-end, content understanding (Grox) e blending de ads.

## Key insights

**Arquitetura geral:**
- Home Mixer (orquestração) → Query Hydration → Candidate Sources → Hydration → Filtering → Scoring → Feed
- Duas fontes de candidatos: **Thunder** (posts de quem você segue, in-network) e **Phoenix Retrieval** (out-of-network, ML similarity search em corpus global)
- **Phoenix Scorer:** transformer baseado em Grok-1 que prediz P(like), P(reply), P(repost), P(click) — score final = combinação ponderada

**Princípio central:** "Eliminamos toda feature hand-engineered e a maioria das heurísticas. O transformer Grok faz todo o trabalho pesado entendendo seu histórico de engagement."

**Atualizações Maio 2026:**
1. Pipeline end-to-end (`phoenix/run_pipeline.py`) — substituiu scripts separados; retrieval → ranking em passo único, espelhando produção
2. Artefatos pré-treinados: modelo Phoenix mini (256-dim, 4 attention heads, 2 transformer layers) ~3GB via Git LFS — inferência out-of-the-box
3. **Grox** (`grox/`): pipeline de content understanding — spam detection, post-category classification, PTOS policy enforcement (classifiers + embedders + task-execution engine)
4. **Ads blending** (`home-mixer/ads/`): injeção e posicionamento de ads com brand-safety tracking
5. Query hydrators: followed topics, starter packs, impression bloom filters, mutual follow graphs, served history
6. Candidate hydrators: engagement counts, brand safety signals, language codes, media detection, mutual follow scores

**Relevância para AI/ML:**
- Exemplo de substituição completa de feature engineering por transformer end-to-end em sistema de produção de escala global
- Recomendação como compressão de engagement history → relevance score (paralelo ao padrão sub-agente de compressão de contexto)

## Links

- [[03-RESOURCES/sources/misc-low-confidence/x-algorithm-may-2026-ranking]] — source anterior sobre mudanças de ranking (comportamento/playbook)
- [[03-RESOURCES/concepts/agent-systems/automated-research-agents]] — ML research em produção
