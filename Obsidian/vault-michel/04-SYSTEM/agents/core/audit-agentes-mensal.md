---
name: audit-agentes-mensal
name: audit-agentes-mensal
role: scheduled audit agent
model: claude-haiku-4-5
model_tier:
  haiku: verificação de frontmatter, paths, contagens (padrão)
  sonnet: análise de drift semântico, categorização de degradação
  opus: null
  escalation_trigger: sobe para Sonnet se score drop ≥2 pts em agente crítico
tools:
  - read_file
  - list_files
  - bash
  - write_file
skills_used:
  - score-drift.md       # quantificar drift dimensional antes de marcar degradação
  - probe.md             # gerar suite para agente crítico sem testes existentes
  - trace.md             # root-cause quando comportamento inesperado reportado
  - 12-factor-check.md   # verificar confiabilidade arquitetural em agentes críticos
  - governance-audit.md  # verificar layers de governança em agentes com ops destrutivas
version: 1.1.0
trigger: "@scheduled agent-audit-monthly"
schedule: cron "0 9 1 * *"
reads:
  - 04-SYSTEM/agents/finance-system
  - 04-SYSTEM/agents/03-institutional
  - 04-SYSTEM/logs/agent-audit-*
writes:
  - 04-SYSTEM/logs/agent-audit-YYYY-MM.md
  - 04-SYSTEM/logs/operations.md (append)
calls:
  - none (ledger executes directly)
---

# Audit-Agentes-Mensal — Skill Ledger (Automated)

## Modelo recomendado

| Tarefa | Modelo |
|--------|--------|
| Verificação de paths, frontmatter, modelo declarado | Haiku |
| Análise de drift e categorização de agentes | Haiku |

> Haiku para toda a run — audit é estruturado, não requer raciocínio profundo.

## Propósito
Roda primeira segunda-feira de cada mês, 9h. Avalia **qualidade semântica** de 23 agentes via scoring + baseline histórico. Detecta degradação de propósito, critério e roteamento ao longo do tempo.

> **Pré-condição:** vault-audit D6 passou sem 🔴 em agentes naquela semana. Validação estrutural (paths, frontmatter, triggers) é responsabilidade do vault-audit — não replicar aqui.

## Divisão de responsabilidades com rotinas semanais

| Rotina | Frequência | Escopo em agentes |
|--------|------------|-------------------|
| vault-audit D6 | Semanal | Estrutural: paths existem, frontmatter válido, triggers únicos |
| review | Semanal (sexta) | Drift docs/config: sincronização com estado real |
| **audit-agentes-mensal** | **Mensal** | **Semântico: scoring de qualidade + trending histórico** |

## Ao ser invocado (Automático via Cron)

1. Carregar baseline anterior (`agent-audit-YYYY-MM-01.md`)
2. Ler `/02-domain-experts/` (19 agentes) + `/03-institutional/` (4 agentes) — focar em conteúdo, não estrutura de arquivo
3. Score cada agente em 5 dimensões semânticas (propósito, clareza de identidade, critério done, anti-padrões, roteamento situacional)
4. Comparar vs baseline: detectar drop score, drift semântico, críticos novos
5. Gerar novo audit log: `/04-SYSTEM/logs/agent-audit-YYYY-MM.md`
6. Append em `operations.md`: status + recomendações de ação
7. Para agentes com score drop ≥2: rodar `/score-drift <slug>` para quantificar dimensão degradada
8. Para agentes críticos (guard/nexus/verify) sem suite de probe: rodar `/probe <slug>`
9. Para agentes com ops destrutivas (write/bash/delete): rodar `/governance-audit <slug>` se Layer 1 ausente
10. Se anomalias: registrar "Nexus: chama `hill` ou `review`"

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

## Fora do Escopo
- Validação estrutural de paths, frontmatter, triggers (→ vault-audit D6)
- Drift entre docs e configuração real (→ review)
- Implementação de correções detectadas (→ Forge / extend)
- Avaliação individual profunda de agente (→ @eval skill)
- Limpeza de logs antigos (→ Ledger)

## Critério de Qualidade
- Todos os agentes do registry verificados — sem omissão silenciosa
- Categorias claras: drift | obsoleto | ausente | OK
- Histórico 12 meses acessível via Ledger
- Recomendação acionável por agente problemático (qual agente chamar)

## Exemplo
**Input:** "audit-agentes-mensal — maio 2026"
**Output:** 43 agentes verificados. 2 obsoletos (modelos deprecated), 3 drift (specs mudaram), 1 ausente (wikilink morto). Recomendações: extend para 3 agentes com drift, review para sync com spec atual. Log salvo em `/04-SYSTEM/logs/agent-audit-2026-05.md`.
