---
skill: ingest-verify
version: 1.0
type: verification
author: Nexus Agent System
created: 2026-05-28
trigger: "@ingest-verify [path]" | post-pipeline gate | verify agent
tags: [verification, ingest, quality-gate, completeness, post-ingest]
---

# Skill: Ingest Verify

## Propósito

Valida completeness de source pages recém-ingestadas. Detecta: frontmatter incompleto, wikilinks quebrados, stubs sem tese central, ausência no manifest, seções obrigatórias faltando.

Tipo: **Verification skill** — inspirado em Anthropic lessons-skills ("Product Verification skills > skill writing excellent"). Garante que ingest não termina com pages quebradas ou vazias.

---

## Condições de Ativação

- Após qualquer ingest de source page (individual ou em batch)
- Antes de marcar pipeline como CONCLUÍDO
- `@ingest-verify [caminho_ou_glob]` ou "verifica ingest"
- Trigger automático do agente `verify` ao encerrar sessão de ingest

## Quando NÃO Usar

- Auditar wikilinks globais do vault inteiro → usar `wiki-lint`
- Auditar agentes/skills registrados → usar `check-resolvable`
- Avaliar profundidade de conceitos existentes → usar `drift-review`
- Verificar uma única página antes de publicação → usar apenas C3 (Haiku direto)

---

## Modelo por Etapa

| Etapa | Modelo | Justificativa |
|-------|--------|---------------|
| Frontmatter parse (bash) | — | Zero tokens |
| Wikilink resolution (bash) | — | Zero tokens |
| Manifest check (bash/python) | — | Zero tokens |
| Tese central check | `claude-haiku-4-8` | Julgamento simples — 1 pergunta Y/N |
| Relatório final | `claude-haiku-4-8` | Estruturação de findings |

---

## Checks

### C1 — Frontmatter completo

Campos obrigatórios em toda source page: `title`, `type`, `created`, `updated`, `tags`.

```bash
python3 - <<'EOF'
import re, sys
content = open(sys.argv[1]).read()
fm = re.search(r'^---\n(.*?)\n---', content, re.DOTALL)
if not fm:
    print("C1 FAIL: no frontmatter"); sys.exit(0)
body = fm.group(1)
for field in ['title', 'type', 'created', 'updated', 'tags']:
    if not re.search(rf'^{field}:', body, re.MULTILINE):
        print(f"C1 FAIL: missing field '{field}'")
print("C1 OK")
EOF
"$arquivo"
```

Falha: campo ausente ou faltando totalmente o bloco `---`.

---

### C2 — Wikilinks resolvem

Extrair todos `[[link]]` do arquivo. Verificar existência no vault.

```bash
VAULT=/Users/michelcsasznik/Obsidian/vault-michel
grep -oP '\[\[([^\|\]#]+)' "$arquivo" | sed 's/\[\[//' | sort -u | while read link; do
  if [[ "$link" == */* ]]; then
    # Full-path wikilink: 03-RESOURCES/concepts/...
    [ -f "$VAULT/${link}.md" ] || echo "C2 DEAD_PATH: $link"
  else
    # Filename-only: [[agent-lifespan-engineering]]
    found=$(find "$VAULT" -name "${link}.md" 2>/dev/null | head -1)
    [ -z "$found" ] && echo "C2 DEAD_NAME: $link"
  fi
done
```

Falha: qualquer link sem arquivo correspondente → listar todos os dead links.

---

### C3 — Tese central presente

Source page deve conter ao menos um parágrafo explicando o que a fonte afirma ou ensina. Stub puro (só frontmatter + headings) não passa.

Prompt Haiku:
```
Leia o arquivo abaixo. Ele contém pelo menos uma frase completa explicando
a tese central, insight principal ou claim da fonte?
Responda apenas: YES | STUB (só headings/listas/links) | EMPTY (sem conteúdo)

<arquivo>
{conteúdo sem frontmatter, primeiros 400 tokens}
</arquivo>
```

Resultado:
- `YES` → C3 ✅
- `STUB` → C3 ⚠️ (ingested mas sinalizado para expansão posterior)
- `EMPTY` → C3 ❌ (page vazia — rejeitar)

---

### C4 — Manifest entry existe

