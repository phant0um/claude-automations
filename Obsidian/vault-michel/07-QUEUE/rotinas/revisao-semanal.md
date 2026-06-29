---
title: Revisão Semanal — System Review + Lint + Conexões + Meta-Coaching
type: rotina
schedule: "domingo 4h AM"
last_improved: 2026-06-20
version: 6
replaces: [manutencao-semanal, meta-coaching-semanal, metricas-ingest]
tags: [rotina, lint, conexões, meta-coaching, system-review, manutenção]
---

# Revisão Semanal

Pipeline semanal unificado. Substitui: `manutencao-semanal` + `meta-coaching-semanal`.

Caveman full. Autônomo.

**Referências vault:**
- [[03-RESOURCES/wiki-index]]
- [[04-SYSTEM/AGENTS.md]]
- [[04-SYSTEM/vault-identity]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[04-SYSTEM/agents/nexus]]

---

## NEXUS GATE — Início

```bash
tail -20 04-SYSTEM/wiki/hot.md
```

`@nexus revisao-semanal iniciando — $(date -I)`

Nexus lê hot.md, verifica estado vault da semana. Autoriza ou bloqueia.
Se bloqueado → parar. Reportar motivo.

---

## FASE 0 — System Review [Haiku]

**Objetivo:** Verificar se documentos estruturais estão atualizados, consistentes e sem drift.

```bash
# Datas de última modificação
stat -f "%Sm %N" -t "%Y-%m-%d" \
  CLAUDE.md \
  04-SYSTEM/AGENTS.md \
  04-SYSTEM/vault-identity.md \
  04-SYSTEM/wiki/hot.md \
  03-RESOURCES/wiki-index.md \
  03-RESOURCES/entities.md \
  03-RESOURCES/index.md \
  03-RESOURCES/log.md \
  03-RESOURCES/session-startup-checklist.md \
  2>/dev/null

# Contagem real de agentes (cross-check com AGENTS.md)
find 04-SYSTEM/agents/ -name "*.md" ! -name "_*" | wc -l

# Agentes sem frontmatter obrigatório (convenção real: name/role/model — L04, não title/trigger)
grep -rL "^model:" 04-SYSTEM/agents/ | head -10

# 04-SYSTEM/ completa
ls 04-SYSTEM/agents/ 04-SYSTEM/wiki/ 04-SYSTEM/logs/ 2>/dev/null

# Staleness de governance 04-SYSTEM/wiki/ por frontmatter `updated:` — NÃO mtime.
# mtime reseta em git checkout/sync e mascara staleness real (achado 2026-06-20:
# 6 arquivos com updated: >30d apareciam fresh por mtime). Cobre os arquivos que o
# seed hardcoded acima + o fecho CLAUDE.md (F0.1) NÃO alcançam (0 seeds linkam
# memory/conventions/skill-memory/vault-graph/vault-structure-map/golden-cases).
NOW=$(date +%s)
for f in 04-SYSTEM/wiki/*.md; do
  u=$(grep -m1 -E '^updated:' "$f" | sed 's/updated:[[:space:]]*//;s/["'\'']//g')
  [ -z "$u" ] && { echo "NO-UPDATED: $f (frontmatter sem campo updated:)"; continue; }
  us=$(date -j -f '%Y-%m-%d' "$u" +%s 2>/dev/null) || continue
  age=$(( (NOW - us) / 86400 ))
  [ "$age" -gt 30 ] && echo "STALE ${age}d: $f (updated: $u)"
done
```

**Vault Health snapshot** (absorvido de `metricas-ingest`, retirada 2026-06-20 por redundância — orphans/hot/volume já cobertos em F1.1/F1.3/F3.1; aqui só os números únicos dela):

```bash
# Conceitos + entidades criados nos últimos 7d (cobertura), por tipo
git log --since="7 days ago" --name-only --pretty=format:"" \
  | grep -E "^03-RESOURCES/(concepts|entities)/" | grep "\.md$" | sort -u \
  | sed 's|03-RESOURCES/||;s|/.*||' | sort | uniq -c
# Queue depth + rotinas ativas
find 07-QUEUE/ -maxdepth 1 -name "*.md" -not -name "_*" | wc -l
find 07-QUEUE/rotinas/ -name "*.md" -not -name "_*" | wc -l
```

