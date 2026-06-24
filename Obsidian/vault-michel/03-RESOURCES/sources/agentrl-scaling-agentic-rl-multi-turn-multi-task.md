---
title: "AgentRL: Scaling Agentic Reinforcement Learning with a Multi-Turn, Multi-Task Framework"
type: source
source: Clippings/AgentRL Scaling Agentic Reinforcement Learning with a Multi-Turn, Multi-Task Framework.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, agentic-rl, source, score-A]
---

## Tese central

AgentRL resolve o problema de treinar LLM agents em multi-turn, multi-task RL com três inovações: pipeline fully-asynchronous generation-training, cross-policy sampling para exploração, e task advantage normalization para estabilizar multi-task training. Superou GPT-5 e Claude-Sonnet-4 em cinco tarefas agentic.

## Argumentos principais

- **Fully-asynchronous generation-training pipeline**: decouples rollout de optimization para maximizar hardware throughput preservando training stability
- **Cross-policy sampling**: amostra ações de um pool de modelos para aumentar diversidade de amostras e eficiência de aprendizado em multi-turn settings
- **Task advantage normalization**: normaliza advantage no nível de tarefa para estabilizar treino com múltiplas tarefas heterogêneas
- **Unified function-call API + containerized environments**: suporta desenvolvimento heterogêneo de ambientes em multi-task RL
- **Centralized controller**: coordena múltiplos ambientes containerizados para rollout

## Key insights

- Multi-task training com AgentRL matches os melhores resultados de modelos task-specific — generalização sem perder performance
- Cross-policy sampling é fundamental para exploração em multi-turn — o modelo sozinho pode ficar preso em trajetórias repetitivas
- A arquitetura assimétrica (generation vs training) maximiza GPU utilization sem sacrificar consistência
- Adotado em produção no AutoGLM (autoglm.zhipuai.ca)

## Exemplos e evidências

- Open-source: github.com/THUDM/AgentRL
- 5 agentic tasks, superando GPT-5, Claude-Sonnet-4, DeepSeek-R1
- Adotado no AutoGLM
- Tsinghua University + Z.AI collaboration

## Implicações para o vault

- Complementa [[03-RESOURCES/sources/agent-r1-unified-modular-framework-agentic-rl]]: AgentRL foca em scale e multi-task, Agent-R1 em abstração step-level
- Cross-policy sampling conecta com [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — diversidade de políticas melhora exploração
- Task advantage normalization é relevante para [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] em multi-task

## Minha Síntese

**O que muda:** Cross-policy sampling é um insight poderoso — em vez de depender de um único modelo para explorar, amostrar de um pool aumenta diversidade. Aplica ao vault: usar modelos diferentes para diferentes fases do pipeline pode melhorar cobertura.

**Conexão pessoal:** O pipeline-semanal usa Haiku para triagem e Sonnet para ingest — já faço uma forma primitiva de cross-policy. Formalizar isto poderia melhorar qualidade.

**Próximo passo:** Nenhum próximo passo imediato — conceito absorvido para referência futura em design de multi-model pipelines.

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/entities/Claude]]