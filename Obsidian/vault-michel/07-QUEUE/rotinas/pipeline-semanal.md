---
title: Pipeline Semanal — Triagem → Ingest → Relatório + Meta-padrões
type: rotina
schedule: "domingo 22h"
last_improved: 2026-06-28
version: 5.3
tags: [rotina, pipeline, ingest, triagem, relatório, token-economy, weekly]
---

# Pipeline Semanal

Pipeline unificado semanal. Substitui: pipeline-diario (v4.4) + weekly-synthesis.
Batch semanal = volume maior = clusters mais ricos + meta-padrões entre dias.

**Princípio**: Bash > AI. Batch > loop. Append > rewrite. **Preservar informação > condensar.**
Batch semanal economiza 3 gates Sonnet × 6 dias = ~2.100 tokens/semana em runs vazios.

**Complementar**: [[07-QUEUE/rotinas/daily-scan]] (diário 16h, bash-only) detecta
duplicatas cedo e flaga se volume > threshold. [[07-QUEUE/rotinas/srs-sources]]
(diário 09h) faz spaced repetition de Score A sources — ambos bash/light, não
afetam este pipeline.

**Referências vault:**
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[04-SYSTEM/agents/nexus]]
- [[04-SYSTEM/agents/nexus-agent-system/model-router]]

---

## NEXUS GATE — Início `[Claude Sonnet]`

```bash
tail -30 04-SYSTEM/wiki/hot.md

# FIAP/concurso absence check
_fc=$(git log --since="7 days ago" --name-only --pretty=format:"" | grep -cE "(fiap|concurso|legisla)" 2>/dev/null || echo 0)
if [[ "$_fc" -eq 0 ]]; then
  if ! grep -q "FIAP/concurso: 0 commits em 7d" 04-SYSTEM/wiki/hot.md; then
    echo "⚠️ FIAP/concurso: 0 commits em 7d — considerar priorização de estudo" >> 04-SYSTEM/wiki/hot.md
  fi
  echo "[pipeline-semanal] AVISO: FIAP/concurso ausente há 7+ dias"
fi
```

Notificar: `@nexus pipeline-semanal iniciando — $(date -I)`

Nexus lê hot.md + verifica anomalias recentes. Autoriza ou bloqueia pipeline.

Se bloqueado → parar. Reportar motivo. Aguardar instrução.

---

## F1.0 Pre-dedup `[bash]`

Detectar duplicatas antes de qualquer scoring — evita gastar tokens
em arquivo já ingestado ou quasi-duplicado.
Skill: [[04-SYSTEM/skills/foundational/pre-ingest-dedup]]

```bash
cd ~/Obsidian/vault-michel

# Quasi-duplicatas por basename similarity
ls Clippings/ .raw/articles/ 2>/dev/null | sort | uniq -d | head -20
# Mesmo stem, extensão diferente (.md vs .pdf)
find .raw/ Clippings/ -type f | sed 's/\.[^.]*$//' | sort | uniq -d
```

Se duplicata detectada: manter versão mais recente, mover outra para `08-ARCHIVE/D/`.

## F1.0b Scan candidatos `[bash]`

