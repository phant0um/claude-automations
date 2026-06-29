---
name: evaporation-reconcile
description: "Quando files evaporate entre scan e processamento, não tratar como erro — tratar como sinal para retroactive manifest reconciliation. Inclui diagnóstico, mitigação e formato de retroactive entry."
skill: evaporation-reconcile
version: 1.0
author: Nexus (criado via F3.3 vault-impact 2026-06-28)
tags: [skill, evaporation, manifest, reconciliation, pipeline, quality]
type: skill
---

# Skill: Evaporation Reconcile

## Propósito

File evaporation é o padrão onde arquivos somem do disco entre o `find` (scan inicial do pipeline) e o processamento (segundos a minutos depois). Em vez de tratar isso como bug ou erro silencioso, esta skill trata evaporation como **sinal de que reconciliação retroativa do manifest é necessária**.

---

## Trigger

- Após F1.0 detectar que `candidates_new.txt` contém paths que `[ -f "$f" ]` retorna false
- Após pipeline reportar "0 files ingested" mas `candidates_new.txt` tem N > 0 entries
- Manual: `@evaporation-reconcile` quando houver suspeita de evaporation

---

## Quando Usar

- Pipeline-diario ou pipeline-semanal reporta discrepancy entre candidatos e ingested
- `cp` falha silenciosamente para paths que existiam no scan
- Triagem reporta mais aprovados que files efetivamente processados

## Quando NÃO Usar

- File não existe desde o início (erro de path, não evaporation)
- Batch vazio por design (não há candidatos)
- Erro de permissão (diferente de evaporation)

---

## Execução

### Step 1: Diagnosticar Evaporation

```bash
#!/bin/bash
# evaporation-diagnose.sh
# Verifica quantos arquivos em candidates_new.txt ainda existem no disco

VAULT_DIR="/Users/michelcsasznik/Obsidian/vault-michel"
EXISTING=0; MISSING=0; MISSING_PATHS=""

while IFS= read -r f; do
  if [ -f "$f" ]; then
    EXISTING=$((EXISTING+1))
  else
    MISSING=$((MISSING+1))
    MISSING_PATHS="$MISSING_PATHS\n$f"
  fi
done < /tmp/candidates_new.txt

echo "=== Evaporation Diagnostic ==="
echo "Existing: $EXISTING"
echo "Missing:  $MISSING"
if [ $MISSING -gt 0 ]; then
  echo ""
  echo "Missing paths:"
  echo -e "$MISSING_PATHS"
fi
```

### Step 2: Confirmar que arquivos já foram processados

Para cada arquivo "missing", checar se está no archive (já foi ingerido):

```bash
#!/bin/bash
# evaporation-archive-check.sh

VAULT_DIR="/Users/michelcsasznik/Obsidian/vault-michel"
> /tmp/evaporated_already_archived.txt
> /tmp/evaporated_truly_gone.txt

while IFS= read -r f; do
  [ -f "$f" ] && continue  # só processa missing
  bn=$(basename "$f")
  archived=$(find "$VAULT_DIR/08-ARCHIVE/" -name "$bn" 2>/dev/null | head -1)
  if [ -n "$archived" ]; then
    echo "$f|$archived" >> /tmp/evaporated_already_archived.txt
  else
    echo "$f" >> /tmp/evaporated_truly_gone.txt
  fi
done < /tmp/candidates_new.txt

echo "Already archived (retroactive manifest needed): $(wc -l < /tmp/evaporated_already_archived.txt)"
echo "Truly gone (sync issue, not processing): $(wc -l < /tmp/evaporated_truly_gone.txt)"
```

### Step 3: Retroactive Manifest Reconciliation

Para arquivos que já estão no archive (já processados mas sem manifest entry):

