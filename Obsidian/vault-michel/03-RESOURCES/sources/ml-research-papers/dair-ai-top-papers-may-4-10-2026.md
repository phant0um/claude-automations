---
title: "DAIR.AI — Top AI Papers of the Week (May 4-10, 2026)"
type: source
source_file: "Clippings/Top AI Papers of the Week.md"
origin: artigo no X (@dair_ai)
ingested: 2026-05-14
tags: [ai-papers, research, agents, harness, memory, training, multi-agent]
triagem_score: 9
---
# DAIR.AI — Top AI Papers of the Week (May 4-10, 2026)

> [!key-insight] Core point
> 10 papers que definem o estado da arte em agent harness design, multi-agent coordination, memória agentic, e training (maio 2026) — com o argumento central de que wins de harness estão se tornando wins de modelo.

## Papers

### 1. HeavySkill
- **Argumento central:** o que drive performance de harness não é orquestração, mas uma inner skill: parallel reasoning + deliberation. Internalize-a no modelo e o scaffolding torna-se opcional.
- **2 estágios:** (1) raciocínio paralelo em múltiplas chains; (2) deliberation pass — compara, critica, sintetiza
- **Resultado:** GPT-OSS-20B: 69.7% → 85.5% no LiveCodeBench (+15.8pp); R1-Distill-Qwen-32B: 35.7% → 69.3% no IFEval
- Treino via RLVR; skill é portável entre harnesses
- [arxiv.org/abs/2605.02396](https://arxiv.org/abs/2605.02396)

### 2. Conductor (Sakana AI, ICLR 2026)
- Modelo 7B orquestra outros LLMs em vez de resolver problemas ele mesmo
- Treinado com RL para: (1) design de topologias de comunicação + (2) prompt engineering focado para cada worker
- Topologias recursivas emergem (Conductor se escolhe como worker)
- +3% em AIME25 e GPQA-D vs melhor worker individual — equivalente a ganhos de geração completa de modelo
- [arxiv.org/abs/2512.04388](https://arxiv.org/abs/2512.04388)

### 3. Self-Improving Pretraining (Meta FAIR)
- Move comportamentos de safety/factuality/quality para o **pretraining** em vez de post-training
- Modelo post-trained forte reescreve sufixos de pretraining → julga rollouts do modelo em treino
- Ganhos: +36.2% factuality, +18.5% safety, 86.3% win rate em generation quality
- [arxiv.org/abs/2601.21343](https://arxiv.org/abs/2601.21343)

### 4. Connect Four AlphaZero Benchmark
- Novo benchmark para coding agents: dado spec de 1 parágrafo + budget limitado, reconstruir breakthrough de ML end-to-end
- Claude Opus 4.7: implementou MCTS + redes neurais + self-play em 3h → 7/8 wins vs solver Pascal Pons (first-mover)
- Nenhum outro frontier agent passou de 2/8
- [arxiv.org/abs/2604.25067](https://arxiv.org/abs/2604.25067)

### 5. Coordination as Architecture
- 41-87% de falhas em sistemas multi-agent são defects de **coordenação**, não capacidade do modelo base
- Propõe coordenação como layer arquitetural configurável, separável da lógica do agente
- Metodologia: mesmos LLMs, ferramentas, prompts, cap de output — só varia estrutura de coordenação
- [arxiv.org/abs/2605.03310](https://arxiv.org/abs/2605.03310)

### 6. Horizon Generalization (Microsoft Research)
- Variável única: horizon length (tamanho da sequência até o goal)
- Horizon é training bottleneck: modelos que aprendem bem em horizons curtos quebram em longos
- Fix: macro actions que comprimem muitas decisões atômicas em uma
- Modelos treinados em horizons reduzidos generalizam para longos no inference — "train cheap, deploy long"
- [arxiv.org/abs/2605.02572](https://arxiv.org/abs/2605.02572)

### 7. 1,000 Synthetic Computers (Microsoft Research)
- 1.000 computadores sintéticos com estruturas de diretórios, documentos e artifacts realistas
- 2 agents: user (define goals) + worker (executa); ~2.000+ turnos por simulação (~1 mês de trabalho humano)
- Framework escalável para bilhões de mundos sintéticos
- Bottleneck de computer-use agents: dados de treino long-horizon realistas
- [arxiv.org/abs/2604.28181](https://arxiv.org/abs/2604.28181)

### 8. Contextual Agentic Memory is a Memo
- Memória de agentes atual = memo, não memória real: lookup sem consolidação
- Teoria CLS (Complementary Learning Systems): biologia usa fast hippocampal + slow neocortical consolidation; AI agents só implementam a primeira metade
- Ceiling de generalização em tarefas composicionalmente novas enquanto memória for retrieval-only
- [arxiv.org/abs/2604.27707](https://arxiv.org/abs/2604.27707)

### 9. Agentic-imodels
- Loop de autoresearch onde coding agent (Claude Code, Codex) itera regressors scikit-learn simultaneously accurate AND legíveis por outros LLMs
- Interpretabilidade medida por: LLM pequeno consegue simular o modelo lendo apenas seu `__str__`?
- Pareto frontier supera todos os baselines interpretativos clássicos; melhora 4 sistemas agentic de data science no BLADE benchmark em 8-73%
- [arxiv.org/abs/2605.03808](https://arxiv.org/abs/2605.03808)

### 10. Skills as Verifiable Artifacts
- Skills são código não-confiável até verificadas; runtime deve enforcar esse default
- Sem skill verification: HITL dispara em toda call irreversível → rubber-stamping em escala
- Com verification como processo gateado separado: HITL só dispara para o não-verificado
- [arxiv.org/abs/2605.00424](https://arxiv.org/abs/2605.00424)

## Conexões
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-reduction]]
- [[03-RESOURCES/concepts/llm-ml-foundations/horizon-length]]
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/concepts/llm-ml-foundations/post-training-llm]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/entities/Claude-Opus-47]]

## Padrão transversal: wins de harness migrando para wins de modelo

A justaposição dos 10 papers desta semana revela um padrão que nenhum paper individual torna explícito: as melhorias que antes exigiam mudanças de harness estão sendo internalizadas como capacidades de modelo. HeavySkill internaliza raciocínio paralelo + deliberation que antes exigia múltiplos agentes externos. IMAD (Latent Agents) internaliza debate multi-agente que antes exigia orquestração de múltiplos processos. Conductor aprende a orquestrar outros LLMs em vez de precisar de orquestrador fixo em código.

Isso não significa que harnesses se tornam obsoletos — AEvo demonstra o oposto, com o harness como componente safety-critical. Significa que a fronteira entre "o que o modelo faz" e "o que o harness faz" está se movendo: capacidades que requeriam scaffolding externo são absorvidas pelo modelo, liberando o harness para focar em coordenação, verificação e proteção de ambiente.

## Horizon Generalization e a implicação de "train cheap, deploy long"

O paper de Horizon Generalization (Microsoft Research) tem uma implicação econômica direta: o custo de treino de agentes long-horizon pode ser reduzido treinando em horizons curtos e contando com generalização no inference. Isso contraria a intuição de que treinar para tarefas longas requer exemplos de treino longos.

A ressalva é que a generalização depende de macro actions — representações comprimidas de múltiplas ações atômicas. Um agente que não tem uma boa biblioteca de macro actions não pode aplicar esse princípio. Para o vault-michel, skills bem definidas funcionam como macro actions: "wiki-ingest" comprime dezenas de ações individuais (ler source, extrair conceitos, criar páginas, atualizar hot.md, validar wikilinks) em uma operação de nível alto.

## Agentic-imodels como exemplo de loop de autoresearch

O paper de Agentic-imodels é o único dos 10 que implementa um loop de autoresearch completo: o agente itera regressores scikit-learn buscando simultâneamente acurácia E legibilidade por outros LLMs. O critério de legibilidade — um LLM pequeno consegue simular o modelo lendo apenas seu `__str__`? — é uma forma de verificação automática de qualidade que não depende de julgamento humano. Isso é relevante para qualquer sistema que precisa gerar artefatos interpretáveis por outros agentes, não apenas por humanos.