```bash
find .raw/articles/ .raw/fiap/ .raw/ebooks/ .raw/images/ Clippings/ \
  -maxdepth 2 \( -name "*.md" -o -name "*.pdf" \) 2>/dev/null | sort > 06-GENERATED/tasks/candidates_all.txt

# normaliza apóstrofo/aspas curvas → retas — evita falso "novo" por mismatch unicode (bug 2026-06-06).
norm() { python3 -c "import sys;d=sys.stdin.read();print(d.replace('’',chr(39)).replace('‘',chr(39)).replace('“',chr(34)).replace('”',chr(34)),end='')"; }
norm < .raw/.manifest.json > 06-GENERATED/tasks/manifest_norm.json

# slug normalizado: lowercase, remove tudo exceto alnum, colapsa hífens
slug() { python3 -c "import sys,re;d=sys.stdin.read().strip();d=re.sub(r'[^a-z0-9]','-',d.lower());d=re.sub(r'-+','-',d).strip('-');print(d,end='')"; }

while IFS= read -r f; do
  fn=$(echo "$f" | norm)
  bn=$(basename "$f" | norm)
  stem="${bn%.*}"
  slug_stem=$(echo "$stem" | slug)
  # checa caminho completo (chave manifest = "Clippings/x.md") E basename solto
  grep -qF "\"$fn\""       06-GENERATED/tasks/manifest_norm.json 2>/dev/null || \
  grep -qF "/$bn\""        06-GENERATED/tasks/manifest_norm.json 2>/dev/null || \
  grep -qF "\"$bn\""       06-GENERATED/tasks/manifest_norm.json 2>/dev/null || \
  grep -qF "/$stem.md\""   06-GENERATED/tasks/manifest_norm.json 2>/dev/null || \
  grep -qF "\"$stem.md\""  06-GENERATED/tasks/manifest_norm.json 2>/dev/null || \
  grep -qF "/$stem.pdf\""  06-GENERATED/tasks/manifest_norm.json 2>/dev/null || \
  grep -qF "\"$stem.pdf\"" 06-GENERATED/tasks/manifest_norm.json 2>/dev/null || \
  grep -qF "$slug_stem"    06-GENERATED/tasks/manifest_norm.json 2>/dev/null || echo "$f"
done < 06-GENERATED/tasks/candidates_all.txt > 06-GENERATED/tasks/candidates_new.txt

NEW_COUNT=$(wc -l < 06-GENERATED/tasks/candidates_new.txt | tr -d ' ')
echo "Candidatos novos: $NEW_COUNT"
```

0 candidatos → gerar brief vazio em `06-GENERATED/triagem/$(date -I)-triagem.md` e parar. **Cost: 0.**

---

## FASE 1 — Triagem `[triagem-agent / heurística bash + Haiku batch]`

Disparar:

```
@triagem-agent — $NEW_COUNT candidatos em 06-GENERATED/tasks/candidates_new.txt
```

Agente: [[04-SYSTEM/agents/nexus-agent-system/triagem-agent]]

Faz: scoring A–D, move C/D para `08-ARCHIVE/[C|D]/`, gera
`06-GENERATED/triagem/$(date -I)-triagem.md`, gera `06-GENERATED/tasks/candidates_aprovados.txt`,
chama `@ingest-agent`.

**Gate opcional `[Sonnet]`**: se triagem flagar confidence < 0.6 em algum item,
Nexus revisa só esses itens antes de seguir.

### F1.1 Grade Assignment Verification `[bash, 0 tokens]`

Após triagem, verificar que todos os arquivos aprovados têm `grade:` no frontmatter:

```bash
# Count approved files without grade
NO_GRADE=$(grep -rL "^grade:" 03-RESOURCES/sources/ --include="*.md" | wc -l)
if [[ "$NO_GRADE" -gt 0 ]]; then
  echo "[F1.1] $NO_GRADE files without grade — running batch_enrich"
  python3 04-SYSTEM/scripts/batch_enrich.py --assign-grades
fi
```

**Princípio**: 67.6% do vault estava sem grade (1685/2491) porque não havia
verificação pós-triagem. Programático em ~3s. Target: 0 files sem grade após F1.1.

---

## FASE 2 — Ingest `[ingest-agent / claude-sonnet-4-6]`

Disparado automaticamente pelo `triagem-agent` ao final da Fase 1.

Agente: [[04-SYSTEM/agents/nexus-agent-system/ingest-agent]]

Faz: classifica (`articles`/`ai-agents`/`concurso`/`fiap`), gera source pages
(templates F2.3a/F2.3b — preservar, não condensar; fiap/concurso →
`02-AREAS/<area>/sources/`, demais → `03-RESOURCES/sources/`), complementa concepts/entities,
**F2.5 Concept Absorption** (atualiza concepts existentes com nova evidência),
**F2.9 Personal Reflection** (Score A: seção "Minha Síntese"),
detecta skills/agents/hooks recorrentes, atualiza `.raw/.manifest.json` (jq atômico,
key com e sem extensão — dedup-gap fix), move A/B para `08-ARCHIVE/[A|B]/`, chama `@report-agent`.

Se >20 arquivos: dispatch `claude-obsidian:wiki-ingest` paralelo (1 por fonte) +
adversarial gate v1 in-flight ([[04-SYSTEM/skills/orchestration/adversarial-gate]]).
Ao final do batch, F2.10 roda adversarial gate v2 (pós-batch).

### F2.10 Batch Quality Gate `[Sonnet]` — adversarial-gate-v2

Skill: [[04-SYSTEM/skills/orchestration/adversarial-gate-v2]]

