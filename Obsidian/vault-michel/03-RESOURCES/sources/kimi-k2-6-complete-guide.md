---
title: "Kimi K2.6: Complete A–Z Guide to the Chinese AI Nobody Saw Coming"
type: source
source_file: "Clippings/Kimi K2.6 Complete A–Z Guide to the Chinese AI Nobody Saw Coming.md"
origin: guia / análise
author: "@kirillk_web3"
published: 2026-05-09
ingested: 2026-05-14
tags: [kimi, kimi-code, ai-model, coding-agent, long-horizon, benchmark]
---

# Kimi K2.6: Complete A–Z Guide

> [!key-insight] Core finding
> Kimi K2.6 é open-source, 7x mais barato que Claude Opus 4.7, e benchmarks on-par em SWE-Bench e Terminal-Bench. Supera Opus 4.7 em long-horizon agentic tasks sustentados (12+ horas).

## Pricing Comparison

| Modelo | Input (por 1M tokens) | Output (por 1M tokens) |
|---|---|---|
| Claude Opus 4.7 | $5.00 | $25.00 |
| Kimi K2.6 | $0.80 | $3.60 |

**7x mais barato.** Em 1M output tokens/dia: Opus 4.7 = $750/mês; Kimi K2.6 = $108/mês.

## Benchmarks

- SWE-Bench: on par com Opus 4.7
- Terminal-Bench: on par com Opus 4.7
- Long-horizon agentic tasks: supera Opus 4.7
- 35% menos steps que Kimi 2.5 para mesmo resultado

## Casos Reais Documentados

**Caso 1 — Zig Inference em Mac:**
- 4.000+ tool calls, 12+ horas contínuas
- 14 iterações de otimização
- Throughput: 15 tok/s → 193 tok/s (+1187%)
- 20% mais rápido que LM Studio, sem intervenção humana

**Caso 2 — Financial Matching Engine:**
- 13 horas contínuas, 12 estratégias de otimização
- 1.000+ tool calls, 4.000+ linhas modificadas
- Medium throughput: 0.43 → 1.24 MT/s (+185%)
- Peak throughput: 1.23 → 2.86 MT/s (+133%)
- Engine já operando perto do limite teórico — K2.6 encontrou headroom que maintainers humanos não viram em anos

## Kimi Code — O Coding Agent

Similar ao Claude Code, powered by K2.6. Diferença agent vs assistant:
- **Assistant:** você pergunta, ele responde, você implementa
- **Agent:** você descreve o resultado, ele executa, itera, corrige erros e entrega

## 5 Hidden Commands

| Comando | Função |
|---|---|
| `@arquivo.ts` | Contexto inline de arquivos específicos |
| `/explain` | Digest arquitetural de código legacy |
| `.kimi/rules` | Persistent project-level instructions |
| Checkpoint prompting | Status reports estruturados em sessões longas |
| `/test` | Geração de cobertura com edge cases |

## Troubleshooting

| Falha | Fix |
|---|---|
| Drift (resolve problema diferente) | Scope lock: "Scope: [módulo]. Não alterar fora." |
| Context Collapse | CONSTRAINTS.md + /compact |
| Silent Regression | "Run full test suite, not just affected tests" |
| Over-Engineering | "Make minimal change necessary" |
| Silent tool failure | "After every shell command, verify the output" |

## Open Source Advantages

- Self-hostável (sem API caps, sem usage limits)
- Fine-tunable em domínios específicos
- Suportado: Ollama, OpenCode, OpenClaw, vLLM, llama.cpp

## Conexões

- [[03-RESOURCES/entities/Kimi-K2.6]] — entity page do modelo
- [[03-RESOURCES/entities/Claude Code]] — comparativo direto
- [[03-RESOURCES/concepts/context-engineering]] — checkpoint prompting como context management
