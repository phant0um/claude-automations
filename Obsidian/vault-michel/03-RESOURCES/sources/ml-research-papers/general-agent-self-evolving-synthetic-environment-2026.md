---
title: "General Agent: A Self-Evolving, Synthetic Agent Environment"
type: source
source: "Clippings/General Agent A Self-Evolving, Synthetic Agent Environment.md"
url: "https://www.primeintellect.ai/blog/general-agent"
author: ["Prime Intellect"]
created: 2026-05-24
ingested: 2026-05-28
tags: [ai-agents, source, synthetic-environments, rl-training, tool-calling, self-evolving]
---

## Tese central

**general-agent** é um ambiente sintético totalmente auto-evoluível para treinamento e avaliação de agentes, com 4.504 tarefas em 1.040 domínios e mais de 8.000 ferramentas únicas. Usa um jogo de 2 jogadores (Synthesizer + Solver) onde o corpus de tarefas cresce progressivamente em dificuldade — gating empírico garante que cada tier seja solvável e suficientemente difícil.

## Argumentos principais

1. **Problema original: escassez de diversidade.** Ambientes agênticos com exposição a milhares de tools são raros no open-source. Treinar agentes capazes requer diversidade de tarefas e tools ao longo de todo o pipeline de pós-treinamento.

2. **Arquitetura: jogo de 2 jogadores.**
   - **Synthesizer**: projeta nova família de tarefas, escreve gold solution + verification function, evolui através de difficulty tiers
   - **Solver**: tenta resolver instâncias de tarefas; serve como gating model durante síntese e como optimization target durante RL training
   - Loop: Synthesizer propõe tiers → Solver estima pass rate → Gate aceita ou retenta

3. **Task anatomy — estrutura semântica clara.** Cada tarefa define: Database (Pydantic model de entidades), Tools (funções Python que manipulam o DB), Instruction (linguagem natural), Gold solution, Verification function. Grounding em operações stateful de banco de dados com semantic verification.

4. **Task evolution — 5 difficulty tiers (t0–t4).** Seguindo metodologia DeepSeek-V3.2 (evolução iterativa é mais fácil do que one-shot difícil). 9 estratégias de evolução: multi_step_reasoning, conditional_rules, cross_entity_coupling, stricter_thresholds, larger_db, schema_extension, tool_proliferation, noisy_instructions, ambiguity_resolution. Cada tier é empirically gated contra target pass-rate band.

5. **Escala do corpus atual.** 4.504 tarefas, 1.040 domínios, 8.159 tools únicos, 2.222 entity classes únicas. 78% das tools e 66% das entity classes são únicas a uma única família — resto são abstrações compartilhadas.

6. **Resultados de treinamento:**
   - **RL**: Qwen3-30B-A3B em 200 steps: reward 30% → ~70%; turns por rollout 8 → 24 (modelo aprende a fazer mais tool calls)
   - **SFT**: Nemotron-3-Nano-30B em apenas 4.417 traces: BFCL-v3 18.9% → 52.3%; MCP-Atlas 0.6% → 12.1% — aproximando-se do modelo final treinado com ordens de magnitude mais dados

## Key insights

- **Task creation is itself an agent task.** O synthesizer é um agente LLM em ambiente sandboxed com acesso ao `general-agent` CLI — guiado por uma structured skill que define formato, estratégias de evolução, critérios de gating.
- **Difficulty generalizes beyond calibration model.** Escada de dificuldade calibrada com GPT-5-mini generaliza para GLM-5.1 (mais forte) — verifica que o corpus mede dificuldade real, não overfitting ao modelo de gating.
- **Failure analysis is gold.** Em day_spa_t2: GLM substitui world knowledge por informação no DB ("massage de fluxo suave deve ser gentil"). Em day_spa_t4: "Prenatal Massage" contextualmente perfeito mas pressure=medium — modelo falha em verificar o campo correto. Esses são os tipos de falhas que ambientes sintéticos bem projetados devem capturar.
- **Custo de síntese**: >1.000 agentes GLM-5.1 em paralelo por vários dias com "barely any supervision" para gerar o corpus inicial.

## Exemplos e evidências

- day_spa family: t0 solve rate GPT-5-mini = 1.00; t4 = 0.20. Escada limpa e monotônica.
- SFT com 4.4k traces: BFCL 18.9%→52.3% em 200 steps (loss 0.6→0.1).
- RL em 200 steps: reward 30%→70%; turnos por rollout 8→24.
- 3 backends de solver: Local (Python direto), OpenCode (MCP server), RLM (IPython kernel com skills).

## Implicações para o vault

- Enriquece [[03-RESOURCES/concepts/agent-systems/synthetic-training-environments]] com a arquitetura 2-player e o gating empírico.
- Enriquece [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] com o corpus que cresce progressivamente em dificuldade.
- Novo ângulo para [[03-RESOURCES/concepts/agent-systems/agentic-rl]]: o RL funciona quando o ambiente tem structure clara (DB state, verification function, gold solution).
- Relevante para Michel como builder: o padrão synthesizer→solver→gate pode ser adaptado para criar testes automatizados de agentes do vault — task = instrução + estado esperado + verification.

## Links

- URL: https://www.primeintellect.ai/blog/general-agent
- Environments Hub: https://app.primeintellect.ai/dashboard/environments/primeintellect/general-agent
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/synthetic-training-environments]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
