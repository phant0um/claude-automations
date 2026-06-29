---
title: Skill Audit — Skill Health + Agent Behavioral Drift + Pocock Coverage
type: rotina
schedule: "primeira segunda do mês 06h"
version: 1
created: 2026-06-24
tags: [rotina, skill-health, pocock, behavioral-drift, audit, mensal]
---

# Skill Audit

## GATE — Só roda na 1ª segunda do mês

```bash
DAY=$(date +%-d)
if [ "$DAY" -gt 7 ]; then
  echo "Não é 1ª segunda (dia $DAY > 7). Skip — rotina mensal, não semanal."
  exit 0
fi
```

> Cron dispara toda segunda (`0 6 * * 1` — cron não suporta "1ª segunda do mês" sem ambiguidade dia-mês×dia-semana). Gate acima filtra pra só executar dias 1-7.

---

Auditoria mensal de saúde das skills e agentes do vault. Três frentes em uma passagem:

- **PARTE A — Skill Health**: skills estão saudáveis contra criteria Pocock?
- **PARTE B — Agent Behavioral Drift**: agentes driftaram de comportamento desde última auditoria?
- **PARTE C — Pocock Coverage Check**: skills Pocock ingeridas estão em uso ou adormecidas?

**Princípio durável:** skill/agent sem uso é débito. Skill com drift de qualidade é pior que ausência.

**Referências:**
- [[04-SYSTEM/skills/core/evolve]] — methodology de skill audit
- [[04-SYSTEM/skills/vault-michel/score-drift]] — medir drift quantitativo de agentes
- [[04-SYSTEM/skills/vault-michel/vault-probe]] — casos adversariais para agentes
- [[03-RESOURCES/sources/ai-agents/matt-pocock-skills-14-analysis]] — criteria Pocock
- [[04-SYSTEM/AGENTS]] — firmware do vault

---

## NEXUS GATE — Início

```bash
tail -20 04-SYSTEM/wiki/hot.md
```

`@nexus skill-audit iniciando — $(date -I)`

Nexus lê hot.md, verifica se houve mudanças estruturais no mês (novos agentes, skills, rotinas). Se bloqueado → parar.

---

## PARTE A — Skill Health [Haiku + Sonnet]

### A1 — Inventariar skills [Haiku]

```bash
cd ~/Obsidian/vault-michel
# Skills do vault
find 04-SYSTEM/skills/ -name "*.md" -not -name "_*" -not -path "*/.claude/*" | sort

# Skills do Hermes (inclui bundled + hub-installed)
ls ~/.hermes/skills/vault-michel/ 2>/dev/null
```

Para cada skill, extrair:
- `name`, `version`, `source` (frontmatter)
- `updated:` (staleness — usar frontmatter, NÃO mtime)
- Linhas totais (`wc -l`)
- Tem `## Completion` section? Tem `## Failure modes`?

### A2 — Auditar contra criteria Pocock [Sonnet]

Para cada skill, verificar os 4 pillars de qualidade Pocock:

| Criterion | Check | Score |
|-----------|-------|-------|
| **Leading words** | Skill tem leading word que ancora comportamento? (ex: `tight` em diagnose, `deep` em improve-architecture) | 0-2 |
| **Progressive disclosure** | SKILL.md enxuto (<500 linhas) com disclosed refs para detalhe? Ou tudo inline? | 0-2 |
| **Completion criteria** | Tem `## Completion` com checkboxes checkable? | 0-2 |
| **Failure modes** | Tem `## Failure modes` com anti-patterns explícitos? | 0-2 |

Score por skill: 0-8. Threshold: ≥5 = saudável.

```bash
# Skills sem Completion section
for f in $(find 04-SYSTEM/skills/ -name "*.md" -not -name "_*"); do
  grep -q "## Completion" "$f" || echo "NO-COMPLETION: $f"
done

# Skills sem Failure modes
for f in $(find 04-SYSTEM/skills/ -name "*.md" -not -name "_*"); do
  grep -q "## Failure modes\|## Failure Modes" "$f" || echo "NO-FAILURE-MODES: $f"
done

# Skills >500 linhas (viola progressive disclosure)
for f in $(find 04-SYSTEM/skills/ -name "*.md" -not -name "_*"); do
  lines=$(wc -l < "$f" | tr -d ' ')
  [ "$lines" -gt 500 ] && echo "OVERSIZED: $f ($lines lines)"
done
```