Ativa automaticamente quando batch de ingest >20 source pages conclui FASE 2.
Dispara subagente adversarial com contexto isolado que valida qualidade agregada do batch:

1. **Link integrity**: wikilinks quebrados em source pages recém-criadas
2. **Categorização**: fonte classificada na categoria errada (articles vs ai-agents vs concurso vs fiap)
3. **Placeholder detection**: stubs com `<placeholder>` ou seções vazias
4. **Concept absorption completeness**: concepts linkados mas sem evidência appended (F2.5)
5. **Beautiful nonsense**: batches que parecem completos mas têm defeitos sistêmicos invisíveis source-a-source

Resultado → `PIPELINE OK` (batch aprovado) ou `PIPELINE FAIL` (reportar issues sistêmicos).
Se FAIL: logar issues em hot.md, não bloquear FASE 3 — report-agent pode ainda gerar relatório
com caveats. Issues críticos (>30% do batch com defeito) → abortar FASE 3, flag para Nexus.

**Diferença de v1**: v1 valida tarefa-a-tarefa durante execução. v2 valida o batch inteiro
após ingest — detecta problemas sistêmicos que per-file não vê.

### F2.11 Batch Enrichment `[bash]`

Skill: `references/batch-enrichment-pipeline.md` · Script: `scripts/batch_enrich.py`

Após F2.10, roda enrichment programático (zero AI calls) nas source pages criadas:

1. **Grade assignment**: files sem `grade:` → assignar por triagem_score/tags/heurística
2. **Bold Tese fix**: `**Tese central**:` → `## Tese Central` (heading)
3. **Tese generation**: files sem Tese Central → gerar do primeiro parágrafo
4. **Resumo generation**: files sem Resumo → gerar da Tese Central (3 sentences)
5. **Links generation**: files sem concept/entity wikilinks → tag-to-concept matching
6. **Orphan resolution**: files com 0 backlinks → connection via tag/entity/category/directory

```bash
python3 04-SYSTEM/skills/core/scripts/batch_enrich.py --all
python3 04-SYSTEM/skills/core/scripts/resolve_orphans.py
```

**Princípio**: structural debt eliminada programaticamente antes do AI spot-check.
F2.8 Nexus foca em qualidade de conteúdo, não em seções faltando.

**Performance**: ~6s para 2491 files (vs 600s+ para 441 files via subagent).

### F2.9b Subagent Batch-Sizing Guard `[bash, 0 tokens]`

Antes de dispatchar subagents para F2.9 Minha Síntese:

```bash
# Count Score A files needing Minha Síntese
NEED_SINTESE=$(grep -rL "## Minha Síntese" 03-RESOURCES/sources/ --include="*.md" | xargs grep -l "grade: A" 2>/dev/null | wc -l)

if [[ "$NEED_SINTESE" -gt 80 ]]; then
  echo "[F2.9b] $NEED_SINTESE files — split into batches ≤50"
  # Split and dispatch in waves
elif [[ "$NEED_SINTESE" -gt 50 ]]; then
  echo "[F2.9b] $NEED_SINTESE files — 2 subagents of ~25 each"
else
  echo "[F2.9b] $NEED_SINTESE files — 1 subagent OK"
fi
```

**Validated thresholds**: ≤45 = safe (~310s) · 87+ = timeout (600s) · 147 = timeout (60% done).
Ver `[[04-SYSTEM/skills/orchestration/references/subagent-batch-sizing]]` para heuristics completas.
**Post-dispatch**: sempre re-contar placeholders restantes — subagents podem completar silenciosamente.

### F2.8 Nexus spot-check `[Sonnet]`

`@nexus revisar ingest $(date -I)` — spot-check 3 source pages criadas:
- Tese central faz sentido?
- Informação preservada (não condensada artificialmente)?
- Links resolvem?

Nexus aprova → segue. Nexus rejeita → reportar issue, aguardar instrução.
(Em paralelo, `report-agent` F3.5 já faz spot-check autônomo —
este gate Sonnet é segunda camada, sample size 3.)

---

## FASE 3 — Relatório `[report-agent / claude-sonnet-4-6]`

Disparado automaticamente pelo `ingest-agent` ao final da Fase 2.

Agente: [[04-SYSTEM/agents/nexus-agent-system/report-agent]]

