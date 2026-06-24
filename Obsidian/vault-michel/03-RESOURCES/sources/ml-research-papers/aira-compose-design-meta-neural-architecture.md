---
title: "Agentic Discovery of Neural Architectures: AIRA-Compose and AIRA-Design"
type: source
source_file: "Clippings/Agentic Discovery of Neural Architectures AIRA-Compose and AIRA-Design.md"
origin: "arxiv.org/abs/2605.15871"
author: "Alberto Pepe, Chien-Yu Lin, Despoina Magka, Bilge Acun, Yannan Wu, Anton Protopopov, Carole-Jean Wu, Yoram Bachrach — FAIR at Meta"
published: 2026-05-14
ingested: 2026-05-28
tags: [neural-architecture-search, recursive-self-improvement, meta-ai, llm-agents, hybrid-llm, mamba, transformer, aira, research]
triagem_score: 9
---
# AIRA-Compose e AIRA-Design — Descoberta Agêntica de Arquiteturas Neurais

> [!key-insight] Tese central
> Agentes LLM podem descobrir autonomamente arquiteturas híbridas (Transformer + Mamba) que superam Llama 3.2 e alternativas encontradas por NAS tradicional (Bayesian Optimization), estabelecendo um paradigma de Recursive Self-Improvement (RSI) para a próxima geração de modelos fundacionais.

## Conteúdo

### Dois frameworks complementares

**AIRA-Compose** (busca de alto nível):
- 11 agentes navegam um espaço combinatório de primitivas computacionais: Attention (mA), MLP (M), Mamba SSM (Mb)
- Espaço: 2^16 = 65.536 arranjos (2 primitivas) ou 3^16 ≈ 43M (3 primitivas)
- Ciclo: draft → debug → improve em tree-based search (MCTS + greedy)
- Budget: 24h de compute por run; modelos escalados de 1M → 350M → 1B → 3B params
- Yield: 14 arquiteturas novas em 2 famílias — AIRAformers (Transformer) e AIRAhybrids (Transformer+Mamba)

**AIRA-Design** (design mecanístico de baixo nível):
- Até 20 agentes escrevem novos mecanismos de atenção do zero (model.py) e otimizam scripts de treinamento (train.py)
- Benchmark LRA: precisão within 2.3pp do SOTA humano em document matching, 2.6pp em text classification
- Benchmark Autoresearch: Greedy Opus 4.5 atinge 0.968 validation BPB — superando o mínimo de referência publicado

### Resultados principais (1B scale, budget fixo de 37.5B tokens)
| Arquitetura | Val Loss | Avg 0-shot | DCLM Core |
|-------------|----------|------------|-----------|
| Llama 3.2 (baseline) | 2.815 | 57.5% | 46.9% |
| AIRAformer-D (Str.) | **2.734** | **59.7%** | **48.9%** |
| AIRAhybrid-D | melhoria +3.8% downstream vs Llama 3.2 |

- AIRAformer-C escala **54% mais rápido** que Llama 3.2 (isoFLOP frontier)
- AIRAhybrid-C escala **23% mais rápido** que Nemotron-2 modificado

### Infrastructure: AIRS-Bench + AIRA-dojo
- Tarefas definidas por `{problem, dataset, metric}` triplet — standardizado e extensível
- Harness AIRA-dojo: 4 operadores — Draft, Debug, Improve, Analyze
- Framework rodou 12 RSI tasks com 6–12 LLMs diferentes como reasoning cores

## Key Insights

- Agentes com domain knowledge navegam o espaço combinatório de forma mais eficiente que Bayesian Optimization pura — contexto semântico supera força bruta
- Arquiteturas attention-heavy (C, D) são melhores com token budget fixo; arquiteturas balanceadas são mais eficientes com compute budget fixo (isoFLOP)
- Claude Opus 4.5/4.6 destacado como top performer nos benchmarks LRA e Autoresearch
- RSI aqui é específico: agentes encontram arquiteturas para os modelos que os rodam — loop recursivo real

## Implicações para o vault

- Evidência forte para [[03-RESOURCES/concepts/agent-systems/automated-research-agents]]
- Instancia concretamente [[03-RESOURCES/concepts/agent-systems/agentic-rl]] com NAS como domínio
- Conexão com [[03-RESOURCES/entities/Meta-AI]] (FAIR) e seus outputs de pesquisa
- Referência para qualquer discussão sobre RSI — agentes melhorando suas próprias arquiteturas base

## Links

- Fonte: `Clippings/Agentic Discovery of Neural Architectures AIRA-Compose and AIRA-Design.md`
- Paper: arxiv.org/abs/2605.15871
- Entidade: [[03-RESOURCES/entities/Meta-AI]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/automated-research-agents]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/hybrid-architectures]]
