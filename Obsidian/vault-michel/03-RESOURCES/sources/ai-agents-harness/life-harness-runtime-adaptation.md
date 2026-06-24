---
title: "Life-Harness: Runtime Harness Adaptation for Deterministic LLM Agents"
type: source
source: "Clippings/Adapting the Interface, Not the Model Runtime Harness Adaptation for Deterministic LLM Agents.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, harness, runtime-adaptation, agent-systems]
---

## Tese central

Adaptar o runtime harness — e não os pesos do modelo — é uma alternativa complementar e altamente eficaz ao model-centric training. Life-Harness converte falhas de interação recorrentes em intervenções reutilizáveis sobre environment contracts, procedural skills, action realization e trajectory regulation, melhorando agentes frozen sem tocar em seus pesos.

## Argumentos principais

- **Um agente LLM não é apenas um LLM** — seu comportamento é co-determinado pelo runtime harness que medeia observações, ferramentas, ações e feedback
- **Falhas em domínios determinísticos vêm da interface, não do modelo** — mismatches em tool schemas, API contracts, admissible actions, feedback rules causam falhas mesmo em modelos com forte raciocínio (Qwen3.5-4B: 74% em HMMT mas só 43.1% em ALFWorld)
- **Life-Harness: harness lifecycle-aware** — evolui a partir de trajetórias de treinamento, detecta padrões de falha recorrentes, converte em intervenções reutilizáveis
- **Transfer cross-model** — harnesses evoluídos de trajetórias Qwen3-4B-Instruct transferem para 17 outros modelos, provando que capturam estrutura do ambiente, não do modelo específico
- **Resultados empíricos** — 116/126 configurações modelo×ambiente melhoradas, média de +88,5% de melhoria relativa em 7 ambientes determinísticos

## Key insights

- Life-Harness divide intervenções em 4 categorias: environment contracts (como o ambiente expõe observações), procedural skills (sequências de ação para tarefas recorrentes), action realization (como mapear intenções em ações executáveis), trajectory regulation (controle de trajetória para evitar loops e degradação)
- A adaptação de interface é FIXA na avaliação — o harness evolui durante training e é congelado para tasks não-vistas
- O gap entre capacidade estática (benchmarks de raciocínio) e performance interativa (benchmarks de agência) é preenchido pela adaptação do harness
- Complementa (não substitui) fine-tuning: model training + harness adaptation > apenas model training

## Exemplos e evidências

- 7 ambientes: τ-bench, τ²-bench, AgentBench
- 18 model backbones testados
- 116/126 configs melhoradas (92% de taxa de sucesso)
- Peking University, 2026

## Implicações para o vault

- Diretamente aplicável ao design dos agentes em `04-SYSTEM/agents/` — harness como objeto de otimização separado do modelo
- O conceito de "skill" em Life-Harness = procedural skill no harness → dialoga com o sistema de skills do vault
- Reforça a separação model layer / harness layer / skill layer em [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]]