```python
#!/usr/bin/env python3
# retroactive-manifest-reconcile.py
# Adiciona manifest entries retroativas para arquivos evaporados já arquivados

import json, os, sys
from datetime import date

VAULT_DIR = "/Users/michelcsasznik/Obsidian/vault-michel"
MANIFEST = os.path.join(VAULT_DIR, ".raw/.manifest.json")
ARCHIVE_MAP = "/tmp/evaporated_already_archived.txt"

with open(MANIFEST, "r") as f:
    manifest = json.load(f)

sources = manifest.get("sources", {})
today = date.today().isoformat()

with open(ARCHIVE_MAP, "r") as f:
    for line in f:
        line = line.strip()
        if not line or "|" not in line:
            continue
        original_path, archive_path = line.split("|", 1)
        bn = os.path.basename(original_path)
        bn_noext = os.path.splitext(bn)[0]

        if bn in sources or bn_noext in sources:
            continue  # já tem entry

        # Buscar source page pelo slug
        slug_stem = bn_noext.lower()
        # normalizar slug
        import re
        slug = re.sub(r'[^a-z0-9]', '-', slug_stem)
        slug = re.sub(r'-+', '-', slug).strip('-')

        # Procurar source page existente
        found = None
        for root, dirs, files in os.walk(os.path.join(VAULT_DIR, "03-RESOURCES", "sources")):
            for fname in files:
                if slug[:40] in fname.lower():
                    found = os.path.join(root, fname)
                    break
            if found:
                break

        page_path = found or archive_path

        # Registrar AMBAS variantes de key (com e sem extensão)
        sources[bn] = {
            "hash": "evaporated-reconcile",
            "ingested_at": today,
            "category": "articles",
            "pages_created": [page_path],
            "note": f"evaporation-reconcile: file evaporated between scan and processing, already archived"
        }
        sources[bn_noext] = {
            "hash": "evaporated-reconcile",
            "ingested_at": today,
            "category": "articles",
            "pages_created": [page_path],
            "alias_of": bn,
            "note": "evaporation-reconcile alias"
        }

manifest["sources"] = sources
with open(MANIFEST, "w") as f:
    json.dump(manifest, f, indent=2, ensure_ascii=False)

print(f"Retroactive entries added: {len([k for k in sources if sources[k].get('note','').startswith('evaporation-reconcile')])}")
```

### Step 4: Report

```bash
echo "=== Evaporation Reconcile Report ==="
echo "Total candidates:    $(wc -l < /tmp/candidates_new.txt)"
echo "Existing on disk:    $EXISTING"
echo "Evaporated:           $MISSING"
echo "  Already archived:   $(wc -l < /tmp/evaporated_already_archived.txt) → retroactive manifest entries added"
echo "  Truly gone:         $(wc -l < /tmp/evaporated_truly_gone.txt) → sync issue (Readwise/iCloud), not pipeline bug"
echo ""
echo "Action: ${MISSING} files evaporated = signal, not error. Manifest reconciled retroactively."
```

---

## Mitigation Steps

1. **Não panicar** — evaporation é padrão recorrente (2026-06-16: 51 files, 2026-06-22: similar). Não é bug do pipeline.
2. **Diagnosticar** — rodar Step 1 para quantificar existing vs missing
3. **Confirmar archive** — rodar Step 2 para separar "já processado" de "truly gone"
4. **Reconcile manifest** — rodar Step 3 para registrar entries retroativas
5. **Re-rodar pipeline** — arquivos truly gone voltarão via Readwise sync; próxima execução os pega

## Causas Raiz de Evaporation

1. **Readwise sync** limpa/substitui arquivos durante o cycle
2. **Pipeline anterior** moveu arquivos para `08-ARCHIVE/` mas não atualizou manifest
3. **Obsidian sync** (iCloud/Dropbox) remove arquivos temporariamente
4. **Evaporation selectivity** — files Score D evaporam mais (consistente com observação 2026-06-28: 51/52 rejeitados eram evaporados)

## Failure Modes

- **Misdiagnosis**: tratar evaporation como bug e debugar o `find` — perder tempo. Evaporation é sync, não bug.
- **Incomplete reconcile**: adicionar manifest entry mas não buscar source page existente → re-ingest na próxima execução.
- **Slug too short**: usar `slug[:30]` para filenames longos gera 0 matches → usar 40-50 chars ou slug completo.
- **Dual-key missing**: registrar só uma variante de key (com extensão) → próxima execução com grep sem extensão gera falso "novo".

---

## Integração

- Complementa [[pre-ingest-dedup]] — dedup previne duplicatas; evaporation-reconcile trata files que somem
- Integra com pipeline-diario F1.0 — após detectar evaporation, acionar reconcile antes de reportar "0 ingested"
- Resultado registrado no [[06-GENERATED/ingest-report/]] da execução

## Completion Checklist

- [ ] Evaporation diagnosticado (existing vs missing)
- [ ] Archive check executado (já arquivados vs truly gone)
- [ ] Retroactive manifest entries adicionadas (com dual-key)
- [ ] Source pages existentes identificadas (slug match 40+ chars)
- [ ] Report gerado com contadores
- [ ] Próxima execução do pipeline não deve re-marcar arquivos reconciliados como "novo"

---

## Changelog

- v1.0 (2026-06-28): Skill criada via F3.3 vault-impact item. Pattern extraído de pre-ingest-dedup SKILL.md (v1.2 File Evaporation Pattern section). Inclui diagnóstico, archive check, retroactive manifest reconcile e report.