---
title: "Conexões Semanais — 2026-06-22"
type: report
connections_found: 3
sources_scanned: 276
generated_by: hermes-agent
created: 2026-06-22
---

# Conexões Semanais — 2026-06-22

## F2.1 — Sources recentes

276 sources com `ingested:` nos últimos 7 dias. Pool antigo: 80 arquivos (50 sources + 30 concepts).

## F2.4 — Conexões encontradas

### 1. Cross-domain: HMM Regime Detection ↔ Algorithmic Trading [ALTA — wikilink aplicado]

**Source recente:** `quant-hmm-regime-adaptive-trading-strategies` — HMM para detectar regime de mercado (bull/bear/neutral), backtest 21 anos, 19.41% annualized vs 10.80% buy-and-hold.

**Concept existente:** `finance-trading/algorithmic-trading` — já cobre backtest rigoroso, walk-forward, survivorship bias, paper→live cycle.

**Conexão:** A source descreve HMM como método concreto de regime detection, mas só linkava `world-model` e `Claude` (agent-systems domain). O concept `algorithmic-trading` cobre o domínio finance-trading mas não mencionava HMM. A source também referencia os agentes `macro` e `quant` do vault — HMM é exatamente o primitivo que conecta os dois.

**Wikilink bidirecional aplicado:** source → `algorithmic-trading` + `trading-automation`; concept → source.

### 2. Padrão 3+: "Loop engineering" como sucessor de "prompt engineering" [ALTA — já documentada em pipeline 2026-06-22]

**Sources convergentes (8 independentes, mesma semana):**
- `loop-engineering-teaching-ai-agents-to-learn-from-their-own-mistakes`
- `the-4-loops-that-quietly-killed-prompt-engineering`
- `claude-code-cowork/how-to-create-loops-with-claude`
- + 5 outras (identificadas no pipeline semanal 2026-06-22)

**Concept existente:** `agent-systems/loop-engineering-patterns` — já criado e linkado com `harness-engineering`.

**Status:** Conexão já estabelecida pelo pipeline semanal. Nenhuma ação adicional necessária — confirmada como padrão real (8 sources independentes).

### 3. Evolução: Intent Engineering → Loop Engineering [MÉDIA — sugerir, não editar]

**Source recente:** `the-intent-engineering-framework-for-ai-agents` — framework de 7 partes para especificar intent (Objective, Outcomes, Health Metrics, Constraints, Decision Types, Stop Rules).

**Concept existente:** `loop-engineering-patterns` — trata codificação como ciclo repetido de feedback.

**Conexão:** Intent engineering especifica *o que* o agente deve fazer quando instruções se esgotam; loop engineering especifica *como* o agente aprende com feedback durante execução. São complementares — intent é o input, loop é o processo. Mas a sobreposição semântica não é forte o suficiente para wikilink bidirecional sem análise mais profunda.

**Sugestão:** Criar concept `intent-engineering` ou adicionar seção em `loop-engineering-patterns` sobre como intent define os stop rules do loop.

## F2.5 — Wikilinks aplicados

- `quant-hmm-regime-adaptive-trading-strategies` ↔ `algorithmic-trading` (bidirecional, alta confiança)
- `quant-hmm-regime-adaptive-trading-strategies` → `trading-automation` (unidirecional)

## F2.6 — Resumo

| Tipo | Count |
|------|-------|
| Cross-domain | 1 |
| Padrão 3+ | 1 (já documentada) |
| Evolução | 1 (média confiança) |
| Contradição | 0 |
| Pergunta-resposta | 0 |
| **Total** | **3** |