Faz: F3.1 análise por cluster, F3.2 cross-connections, F3.3 vault impact,
**F3.4 Contradiction Register** (append em `_contradiction-register.md` + stale check),
**F3.4b Vault Impact → Kanban** (itens "alta" → `07-QUEUE/kanban/vault-impact-kanban.md`),
F3.5 spot-check autônomo + veredito (`PIPELINE OK`/`PIPELINE FAIL`),
**F3.6 Meta-padrões semanais** (consolida ingest-diarios da semana — ver abaixo),
**F3.7 Connection Density Metrics** (orphan rate, backlinks, concept coverage — bash only),
append `04-SYSTEM/wiki/hot.md`, chama `@ledger` (commit gate + session log).

sources_this_week < 2 → skip F3.1/F3.2 (clusters/cross-connections), hot.md mínimo
(F3.0). 0 sources na semana → skip relatório inteiro, hot.md só com triagem+ingest. **Cost: 0.**

### F3.6 Meta-padrões semanais `[Sonnet]`

**Absorvido de weekly-synthesis (v1).** Como pipeline é semanal, F3.6 é nativo —
não há rotina separada.

AI call com F3.1 clusters + F3.2 cross-connections do run atual (que já contém
todas as sources da semana acumulada). Identifica:

1. **Meta-padrões**: temas que apareceram em 3+ sources com ângulos diferentes
   (não repetições — evolução do conceito)
2. **Convergências**: 2+ sources que concordam (citação dupla obrigatória)
3. **Contradições persistentes**: contradições que persistem entre clusters
4. **Gaps acumulados**: tópicos que apareceram mas não foram aprofundados
5. **Top 3 insights da semana**: o que mudou no vault que não era óbvio source-a-source

Output integrado ao relatório semanal (não arquivo separado):

```markdown
## F3.6 Meta-padrões semanais

| Padrão | Sources | Evolução |
|--------|---------|----------|
| <tema> | A, B, C | <como evoluiu> |

### Top 3 insights da semana
1. <insight não-óbvio que emergiu só vendo a semana inteira>
2. ...
3. ...
```

### F3.5 Nexus final review `[Sonnet]`

`@nexus revisar $(date -I)-relatorio-semanal` — Nexus lê veredito do report-agent.
`PIPELINE FAIL` → investigar motivo, não marcar rotina como concluída.
`PIPELINE OK` → extrair top action, encerrar.

---

## Commit gate

Executado por `@ledger` dentro do `report-agent` (F3.5). Threshold: >3 arquivos
rastreados em agents/skills/hot.md → commit automático
(achado meta-coaching 2026-06-07: 18 arquivos / +346 linhas ficaram 7 dias sem commit).

Se `@ledger` falhar (hook/conflito): reportar `⚠️ commit pendente — <motivo>` no
hot.md, não bloquear o resto da rotina.

### F3.3 Squash Guardrail

F3.3 Vault Impact closures devem ser squashadas em 1 commit por ciclo, não commits fragmentados (meta-coaching 2026-06-28: 5 commits em 1 dia para mesmo item = waste pattern recorrente).

---

## Passos extras (wiring skills novas)

### Rodar `repo-radar` sobre repos novos da semana

Rodar skill `repo-radar` sobre repos novos da semana (este loop de análise
de repos = o caso de uso dela). Liga a T31.

### Cobrar decisões `tooling-eval` pendentes

Listar notas `type: tooling-eval` em `04-SYSTEM/wiki/` com checklist de decisão
humana NÃO marcado; cobrar decisão (adotar/descartar). Evita pilha de candidatas
órfãs (cc-switch, OpenBB, cognee, timesfm, gstack, opendraft…).

---

## Cost budget

| Fase | Step | Modelo | Tokens Claude |
|------|------|--------|----------------|
| — | F1.0/F1.0b dedup+scan | bash | 0 |
| — | NEXUS GATE início | Sonnet | ~100 |
| F1 | heurística bash (≥60% dos candidatos, score 0-3/7-10) | — | 0 |
| F1 | borderline scoring (score 4-6, 1 batch) | Haiku | ~32×N_t |
| F2 | ingest-agent (source pages + manifest + F2.5 absorption + F2.9 reflection) | Sonnet | 250×N_a + 500×N_f + 100×N_A |
| F2.10 | adversarial-gate-v2 (batch >20 files, pós-ingest) | Sonnet | ~300 (só se >20) |
| F2.11 | batch enrichment (grade/tese/resumo/links/orphans) | bash | 0 |
| F2.8 | Nexus spot-check (3 amostras) | Sonnet | ~150 |
| F3 | report-agent (clusters + cross-conn + vault impact + F3.4 + F3.4b + F3.6 + F3.5 + F3.7) | Sonnet/Haiku | inclui na verificação |
| F3.5 | Nexus final review | Sonnet | ~100 |
| — | ledger (commit + session log) | Haiku | 0–50 |

