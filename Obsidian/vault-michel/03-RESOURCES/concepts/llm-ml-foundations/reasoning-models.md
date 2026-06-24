---
title: "Reasoning Models"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Reasoning Models

LLMs que "pensam antes de responder" — usando compute extra em inferência para resolver problemas complexos.

## O que é

Reasoning models são LLMs treinados para gerar uma cadeia de raciocínio interna (chain-of-thought) antes da resposta final. Diferente dos modelos padrão que respondem em um passo, eles usam **test-time compute scaling**: mais tokens de raciocínio = melhor resposta.

Exemplos: OpenAI o1/o3, Claude 3.7 Sonnet (extended thinking), DeepSeek-R1, Gemini 2.0 Flash Thinking.

## Como funciona

**Mecanismo central:** o modelo gera tokens de "scratchpad" (pensamento) antes da resposta. Esses tokens podem ser:
- Visíveis (Claude extended thinking, DeepSeek-R1 `<think>` tags)
- Ocultos (o1 — thinking não exposto ao usuário)

**Treinamento:** RLHF/GRPO com recompensa baseada em acerto da resposta final, não no processo de raciocínio. O modelo aprende sozinho a usar o scratchpad de forma útil.

**Test-time compute scaling:** mais tokens de thinking → melhor performance em benchmarks matemáticos/lógicos (relação log-linear aproximada).

## Variantes

| Modelo | Thinking | Controle |
|--------|----------|---------|
| o1/o3 | Oculto | Nenhum |
| Claude 3.7 Sonnet | Visível (opcional) | Budget tokens |
| DeepSeek-R1 | Visível (`<think>`) | Nenhum |
| Gemini Flash Thinking | Visível | Nenhum |

## Por que importa

**Quando usar reasoning models:**
- Matemática, lógica, provas formais
- Planejamento multi-etapa
- Código complexo com bugs sutis
- Decisões com trade-offs não-óbvios

**Quando NÃO usar:**
- Tarefas simples de extração/sumarização (custo 10-100× maior)
- Aplicações latency-sensitive (3-30s de thinking)
- Conversação casual

Para agentes: reasoning models como "orquestrador" + modelos rápidos como "executores" é o padrão emergente.

## Related
- [[03-RESOURCES/concepts/reinforcement-learning]]
- [[03-RESOURCES/concepts/rlhf-pipeline]]
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/model-selection-patterns]]