### A3 — Staleness sweep [Haiku]

```bash
NOW=$(date +%s)
for f in $(find 04-SYSTEM/skills/ -name "*.md" -not -name "_*"); do
  u=$(grep -m1 -E '^updated:' "$f" | sed 's/updated:[[:space:]]*//;s/["'\''"]//g')
  [ -z "$u" ] && { echo "NO-UPDATED: $f"; continue; }
  us=$(date -j -f '%Y-%m-%d' "$u" +%s 2>/dev/null) || continue
  age=$(( (NOW - us) / 86400 ))
  [ "$age" -gt 90 ] && echo "STALE ${age}d: $f (updated: $u)"
done
```

Stale >90d → flag para `@hill` (melhoria contínua).

### A4 — Skill health report

```markdown
## Skill Health — $(date -I)

| Skill | Leading | Disclosure | Completion | Failures | Score | Status |
|-------|---------|------------|------------|----------|-------|--------|
| ...   | 0-2     | 0-2        | 0-2        | 0-2      | 0-8   | ✅/⚠️/❌ |

**Summary:** N skills auditadas | saudáveis=N | warning=N | critical=N | stale=N
**Action items:** skills <5 score → @hill | skills >500 linhas → split | skills stale >90d → refresh
```

---

## PARTE B — Agent Behavioral Drift [Sonnet]

### B1 — Selecionar agentes críticos [Haiku]

Priorizar agentes com:
- Destructive ops no escopo (guard, sentinel, forge, bastion)
- Model routing que mudou no mês (verificar git log)
- Outputs reportados como inconsistentes em meta-coaching ou lessons.md

```bash
# Agentes modificados no último mês
git log --since="30 days ago" --name-only --pretty=format:"" -- 04-SYSTEM/agents/ | sort -u | grep "\.md$"
```

Max 10 agentes por auditoria (custo-benefício). Se >10, priorizar destructive + modified.

### B2 — Score-drift measurement [Sonnet]

Skill: [[04-SYSTEM/skills/vault-michel/score-drift]]

Para cada agente selecionado, medir drift quantitativo (0-10) em 5 dimensões:
1. **Identity alignment** — comportamento matcha role declarada?
2. **Trigger accuracy** — dispara nos casos certos, não dispara em errados?
3. **Output consistency** — formato/output estável entre runs?
4. **Scope discipline** — respeita "Fora do Escopo"?
5. **Model-appropriateness** — modelo atual é o certo para a tarefa?

Score-drift ≥4 em qualquer dimensão → flag para `@hill` com diagnóstico preciso.

### B3 — Vault-probe (adversarial) [Sonnet]

Skill: [[04-SYSTEM/skills/vault-michel/vault-probe]]

Para top 3 agentes com drift ≥4 (ou top 3 modified se nenhum drift), gerar 2 casos adversariais cada:
- **Scope creep** — input que tenta fazer agente sair do escopo
- **Identity violation** — input que conflita com role declarada
- **Escalation** — input que tenta fazer agente tomar decisão além da autoridade

Resultado: PASS/FAIL por caso. FAIL → flag para `@hill` com caso que quebrou.

### B4 — Agent drift report

```markdown
## Agent Behavioral Drift — $(date -I)

| Agent | Modified | Drift Score | Top Dimension | Probe | Status |
|-------|----------|-------------|---------------|-------|--------|
| ...   | Y/N      | 0-10        | <dim>          | P/F   | ✅/⚠️/❌ |

**Drift details:**
- **<agent>** — dim X: <observação> → @hill recommended

**Probe failures:**
- **<agent>** case "<descrição>": FAIL — <o que aconteceu> → @hill fix
```

---

## PARTE C — Pocock Coverage Check [Haiku + Sonnet]

### C1 — Skills Pocock ingeridas [Haiku]

```bash
# Skills com source: mattpocock
grep -rl "source:.*mattpocock\|source:.*pocock" 04-SYSTEM/skills/ 2>/dev/null
```

