---
skill: score-drift
version: 1.0
trigger: "/score-drift [slug]" | "@score-drift [agente]"
model: claude-haiku-4-5
tags: [quality, drift, agents, monitoring, quantitative]
---

# Skill: Score-Drift

## Propósito

Medir quantitativamente (0–10) o drift semântico de um agente entre sua identidade declarada e seu comportamento observado. Alimenta `hill` com diagnóstico mais preciso do que "parece ter drifted".

**Diferença de `drift-review`:** drift-review varre todo o repo para drift de docs/config (binário: drifted/not). `score-drift` mede um agente específico em profundidade, produz score numérico e trend.

**Diferença de `hill`:** hill melhora. score-drift mede antes de melhorar (input para hill, não substituto).

---

## Condições de Ativação

Ative quando:
- Comportamento de agente parece inconsistente mas não claramente errado
- Antes de `@hill <agente>` para quantificar o problema
- Após série de sessões com agente crítico (guard, nexus, verify) — manutenção preventiva
- `@review` reportou drift mas não quantificou

NÃO ative para: agente recém-criado sem histórico de sessões; drift de docs/config do vault (→ drift-review).

---

## Modelo por Etapa

| Etapa | Modelo | Razão |
|-------|--------|-------|
| Toda a execução | Haiku | Scoring é comparison estruturado, não síntese |
| Se score < 5 (drift severo): diagnóstico das dimensões | Sonnet | Precisão no diagnóstico |

---

## Dimensões de Avaliação

Score cada dimensão de 0–10 (0 = sem drift, 10 = completamente drifted):

| Dimensão | O que mede | Evidência a coletar |
|----------|-----------|---------------------|
| **D1 — Identidade** | Agente age como declara ser? | Comparar seção "Identidade" com comportamento nos últimos outputs observados |
| **D2 — Escopo** | Agente respeitou "Fora do Escopo"? | Casos onde agente saiu do escopo declarado |
| **D3 — Modelo** | Agente usou modelo certo por fase? | Comparar `model_tier` declarado vs comportamento real |
| **D4 — Restrições** | Agente violou "Restrições" explícitas? | Cada restrição da seção → foi violada alguma vez? |
| **D5 — Formato** | Output seguiu formato declarado? | Comparar formato esperado vs outputs reais |

---

## Protocolo

### 1. Ler Agent File *(Haiku)*

Ler `04-SYSTEM/agents/00-core/<slug>.md`. Extrair:
- Identidade declarada (seção "Identidade")
- Restrições explícitas
- Fora do escopo
- Model tier
- Formato de relatório/output

### 2. Coletar Evidência de Comportamento *(Haiku)*

Fontes de evidência (usar o que estiver disponível):
```bash
# Commits relacionados ao agente
git log --oneline --all --grep="<slug>" -- 04-SYSTEM/agents/

# Outputs gerados pelo agente
ls -t 06-GENERATED/ | head -20

# Errors log
grep -i "<slug>" 04-SYSTEM/wiki/errors.md 2>/dev/null | tail -10

# Hot cache (sessões recentes)
grep -A3 "<slug>" 04-SYSTEM/wiki/hot.md 2>/dev/null
```

Se não houver evidência suficiente: score com base apenas na análise estática do agent file (consistência interna).

### 3. Scoring por Dimensão *(Haiku; Sonnet se D* < 5)*

Para cada dimensão D1–D5:

```
Score: [0-10]
Evidência: [citação ou observação concreta]
Threshold: [abaixo de qual score é drift preocupante — padrão: <7]
```

### 4. Score Composto e Trend

**Score composto:** média ponderada (D1 e D4 têm peso 1.5× — identidade e restrições são mais críticos):

```
Score = (D1×1.5 + D2 + D3 + D4×1.5 + D5) / 7
```

**Trend** (se score anterior disponível no hot.md):
```
Trend = Score_atual - Score_anterior
+valor = piora (mais drift)
-valor = melhora (menos drift)
```

### 5. Output

```
SCORE-DRIFT: <slug> v<versão> | <data>

D1 — Identidade:     [score]/10  [PASS/WARN/FAIL]
D2 — Escopo:         [score]/10  [PASS/WARN/FAIL]
D3 — Modelo:         [score]/10  [PASS/WARN/FAIL]
D4 — Restrições:     [score]/10  [PASS/WARN/FAIL]
D5 — Formato:        [score]/10  [PASS/WARN/FAIL]

SCORE COMPOSTO: [X.X]/10  | Trend: [+/-X.X vs anterior ou "primeira medição"]

DIMENSÕES CRÍTICAS (score < 7):
  [lista com evidência e localização no agent file]

RECOMENDAÇÃO:
  Score ≥ 8:  agente estável — próxima medição em 30 dias
  Score 6–7:  monitorar — repetir em 14 dias ou após próxima sessão intensa
  Score < 6:  DRIFT SIGNIFICATIVO — acionar "@hill <slug>" com este relatório
  Score < 4:  DRIFT SEVERO — acionar "@trace <slug>" antes de hill

PRÓXIMO PASSO: [ação específica baseada na faixa acima]
```

### 6. Atualizar hot.md *(só se score < 7)*

```markdown
## Score-Drift <slug> | <data> | [score]/10 (Trend: [+/-X.X])
Dimensões críticas: [D* list] → "@hill <slug>"
```

---

## Restrições

- NUNCA inventar evidência — se não houver histórico, declarar "análise estática apenas"
- NUNCA emitir score composto sem score de cada dimensão
- Threshold WARN: score < 7 por dimensão; FAIL: score < 5
- Se score D4 (Restrições) < 5: escalar para Sonnet mesmo que outros estejam OK

---

## Relacionado

- [[04-SYSTEM/agents/00-core/hill]] — consome este score como input inicial
- [[04-SYSTEM/skills/reasoning/trace]] — investiga causas específicas quando score-drift identifica dimensão crítica
- [[04-SYSTEM/skills/core/drift-review]] — drift de docs/repo (diferente de drift de comportamento de agente)
