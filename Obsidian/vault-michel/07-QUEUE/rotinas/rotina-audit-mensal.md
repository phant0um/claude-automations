---
title: Auditoria Mensal — Rotinas + Agentes
type: rotina
schedule: "primeiro sábado do mês, 2h"
last_improved: 2026-06-20
version: 12
tags: [rotina, auditoria, melhoria-contínua]
---

# Auditoria Mensal — Rotinas + Princípios

## GATE — Só roda no 1º sábado do mês

```bash
DAY=$(date +%-d)
if [ "$DAY" -gt 7 ]; then
  echo "Não é 1º sábado (dia $DAY > 7). Skip — rotina mensal, não semanal."
  exit 0
fi
```

> Cron dispara toda sábado (`0 2 * * 6` — cron não suporta "1º sábado do mês" sem ambiguidade dia-mês×dia-semana). Gate acima filtra pra só executar dias 1-7.

---

**Agents:** `nexus` (coordenação), `review` (drift detection), `hill` (melhoria), `ledger` (tracking histórico)

**Modelos por step:**
| Step | Modelo | Motivo |
|------|--------|--------|
| Nexus gate início + @review | **Sonnet extended** | drift detection exige raciocínio semântico |
| Scan rotinas (step 1) | **Haiku** | bash + leitura de frontmatter |
| Avaliar por rotina (step 2) | **Sonnet** | análise 3-princípios por arquivo |
| Compilar relatório (step 3) | **Sonnet** | síntese estruturada multi-rotina |
| Hill-climbing (step 4) | **Sonnet** | proposta de ações com impacto/esforço |
| Output consolidado (step 5) | **Sonnet** | escrita do relatório mensal |
| Agent system audit (step 7) | **Haiku** | contagem + verificação frontmatter |
| Nexus final + Ledger (step 8) | **Sonnet / Haiku** | Nexus=Sonnet (gate), Ledger=Haiku |

Audita conformidade de todas as rotinas em `07-QUEUE/rotinas/` contra:
- Karpathy 4P (think, simplicity, surgical, goal-driven)
- Token-economy (RTK, caveman, context-mode, memory, subagents, skills, plan, compact)
- Vault principles (edit>write, wikilinks, hot.md, manifest)

---

## NEXUS GATE — Início

`@nexus audit-mensal iniciando — $(date -I)` — Nexus lê hot.md do mês, identifica rotinas com mais issues reportados. Direciona foco da auditoria.

`@review` — drift check em todas rotinas antes de análise detalhada.

---

## 1. Scan rotinas

```bash
ROTINA_COUNT=$(ls -1 ~/Obsidian/vault-michel/07-QUEUE/rotinas/*.md | grep -v "_template" | wc -l | tr -d ' ')
ls -1 ~/Obsidian/vault-michel/07-QUEUE/rotinas/*.md | \
  grep -v "_template" | \
  sort
echo "Total: $ROTINA_COUNT rotinas"
```

Lista auto-detectada ($ROTINA_COUNT rotinas). Não hardcodear — o count
reflete o estado real do diretório. Se rotina nova/renomeada, o scan pega.

Agendamento (cross-check com scheduler): verificar quais têm `schedule:` no
frontmatter (agendadas) vs manuais. `weekly-ops` roda pela task `rotina-health` (taskId legado).

Se contagem divergir do step 1 header (anteriormente 14, agora auto-detect):
não alertar — a contagem é dinâmica por design.

---

## 2. Ler cada rotina + avaliar `[Sonnet]`

Para cada arquivo:

### 2.1 Karpathy 4P Compliance

| Princípio | Check | Pass/Fail |
|-----------|-------|-----------|
| Think before acting | Tem plan mode ou spec em steps iniciais? | ☐ |
| Simplicity first | Não cria stubs/fragmentos desnecessários? Prefere append vs rewrite? | ☐ |
| Surgical changes | Escopo bem-definido? Não toca arquivos fora escopo? | ☐ |
| Goal-driven, verify | Tem acceptance criteria / checklist final? | ☐ |

Fail → flags como "drift".

### 2.2 Token-Economy Compliance

| Layer | Check | Pass/Fail |
|-------|-------|-----------|
| RTK | Usa RTK em bash commands? `rtk git status`, etc? | ☐ |
| Caveman | Output em caveman mode (fragments OK)? | ☐ |
| Context-mode | Batch queries em vez de N queries 1-by-1? | ☐ |
| Memory | Aproveita cross-session memory pra patterns? | ☐ |
| Subagents | Paralelo em 3+ tasks independentes? | ☐ |
| Skills | Reutiliza skills em vez de re-code? | ☐ |
| Plan mode | Usa plan mode pra 3+ steps? | ☐ |
| Compact | Proativa <70% context window? | ☐ |