**Total Claude estimado**: `~32×N_t + 250×N_a + 500×N_f + 100×N_A + ~1450-1850 fixed`
onde N_A = número de Score A sources (F2.9 reflection cost). Se batch >20, +~300 (F2.10 adversarial-gate-v2).

**Economia vs v4.4 diário**: 6 runs vazios/semana × ~350 tokens (3 gates Sonnet)
= ~2.100 tokens/semana economizados em runs que produziam 0 sources.

---

## Self-improvement log `[bash]`

```bash
mkdir -p 06-GENERATED/tasks
echo "- $(date -I): [pipeline-semanal] $NEW_COUNT candidatos, $(wc -l < 06-GENERATED/tasks/candidates_new.txt 2>/dev/null || echo 0) aprovados, $VERDICT" >> 06-GENERATED/tasks/lessons.md
```

---

## Guardrails

- **Source pages**: profundidade > brevidade — preservar informação relevante sem condensar
- Single Read por arquivo (5000 chars artigos / 8000 chars FIAP após filtragem)
- Zero stubs — linkar concepts/entities existentes
- Nexus gates obrigatórios: início (Sonnet), F2.8 spot-check (Sonnet), F3.5 final (Sonnet)
- Se Nexus bloquear: parar pipeline, não pular gate
- Erros: log + continue batch
- FIAP: criar entity de fase se não existir
- Se >20 arquivos: dispatch wiki-ingest agents paralelo + F2.10 adversarial-gate-v2 (pós-batch)
- Confidence < 0.6 (triagem): escalar para Nexus/Sonnet conforme [[04-SYSTEM/agents/nexus-agent-system/model-router]]
- Borderline scoring (F1, score 4-6): SEMPRE 1 chamada batch, nunca loop per-file
- Triagem § "Sugestões/Melhorias": caveman ultra (flags 1-linha) — versão
  canônica fica em F3.2/F3.3
- Nunca injetar data/timestamp ao vivo na prosa de agent-spec/CLAUDE.md (cache-killer)
- **Retry cap**: máx 3 retries por chamada AI, 10 por fase. Estourou → abortar
  fase, logar `⚠️ retry-cap <fase> <motivo>` em hot.md, seguir próxima fase
  (não travar pipeline). Previne spike em API outage/prompt ruim.
- **F2.5 Concept Absorption**: append-only em concepts existentes — nunca
  reescrever, só agregar evidência. 1 linha por source.
- **F2.9 Personal Reflection**: só Score A, só artigos/ai-agents, máx 3 por run.
  **Cap global em dispatches paralelos**: o cap de 3 é do run inteiro, não por
  batch/subagente. Antes de cada dispatch paralelo, o orquestrador deve passar
  o contador atual de reflections já geradas como contexto, e cada subagente
  deve checar `if remaining_reflections > 0` antes de gerar nova reflection.
  Subagente que recebe `remaining_reflections = 0` pula F2.9 silenciosamente.
  Não inventar ação se não há uma clara.
- **F3.4 Contradiction Register**: append-only. Stale > 14 dias → flag para Nexus.
- **F3.4b Vault Impact → Kanban**: dedup obrigatório. Auto-resolve se skill/agent
  criado. Stale > 30 dias pendente → flag para Nexus.
- **F3.6 Meta-padrões semanais**: mínimo 3 sources para identificar padrão. Sem
  inventar convergência com <2 sources concordando.
- **F3.7 Connection Density Metrics**: bash only, zero AI cost. Orphan rate
  >30% → flag para Nexus acionar connection-finder.
- **F3.7 Performance pitfall (2026-06-23):** O script F3.7 original usa
  `grep -rl` recursivo no vault inteiro para contar backlinks por source page.
  Com 402+ source pages, cada grep faz scan completo do vault → O(N*M)
  onde N=sources, M=arquivos vault. Timeout em 120s. **Fix**: usar Python com
  índice em memória (dict de slugs → backlink count) construído em 1 pass.
  Alternativa: contar apenas sources novas do batch (não todas as 402+).
  Orphan rate para batch fresco é sempre ~100% — só é significativo após
  connection-finder rodar. Considerar mover F3.7 para rotina separada
  (ex: vault-hot-sweep) ao invés de bloquear o pipeline.
