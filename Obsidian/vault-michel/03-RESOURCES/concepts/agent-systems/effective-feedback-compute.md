---
title: "Effective Feedback Compute (EFC)"
type: concept
status: stable
created: 2026-06-09
updated: 2026-06-09
tags: [concept, ai-agents, scaling-laws, harness, efc, test-time-compute, harness-engineering]
---

# Effective Feedback Compute (EFC)

**Definição:** Coordinate de scaling para agent harnesses que mede feedback útil em uma trajetória — creditando apenas eventos que são simultaneamente *informative*, *valid*, *non-redundant* e *retained*. Proposto por Zhang et al. (Harbin IT, 2026) como alternativa a raw compute (tokens, tool calls, custo).

> "Harness scaling is governed less by how much computation is spent than by how efficiently raw budget is converted into durable, task-sufficient feedback."

---

## Fórmula

```
EFC_t = κ · I_t · V_t · R_t · M_t        (κ = 10, todos em [0,1])
EFC(τ) = Σ EFC_t
```

| Fator | Significado | O que captura |
|-------|-------------|---------------|
| **I** Informativeness | Revela informação relevante | Nova constraint, progresso mensurável, modo de falha diagnosticado |
| **V** Validity | Suportado por evidência confiável | Checker determinístico, unit test, resultado de execução consistente |
| **R** Non-redundant relevance | Aborda subgoal ativo, adiciona ao que já existe | Evita repetir observações já conhecidas |
| **M** Memory update | Muda plan/estado/memória de forma que afeta futuro | Feedback que persiste para decisões subsequentes |

O produto (não soma) cria **gargalo**: qualquer fator próximo de zero anula a contribuição, mesmo que os outros sejam altos. Um feedback inválido (V≈0) não conta, mesmo que informativo.

---

## Normalização por Task Demand

```
D_task = L · H_tool · S_state · (1 + N_obs) · (1 - V_oracle)
X = EFC / D_task       (feedback relativo ao que a tarefa exige)
η = EFC / C_raw        (eficiência do harness: EFC por unidade de budget)
```

**Por que normalizar:** Um harness pode converter bem e ainda falhar se a tarefa exige mais feedback do que a trajetória entrega. EFC/D_task mede suficiência, não apenas volume.

**Componentes de D_task:**
- **L**: número mínimo de passos de raciocínio
- **H_tool**: entropia de seleção de tool (ambiguidade)
- **S_state**: demanda de state-tracking
- **N_obs**: ruído/ambiguidade das observações
- **V_oracle**: cobertura de verificação confiável (reduz demanda)

---

## Resultados Empíricos (Zhang et al., 2026)

### Por que raw compute falha

| Coordenada | R² (sintético) | R² (traces reais mistos) |
|------------|---------------|--------------------------|
| Raw tokens | 0.33 | −0.08 |
| Tool calls | 0.42 | −0.02 |
| SAS (multivariate baseline) | 0.88 | 0.43 |
| **NRS-EFC / D_task** | **0.99** | **0.92** |

### Prova causal (matched-budget)

Mesmo budget (0.000% diferença em tokens/cost/tool-calls), diferente qualidade de feedback:
- Condição low-EFC: **sucesso = 0.27**
- Condição high-EFC: **sucesso = 0.90**

A diferença não vem de gastar mais — vem de converter melhor.

### Holdout prospectivo (protocolo pré-especificado)

NRS-EFC/D_task: R²=0.85 em traces nunca vistos. Raw compute: R² negativo (pior que predizer a média).

---

## Decomposição: Eficiência × Demanda

EFC separa dois mecanismos independentes:

**1. Harness Efficiency (η):** Controla conversão raw→EFC
- Router quality: +0.28η (relevância + não-redundância)
- Verifier strength: +0.22η (validade)
- Memory fidelity: +0.20η (retenção)
- Observation noise: −0.17η (dilui/corrompe feedback)

Nos ablations de módulo: η explica R²=0.97 do sucesso; raw cost explica R²=0.01.

**2. Task Demand (D_task):** Controla a escala em que feedback se torna suficiente
- Mesma quantidade de EFC pode ser suficiente para uma tarefa simples e insuficiente para uma complexa
- Cross-family prediction: Oracle-EFC→R²=0.90; Oracle-EFC/D_task→R²=0.96

---

## Variantes Práticas

| Variante | Quando usar |
|----------|-------------|
| **Oracle-EFC** | Apenas em ambientes sintéticos com estado oculto mensurável |
| **Estimated-EFC** | Traces semi-reais — estimado de features observáveis (checker fires, tool refs, plan updates) |
| **NRS-EFC** (Non-redundant Stable) | Traces reais — down-pesa loops redundantes e observações instáveis com gates de status/progresso |

Estimated-EFC alcança R²≈0.94 sem acesso ao estado oculto, usando apenas sinais de trace.

---

## Eficiência é Harness×Task, não Global

η não é propriedade invariante do harness:

| Slice | Padrão de eficiência |
|-------|----------------------|
| HumanEval (código executável) | H5/H6 dominam (η≈1.9) — rich execution feedback exploitable |
| Terminal-Bench | Todos harnesses baixos (η≈0.1) — slice intrinsecamente difícil de converter |
| SWE-bench | H0/H3 melhores — harnesses simples favorecem esse ambiente |

**Implicação:** Escolher o harness certo depende do tipo de feedback que a tarefa produz, não só da "força" do harness em abstrato.

---

## Conexão com Harness Design

EFC formaliza por que os componentes canônicos do harness importam:

| Componente | Fator EFC que melhora |
|------------|----------------------|
| Verifier/checker | V (validade) |
| Router quality | R (relevância, não-redundância) |
| Memory system | M (retenção) |
| Cleaner observations | I + V |
| Error recovery / repair | R (evita redundância de falha) |

Um harness que loop no mesmo erro 10 vezes tem high token-cost mas EFC≈0 (R→0 em eventos repetidos).

---

## Diagnóstico com EFC

| Sintoma | Diagnóstico | Ação |
|---------|-------------|------|
| η baixo, tokens altos | Harness converte pouco — budget desperdiçado | Melhorar routing/verification/memory |
| η alto, sucesso baixo | EFC suficiente? Checar EFC/D_task | Task demand pode não estar satisfeita |
| EFC alto por NRS, sucesso baixo | Verificar estabilidade (Q_t status gates) | Reduzir observation noise |
| Raw cost alto, EFC baixo | H4 pattern — high-budget noisy | Rever mecanismos de feedback |

---

## Relação com Conceitos do Vault

- **[[03-RESOURCES/concepts/agent-systems/harness-engineering]]**: EFC é a métrica formal que quantifica a qualidade de cada componente do harness (router, verifier, memory, tools)
- **[[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]**: η baixo → harness-bound; η alto mas falha → model-bound ou D_task não satisfeita
- **[[03-RESOURCES/concepts/agent-systems/managed-agents-harness]]**: Events no stream da API gerenciada têm EFC alto quando retained + informative (progress events, checker results)
- **[[03-RESOURCES/concepts/agent-systems/harness-adaptation]]**: EFC pode guiar qual harness adaptar para qual task slice
- **[[03-RESOURCES/concepts/agent-systems/agent-observability]]**: Observabilidade de trace = observabilidade de EFC — logs de checker, tool references, memory updates são os inputs do Estimated-EFC
- **[[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]**: EFC formaliza quando um feedback loop realmente aprende vs. apenas itera

---

## Fonte

- [[03-RESOURCES/sources/scaling-laws-agent-harnesses-efc]]
