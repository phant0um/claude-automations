---
title: "Scaling Laws for Agent Harnesses via Effective Feedback Compute"
type: source
source: "Clippings/Scaling Laws for Agent Harnesses via Effective Feedback Compute.md"
url: "https://arxiv.org/html/2605.29682v1"
authors: ["Xuanliang Zhang", "Dingzirui Wang", "Keyan Xu", "Qingfu Zhu", "Wanxiang Che"]
institution: "Harbin Institute of Technology"
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, scaling-laws, harness, effective-feedback-compute, efc, paper, test-time-compute]
---

# Scaling Laws for Agent Harnesses via Effective Feedback Compute

**Autores:** Xuanliang Zhang, Dingzirui Wang, Keyan Xu, Qingfu Zhu, Wanxiang Che (Harbin Institute of Technology)
**ArXiv:** 2605.29682

## Tese Central

Raw compute (tokens, tool calls, wall time, cost) é um coordinate fraco para agent harnesses porque não distingue feedback útil de feedback redundante ou instável. **Effective Feedback Compute (EFC)** — que credita apenas feedback informativo, válido, não-redundante e retido — prevê falhas muito melhor. A escala não é sobre *quanto* você computa, mas sobre *quão eficientemente* o budget bruto é convertido em feedback durável, suficiente para a demanda da tarefa.

---

## Definição Formal de EFC

Dado uma trajetória τ = {(sₜ, aₜ, oₜ, uₜ)}, cada evento de feedback eₜ recebe quatro fatores em [0,1]:

- **Iₜ** (Informativeness): revela informação relevante à tarefa (nova constraint, progresso mensurável)
- **Vₜ** (Validity): suportado por evidência confiável (checker determinístico, unit test, resultado de execução)
- **Rₜ** (Non-redundant relevance): aborda o subgoal ativo e adiciona além do que já está na trajetória
- **Mₜ** (Memory update): muda plan/estado/memória de forma que afeta ações futuras

```
EFC_t = κ · I_t · V_t · R_t · M_t    (κ = 10)
EFC(τ) = Σ EFC_t
```

O produto (não soma) cria comportamento de gargalo: feedback com validade zero não contribui, mesmo que altamente informativo.

**Variantes:**
- **Oracle-EFC**: usa estado oculto da tarefa (apenas em ambientes sintéticos controlados)
- **Estimated-EFC**: estimado de features observáveis no trace (checker fires, tool references, plan updates, memory retention)
- **NRS-EFC** (Non-redundant Stable EFC): variante para traces reais, down-pesa redundâncias e observações instáveis

---

## Normalização por Task Demand

Para comparar tarefas com diferentes demandas de verificação:

```
D_task = L · H_tool · S_state · (1 + N_obs) · (1 - V_oracle)
```

Onde:
- **L**: número mínimo de passos de raciocínio/ação estimado
- **H_tool**: entropia de seleção de tool (ambiguidade)
- **S_state**: demanda de state-tracking
- **N_obs**: ruído/ambiguidade das observações
- **V_oracle**: cobertura de sinais de verificação confiáveis (reduz demanda quando checks são disponíveis)

**Coordenadas normalizadas:** `X = EFC / D_task` e `η = EFC / C_raw` (eficiência do harness)

---

## Resultados Quantitativos (R²)

### Tarefas Sintéticas Controladas

| Coordenada | R² | MAE |
|------------|-----|-----|
| Raw tokens | 0.33 | — |
| Wall time | 0.37 | — |
| Raw cost | 0.38 | — |
| Operations | 0.42 | — |
| Tool calls | 0.42 | — |
| **SAS (baseline forte)** | **0.88** | — |
| Oracle-EFC | 0.94 | — |
| Estimated-EFC | 0.94 | — |
| **Oracle-EFC / D_task** | **0.99** | **0.02** |

### Matched-Budget Intervention (mesmo budget, diferente qualidade de feedback)

- Budget raw: delta médio = 0.000% (orçamento idêntico)
- Condição low-EFC: sucesso = **0.27**
- Condição high-EFC: sucesso = **0.90** (p = 1×10⁻³⁰⁰)
- Prova causal: a melhora não vem de gastar mais, mas de converter melhor

### Tarefas Executáveis (código HumanEval-style)

| Coordenada | R² |
|------------|-----|
| Raw tokens | 0.78 |
| SAS | 0.95 |
| Estimated-EFC | 0.96 |
| **Estimated-EFC / D_task** | **0.97** |
| Oracle variants | 0.99 |

### Traces Reais (HumanEval + Terminal-Bench + SWE-bench — misturados)

| Coordenada | R² |
|------------|-----|
| Raw tokens | −0.08 |
| Wall time | −0.08 |
| Raw cost | −0.07 |
| Tool calls | −0.02 |
| SAS | 0.43 |
| NRS-EFC | 0.89 |
| **NRS-EFC / D_task** | **0.92** |

### Holdout Prospectivo (protocolo pré-especificado)