**Tier por complexidade:** rotinas leves/interativas (`srs-concurso`, `daily-brief`, `x-thread-weekly`) avaliam só subset de 5 camadas — marcar `Subagents`/`RTK`/`Memory` como **N/A** (não Fail) se a rotina não tem 3+ tasks paralelas, não roda bash extensivo, ou não gera padrões cross-session reutilizáveis. N/A não conta no denominador.

Count (sobre camadas aplicáveis): 0-2 fails = OK, 3+ = drift.

### 2.3 Vault Principles Compliance

| Princípio | Check | Pass/Fail |
|-----------|-------|-----------|
| Edit > Write | Prefere editar existente vs criar novo? | ☐ |
| Wikilinks | Usa `[[path]]` vs URLs? Links válidos? | ☐ |
| Hot.md append | Atualiza `04-SYSTEM/wiki/hot.md` após execução? | ☐ |
| Naming pattern | Outputs seguem `{YYYY-MM-DD}-{rotina}.md` (prefixo de data)? | ☐ |
| Frontmatter | Tem YAML header: type, tags, schedule, version? | ☐ |

---

## 3. Compilar relatório `[Sonnet]`

Por rotina:

```markdown
## [Nome Rotina]

**Status:** ✓ OK / ⚠️ DRIFT

### Karpathy 4P
- Think: ✓/✗
- Simplicity: ✓/✗
- Surgical: ✓/✗
- Goal-driven: ✓/✗

### Token-Economy (X/Y camadas aplicáveis — Y=8 ou 5 se rotina leve, ver tier 2.2)
- Fails: [lista se houver]

### Vault Principles (X/5)
- Fails: [lista se houver]

### Recomendações
1. [ação 1]
2. [ação 2]
```

---

## 4. Hill-climbing recomendações `[Sonnet]`

Para cada "DRIFT" identificado, sugerir **ação concreta**:

| Drift | Recomendação | Esforço | Impacto |
|-------|--------------|---------|---------|
| `ingest-diario` sem RTK em bash | Ativar `rtk` hook em todos comandos git/ls/grep | 15 min | Alto (60-90% economia tokens) |
| `connection-finder` sem memory | Cache co-occurrence matrix em memory.md, reuser semanal | 30 min | Médio (200-300 tokens) |
| `process-queue` sem plan mode | Adicionar step 1: "entender 3+ tasks antes agir" | 10 min | Baixo (structure clarity) |

---

## 5. Output consolidado

Gerar: `06-GENERATED/audits/YYYY-MM-rotina-audit.md`

Frontmatter:
```yaml
title: Auditoria Mensal — Rotinas
type: report
period: YYYY-MM (ex: 2026-05)
rotinas_audited: <auto-detect>
compliance_score: X/100  # média dos 3 princípios
drift_count: N
generated_by: nexus + review + hill
created: YYYY-MM-DD
```

Seções:
1. Resumo executivo (1 frase por rotina: OK / DRIFT + top issue)
2. Compliance matrix (N rotinas × 3 princípios — N = `ls 07-QUEUE/rotinas/*.md | wc -l`)
3. Hill-climbing backlog (ordenado por impacto)
4. Ações sugeridas pra próximo mês

Max 200 linhas.

---

## 6. Atualizar hot.md

Append:
```markdown
## Monthly Audit YYYY-MM-DD | Rotinas

**Score:** X/100  
**Drift:** N rotinas (lista)  
**Quick wins:** Top 3 ações (link a audit report)  
**Next focus:** [rotina com mais oportunidade]
```

---

## 6.5 Skills audit — verificar orphans e integrações

```bash
# Skills sem referência em agents ou rotinas
VAULT=~/Obsidian/vault-michel
find $VAULT/04-SYSTEM/skills -name "*.md" | while read s; do
  slug=$(basename "$s" .md)
  refs=$(grep -rl "$slug" $VAULT/04-SYSTEM/agents $VAULT/07-QUEUE/rotinas 2>/dev/null | grep -v "/$slug.md" | wc -l | tr -d ' ')
  [ "$refs" -eq 0 ] && echo "ORPHAN: $slug"
done
```

Para cada skill orphan identificada: avaliar se deve ser integrada em agente ou rotina, ou arquivada.

## 6.6 Score-drift + Probe dos agentes core `[Haiku]`

