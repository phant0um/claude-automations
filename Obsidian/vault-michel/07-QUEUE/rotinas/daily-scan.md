---
title: Daily Scan — Dedup + Candidatos (bash-only)
type: rotina
schedule: "diário 16h"
version: 2
last_improved: 2026-06-19
created: 2026-06-18
tags: [rotina, daily, scan, dedup, bash-only]
---

# Daily Scan

Scan diário bash-only (zero AI cost). Detecta duplicatas e identifica candidatos
novos. Se volume > threshold, flag para execução do pipeline-semanal.

**Princípio**: pegar duplicatas cedo evita acúmulo. Não gastar tokens diariamente
quando volume baixo — acumular para batch semanal.

**Referências:**
- [[07-QUEUE/rotinas/pipeline-semanal|pipeline-semanal]] — executa triagem→ingest→relatório semanal
- [[04-SYSTEM/skills/foundational/pre-ingest-dedup|pre-ingest-dedup]] — skill de dedup

---

## F1.0 Pre-dedup `[bash]`

```bash
cd ~/Obsidian/vault-michel

# Quasi-duplicatas por basename similarity
ls Clippings/ .raw/articles/ 2>/dev/null | sort | uniq -d | head -20
# Mesmo stem, extensão diferente (.md vs .pdf)
find .raw/ Clippings/ -type f | sed 's/\.[^.]*$//' | sort | uniq -d
```

Se duplicata detectada: manter versão mais recente, mover outra para `08-ARCHIVE/D/`.

---

## F1.0b Scan candidatos `[bash]`

```bash
find .raw/articles/ .raw/fiap/ .raw/ebooks/ .raw/images/ Clippings/ \
  -maxdepth 2 \( -name "*.md" -o -name "*.pdf" \) 2>/dev/null | sort > /tmp/candidates_all.txt

# normaliza apóstrofo/aspas curvas → retas
norm() { python3 -c "import sys;d=sys.stdin.read();print(d.replace(''',chr(39)).replace(''',chr(39)).replace('"',chr(34)).replace('"',chr(34)),end='')"; }
norm < .raw/.manifest.json > /tmp/manifest_norm.json

# slug normalizado — usar arquivo externo ao invés de inline python3 -c (bash 3.x quoting bug)
# Pitfall (2026-06-24): inline python3 -c com regex + parênteses quebra no macOS bash 3.x
slug() { python3 04-SYSTEM/scripts/slug_fn.py; }

while IFS= read -r f; do
  fn=$(echo "$f" | norm)
  bn=$(basename "$f" | norm)
  stem="${bn%.*}"
  slug_stem=$(echo "$stem" | slug)
  grep -qF "\"$fn\""       /tmp/manifest_norm.json 2>/dev/null || \
  grep -qF "/$bn\""        /tmp/manifest_norm.json 2>/dev/null || \
  grep -qF "\"$bn\""       /tmp/manifest_norm.json 2>/dev/null || \
  grep -qF "/$stem.md\""   /tmp/manifest_norm.json 2>/dev/null || \
  grep -qF "\"$stem.md\""  /tmp/manifest_norm.json 2>/dev/null || \
  grep -qF "/$stem.pdf\""  /tmp/manifest_norm.json 2>/dev/null || \
  grep -qF "\"$stem.pdf\"" /tmp/manifest_norm.json 2>/dev/null || \
  grep -qF "$slug_stem"    /tmp/manifest_norm.json 2>/dev/null || echo "$f"
done < /tmp/candidates_all.txt > /tmp/candidates_new.txt

NEW_COUNT=$(wc -l < /tmp/candidates_new.txt | tr -d ' ')
echo "Candidatos novos: $NEW_COUNT"
```

---

## F1.0c Cross-check campo `source:` `[bash]`

O F1.0b só compara basename × manifest. Não pega o caso **slug temático divergente**:
mesmo Clipping já virou source page sob outro nome de arquivo, em run anterior, mas o
manifest não registrou (errors 2026-06-10 — 6 pares duplicados em `sources/`).

Antes de finalizar a lista, descartar candidatos cujo basename já aparece no campo
`source:` de alguma source page existente.

```bash
# Coleta todos os valores de source: das pages existentes (1 passada)
grep -rhE "^source:" 03-RESOURCES/sources/ 02-AREAS/*/sources/ --include="*.md" 2>/dev/null \
  > /tmp/existing_source_fields.txt

while IFS= read -r f; do
  bn=$(basename "$f")
  grep -qF "$bn" /tmp/existing_source_fields.txt || echo "$f"
done < /tmp/candidates_new.txt > /tmp/candidates_new_filtered.txt
mv /tmp/candidates_new_filtered.txt /tmp/candidates_new.txt

NEW_COUNT=$(wc -l < /tmp/candidates_new.txt | tr -d ' ')
echo "Após cross-check source-field: $NEW_COUNT candidatos"
```