| Coordenada | R² holdout |
|------------|------------|
| Raw compute (todos) | negativo |
| SAS | 0.26 |
| NRS-EFC | 0.77 |
| **NRS-EFC / D_task** | **0.85** |

---

## Argumentos Principais

### 1. Raw budget não é o scaling coordinate

Dois trajectories com o mesmo número de tokens ou tool calls podem diferir radicalmente em se suas observações são úteis, válidas, não-redundantes e retidas. H4 (high-budget noisy) gasta mais do que H5/H6 mas performa pior — destrói a hipótese "mais compute = mais performance".

### 2. Harness efficiency η é a variável mediadora

Nos ablations de módulo, eficiência do harness (η = EFC/C_raw) explica quase toda a variação de sucesso com R²=0.97, enquanto raw cost explica R²=0.01. Os três fatores que mais aumentam η:
1. **Router quality**: +0.28 (melhora relevância e não-redundância)
2. **Verifier strength**: +0.22 (melhora validade)
3. **Memory fidelity**: +0.20 (melhora retenção)

Fatores adversos: observation noise (−0.17), tool entropy (−0.11), state pressure (−0.05).

### 3. Task demand normaliza o que "suficiente" significa

Um harness pode converter bem e ainda falhar se a tarefa exige mais feedback do que a trajetória provê. EFC/D_task detecta isso; EFC absoluto não.

### 4. Eficiência do harness é slice-specific, não global

| Slice | Padrão |
|-------|--------|
| HumanEval | H5/H6 dominam (η ≈ 1.9) — rich feedback exploitable |
| Terminal | Todos harnesses têm η baixo (~0.1) — slice intrinsecamente difícil de converter |
| SWE | H0/H3 performam melhor — harnesses simples favorecem esse ambiente |

Harness efficiency é uma interação harness×task, não propriedade invariante do harness.

---

## Famílias de Harness (H0–H6)

| Harness | Descrição | Característica EFC |
|---------|-----------|-------------------|
| H0 | Direct Answer (single pass) | EFC mínimo |
| H1 | Checklist Verify (lightweight) | Weak verification, sem closed loop |
| H2 | Routed Tools | Melhor relevância, memória moderada |
| H3 | Stateful Memory | Foco em retenção, menor redundância |
| H4 | High Budget Noisy | Alto custo, baixo EFC — controle negativo |
| H5 | Closed Loop | Routing + verification + memory juntos |
| H6 | Deep Closed Loop | H5 + maior profundidade e mecanismos mais fortes |

---

## Key Insights

1. **O problema com métricas de custo atuais**: tokens/tool-calls/cost conflationam "gastar" com "aprender". Um harness que repete o mesmo erro 10 vezes tem muito token-cost mas EFC perto de zero.

2. **Implicação de design**: Para melhorar um harness, a pergunta certa não é "quanto budget allocar?" mas "como converter mais do budget em feedback informativo, válido, não-redundante e retido?".

3. **Trace-time estimation funciona**: Estimated-EFC (sem acesso ao estado oculto) alcança R²≈0.94 próximo ao Oracle-EFC, usando apenas features observáveis: checker fires, tool references, plan updates, memory retention, repeated-error avoidance.

4. **EFC como proxy de calibração de harness**: η (EFC/C_raw) pode detectar harnesses que gastam sem aprender — benchmark útil para comparar harness designs no mesmo modelo.

5. **Task demand calibration requer fitting heterogêneo**: A normalização hand-designed funciona em tarefas controladas; em misturas heterogêneas, expoentes fitted são necessários para máxima transferência.

---

## Modelo de Scaling

Usa power-law failure model para todos os coordinados:

```
E(z) = E_∞ + A · z^(-α)
```

Onde E(z) é taxa de falha prevista, E_∞ é erro irredutível, A é parâmetro de escala, α é expoente de scaling. Todos os coordenados são median-normalized antes do fit para comparabilidade de expoentes.

---

## Implicações para o Vault

1. **Medição de agentes do vault**: Ao avaliar agentes (Nexus, guard, hill, etc.), medir retenção de feedback entre passos, não apenas tool calls ou tokens gastos. Um agente que usa bem o MEMORY.md tem EFC muito maior que um que não retém.

2. **Harness design decisions**: EFC formaliza por que o vault prioriza verify → routing → memory no design de harnesses. O produto I·V·R·M mostra que qualquer fator zero anula o resto.

3. **Critério para harness-bound vs model-bound**: Se η é baixo (pouco EFC por token), o problema é harness-bound. Se η é alto mas sucesso ainda é baixo, pode ser model-bound ou demanda de tarefa (D_task) não satisfeita.

4. **Link com managed-agents-harness**: EFC formaliza a qualidade de feedback nos loops de event-streaming da API gerenciada — eventos de progresso que o harness retém e age são EFC; events descartados são custo bruto sem retorno.

---

## Links

- [[03-RESOURCES/concepts/agent-systems/effective-feedback-compute]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]
- [[03-RESOURCES/concepts/agent-systems/managed-agents-harness]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