- **Rotinas complementares**: [[07-QUEUE/rotinas/daily-scan]] (diário 16h, bash)
  e [[07-QUEUE/rotinas/srs-sources]] (diário 09h, SRS) — não afetam este pipeline.

---

## Changelog

- v5.2 (2026-06-24): Integrada skill órfã `adversarial-gate-v2` (pós-batch quality gate).
  F2.10 Batch Quality Gate adicionado após FASE 2 — auto-ativa quando batch >20 source pages.
  Valida: link integrity, categorização, placeholders, concept absorption completeness, beautiful nonsense.
  Diferença de v1: v1 = in-flight tarefa-a-tarefa, v2 = pós-batch agregado. v1 mantida na FASE 2
  para dispatches paralelos. Cost budget: +~300 tokens (só se >20 files). Registrada em AGENTS.md
  e moc-skills.md. Resolve órfã detectada em skill audit 2026-06-24.
- v5.1 (2026-06-20): naming — triagem invertida p/ `06-GENERATED/triagem/YYYY-MM-DD-triagem.md` (prefixo de data). Triagens já criadas mantidas. Só cosmético; lógica do pipeline intocada.
- v5.0 (2026-06-18): Pipeline diário → semanal. Schedule domingo 22h. Merge
  completo de weekly-synthesis (F3.6 meta-padrões agora é fase nativa do
  report-agent, não rotina separada). Economia: ~2.100 tokens/semana em runs
  vazios que não happen mais 6x/semana. F1.0/F1.0b dedup+scan movidos para
  [[07-QUEUE/rotinas/daily-scan]] (bash-only, diário 16h) — este pipeline
  consome `06-GENERATED/tasks/candidates_new.txt` acumulado. SRS-sources (diário 09h)
  mantido como rotina complementar independente. Rename: pipeline-diario.md
  → pipeline-semanal.md.weekly-synthesis.md → deletado (absorvido).
- v4.4 (2026-06-18): 8 melhorias para maximizar extração de conhecimento das
  ingests. **F2.5 Concept Absorption** — concepts deixam de ser write-once:
  cada source page appenda evidência nos concepts linkados (append-only,
  seção `## Evidências`). **F2.9 Personal Reflection** — Score A sources
  ganham seção "Minha Síntese" (o que muda, conexão pessoal, próximo passo).
  **Dedup-gap fix** — manifest agora registra key com e sem extensão (alias_of),
  alinhando com F1.0b grep. Fixes triagem-2026-06-17 (19/19 falsos positivos).
  **F3.4 Contradiction Register** — contradições acumulam cumulativamente em
  `03-RESOURCES/concepts/_contradiction-register.md` ao invés de dissolverem
  a cada run. Stale check > 14 dias. **F3.4b Vault Impact → Kanban** — itens
  "alta" do F3.3 viram tickets tracked em `07-QUEUE/kanban/vault-impact-kanban.md`
  com auto-resolve. **F3.7 Connection Density Metrics** — orphan rate, avg
  backlinks, concept coverage (bash only, zero AI cost). **Weekly Synthesis**
  — nova rotina `07-QUEUE/rotinas/weekly-synthesis.md` (domingo 22h) lê
  ingest-diarios da semana e identifica meta-padrões. **SRS for Sources**
  — nova rotina `07-QUEUE/rotinas/srs-sources.md` (diário 09h) aplica spaced
  repetition em Score A sources. Cost budget: +100×N_A tokens (F2.9 reflection).
  ingest-agent v1.3→v1.4, report-agent v1.2→v1.3.
- v4.3 (2026-06-10): F1.0b dedup bug fix — manifest guarda chave com prefixo de
  pasta (`Clippings/x.md`), grep antigo só comparava `"basename.md"` (quote
  colada no nome) e nunca batia com `"Clippings/x.md"`. Causou re-triagem de
  arquivos já ingeridos no mesmo dia (achado pipeline 2026-06-09: 4/57
  aprovados já tinham source page real no manifest). Fix: checa caminho
  completo + `/basename"` (sufixo de path) além do formato antigo.