---

## F1.0d Categoria sanity check `[bash]`

**Princípio**: detectar false-positive de categorização antes do ingest.
Se >30% do batch seria categorizado como "concurso" mas não há input
em `.raw/concurso/` ou filenames com "aula-", algo está errado.

**Pitfall (2026-06-23 run 2):** 74/230 source pages (32%) categorizadas como
"concurso" incorretamente — papers acadêmicos com keywords "fiscal/tribut"
em contexto de computational finance, não concurso público.

```bash
# Quick categorization preview (keyword matching, same logic as ingest)
CONCURSO_COUNT=0
TOTAL_COUNT=$(wc -l < /tmp/candidates_new.txt | tr -d ' ')
while IFS= read -r f; do
  # Same weak keyword matching as ingest-agent categorize()
  if head -c 3000 "$f" 2>/dev/null | grep -qiE "concurso|legisla|CESPE|CEBRASPE|FGV|FCC|receita federal|SEFAZ|tribut|fiscal"; then
    CONCURSO_COUNT=$((CONCURSO_COUNT+1))
  fi
done < /tmp/candidates_new.txt

PCT=$((CONCURSO_COUNT*100/TOTAL_COUNT))
CONCURSO_INPUT=$(find .raw/concurso/ -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

if [[ $PCT -gt 30 && "$CONCURSO_INPUT" -eq 0 ]]; then
  echo "⚠️ F1.0d: $CONCURSO_COUNT/$TOTAL_COUNT ($PCT%) categorizados como 'concurso' mas sem input .raw/concurso/ — provável false-positive"
  echo "  Categorização concurso requer 2+ keywords do conjunto {concurso, CESPE, CEBRASPE, FGV, FCC, SEFAZ, servidor público} ou 'concurso' no título"
fi
```

---

## Volume threshold flag `[bash]`

```bash
THRESHOLD=30  # se >30 candidatos acumulados, flag para rodar pipeline-semanal

if [[ "$NEW_COUNT" -ge "$THRESHOLD" ]]; then
  FLAG="⚠️ daily-scan: $NEW_COUNT candidatos ≥ threshold ($THRESHOLD) — considerar rodar pipeline-semanal"
  echo "$FLAG"
  # Append ao hot.md se não já presente
  if ! grep -q "daily-scan: $NEW_COUNT candidatos" 04-SYSTEM/wiki/hot.md 2>/dev/null; then
    echo "- $FLAG — $(date -I)" >> 04-SYSTEM/wiki/hot.md
  fi
else
  echo "daily-scan: $NEW_COUNT candidatos (abaixo de threshold $THRESHOLD) — acumular para batch semanal"
fi
```

---

## Guardrails

- **Zero AI cost** — bash only, sem chamadas de modelo
- **Não move arquivos** (exceto duplicatas óbvias F1.0) — só scan
- **Threshold configurável** — ajustar conforme volume típico de Clippings/
- **Não bloqueia** — se encontrar erro (manifest ausente, permissão), logar e seguir
- **Output**: `/tmp/candidates_new.txt` preservado para pipeline-semanal consumir
- **Schedule**: diário 16h (mesmo horário anterior, mas sem gates Sonnet)

---

## Relação com pipeline-semanal

O pipeline-semanal (domingo 22h) consome `/tmp/candidates_new.txt` acumulado
da semana. O daily-scan garante que duplicatas sejam pegas cedo e que o
volume seja monitorado — se passar threshold, sinaliza para rodar pipeline
antes do domingo.

---

## Changelog

- v2.1 (2026-06-24): fix slug() inline python3 -c quoting bug no macOS bash 3.x — extraído para
  04-SYSTEM/scripts/slug_fn.py. Pitfall: inline python3 -c com regex + parênteses quebra
  silenciosamente no bash 3.x (macOS). Resultado: slug vazio → grep -qF "" retorna true
  para qualquer input → falsos negativos na dedup (3 arquivos perdidos em run 2026-06-24).
- v2 (2026-06-19): + F1.0c cross-check do campo `source:` das source pages existentes —
  pega slug temático divergente que F1.0b (basename×manifest) deixava passar
  (errors 2026-06-10, 6 pares duplicados).
- v1 (2026-06-18): criado.