---
title: "Single-agent AI coding is a nightmare for engineers"
type: source
source_file: .raw/articles/Single-agent AI coding is a nightmare for engineers.md
author: Sarah Chieng (@MilksandMatcha) & @0xSero
ingested: 2026-04-17
tags: [multi-agent, orchestration, ai-coding, patterns, codex]
---

# Single-agent AI coding is a nightmare for engineers

> [!summary]
> Sarah Chieng e @0xSero explicam o "single-agent ceiling" e propõem workflows multi-agente com metáfora de cozinha profissional. Benchmarks reais: workflow multi-agente reduziu tempo de 36.5 min para 5.2 min com 100% de sucesso vs 100% de falha no single-agent.

## Problema: o teto do agente único

- Contexto incha, tokens se esgotam, qualidade despenca
- Causa raiz: expectativa demais de um único agente + tarefas não decompostas em subtarefas verificáveis
- Solução: [[multi-agent-orchestration]] — o "back of house" da cozinha profissional

## 3 Ganhos Imediatos

1. **Tokens**: context window efetiva salta de ~200K para 25M+ (cada subagente tem janela própria)
2. **Controle**: fluxo sequencial enforced a cada turno do loop agentic; 84.3% menos intervenções manuais
3. **Velocidade**: tarefas bem definidas rodam em paralelo (~5x speedup em exploração)

## 5 Padrões que Funcionam

| Padrão | Metáfora | Melhor para |
|--------|----------|-------------|
| The Prep Line | Brigade paralela | Design exploration, variações, testes |
| The Dinner Rush | Swarm simultâneo | Componentes independentes de um app |
| Courses in Sequence | Tasting menu em fases | Refatorações grandes, app rebuilds |
| Prep-to-Plate Assembly | Estações sequenciais | Pipelines de pesquisa, long-horizon |
| Gordon Ramsay | Builder + 2 verifiers | SEMPRE — layer sobre qualquer padrão |

> [!insight]
> O padrão Gordon Ramsay (separar build de verify) é o mais importante e deve ser aplicado sobre todos os outros. Com modelos rápidos como Codex Spark (~1200 tok/s), adicionar verificação é praticamente gratuito.

## Entidades Mencionadas

- [[Sarah-Chieng]] — autora (@MilksandMatcha)
- [[Codex-Spark]] — modelo OpenAI ~1200 tokens/seg (powered by Cerebras)
- [[MoonshotAI-Kimi-K2]] — pioneiros do conceito de "swarms"
- [[factory-ai]] — referência para missions e dependency trees

## Conceitos Relacionados

- [[multi-agent-orchestration]]
- [[claude-agent-harness-architecture]]
- [[prompt-engineering-patterns]]
