---
title: "OptiLLM: Optimizing Inference Proxy for LLMs"
type: source
source: "Clippings/algorithmicsuperintelligenceoptillm Optimizing inference proxy for LLMs.md"
url: "https://github.com/algorithmicsuperintelligence/optillm"
author: "Asankhaya Sharma / algorithmicsuperintelligence"
published: 2026-05-24
ingested: 2026-05-28
tags: [llm-inference, inference-optimization, open-source, proxy, reasoning]
triagem_score: 8
---

## O que é

OptiLLM é um proxy de inferência OpenAI-compatível que implementa 20+ técnicas de otimização para melhorar acurácia em tarefas de raciocínio, sem fine-tuning. Drop-in replacement: basta apontar `base_url` para `http://localhost:8000/v1`.

**Claim principal**: 2–10x de ganho de acurácia em tarefas de raciocínio com zero treinamento.

## Resultados benchmark (headline)

| Técnica | Modelo base | Ganho | Benchmark |
|---------|------------|-------|-----------|
| MARS | Gemini 2.5 Flash Lite | +30.0 pts | AIME 2025 (43.3→73.3%) |
| CePO | Llama 3.3 70B | +18.6 pts | Math-L5 |
| MOA | GPT-4o-mini | ≈ GPT-4 | Arena-Hard-Auto |
| PlanSearch | GPT-4o-mini | +20% pass@5 | LiveCodeBench |

## Técnicas implementadas (principais slugs)

- `mars` — Multi-Agent Reasoning System: múltiplos agentes com temperaturas diversas + verificação cruzada
- `cepo` — Cerebras Planning and Optimization: Best-of-N + CoT + Self-Reflection encadeados
- `moa` — Mixture of Agents: combina respostas de múltiplos modelos críticos
- `mcts` — Monte Carlo Tree Search para decisões no chat
- `bon` — Best of N Sampling
- `plansearch` — busca sobre planos candidatos em linguagem natural
- `re2` — ReRead: processa queries duas vezes para melhorar raciocínio
- `cot_reflection` — CoT com seções `<thinking>`, `<reflection>`, `<output>`
- `z3` — Z3 theorem prover para raciocínio lógico
- `self_consistency` — método avançado de auto-consistência

## Plugins notáveis

- `spl` — System Prompt Learning: 3º paradigma de aprendizado LLM (per Karpathy)
- `longcepo` — contexto infinito via divide-and-conquer
- `mcp` — cliente MCP integrado: qualquer LLM com qualquer MCP server
- `deep_research` — Test-Time Diffusion Deep Researcher (TTD-DR)
- `router` — rota requisições para diferentes abordagens baseado no prompt
- `memory` — camada de memória de curto prazo (contexto ilimitado)

## Modo de uso

Controle da técnica via prefixo no nome do modelo:
```
model="moa-gpt-4o-mini"   # Mixture of Agents
model="mcts-gpt-4o"       # Monte Carlo Tree Search
```
Ou via `extra_body={"optillm_approach": "bon|moa|mcts"}`.
Operador `|` = paralelo; `&` = pipeline sequencial.

## Suporte multi-provider

OpenAI, Anthropic, Google, Cerebras, Azure OpenAI, e 100+ modelos via LiteLLM.

## Instalação rápida

```bash
pip install optillm
optillm
```

Docker disponível (`ghcr.io/algorithmicsuperintelligence/optillm:latest`).

## Ligações vault

- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/heavy-thinking]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