- v4.2 (2026-06-09): 2 levers de varredura das 13 sources token-economy-cost
  restantes. (1) Retry cap: máx 3/chamada, 10/fase → abortar+logar, não travar
  (v4.1 removeu Ollama e ficou sem cap de retry). (2) Phase-handoff trim:
  report-agent lê só "Aprovados (A/B)" + flags ultra do triagem, não a tabela
  "Score Individual" inteira (audit trail C/D infla contexto à toa). 3 agentes
  → v1.2.0. Demais levers das sources já cobertos (model routing=advisor,
  CLEAN=log filter, SKILL.md=fat-skill) ou harness-level (streaming/batch,
  auto-compact, TTL). Zero contradição com v4.1.
- v4.1 (2026-06-09): Reverte v4.0/ADR-001 (Ollama Cloud) — usuário não quer
  pagar licença + scoring minimax≠Haiku diverge (F1 é scoring). Os 3 agentes
  (`triagem-agent`/`ingest-agent`/`report-agent`) mantidos, modelo
  Ollama→Claude (Haiku/Sonnet). Novo: pré-filtro heurístico bash
  (`triagem-scoring`, nunca conectado antes) resolve ≥60% sem AI call;
  borderline (4-6) em 1 batch Haiku (era loop, abaixo do cache floor 4096tok).
  Cap leitura Clippings/X (8000 chars). F3.0 skip condicional
  (sources_today<2). Triagem §Sugestões/Melhorias → caveman ultra (rascunho),
  F3.2/F3.3 = versão canônica. Cost budget recalculado: redução honesta
  ~35-45% (não 70-80%). Guardrail novo: nunca data/timestamp vivo em prosa de
  agent-spec/CLAUDE.md (cache-killer). Ver ADR-003 (supersede parcial ADR-001;
  ADR-002/vault-reconcile não afetado).
- v4.0 (2026-06-09): F1–F3 delegadas a agentes vault-nativos via Ollama Cloud (`triagem-agent`,
  `ingest-agent`, `report-agent`) — substitui execução direta em Claude Sonnet/Haiku/Opus.
  Claude mantido só para: NEXUS GATE início, F2.8 spot-check, F3.5 final review (3 gates Sonnet,
  ~350-400 tokens/run vs ~2800+ base anterior). Commit gate movido para `@ledger` dentro do
  report-agent. Ver ADR-001. **Revertido em v4.1.**
- v3.5 (2026-06-07): + Commit gate obrigatório pós hot-cache (achado meta-coaching WP2 — 18 arquivos/+346 linhas ficaram 7 dias sem commit). Threshold: >3 arquivos rastreados em agents/skills/hot.md → commit automático.
- v3.4 (2026-05-31): F1.0 grep regex→fixed-string (`-F`) — previne falha em filenames com parênteses/espaços. F2.6 md5 + jq usam `--arg` e `"$f"` quoted — previne null hash. Nexus Gate: FIAP/concurso 7d absence check → flag em hot.md.
- v3.3 (2026-05-31): F1.0 manifest check normalizado por stem (sem extensão) — previne falsos positivos de re-conversões PDF→MD.
- v3.2 (2026-05-30): F3.3 Vault Impact — coluna `Status` padronizada no template.
- v3.1 (2026-05-25): Revert leitura de parágrafos — intro+resumo+conclusão apenas (mais econômico). Clippings/X: 100% do MD.
- v3 (2026-05-25): Score 0-10 → A/B/C/D. Leitura adaptativa. Aprovados: A/B (ingest). C/D: arquivo sem ingest. F1.2/F2.7: mover todas as fontes pra 08-ARCHIVE/[grade].
- v2 (2026-05-24): F1.2 atualizado — rejeitados agora vão para 08-ARCHIVE/D/$(date -I)/ (era triagem-rejeitados/). F2.4 atualizado — Clippings movidos para 08-ARCHIVE/A-B-C-D/$(date -I)/ por score após ingest (era rm simples). Estrutura: A=8-9, B=7, C=6, D=<6.
- v1 (2026-05-23): criado. Merge de triagem-clipping (v1) + ingest-diario (v5) + relatorio-pos-ingest (v2). Nexus gates em 3 pontos. Templates expandidos — profundidade > brevidade, sem condensação artificial. Skills: wiki-ingest, relatorio-artigos. Agents: nexus, guard, ingest-report.