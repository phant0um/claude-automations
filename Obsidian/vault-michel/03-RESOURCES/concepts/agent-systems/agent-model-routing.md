---
title: Agent Model Routing
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [multi-agent, model-selection, cost-optimization, routing, orchestration]
---

# Agent Model Routing

Estratégia de seleção de modelo LLM por tipo de atividade dentro de um sistema multi-agente, visando maximizar qualidade e minimizar custo de tokens.

## Princípio

Nem toda tarefa precisa do modelo mais capaz. Usar Opus para tudo é desperdício; usar Haiku para decisões críticas é risco. O roteamento correto mapeia complexidade da tarefa ao tier de modelo adequado.

## Regra de decisão

```
if    raciocínio sistêmico, alto impacto, trade-offs arquiteturais  → Opus
elif  geração de código, análise técnica, design de API             → Sonnet
elif  padrão conhecido, output < 500 tokens, config repetitiva      → Haiku
else                                                                 → Sonnet
```

## Tiers no Fullstack Agent System

| Tier | Modelo | Uso típico |
|---|---|---|
| Opus | claude-opus-4-7 | Threat modeling, arquitetura RAG, planejamento multi-step |
| Sonnet | claude-sonnet-4-6 | APIs, componentes, IaC, ETL, análise de código |
| Haiku | claude-haiku-4-5-20251001 | Testes, YAML, docs, configs, reports |

**Economia estimada: ~60–75% vs. usar Opus em tudo.**

## Onde aparece

- [[Fullstack-Agent-System]] — 3 tiers explícitos por agente/atividade
- [[Nexus-Agent-System|Nexus Agent System]] — mesma estrutura
- Fonte: [[rl-conductor-orchestration]] — modelo 7B treinado via GRPO aprende roteamento ótimo

## Context Budget como Critério Upstream

O roteamento por custo/capacidade assume que o model tier é a variável principal. Mas **context budget** é um constraint upstream que o roteamento não resolve:

> Mesmo escolhendo Haiku (mais barato), se o system prompt consome 31% da janela com plugins/MCPs — a sessão encurta e o custo real aumenta.

Portanto: **context budget → otimizar primeiro → depois rotear por tier.**

```
[1] Medir context overhead (plugins, MCPs, skills no prompt)
       ↓ se > 10% da janela → auditoria/lazy-loading
[2] Rotear por complexidade da tarefa
       ↓ Opus / Sonnet / Haiku
[3] Cache prefix para maximizar hit rate nas camadas estáticas
```

Ver: [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]

## Implementações Concretas

### OptILM (inference proxy)
[[03-RESOURCES/sources/open-source-ecosystems/optillm-inference-proxy]] — proxy OpenAI-compatível que aplica 20+ técnicas de otimização em tempo de inferência sem fine-tuning:

| Técnica | Ganho headline | Benchmark |
|---------|---------------|-----------|
| MARS | +30pp | AIME 2025 (43→73%) |
| CePO | +18.6pp | Math-L5 |
| MOA (Mixture-of-Agents) | ≈ GPT-4 | Arena-Hard-Auto |

Drop-in replacement: apontar `base_url` para `http://localhost:8000/v1`. Complementa roteamento por tier — aplica otimização **dentro** de cada tier.

**Quando usar OptILM vs. upgrade de tier:**
- Tarefa de raciocínio com modelo menor → OptILM (mais barato)
- Tarefa com trade-offs arquiteturais → upgrade para Opus
- Ambos não são mutuamente exclusivos

### RL Conductor
[[rl-conductor-orchestration]] — modelo 7B treinado via GRPO aprende roteamento ótimo. Mais complexo que regras estáticas, mas aprende padrões de uso real.

## Relações

- Implementado em: [[Fullstack-Agent-System]]
- Documentado em: Agent-Model-Map (Fullstack Agent System)
- Princípio similar: [[multi-agent-orchestration]] (tier por complexidade)
- Constraint upstream: [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- Implementação OSS: [[03-RESOURCES/sources/open-source-ecosystems/optillm-inference-proxy]]

## Evidências
- **[2026-06-19]** Modelo caro (Claude) escreve/refina skills, modelo barato (MiniMax) executa — roteamento por fase do ciclo de vida do skill em vez de por tarefa isolada — [[how-i-turned-minimax-into-fable-5-97-percent-cheaper]]
- **[2026-06-19]** Roteamento por dificuldade (Haiku para grunt work, Sonnet para drafts, Opus para julgamento) citado como vantagem central de sub-agentes sobre role colado em chat único — [[03-RESOURCES/sources/how-to-run-claude-as-a-team-not-a-tool]]
- **[2026-06-22]** Sakana Fugu: model routing como produto comercial — LLM treinado para orquestrar pool de LLMs (incl. si mesmo recursivamente). Single API, complexity never reaches user code. AI sovereignty argument: swappable agents route around vendor restrictions — [[03-RESOURCES/sources/ai-agents/sakana-fugu-orchestration-model]]
- **[2026-06-22]** Google TF→JAX: Planner agent usa análise estática determinística (compilador), Coder agent usa LLM — roteamento não só por dificuldade mas por tipo de tarefa (deterministic vs generative) — [[03-RESOURCES/sources/ai-agents/6x-faster-migration-tensorflow-to-jax]]
- **[2026-06-24]** Gerenciar AI de diferentes níveis de capacidade requer o mesmo skill que gerenciar pessoas de diferentes níveis —... — [[ai-management-like-managing-people]]