→ Números entram no bloco **System Review** do relatório consolidado. Alertas: queue >5 = backlog pipeline; concepts=0 em 7d = cobertura estagnada.

Ler cada arquivo da lista. Verificar:
- **Staleness:** medir por frontmatter `updated:` (não mtime — ver bloco wiki acima). >30d → marcar stale. Arquivos sem `updated:` → flag `NO-UPDATED`
- **Wikilinks internos:** referências que resolvem arquivo existente
- **Drift:** contagens, listas de agentes, estrutura de pastas vs estado real do vault
- **04-SYSTEM/agents/:** agentes sem frontmatter (convenção real `name`/`role`/`model` — L04, não `title`/`trigger`)

### F0.1 — Ref-graph walk a partir de CLAUDE.md [Haiku]  *(v5)*

**Objetivo:** cobrir o **fecho transitivo** de CLAUDE.md (refs → refs-das-refs),
não só a lista fixa acima. A lista fixa vira **seed garantido**; este walk descobre
o resto dinamicamente — referência nova em CLAUDE.md auto-entra em cobertura (mata
o próprio drift de lista hardcoded). **Report-only** — firmware é human-gated.

```bash
# refs (wikilinks + code-paths .md) de um arquivo → paths vault-relativos
refs_of() {
  { grep -oE '\[\[[^]]+\]\]' "$1" | sed 's/\[\[//;s/\]\]//;s/|.*//;s/#.*//'
    grep -oE '`[0-9A-Za-z._/-]+\.md`' "$1" | tr -d '`'
  } | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
    | sed -E '/\.md$/!s/$/.md/' | sort -u
}

CLOSURE=$(mktemp); echo "CLAUDE.md" > "$CLOSURE"
FRONTIER="CLAUDE.md"
for depth in 1 2; do                     # profundidade 2
  NEXT=""
  for f in $FRONTIER; do
    [ -f "$f" ] && NEXT="$NEXT $(refs_of "$f")"
  done
  echo "$NEXT" | tr ' ' '\n' | grep -v '^$' >> "$CLOSURE"
  FRONTIER="$NEXT"
done
sort -u "$CLOSURE" -o "$CLOSURE"
echo "Fecho CLAUDE.md (prof. 2): $(wc -l < "$CLOSURE") arquivos"

