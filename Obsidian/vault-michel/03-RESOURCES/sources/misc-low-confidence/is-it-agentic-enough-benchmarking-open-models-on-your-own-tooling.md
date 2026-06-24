---
title: "Is It Agentic Enough? Benchmarking Open Models on Your Own Tooling"
type: source
source: Clippings/Is it agentic enough? Benchmarking open models on your own tooling.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ml-research, benchmarking, agents, open-models, hugging-face]
---

## Tese central

Benchmarks atuais só olham o final answer. Hugging Face propõe tool-specific benchmark que mede o processo inteiro: não só se o agent acertou, mas quanto trabalho custou, e como isso muda entre models, library revisions e tasks. Princípios: "if it isn't tested, it doesn't work; if it isn't documented, it doesn't exist."

## Argumentos principais

1. **Novo conceito em library development**: código deve ser correct, fast, E agent-drivable. API clunky ou docs stale mandam agent por path mais longo e caro
2. **Process benchmark**: não só final answer — quanto trabalho custou chegar lá
3. **Case study**: `transformers` library. Sweep de models × revisions × tasks em Hugging Face Jobs (hardware idêntico)
4. **Pi coding agent**: harness roda em open models, fan-out em HF Jobs
5. **Agent-optimized tooling**: API precisa ser discoverable, docs extensivos, structured para agent ter acesso rápido a useful files e examples

## Key insights

- Agent-optimized tooling: test for agentic-use, não só human-use
- "If it isn't documented, it doesn't exist" — para agents, docs são o API surface
- Process metrics > outcome metrics para optimization de agents
- Model × revision × task matrix em hardware idêntico elimina confounders

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations]]
- [[03-RESOURCES/concepts/agent-systems]]