```bash
python3 - <<'EOF'
import json, sys, os
manifest = json.load(open('/Users/michelcsasznik/Obsidian/vault-michel/.raw/.manifest.json'))
arquivo = sys.argv[1]
basename = os.path.basename(arquivo).replace('.md', '')
# Check both filename key and source: field values
found = any(
    basename in str(k) or
    (isinstance(v, dict) and basename in str(v.get('source', '')))
    for k, v in manifest.items()
)
print("C4 OK" if found else f"C4 FAIL: '{basename}' not in manifest")
EOF
"$arquivo"
```

Falha: source page criada mas não registrada em `.raw/.manifest.json`.

---

### C5 — Seções obrigatórias

Source pages devem ter:
1. Pelo menos um heading (`##`) com conteúdo abaixo
2. Pelo menos um wikilink `[[...]]` (links para conceitos, entidades ou fontes relacionadas)

```bash
has_heading=$(grep -c '^## ' "$arquivo" || echo 0)
has_wikilink=$(grep -c '\[\[' "$arquivo" || echo 0)
[ "$has_heading" -lt 1 ] && echo "C5 FAIL: no headings"
[ "$has_wikilink" -lt 1 ] && echo "C5 WARN: no wikilinks (isolated page)"
```

Exceção: tag `status: stub` no frontmatter → C5 reporta ⚠️, não ❌.

---

## Protocolo de Execução

### Input
- `$arquivo`: caminho absoluto para source page
- Para batch: lista de caminhos (um por linha) — processar sequencialmente, máx 20 por execução; acima disso paralelizar via subagents

### Sequência

```
PASSO 1 (bash, 0 tokens): C1 frontmatter + C2 wikilinks + C4 manifest + C5 seções
PASSO 2 (Haiku): C3 tese central — apenas se PASSO 1 não retornou C4 FAIL
PASSO 3 (Haiku): compilar relatório final com veredicto
```

### Relatório

```
=== INGEST-VERIFY | <timestamp> ===
Arquivo: <path>

CHECKS:
  C1 Frontmatter:   ✅ OK | ❌ campos ausentes: [X, Y]
  C2 Wikilinks:     ✅ OK | ❌ dead links: [[A]], [[B]]
  C3 Tese central:  ✅ OK | ⚠️ STUB | ❌ EMPTY
  C4 Manifest:      ✅ OK | ❌ não registrado
  C5 Seções:        ✅ OK | ⚠️ sem wikilinks | ❌ sem headings

VEREDICTO: ✅ APROVADO | ⚠️ AVISO (X avisos) | ❌ REJEITAR (Y erros)

AÇÃO REQUERIDA:
  [fix específico para cada ❌ ou ⚠️]
```

**Veredicto:**
- ✅ `APROVADO`: todos C1–C5 passam (⚠️ avisos permitidos)
- ⚠️ `AVISO`: C3=STUB ou C5=sem wikilinks — page válida, sinalizada para expansão
- ❌ `REJEITAR`: qualquer C1, C2, C4 falha, ou C3=EMPTY — source page incompleta

---

## Batch Mode (pós-pipeline)

Após pipeline de ingest em paralelo, rodar sobre todas as pages criadas na sessão:

```bash
# Coletar pages criadas na sessão (últimas N horas)
find /Users/michelcsasznik/Obsidian/vault-michel/03-RESOURCES/sources/ \
  -name "*.md" -newer /tmp/pipeline-start-marker \
  | head -20 > /tmp/verify-batch.txt

# Rodar skill sobre cada uma
# (Nexus ou verify agent processa /tmp/verify-batch.txt)
```

Saída batch: tabela com 1 linha por arquivo — caminho, veredicto, findings.

---

## Restrições

- NUNCA modificar arquivo verificado — apenas reportar
- Dead wikilinks: listar exatos, não tentar corrigir automaticamente
- C3 stub: reportar como ⚠️, nunca ❌ automaticamente — stub pode ser intencional
- Manifest check: falsa ausência possível se key format variou (ver `no_source_field_in_page` pattern) — mencionar na ação sugerida, não travar o veredicto

## Ver Também

- [[04-SYSTEM/skills/core/check-resolvable]] — auditar agentes vs AGENTS.md
- [[04-SYSTEM/skills/core/drift-review]] — profundidade de conteúdo de concepts
- [[03-RESOURCES/concepts/agent-systems/floor-raising-vs-benchmark-maxing]] — philosophy: verificação como floor-raising
- [[03-RESOURCES/sources/claude-code-skills/lessons-building-claude-code-skills]] — 6 skill types; Verification as distinct category
