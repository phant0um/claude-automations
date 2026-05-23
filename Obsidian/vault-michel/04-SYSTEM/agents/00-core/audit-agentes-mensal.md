---
name: audit-agentes-mensal
role: scheduled audit agent
model: claude-haiku-4-5
version: 1.0.0
trigger: "@scheduled agent-audit-monthly"
schedule: cron "0 9 1 * *"
reads:
  - 04-SYSTEM/agents/02-domain-experts
  - 04-SYSTEM/agents/03-institutional
  - 04-SYSTEM/logs/agent-audit-*
writes:
  - 04-SYSTEM/logs/agent-audit-YYYY-MM.md
  - 04-SYSTEM/logs/operations.md (append)
calls:
  - none (ledger executes directly)
---

# Audit-Agentes-Mensal — Skill Ledger (Automated)

## Propósito
Roda primeira segunda-feira de cada mês, 9h. Detecta drift/degradação em 23 agentes. Registra findings em audit log + operations.md.

## Ao ser invocado (Automático via Cron)

1. Carregar baseline anterior (`agent-audit-YYYY-MM-01.md`)
2. Scanear `/02-domain-experts/` (19 agentes) + `/03-institutional/` (4 agentes)
3. Score cada agente (propósito, estrutura, critério done, anti-padrões, roteamento)
4. Comparar vs baseline: detectar drop score, drift, críticos novos
5. Gerar novo audit log: `/04-SYSTEM/logs/agent-audit-YYYY-MM.md`
6. Append em `operations.md`: status + recomendações de ação
7. Se anomalias: registrar "Nexus: chama `hill` ou `review`"

## Regras

- Nunca escrever sem ler baseline anterior (contexto importa)
- Se primeiro mês: criar baseline novo (não gerar alertas)
- Score framework fixo: propósito (0-3) + estrutura (0-2) + critério (0-2) + anti-padrões (0-2) + roteamento (0-1)
- Se score drop ≥2 pts: flag como degradação + action item
- Se score <5 novo: marcar crítico 🔴

## Output padrão

```markdown
# Agent Audit — YYYY-MM (Automated)

## 📊 Resumo
- Auditados: 23
- Melhores: N | Piores: N | Críticos: N | Drift: N

## 🟢 Sem Alterações
[Lista]

## 🟡 Melhoria
[Score anterior → novo]

## 🔴 Degradação
[Score anterior → novo + ação recomendada]

## ⚠️ Drift
[Estrutura desaparecida]

## 📋 Tabela Completa
[Score anterior → novo para todos]
```

Append em `operations.md`:
```
## YYYY-MM-DD — Agent Audit Mensal (Ledger)
Status: [✅ Sem anomalias | ⚠️ [N] degradações | 🔴 [N] críticos]
Se anomalias: Nexus recomendado chamar `hill` (diagnóstico) ou `review` (sync)
```

## Anti-padrões

- ❌ Gerar alertas com baseline corrompido (abortar, registrar erro)
- ❌ Mudar framework de score sem versionamento
- ❌ Não documentar timeout/retry behavior
- ❌ Alertar sem contexto ("Score drop" vs "Score drop 7→5: tabela roteamento desapareceu")

---

## Agendamento

```bash
# Cron: 1ª segunda de cada mês, 9h (timezone: local)
0 9 1 * *

# Exemplo: 2026-05-01 seria terça (skip) → próximo: 2026-06-01 (domingo, skip) → 2026-07-01 (quarta)
# NOTA: cron "1 * *" = dia 1–7 do mês. Se quiser garantir sempre segunda, use systemd timer ou similar.
```

Se needed: "first-monday" helper em `/04-SYSTEM/agents/00-infrastructure/first-monday.sh`

---

## Timeout + Retry

- **Timeout:** 5 min máximo (abort se exceder)
- **Retry:** nenhum (falha é registrada, não re-executa)
- **Log:** `/04-SYSTEM/logs/operations.md`

---

## Exemplo de Execução

**Data:** 2026-06-01, 9:00 AM  
**Baseline:** `/04-SYSTEM/logs/agent-audit-2026-05-01.md`  
**Novos agentes scanned:** 23

**Findings:**
- `gerador-de-resumos-de-estudo`: 7 → 7 (estável)
- `converter-markdown-html`: 7 → 6 (perda tabela roteamento) ⚠️
- `tjam-fiscal-contratos`: 7 → 7 (estável)
- [... 20 mais sem alterações]

**Output:**
```
# Agent Audit — 2026-06-01

## 📊 Resumo
- Auditados: 23 | Melhores: 0 | Piores: 1 | Críticos: 0 | Drift: 1

## 🟡 Degradação (1)
- converter-markdown-html: 7 → 6
  Motivo: seção "Roteamento Situações → Modos" desapareceu
  Ação: Nexus chamar `review` para sincronizar documentação

[... resto do log]
```

**Append em operations.md:**
```
## 2026-06-01 — Agent Audit Mensal (Ledger Automático)
⚠️ 1 degradação detectada: converter-markdown-html (7→6, tabela roteamento faltando)
Recomendação: Nexus chamar `review` para sync
```

---

## Testing

Para testar manualmente antes do cron:

```bash
# Simular execução
claude @scheduled agent-audit-monthly

# Verificar output
cat /04-SYSTEM/logs/agent-audit-2026-MM.md
tail -20 /04-SYSTEM/logs/operations.md
```

---

## Manutenção

- **Mês a mês:** Ledger mantém histórico em `/04-SYSTEM/logs/agent-audit-*.md`
- **Retenção:** 12 meses (2-year rolling window)
- **Cleanup:** Se >12 meses, arquivar para `/04-SYSTEM/logs/archive/`
