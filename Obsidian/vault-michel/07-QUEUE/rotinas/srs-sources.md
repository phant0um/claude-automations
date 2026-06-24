---
title: SRS Sources — Revisão Espaçada de Sources Score A
type: rotina
schedule: "diário 09h"
version: 2
last_improved: 2026-06-19
created: 2026-06-18
tags: [rotina, srs, sources, spaced-repetition, retention]
---

# SRS Sources — Revisão Espaçada de Sources

Rotina diária de spaced repetition para source pages Score A. Garante que
conhecimento de alta densidade seja revisitado antes do esquecimento.

**Princípio**: Score A entra no vault e nunca mais é revisitado. Esquecimento
garantido. SRS existente para concurso (SM2) é adaptado para sources.

**Referências:**
- [[07-QUEUE/rotinas/srs-concurso|SRS Concurso]] — infraestrutura SM2 de referência
- [[03-RESOURCES/concepts/learning-cognition/knowledge-compounding|knowledge compounding]]
- [[07-QUEUE/rotinas/pipeline-semanal|pipeline-semanal]] — origem das sources

---

## NEXUS GATE

```bash
tail -10 04-SYSTEM/wiki/hot.md
```

`@nexus srs-sources iniciando — $(date -I)` — autoriza ou bloqueia.

---

## FASE 0 — Sync tracker com manifest `[bash]`

**Princípio**: o ingest-agent deveria popular o tracker via F2.10, mas isto
nem sempre acontece. O SRS rotina deve detectar Score A sources no manifest
que não estão no tracker e adicioná-las automaticamente.

**Pitfall (2026-06-23 run 2):** 166 Score A sources ingested mas 0 entraram no
tracker. F2.10 foi pulado. Sem sync, o SRS não tem nada para revisar.

```bash
TODAY=$(date -I)
TRACKER="07-QUEUE/trackers/srs-sources-tracker.md"
NEXT=$(date -I -v+7d 2>/dev/null || date -I -d "+7 days")

# Se tracker não existe, criar
[ -f "$TRACKER" ] || printf '%s\n' \
  '| Slug | Categoria | Score | Ingested | Ultima Revisão | Próxima Revisão | Intervalo | Nota | Sessões |' \
  '|------|-----------|-------|----------|----------------|-----------------|-----------|------|---------|' > "$TRACKER"

# Coletar Score A sources do manifest
python3 -c "
import json, os
from datetime import date
manifest = json.load(open('.raw/.manifest.json'))
TODAY = '$TODAY'
NEXT = '$NEXT'
tracker = open('$TRACKER').read()
added = 0
for key, entry in manifest.get('sources', {}).items():
    if 'alias_of' in entry:
        continue  # skip aliases
    pages = entry.get('pages_created', [])
    if not pages:
        continue
    page = pages[0]
    slug = os.path.basename(page).replace('.md', '')
    # Verifica se já está no tracker
    if f'| {slug} |' in tracker:
        continue
    # Verifica se é Score A lendo a source page
    try:
        content = open(page).read(500)
        if 'score: A' in content:
            cat = entry.get('category', 'articles')
            print(f'| {slug} | {cat} | A | {entry.get(\"ingested_at\", TODAY)} | {TODAY} | {NEXT} | 7 |  | 0 |')
            added += 1
    except:
        pass
print(f'Synced: {added} new Score A sources added to tracker', file=__import__('sys').stderr)
" >> "$TRACKER" 2>/tmp/srs_sync.log

SYNCED=$(cat /tmp/srs_sync.log 2>/dev/null | grep -oE '[0-9]+ new' | head -1)
echo "FASE 0: $SYNCED"
```

---

## FASE 1 — Ler tracker e identificar sources vencidas `[bash]`

```bash
TODAY=$(date -I)
TRACKER="07-QUEUE/trackers/srs-sources-tracker.md"

# Filtra sources com proxima_revisao <= hoje
grep -E "^\|" "$TRACKER" | \
  awk -F'|' '{gsub(/ /,"",$5); if ($5 <= "'"$TODAY'"' && $5 != "" && $5 !~ /Próxima|---/) print $2, $5}' | \
  head -5
```

Se lista vazia → "Nenhuma source vence hoje." → encerrar.

---

## FASE 2 — Selecionar até 3 sources `[bash]`

Critério de prioridade:
1. `proxima_revisao` mais antiga (mais atrasada)
2. `score` = A (apenas A entraram no SRS)
3. `sessoes` menor (sources novas têm prioridade)