# Por arquivo do fecho: existência + staleness >30d
NOW=$(date +%s)
while IFS= read -r f; do
  if [ ! -f "$f" ]; then
    if [[ "$f" != */* ]]; then
      # bare-name wikilink — resolver por find, NÃO confiar em 1º hit (IX.3)
      H=$(find . -name "$f" -not -path "*/08-ARCHIVE/*" | wc -l | tr -d ' ')
      # H=0 → wikilink de exemplo na prosa (ex.: [[link]], [[wikilinks]]), não ref real → drop
      [ "$H" -gt 1 ] && echo "AMBIG: $f ($H candidatos → check-resolvable)"
    else
      echo "DEAD-REF: $f (path canônico ausente)"
    fi
    continue
  fi
  AGE=$(( (NOW - $(stat -f %m "$f")) / 86400 ))
  [ "$AGE" -gt 30 ] && echo "STALE ${AGE}d: $f"
done < "$CLOSURE"
rm -f "$CLOSURE"
```

Dead-ref/ambíguos → rodar `check-resolvable` antes de reportar (IX.3 — distingue
quebrado real de capitalização/archive). Skill: [[04-SYSTEM/skills/core/check-resolvable]].

**Escalonamento (report-only):** itens do fecho com drift → bucket **"Firmware drift
(human-gated)"** em `## Action items`. NÃO editar CLAUDE.md / principles / errors /
AGENTS / Identity autonomamente — Autonomia "confirm before: CLAUDE.md edits" +
INVARIANT. F0.1 **sinaliza**; sessão Nexus+humano corrige.

**Guardrail:** FASE 0 = report only. Sem edições. F0.1 inclui firmware (CLAUDE.md +
fecho): drift vira action item human-gated, nunca edit autônomo (INVARIANT).

### F0.2 — External repos sweep [Haiku]  *(v8)*

**Objetivo:** saúde de backup dos repos de código que vivem **fora do vault** em git
próprio (`phant0um/*`). Esses não precisam de rotina dedicada — `git push` já é o backup
e a rotatividade é baixa. Mas working-tree sujo / commits não-pushados / remote morto
dão falsa sensação de backup. Sweep barato (sem clone, sem fetch). **Report-only** —
nunca commita/pusha repo externo aqui (push é outward, requer confirmação humana).

```bash
# Repos de código fora do vault (não confundir com backup do vault — esse é ~/.vault-git).
for r in ~/Dev/nexus-agent-system ~/Dev/fullstack-agent ~/Dev/projetos/claude-automations; do
  [ -d "$r/.git" ] || { echo "MISSING: $r (sem clone local)"; continue; }
  name=$(basename "$r")
  url=$(git -C "$r" remote get-url origin 2>/dev/null)
  dirty=$(git -C "$r" status --porcelain | wc -l | tr -d ' ')
  ahead=$(git -C "$r" rev-list --count @{u}..HEAD 2>/dev/null || echo "?")
  flag=""
  case "$url" in *mchlcs/*) flag="$flag ⚠️REMOTE-MORTO(mchlcs→push falha)";; esac
  [ "$dirty" -gt 0 ] && flag="$flag ⚠️${dirty}-dirty"
  { [ "$ahead" != "0" ] && [ "$ahead" != "?" ]; } && flag="$flag ⚠️${ahead}-unpushed"
  echo "$name: dirty=$dirty unpushed=$ahead${flag}"
done
# Os 3 repos têm fonte viva no vault (04-SYSTEM/agents/{nexus,fullstack}-agent-system,
# skills→claude-automations). Drift fonte↔repo é tratado em update manual, não aqui.
```

Qualquer `⚠️` → action item **[média]** no relatório: "commit/push `<repo>`" ou
"corrigir remote `<repo>`". Repo externo = human-gated p/ commit/push (não autônomo).

---

## FASE 1 — Wiki Lint [Sonnet]

Skill: `claude-obsidian:wiki-lint`
Agent: `review` (drift detection)

**Modelos:**
| Step | Modelo |
|------|--------|
| F1.1 Wiki lint | **Sonnet** |
| F1.4 Agent scan | **Haiku** |
| F1.5 Lessons | **Haiku** |
| F1.5b Frontmatter | **Haiku** |

### F1.1 Lint vault [Sonnet]

Após lint, rodar `check-resolvable` em links flagados como dead — distingue links realmente quebrados de paths com capitalização diferente antes de reportar.
Skill: [[04-SYSTEM/skills/core/check-resolvable]]

- Orphan pages (sem inbound links) — **filtrar sources por default** (são folhas da rede, ~99% orphan é esperado e ruído, L06). Sinal acionável = orphan **concepts/entities**.
- Dead wikilinks (target ausente)
- Stale claims (>30d, referenciados como "current")
- Frontmatter gaps (title/type/created/updated/tags)
- Empty sections (## headings sem conteúdo)
- Duplicate concepts (overlap semântico)

Report: counts + top 10 por categoria.

### F1.2 Manifest dedup sweep

```bash
cd ~/Obsidian/vault-michel
jq '.sources | to_entries | group_by(.value.hash) | map(select(length > 1)) | .[]' .raw/.manifest.json
jq '.sources | to_entries[] | select(.value.pages_created == null or .value.category == null) | .key' .raw/.manifest.json
```

Report dups + sugestões de merge. **NÃO alterar manifest.**

### F1.3 Hot cache trim

```bash
LINES=$(wc -l < 04-SYSTEM/wiki/hot.md | tr -d ' ')
echo "hot.md: $LINES linhas"
```

Se >300 linhas: arquivar entries >14d em `03-RESOURCES/log.md`. Manter últimos 14d.

### F1.4 Agent system scan [Haiku]

```bash
ls 04-SYSTEM/agents/ | grep -v "^_"
```

Verificar: `project-setup.md` presente, agentes sem frontmatter, dead wikilinks internos.

### F1.5 Lessons consolidation [Haiku]

```bash
wc -l < 06-GENERATED/tasks/lessons.md 2>/dev/null || echo "0"
```

Se >30 entries: agrupar similares, cap 30.
Output: `06-GENERATED/tasks/lessons.md`

### F1.5b Frontmatter vault scan [Haiku]

```bash
bash .claude/hooks/frontmatter-scan.sh --fix-report
```

Output: `06-GENERATED/audits/$(date -I)-frontmatter-audit.md`

### F1.6 Queue cleanup

```bash
find 07-QUEUE/.archive/ -maxdepth 1 -name "*.md" -mtime +30 | wc -l
```

Se >20 entries com >30d: deletar. Report count.

---

## FASE 2 — Connection Finder [Sonnet]

**Objetivo:** Surfar conexões não-óbvias entre vault recente e antigo.
Skill: `claude-obsidian:wiki-query`

### F2.1 Coletar sources recentes

```bash
cd ~/Obsidian/vault-michel
grep -rl "^ingested:" 03-RESOURCES/sources/ | while read f; do
  date=$(grep "^ingested:" "$f" | head -1 | sed 's/ingested: *//')
  if [[ "$date" > "$(date -d '7 days ago' -I 2>/dev/null || date -v-7d -I)" ]]; then
    echo "$f"
  fi
done > /tmp/recent_sources.txt
RECENT_COUNT=$(wc -l < /tmp/recent_sources.txt | tr -d ' ')
```

0 sources recentes → skip FASE 2, reportar no relatório final.

### F2.2 Pool vault antigo

```bash
# shuf não existe no macOS (L05) — função fallback portável (robusta em bash E zsh,
# evita word-split de "$RND"). gshuf > shuf > sort -R.
rnd() { if command -v gshuf >/dev/null; then gshuf; elif command -v shuf >/dev/null; then shuf; else sort -R; fi; }
find 03-RESOURCES/sources/ -name "*.md" | \
  grep -vF -f /tmp/recent_sources.txt | rnd | head -50 > /tmp/old_sources.txt
find 03-RESOURCES/concepts/ -name "*.md" | rnd | head -30 >> /tmp/old_sources.txt
```

### F2.3 Extrair temas [Haiku]

```bash
for f in $(cat /tmp/recent_sources.txt); do
  echo "=== $f ===" && grep -E "^(tags:|## Tese)" "$f" | head -4
done
```

### F2.4 Match e classificar conexões [Sonnet]

| Tipo | Critério |
|------|----------|
| **Cross-domain** | Áreas diferentes, insight compartilhado |
| **Contradição** | Mesma claim, conclusões opostas |
| **Padrão 3+** | 3+ sources convergem |
| **Pergunta-resposta** | Source antiga pergunta, recente responde |
| **Evolução** | Mesma ideia, versão refinada |

Só conexões não-óbvias. Max 10 por relatório.

### F2.5 Aplicar wikilinks

Alta confiança → wikilink bidirecional em `## Relações`.
Média confiança → sugerir no relatório, não editar.

### F2.6 Output [Sonnet]

`06-GENERATED/connections/$(date -I)-connections.md`

```markdown
---
title: "Conexões Semanais — YYYY-MM-DD"
type: report
connections_found: N
sources_scanned: N
generated_by: claude-code
created: YYYY-MM-DD
---
```

---

## FASE 2.7 — Contradiction Sweep (se conexões encontraram >2 contradições)

Skill: [[04-SYSTEM/skills/core/contradiction-sweep]] — reconciliar automaticamente contradições temporais/factuais; flag metodológicas para decisão humana.

---

## FASE 3 — Meta-Coaching [Haiku + Sonnet]

**Objetivo:** Auditar atividade da semana. Surfar padrões de comportamento de alto impacto.

### F3.1 Coletar atividade [Haiku]

```bash
# Commits da semana
git log --since="7 days ago" --name-only --pretty=format:"%ad | %s" --date=short

# Volume por área
git log --since="7 days ago" --name-only --pretty=format:"" | \
  grep -oE "^[^/]+" | sort | uniq -c | sort -rn
```

### F3.2 Ler baseline

```bash
ls 06-GENERATED/meta-coaching/ 2>/dev/null | sort | tail -1
```

Se existir: ler relatório anterior para comparação.

### F3.3 Cluster por intent [Haiku]

Grupos: `ingest` / `agent` / `rotina` / `fix` / `fiap` / `concurso` / `other`.
Para cada: count commits, arquivos únicos, scope estimado.

### F3.4 Identificar 3-5 waste patterns [Sonnet]

Ranked por (frequência × impacto). Para cada:
- Nome do padrão (uma linha)
- Evidência: 2-3 commits concretos
- Causa raiz hipotética
- Custo estimado

**Se waste pattern é bug comportacional recorrente** (agente produzindo output errado repetidamente): disparar `@diagnose` com o padrão como input. Skill: [[04-SYSTEM/skills/reasoning/diagnose]] — ETAPA 0 constrói tight loop que vai red no bug antes de hipotesise.

**Se waste pattern revela decisão arquitetural não-documentada**: rodar `grill-me` com Doc Capture para extrair ADR inline. Skill: [[04-SYSTEM/skills/foundational/grill-me]] — durante grilling, capturar termo/decisão em `decisions.md` se passar nos 3 critérios (hard to reverse + surprising + real trade-off).

### F3.5 Surface surprises [Sonnet]

Padrões não óbvios. NÃO fabricar para bater quota.

### F3.6 Top 2 fixes [Sonnet]

Para top 2 padrões: UMA ação concreta cada.
- Mudança específica (tool/situação/threshold)
- Métrica de verificação semana seguinte
- Custo de não fazer nada

Output: `06-GENERATED/meta-coaching/$(date -I)-meta-coaching.md`

### F3.7 Evolve — capturar padrões da semana [Sonnet]

Skill: [[04-SYSTEM/skills/core/evolve]] — ao fim da análise meta-coaching, extrair padrões que funcionaram e cristalizar como skills reutilizáveis.

### F3.8 Meta-Learn — extrair princípios de correções [Sonnet]

Se F3.4 (waste patterns) revelar correções recorrentes (mesmo tipo de erro ≥2× com padrão): rodar `meta-learn`.
Skill: [[04-SYSTEM/skills/core/meta-learn]] — extrai princípio durável, não regra frágil.

### F3.9 Pre-Mortem — antes de mudanças arquiteturais da semana seguinte [Sonnet]

Se relatório contiver ação de alto custo (restructuring, agente novo, mudança de routing): rodar `/pre-mortem` antes de executar.
Skill: [[04-SYSTEM/skills/reasoning/pre-mortem]]

### F3.10 Errors.md scan — fechar loop de autoaprendizado [Haiku + Sonnet]

**Objetivo:** Fechar o loop errors.md → classificação → ação. Sem esta fase, erros
são logados mas nunca consumidos automaticamente.

**Passo 1 — Detectar entradas novas `[Haiku]`**

```bash
cd ~/Obsidian/vault-michel
# Entradas de errors.md dos últimos 7 dias (por data no header ## YYYY-MM-DD)
awk '/^## 2026-/{d=$0} /^## /{if(d ~ /'"$(date -v-7d +%Y-%m-%d)"'/ || d ~ /'"$(date -v-6d +%Y-%m-%d)"'/ || d ~ /'"$(date -v-5d +%Y-%m-%d)"'/ || d ~ /'"$(date -v-4d +%Y-%m-%d)"'/ || d ~ /'"$(date -v-3d +%Y-%m-%d)"'/ || d ~ /'"$(date -v-2d +%Y-%m-%d)"'/ || d ~ /'"$(date -v-1d +%Y-%m-%d)"'/ || d ~ /'"$(date +%Y-%m-%d)"'/) print "NEW: " d}' 04-SYSTEM/wiki/errors.md 2>/dev/null

# Simpler: pega últimas 3 entradas (## headers)
grep -n "^## " 04-SYSTEM/wiki/errors.md | tail -3
```

**Passo 2 — Classificar `[Sonnet]`**

Para cada entrada nova em errors.md:
- **Padrão** (mesmo tipo de erro ≥2×): disparar `/meta-learn` para extrair princípio
- **Recorrente** (erro já extraído como princípio mas volta): flag para `@hill <slug>` — enforcement problem, não princípio novo
- **Pontual** (erro isolado sem padrão): registrar no relatório, nenhuma ação

**Passo 3 — Output**

```markdown
### Errors.md scan
- Entradas novas: N
- Padrões detectados: [lista com ≥2 ocorrências] → /meta-learn
- Recorrentes (enforcement): [lista] → @hill
- Pontuais: [lista] → log only
```

```markdown
---
title: "Meta-Coaching — YYYY-MM-DD"
type: report
period: YYYY-WNN
commits_analyzed: N
generated_by: claude-code
created: YYYY-MM-DD
---
```

---

## Relatório consolidado

Output: `06-GENERATED/revisao-semanal/$(date -I)-revisao-semanal.md`

```markdown
---
title: "Revisão Semanal — YYYY-MM-DD"
type: report
generated_by: claude-code
created: YYYY-MM-DD
---

## System Review
- Stale (>30d): [lista]
- Drift detectado: [descrever]
- Vault Health: concepts+entities 7d=N | queue=N | rotinas ativas=N [alertas se queue>5 ou concepts=0]
- Ref-graph CLAUDE.md: N no fecho | stale=N | dead-ref=N | ambíguos=N
- Repos externos (phant0um/*): [lista repo: dirty/unpushed/⚠️ ou "todos limpos"]
- Action items: [lista]

## Lint
- orphans=N, dead=N, stale=N, frontmatter-gaps=N, dup-concepts=N
- Manifest dups: N | Hot cache: N→N linhas
- Agents: sem frontmatter=N | Lessons: N→N | Queue: N limpos

## Conexões
- Sources recentes: N | Pool: N
- Conexões: N (cross-domain=N, contradições=N, padrões-3+=N)
- Wikilinks adicionados: N

## Meta-Coaching
- Commits analisados: N
- Top waste pattern: [nome]
- Top fixes: [1-2 linhas]

## Action items (prioridade)
- [alta] ...
- [média] ...

### Firmware drift (human-gated)
- [ ] <arquivo stale/dead do fecho CLAUDE.md> — requer sessão Nexus (não autônomo)
```

---

## Self-improvement log `[bash]`

```bash
mkdir -p 06-GENERATED/tasks
echo "- $(date -I): [revisao-semanal] stale=$STALE_COUNT drift=$DRIFT_COUNT orphans=$ORPHAN_COUNT connections=$CONN_COUNT waste_top=$TOP_WASTE" >> 06-GENERATED/tasks/lessons.md
```

---

## NEXUS GATE — Fim [Sonnet]

`@nexus revisar $(date -I)-revisao-semanal` — extrai top 3 actions, prioriza.

```bash
{
  echo ""
  echo "## Revisão Semanal $(date -I)"
  echo "**System:** stale=$N drift=$N"
  echo "**Lint:** orphans=$N dead=$N dups=$N"
  echo "**Conexões:** $N encontradas, $N wikilinks adicionados"
  echo "**Meta-coaching:** top waste: <padrão>"
  echo "→ [[06-GENERATED/revisao-semanal/$(date -I)-revisao-semanal]]"
} >> 04-SYSTEM/wiki/hot.md
```

### Commit gate (obrigatório)

Mesma regra de `pipeline-semanal` — F1/F2 podem editar agentes/concepts/wikilinks; sem commit, esse trabalho some na próxima auditoria de git log (achado WP2 desta própria revisão, 2026-06-07).

```bash
cd ~/Obsidian/vault-michel
CHANGED=$(git status --short -- 04-SYSTEM/agents 04-SYSTEM/skills 04-SYSTEM/wiki/hot.md | wc -l | tr -d ' ')
if [ "$CHANGED" -gt 3 ]; then
  git add 04-SYSTEM/agents 04-SYSTEM/skills 04-SYSTEM/wiki/hot.md
  git commit -m "revisão-semanal $(date -I) — lint+conexões+meta-coaching, $CHANGED arquivos"
  echo "✅ commit $(git rev-parse --short HEAD)"
else
  echo "→ $CHANGED arquivo(s), abaixo do threshold — sem commit"
fi
```

---

## Cost budget

| Fase | Step | Tokens |
|------|------|--------|
| F0 | System review | ~300 |
| F1 | Wiki lint | ~500 |
| F1 | Agent scan | ~200 |
| F2 | Connection finder | ~800–1200 |
| F3 | Meta-coaching | ~400–600 |
| — | Nexus gates (2×) | ~150 |
| **Total** | | **~2350–2950** |

---

## Guardrails

- F0, F1: report only (exceção: hot cache trim, queue cleanup, lessons cap)
- F2: wikilinks só com confiança alta
- F3: fixes nomeiam tool/situação/threshold — sem conselho vago
- Nexus gates obrigatórios: início e fim. Se bloquear → parar.
- Se 0 sources recentes: F2 skip
- Não inventar conexões — se <3 reais, reportar <3
- Todos outputs → `06-GENERATED/`

---

## Changelog

- v8 (2026-06-28): FASE 0 ganha **F0.2 External repos sweep** — saúde de backup dos repos de código fora do vault (`phant0um/nexus-agent-system`, `phant0um/claude-automations`; `fullstack-agent` remote-only). Sweep barato report-only (sem clone/fetch): flag dirty / unpushed / remote morto (`mchlcs` — owner inexistente, push falha silencioso). Não cria rotina dedicada — baixa rotatividade, `git push` já é backup; só dobra no semanal. Achado 2026-06-28: 2 clones com remote `mchlcs/` morto + 9 arquivos uncommitted em claude-automations.
- v7 (2026-06-20): FASE 0 ganha **scan de staleness de `04-SYSTEM/wiki/*.md` por frontmatter `updated:`** (não mtime). Fecha buraco: 6 governance files (memory/conventions/skill-memory/vault-graph/vault-structure-map/golden-cases) ficavam invisíveis — fora do seed hardcoded E do fecho CLAUDE.md (0 seeds linkam), e o check por mtime os via fresh porque checkout/sync reseta mtime (staleness real, 38d/37d, vive no frontmatter). Bullet staleness migrado mtime→`updated:`. Flag `NO-UPDATED` p/ arquivos sem o campo.
- v6 (2026-06-20): naming — 4 outputs invertidos p/ prefixo de data (`$(date -I)-frontmatter-audit`, `$(date -I)-connections`, `$(date -I)-meta-coaching`, `$(date -I)-revisao-semanal`). Wikilink hot.md + ref `@nexus revisar` atualizados. Relatórios já criados mantidos. `lessons.md` (cumulativo, sem data) intocado.
- v5 (2026-06-20): FASE 0 ganha **F0.1 ref-graph walk** — fecho transitivo de CLAUDE.md (prof. 2) substitui cobertura hardcoded por descoberta dinâmica. Mata drift de lista fixa (ref nova auto-coberta). Report-only; firmware human-gated. Aplica IX.3 (check-resolvable, exclui 08-ARCHIVE). Fecha lacuna detectada no ciclo de revisão CLAUDE.md 2º-nível (operations.md 2026-06-20).
- v4 (2026-06-20): absorveu o **Vault Health snapshot** de `metricas-ingest` (retirada por redundância — ~80% dela já estava aqui: orphans=F1.1, hot-health=F1.3, volume=F3.1). FASE 0 ganha concepts/entities-7d + queue depth; relatório consolidado ganha linha Vault Health no System Review. Fusão A (16→15 rotinas).
- v3 (2026-06-19): aplicados aprendizados do vault. F2.2 `shuf`→fallback portável `gshuf||shuf||sort -R` (L05 — shuf ausente no macOS degradava pool do Connection Finder em silêncio). F0/F1.1 check de frontmatter de agente corrigido para convenção real `name/role/model` (L04, não `title/trigger`). F1.1 orphan scan filtra sources por default (folhas, L06) — sinal = orphan concepts/entities.
- v2 (2026-06-07): + Commit gate obrigatório no NEXUS GATE Fim (achado WP2 — 18 arquivos/+346 linhas ficaram 7 dias sem commit, risco perda de trabalho).
- v1 (2026-05-31): criado. Merge de `manutencao-semanal` (v1) + `meta-coaching-semanal` (v4). Nova FASE 0: system review de docs estruturais (CLAUDE.md, AGENTS.md, vault-identity, 03-RESOURCES/*.md, 04-SYSTEM/). Todos outputs → `06-GENERATED/`. `tasks/lessons.md` → `06-GENERATED/lessons.md`. Schedule: domingo 4h. Nexus gates início e fim.
