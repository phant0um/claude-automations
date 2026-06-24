---
title: HALO — Harness Self-Optimization
type: concept
status: developing
created: 2026-05-15
updated: 2026-05-15
tags: [agents, harness, self-improvement, rlm, optimization]
---

# HALO — Harness Self-Optimization

## Definition

**HALO** (Hierarchical Agent Loop Optimizer) — agente que melhora outros agentes analisando traces de execução em massa e propondo mudanças no **harness**, não no modelo subjacente.

## Core Claim

**Mismanaged Genius Hypothesis:** modelos frontier já possuem inteligência superior; o gargalo real é o harness mal projetado pelos humanos. HALO trata o harness como camada de serviço otimizável e mensurável.

## Mecanismo

```
collect traces → HALO analisa failure modes → coding agent aplica → re-run → repete
```

1. **Coleta:** traces de execução em massa (AppWorld, TerminalBench, FinanceBench)
2. **Análise (HALO):** identifica padrões de falha recorrentes no harness
3. **Patch:** coding agent aplica mudanças cirúrgicas ao harness
4. **Validação:** re-run dos benchmarks; repete se necessário

## Resultados

| Benchmark | Ganho |
|-----------|-------|
| AppWorld | +10% |
| TerminalBench | +10% |
| FinanceBench | +10% |

## Diferença de RLHF

| Dimensão | RLHF | HALO |
|----------|------|------|
| Alvo | Pesos do modelo | Harness (prompts, fluxo, ferramentas) |
| Custo | Alto (fine-tuning) | Baixo (edições de config/prompt) |
| Reversibilidade | Baixa | Alta (git revert) |
| Escopo | Universal | Tarefa-específico |

## Por que importa

Harness vira **optimizable service layer** — mensurável por benchmark, iterável sem custo de training. Implicação: organizações sem acesso a fine-tuning podem melhorar agentes apenas melhorando o harness.

## Connections

- [[03-RESOURCES/sources/ml-research-papers/halo-rlm-self-improving-agents]] — source (Clipping)
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]] — camadas onde HALO opera
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — o que HALO otimiza
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] — loop subjacente