Para agentes críticos sem suite em `06-GENERATED/probe/`: gerar antes do score-drift.
Skill: [[04-SYSTEM/skills/reasoning/probe]] — suite adversarial que o hill usa como input.



Rodar `/score-drift` em todos os agentes core (guard, hill, verify, extend, review, nexus):
Skill: [[04-SYSTEM/skills/core/score-drift]] (estava `reasoning/` — wikilink quebrado, skill vive em `core/`). Probe suites já existem em `06-GENERATED/probe/` (prereq de 6.6 cumprido).

```bash
# Agentes core para score-drift
ls ~/Obsidian/vault-michel/04-SYSTEM/agents/core/*.md | grep -v "_"
```

Score < 7 em qualquer dimensão → flag para `@hill` no próximo ciclo.

## 6.7 Governance-audit em agentes com ops destrutivas `[Sonnet]`

Identificar agentes com `write_file`, `bash` (delete/push) no `tools:`:

```bash
grep -l "bash\|write_file" ~/Obsidian/vault-michel/04-SYSTEM/agents/core/*.md
```

Para cada um: verificar Layer 1 (Intent Boundary) presente e completo.

⚠️ **Checar por seção, não por string literal.** Audit 2026-06 produziu falso positivo/negativo grepando "Layer 1"/"Intent Boundary" — bateu só em quem cita o termo (audit-agentes-mensal, que NÃO tem as seções) e perdeu 7 agentes que cumprem via convenção real do vault. Verificar presença de:
- `## Identidade` + `## Fora do Escopo` + `## Restrições` (formato padrão), OU
- `## Propósito` + `## Regras`/`REGRAS DE QUALIDADE` (formato skill-ledger/prompt automatizado — ex: audit-agentes-mensal, ingest-report)

Skill: [[04-SYSTEM/skills/core/governance-audit]]

## 6.8 12-factor-check em agentes críticos `[Haiku]`

Rodar `/12-factor-check` em guard, nexus, verify (alta frequência + ops irreversíveis):
Skill: [[04-SYSTEM/skills/core/12-factor-check]]

Score < 0.70 → action item para @extend no próximo ciclo.

**Se F10 (focused) FAIL** (agente com >10 tools ou múltiplos propósitos): rodar `/code-optimize` com Deep Modules analysis no agente. Skill: [[04-SYSTEM/skills/core/code-optimize]] — aplicar deletion test ("deletar este module concentraria complexidade, ou só moveria?") e deepening opportunities (combinar modules pequenos, mover complexidade atrás de interface menor).

## 6.9 Decisions.md audit `[Haiku]`

```bash
wc -l ~/Obsidian/vault-michel/04-SYSTEM/wiki/decisions.md
```

Verificar: entradas do mês presentes? Decisões arquiteturais sem registro? Entradas >6 meses sem condição de revisão cumprida → considerar arquivar.

---

## 7. Agent system audit `[Haiku]`

```bash
ls 04-SYSTEM/agents/ | grep -v "^_"
```

Para cada sistema: contar agentes, verificar `project-setup.md`.

Sistemas esperados (com project-setup.md): Finance, Knowledge, Marketing, MTG, TJAM, Travel.
Sistemas adicionais: Edu, Fullstack, Nexus, Productivity, standalone/.

Report por sistema:
| Sistema | Agentes | project-setup.md | Status |
|---------|---------|-----------------|--------|

Incluir no compliance matrix final como 4ª coluna.

---

## 8. Nexus final + Ledger

`@nexus revisar $(date +%Y-%m)-rotina-audit` — Nexus extrai top 3 ações, prioriza hill-climbing backlog.

`@ledger registrar`:
- Agentes usados: nexus, review, hill, ledger
- Compliance score histórico (tracking)
- Rotinas com drift persistente (>2 meses)

---

## Acceptance Criteria

- [ ] Todas as rotinas auditadas (listadas no report)
- [ ] Compliance matrix completa (rotinas × 3 princípios)
- [ ] ≥2 hill-climbing ações recomendadas
- [ ] Output em `06-GENERATED/audits/YYYY-MM-rotina-audit.md`
- [ ] hot.md atualizado
- [ ] Wikilinks válidos no report
- [ ] Ledger registrado

---

## Self-improvement log `[bash]`

```bash
mkdir -p 06-GENERATED/tasks
echo "- $(date -I): [rotina-audit-mensal] compliance=$COMPLIANCE_SCORE, rotinas_ativas=$ACTIVE_COUNT, agents_auditados=$AGENTS_AUDITED, findings=$FINDINGS_COUNT" >> 06-GENERATED/tasks/lessons.md
```

