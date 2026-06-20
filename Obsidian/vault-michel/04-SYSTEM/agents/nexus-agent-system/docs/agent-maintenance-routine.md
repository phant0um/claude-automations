---
title: Agent Maintenance Routine — Monthly
type: procedure
automated: true
owner: ledger
schedule: cron "0 9 1 * *" (1st Mon every month)
created: 2026-05-14
---

# Agent Maintenance Routine — Automática Mensal

**Executada por:** `ledger` skill  
**Frequência:** 1ª segunda-feira de cada mês, 9h (timezone: local)  
**Duração:** ~5-10 min (fully automated)  
**Output:** `/04-SYSTEM/logs/agent-audit-YYYY-MM.md`

---

## Objetivo

Detectar e alertar sobre **drift** (agents cujo comportamento diverge de sua documentação) e **score decay** (agents que degradaram em padrão/clareza desde audit anterior).

Rotina roda SEM intervenção humana. Alertas são registrados apenas em `operations.md` (não dispara chamadas).

---

## Sequência de Execução (Automated)

### Etapa 1: Carregar Baseline

```
baseline_anterior = ler('/04-SYSTEM/logs/agent-audit-YYYY-MM-01.md')
agentes_lista = scan('/04-SYSTEM/agents/finance-system/*') 
                + scan('/04-SYSTEM/agents/03-institutional/*')
```

Se baseline anterior não existe (primeiro mês): criar novo baseline e exit.

### Etapa 2: Score Cada Agente (Mesmo Framework)

Para cada agente:
```
score = (
  clareza_propósito (0-3) +
  estrutura_modos (0-2) +
  critério_done (0-2) +
  anti_padrões (0-2) +
  tabela_roteamento (0-1)
)
```

Registrar: `{agente, score_anterior, score_novo, delta, flags}`

### Etapa 3: Detectar Anomalias

**Flag: Score Drop**
- Se `score_novo < score_anterior - 1` → ⚠️ DEGRADAÇÃO
  - Exemplo: `resumos-estudo: 7 → 5` (perda 2 pontos)
  - Causa provável: edição manual quebrou estrutura

**Flag: Score <5**
- Se `score_novo < 5` → 🔴 CRÍTICO
  - Registrar em `operations.md` com ação: "Agente X regressou para crítico"

**Flag: Estrutura Drift**
- Se `tabela_roteamento == 0` (desapareceu) → ⚠️ DRIFT
  - Causa: alguém deletou ou comentou a seção

### Etapa 4: Gerar Relatório

Arquivo: `/04-SYSTEM/logs/agent-audit-YYYY-MM.md`

```markdown
---
title: Agent Audit — YYYY-MM
type: audit
generated: [timestamp]
baseline_from: agent-audit-YYYY-MM-01.md
---

# Agent Audit — YYYY-MM (Automated)

## 📊 Resumo Executivo
- **Agentes auditados:** 23
- **Scores melhores:** N
- **Scores piores:** N
- **Críticos (<5):** N
- **Drift detectado:** N

## 🟢 Sem Alterações
[Agentes com score estável ±0]

## 🟡 Melhoria Detectada
[Agentes que melhoraram]

## 🔴 Degradação Detectada
[Agentes que pioraram + flagged para revisão manual]

## ⚠️ Drift Flags
[Estrutura que desapareceu ou mudou]

---

## 📋 Tabela Completa (Score Anterior → Novo)
[Tabela estruturada]

## Próximos Passos
- Se degradação: Nexus chama `hill` para diagnóstico
- Se drift: Nexus chama `review` para sincronização
- Se crítico novo: marcar para próxima sessão imediata
```

### Etapa 5: Registrar em Operations Log

Adicionar entrada em `/04-SYSTEM/logs/operations.md`:

```
## 2026-MM-DD — Agent Audit Mensal (Ledger Automático)

Status: ✅ Sem anomalias | ⚠️ [N] degradações | 🔴 [N] críticos novos

Se degradações detectadas:
- Agente X: 7 → 5 (perda de tabela roteamento)
- Recomendação: Nexus chama `hill` para investigação
```

---

## Critérios de Ação (Threshold)

| Condição | Ação | Prioridade |
|---|---|---|
| Score drop ≥2 pts | Registrar em `operations.md` + flag para `hill` | Alta |
| Score <5 novo | Chamar `hill` imediatamente | Crítica |
| Tabela roteamento desapareceu | Chamar `review` para drift sync | Média |
| Nenhuma anomalia | Log "sem alterações" + proseguir | Baixa |

---

## Failure Modes (Tratamento de Erros)

| Cenário | Tratamento |
|---|---|
| Arquivo agente não encontrado | Registrar como "não auditado" + continuar |
| Baseline anterior corrompido | Criar novo baseline a partir de 02-domain-experts + 03-institutional |
| Score framework muda | Versionar: `agent-audit-2026-05-14-v2.md` |

---

## Integração com Nexus

Após execução automática, Ledger registra em `operations.md`:
- Se **sem anomalias**: Nexus lê log, prosegue sem ação
- Se **anomalias detectadas**: Nexus lê log + agenda sessão com `hill` ou `review`

Nexus não é bloqueado — rotina é assíncrona e informativa.

---

## Histórico de Execuções

| Data | Status | Anomalias | Ação Recomendada |
|---|---|---|---|
| 2026-06-01 | ✅ | Nenhuma | Prosseguir |
| 2026-07-01 | ⏳ | Pendente | — |

---

## Notas de Implementação

- Ledger deve ter acesso de **leitura** a todos agentes (não escreve)
- Cronograma: 1ª segunda-feira do mês, 9h
- Timezone: user's local (não UTC)
- Timeout: máx 5 min (abort se exceder)
- Retry: nenhum (falha é registrada, não re-executa)