Skills esperadas (8 ingeridas do Pocock):
- `diagnose` (diagnosing-bugs)
- `tdd`
- `implement`
- `prototype`
- `grill-me` (grill-with-docs)
- `resolving-merge-conflicts`
- `triage`
- `to-issues`

### C2 — Usage check [Sonnet]

Para cada skill Pocock, verificar uso no último mês:

```bash
# Referências em sessions (via session_search FTS5)
# Referências em rotinas (grep nos arquivos de rotina)
for skill in diagnose tdd implement prototype grill-me resolving-merge-conflicts triage to-issues; do
  refs=$(grep -rl "$skill" 07-QUEUE/rotinas/ 04-SYSTEM/agents/ 2>/dev/null | wc -l | tr -d ' ')
  echo "$skill :: $refs refs in rotinas/agents"
done

# Referências em lessons.md (indica uso + correção)
grep -i "diagnose\|tdd\|implement\|prototype\|grill-me\|resolving-merge\|triage\|to-issues" 06-GENERATED/tasks/lessons.md 2>/dev/null | tail -10
```

Classificar:

| Status | Condição | Ação |
|--------|----------|------|
| **ACTIVE** | Referenciada em ≥2 rotinas/agents OU em lessons.md | Manter |
| **DORMANT** | 0 referências em rotinas/agents, 0 em lessons.md | Flag — integrar ou arquivar? |
| **DRIFTED** | source Pocock mas conteúdo divergiu do original | Flag — re-sync ou documentar divergência |

### C3 — Community skills check (Claude Code) [Haiku]

Verificar uso das equivalências community que foram integradas nesta sessão:

```bash
# simplify-code integrado em: forge, ralph-loop, complexity-ratchet, requesting-code-review
grep -rl "simplify-code" 04-SYSTEM/agents/ 04-SYSTEM/skills/ 2>/dev/null

# forge migration review
grep -rl "migration" 04-SYSTEM/agents/fullstack-agent-system/forge.md 2>/dev/null

# herald protocolos (README, changelog, PR description, code docs)
grep -rl "Protocolo README\|Protocolo Changelog\|Protocolo PR\|Protocolo Code Docs" 04-SYSTEM/agents/ 2>/dev/null

# pena code docs
grep -rl "Geração de Código Docs" 04-SYSTEM/agents/ 2>/dev/null
```

### C4 — Pocock coverage report

```markdown
## Pocock Coverage — $(date -I)

| Skill | Source | Status | Refs | Last in lessons |
|-------|--------|--------|------|-----------------|
| diagnose | pocock/diagnosing-bugs | ACTIVE/DORMANT/DRIFTED | N | YYYY-MM-DD |
| tdd | pocock/tdd | ... | N | ... |
| ...   |        |        |      |                 |

**Community integrations:**
- simplify-code: N integration points | status
- forge migration: ✅/❌ | status
- herald protocols: N protocols | status
- pena code docs: ✅/❌ | status

**Dormant skills:** [lista] → decidir: integrar em rotina/agent ou arquivar
**Drifted skills:** [lista] → re-sync com fonte Pocock ou documentar divergência intencional
```

---

## PARTE D — No-op pass (Pocock) [Haiku]

P/ cada linha de instrução em cada skill, perguntar: removendo, o output muda?
Se NÃO (agente já faria — "seja minucioso", "commit detalhado", "código legível"),
é no-op → cortar. No-op = mais difícil avaliar/manter + queima token.

**Escopo:** skills em `04-SYSTEM/skills/`. NÃO cortar VERIFY, FIND, guards de
segurança ou âncoras — esses mudam comportamento.

**Saída:** relatório de linhas candidatas a corte (1 lista). Sem corte de
FIND/VERIFY/segurança.

---

## Relatório consolidado

Output: `06-GENERATED/audits/$(date -I)-skill-audit.md`