---

## Guardrails

- NÃO executar mudanças — apenas recomendar (hill faz implementação em follow-up)
- Se rotina quebrou (excuted files não gera output) → priority "alta"
- Se compliance <70% → escalate pra Nexus pra replanning
- Ignorar worktrees (foco em `/07-QUEUE/rotinas/`)

---

## Changelog

- v12 (2026-06-20): naming — output invertido p/ `YYYY-MM-rotina-audit.md` (prefixo de data). **Critério de naming-check (§4) invertido** p/ `{YYYY-MM-DD}-{rotina}.md` — senão a audit flagaria o formato novo como drift. Audits já criados mantidos.
- v11 (2026-06-20): contagem 16→14 — **fusões por redundância**. Fusão A: `metricas-ingest` retirada (~80% já em revisao-semanal F1.1/F1.3/F3.1; dashboard único absorvido em revisao FASE 0). Fusão B: `rotina-health`+`fix-tracker` → `weekly-ops` (gêmeas de segunda, mesma lógica "alegado≠verificado"). Checks 48→42. Agendamento 12 agendadas + 2 manuais. 3 arquivos → `08-ARCHIVE/rotinas/`.
- v10 (2026-06-19): contagem 13→16 — 3 rotinas novas (`vault-backup`, `rotina-health`, `fix-tracker`) criadas a partir de aprendizados (WP2 backup-gap, WP3 scheduler/runtime drift, Meta-Learn F3.8 fix-tracking). Checks 39→48. Agendamento 13 agendadas + 3 manuais.
- v9 (2026-06-19): contagem 10→13 (step 1 list, header, output frontmatter, step 5, acceptance 30→39 checks) — faltavam `daily-scan`, `srs-sources`, `vault-hot-sweep`. + cross-check de agendamento. step 6.6 wikilink `reasoning/score-drift`→`core/score-drift` (skill vivia em `core/`, link quebrado bloqueava o step). Nota: probe suites já existem em `06-GENERATED/probe/`.
- v8 (2026-06-09): contagem 9→10 — nova rotina `vault-reconcile-semanal.md` (sexta 22h, vault-reconcile agent via Ollama). Compliance matrix 27→30 checks.
- v7 (2026-06-07): corrigido bug de metodologia no step 6.7 (drift #3 do audit 2026-06 era falso positivo — grep de string literal "Layer 1"/"Intent Boundary" não detecta seções equivalentes do vault). Adicionada nota: checar `## Identidade`+`## Fora do Escopo`+`## Restrições` (formato padrão) OU `## Propósito`+`## Regras` (formato skill-ledger), não string literal. Verificado: guard/hill/extend/review/spec/verify/vault-audit já cumprem via convenção real — não precisam de boilerplate adicional.
- v6 (2026-06-07): tier por complexidade no Token-Economy Compliance (drift #9 do audit 2026-06) — rotinas leves/interativas (srs-concurso, daily-brief, x-thread-weekly, metricas-ingest) avaliam Subagents/RTK/Memory como N/A se não-aplicável, em vez de Fail. Template do relatório ajustado pra denominador variável (X/Y, Y=8 ou 5).
- v5 (2026-06-06): contagem 7→9 (drift achado em audit mensal 2026-06 — ver [[06-GENERATED/audits/rotina-audit-2026-06]]). manutencao-semanal + meta-coaching-semanal deprecadas (substituídas por revisao-semanal v1) → movidas pra `08-ARCHIVE/rotinas/`. 4 novas: revisao-semanal, metricas-ingest, srs-concurso, x-thread-weekly. Lista "Nomes esperados", compliance matrix (21→27 checks) e acceptance criteria corrigidos.
- v4 (2026-06-06): cron `0 2 1-7 * 6` (dia-mês × dia-semana = OR ambíguo, scheduler falhava ao iniciar) → `0 2 * * 6` + gate de auto-skip se dia>7. Migração remoto→local revertida (description "MIGRADA PARA REMOTA" removida).
- v3 (2026-05-23): contagem 8→7 rotinas (merge pipeline-diario + manutencao-semanal). Nexus gate início e fim. Ledger tracking. Modelos: Haiku (scan/ledger), Sonnet (análise/relatório/hill), Opus (Nexus/review).
- v2 (2026-05-16): contagem 7→8 rotinas, step 7 agent system audit adicionado (115 agentes, 5 sistemas novos). Scheduled task criado.
- v1 (2026-05-14): criado. Agentes: review (drift) + hill (melhoria). Frequência: mensal. Métricas: 3×7 compliance matrix.