Max 3 sources por sessão. Sessão: ~15-20 min.

---

## FASE 3 — Revisar source `[Sonnet]`

Para cada source selecionada:

```bash
SOURCE_SLUG="$1"
SOURCE_FILE=$(find 03-RESOURCES/sources/ 02-AREAS/fiap/sources/ 02-AREAS/concurso/sources/ \
  -name "${SOURCE_SLUG}.md" -print -quit 2>/dev/null)
```

AI call: "Releia esta source page. Compare com o que você lembra:

1. **Recall**: antes de ler a source page, tentar recall ativo — qual a tese central?
2. **Releitura**: ler a source page completa
3. **Auto-avaliação** (1-5):
   - 5: lembrei tudo, incluindo nuances
   - 4: lembrei tese + argumentos principais
   - 3: lembrei tese, esqueci detalhes
   - 2: vago, precisei reler tudo
   - 1: não lembrava nada
4. **Nova conexão**: identificar 1 wikilink novo que não estava na source page
   original — conhecimento que compoundou desde a ingestão"

---

## FASE 4 — Atualizar tracker `[bash]`

```bash
# Calcular próximo intervalo (SM2 simplificado)
# nota 1-2 → intervalo = 1  (reset)
# nota 3   → intervalo = max(intervalo_atual * 1.5, 3)
# nota 4   → intervalo = intervalo_atual * 2
# nota 5   → intervalo = intervalo_atual * 2.5
```

Atualizar `07-QUEUE/trackers/srs-sources-tracker.md`:
- `ultima_revisao` = hoje
- `proxima_revisao` = hoje + novo_intervalo
- `intervalo_dias` = novo_intervalo
- `nota_ultima` = nota_dada
- `sessoes` = sessoes + 1

Se nova conexão encontrada → append à source page:
```bash
# Append em "## Conexões Descobertas" (criar seção se não existir)
NEW_CONN_LINE="- **[${TODAY}]** nova conexão: [[<conceito>]] — <razão>"
```

---

## FASE 5 — Relatório da sessão

```markdown
## Sessão SRS Sources — {data}

**Sources revisadas:** {lista}
**Média de recall:** {n}
**Novas conexões:** {N}
**Próximas revisões:**
- {source A}: {data}
- {source B}: {data}
**Alerta:** sources com nota ≤ 2 por 2 sessões → recomendado re-ingest
```

Salvar em `05-DAILY/{data}.md` seção `## SRS Sources` ou imprimir.

---

## Tracker — Formato

Arquivo: `07-QUEUE/trackers/srs-sources-tracker.md`

```markdown
| Slug | Categoria | Score | Ingested | Ultima Revisão | Próxima Revisão | Intervalo | Nota | Sessões |
|------|-----------|-------|----------|----------------|-----------------|-----------|------|---------|
| <slug> | ai-agents | A | 2026-06-15 | 2026-06-18 | 2026-06-25 | 7 | 4 | 1 |
```

### População inicial

O tracker é populado pelo ingest-agent: cada source page Score A criada
adiciona uma linha com:
- `Ingested` = data de ingestão
- `Ultima Revisão` = data de ingestão (primeira revisão = primeiro intervalo)
- `Próxima Revisão` = Ingested + 7 (intervalo inicial = 7 dias)
- `Intervalo` = 7
- `Nota` = vazia
- `Sessões` = 0

---

## Guardrails

- **Max 3 sources por sessão** — não sobrecarregar
- **Só Score A** — Score B não entra no SRS (densidade não justifica revisita)
- **Nota ≤ 2 por 2 sessões consecutivas** → flag "re-ingest recomendado"
- **Nova conexão é obrigatória** — se não encontrou, nota máx = 3
- **Tracker append-only** — nunca remover sources do tracker, só atualizar
- **Retry cap** — máx 3/chamada, 10/fase → abortar+logar

---

## Trigger manual

```
@nexus srs-sources          → roda sessão completa
@nexus srs-sources status   → lista o que vence nos próximos 7 dias
@nexus srs-sources update [slug] [nota]  → atualiza tracker sem revisão
```

---

## Changelog

- v2 (2026-06-19): tracker `07-QUEUE/trackers/srs-sources-tracker.md` criado (estava referenciado mas inexistente → FASE 1 falhava); ingest-agent (F2.10) passa a fazer `mkdir -p` + popular linha por Score A. (Sem commit gate — tracker e source pages são gitignored por design.)
- v1 (2026-06-18): criado.