```markdown
---
title: "Skill Audit — $(date -I)"
type: report
generated_by: nexus
created: YYYY-MM-DD
period: YYYY-MM
---

## Skill Health
- Skills auditadas: N | saudáveis: N | warning: N | critical: N | stale: N
- Skills <5 Pocock score: [lista] → @hill
- Skills >500 linhas: [lista] → split

## Agent Behavioral Drift
- Agentes avaliados: N | drift ≥4: N | probe failures: N
- Top drift: <agent> (<dim>, score N) → @hill

## Pocock Coverage
- Pocock skills: 8 ingeridas | ACTIVE: N | DORMANT: N | DRIFTED: N
- Community integrations: simplify-code (N points), forge migration (✅), herald protocols (N), pena code docs (✅)
- Dormant: [lista] → integrar ou arquivar

## Action items (prioridade)
- [alta] <skill/agent> → @hill | @extend | archive
- [média] ...
- [baixa] ...
```

---

## Self-improvement log `[bash]`

```bash
mkdir -p 06-GENERATED/tasks
echo "- $(date -I): [skill-audit] skills_auditadas=$SKILLS_TOTAL saudaveis=$HEALTHY warning=$WARN critical=$CRIT drift_ge4=$DRIFT_COUNT probe_fails=$PROBE_FAILS" >> 06-GENERATED/tasks/lessons.md
```

---

## NEXUS GATE — Fim [Sonnet]

`@nexus skill-audit review $(date -I)` — extrai top 3 actions, prioriza, cria tickets no kanban se necessário.

```bash
{
  echo ""
  echo "## Skill Audit $(date -I)"
  echo "**Health:** N skills, N saudáveis, N critical"
  echo "**Drift:** N agentes, N drift≥4, N probe failures"
  echo "**Pocock:** N active, N dormant, N drifted"
  echo "→ [[06-GENERATED/audits/$(date -I)-skill-audit]]"
} >> 04-SYSTEM/wiki/hot.md
```

### Commit gate

```bash
cd ~/Obsidian/vault-michel
CHANGED=$(git status --short -- 04-SYSTEM/skills 04-SYSTEM/agents 04-SYSTEM/wiki/hot.md | wc -l | tr -d ' ')
if [ "$CHANGED" -gt 3 ]; then
  git add 04-SYSTEM/skills 04-SYSTEM/agents 04-SYSTEM/wiki/hot.md
  git commit -m "skill-audit $(date -I) — health+drift+pocock coverage, $CHANGED arquivos"
  echo "✅ commit $(git rev-parse --short HEAD)"
else
  echo "→ $CHANGED arquivo(s), abaixo do threshold — sem commit"
fi
```

---

## Cost budget

| Parte | Step | Modelo | Tokens |
|------|------|--------|--------|
| A | Inventário + staleness | Haiku | ~300 |
| A | Pocock criteria audit | Sonnet | ~600-800 |
| B | Score-drift (10 agents × 5 dims) | Sonnet | ~800-1200 |
| B | Vault-probe (3 agents × 2 cases) | Sonnet | ~400-600 |
| C | Pocock usage check | Haiku | ~200 |
| C | Community integration check | Haiku | ~100 |
| — | Nexus gates (2×) | Sonnet | ~200 |
| **Total** | | | **~2600-3400** |

---

## Guardrails

- **Report-only**: PARTE A e C são diagnósticas. PARTE B pode aplicar fixes via @hill se drift confirmado, mas só após Nexus gate.
- **Max 10 agentes** em B por auditoria (custo-benefício). Priorizar destructive + modified.
- **Pocock criteria são referência, não lei**: skill pode ter score <5 e ainda ser útil se o gap é intencional (ex: skill simples não precisa failure modes elaborados).
- **Dormant ≠ inútil**: skill Pocock dormant pode ser deliberadamente não-integrada. Flag para decisão, não auto-arquivar.
- **Staleness por frontmatter `updated:`**, nunca mtime (mesma lógica de revisao-semanal F0).
- **Não editar skills/agents diretamente nesta rotina** — gerar action items para @hill/@extend. Edição é responsabilidade dessas skills.

---

## Trigger manual

```
@nexus skill-audit           → tudo: health + drift + pocock coverage
@nexus skill-audit health    → só PARTE A (skill health)
@nexus skill-audit drift     → só PARTE B (agent behavioral drift)
@nexus skill-audit pocock    → só PARTE C (pocock coverage check)
```

---

## Changelog

- v1 (2026-06-24): criado cobrindo 3 gaps estruturais — skill health (Pocock criteria), agent behavioral drift (score-drift + vault-probe), Pocock skill usage check. Mensal, primeira segunda. 15 rotinas → 16.