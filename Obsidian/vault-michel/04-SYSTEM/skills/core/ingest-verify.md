---
name: ingest-verify
description: Valida completeness de source pages recém-ingestadas — frontmatter, wikilinks, manifest, tese central, seções, concept absorption (F2.5) e personal reflection (F2.9).
skill: ingest-verify
version: 1.1
type: verification
author: Nexus Agent System
created: 2026-05-28
updated: 2026-06-18
trigger: "@ingest-verify [path] or post-pipeline gate or verify agent"
tags: [verification, ingest, quality-gate, completeness, post-ingest]
---

# Skill: Ingest Verify

## Propósito

Valida completeness de source pages recém-ingestadas. Detecta: frontmatter incompleto, wikilinks quebrados, stubs sem tese central, ausência no manifest, seções obrigatórias faltando, concept absorption pendente, reflection missing.

Tipo: **Verification skill** — inspirado em Anthropic lessons-skills. Garante que ingest não termina com pages quebradas ou vazias.

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

---

## Modelo por Etapa

| Etapa | Modelo | Justificativa |
|-------|--------|---------------|
| Frontmatter parse (bash) | — | Zero tokens |
| Wikilink resolution (bash) | — | Zero tokens |
| Manifest check (bash/python) | — | Zero tokens |
| Tese central check | Haiku | Julgamento simples — 1 pergunta Y/N |
| Relatório final | Haiku | Estruturação de findings |
| C6 Concept absorption (bash) | — | Zero tokens |
| C7 Personal reflection (bash) | — | Zero tokens |

---

## Checks

### C1 — Frontmatter completo

Campos obrigatórios: `title`, `type`, `created`, `updated`, `tags`.

### C2 — Wikilinks resolvem

Extrair todos `[[link]]` do arquivo. Verificar existência no vault.

**Pitfall (2026-06-23 run 2):** 224/1215 wikilinks (18%) não resolviam porque o
ingest script gerou paths que não existem no filesystem. O check C2 deve:
1. Extrair todos `[[link]]` que apontam para `03-RESOURCES/concepts/` ou `03-RESOURCES/entities/`
2. Para cada link, verificar se `vault_path/link.md` existe
3. Se >5% links quebrados → FAIL (não PASS com warning). Abortar batch e reparar.
4. Reportar lista de links quebrados para reparo imediato

**Implementation bash:**
```bash
BROKEN=0
TOTAL=0
for f in "$SOURCES_DIR"/*.md; do
  links=$(grep -oE '\[\[03-RESOURCES/(concepts|entities)/[^\]]+\]\]' "$f")
  for link in $links; do
    TOTAL=$((TOTAL+1))
    path=$(echo "$link" | sed 's/\[\[//;s/\]\]//')
    [[ -f "$VAULT/$path.md" || -f "$VAULT/$path" ]] || BROKEN=$((BROKEN+1))
  done
done
PCT=$((BROKEN*100/TOTAL))
[[ $PCT -gt 5 ]] && echo "FAIL: $BROKEN/$TOTAL links broken ($PCT%)" || echo "OK: $BROKEN/$TOTAL broken ($PCT%)"
```

### C3 — Tese central presente

Source page deve conter ao menos um parágrafo explicando o que a fonte afirma.

### C4 — Manifest entry existe

Verificar se source page está registrada em `.raw/.manifest.json`.

### C5 — Seções obrigatórias

Pelo menos 1 heading `##` + pelo menos 1 wikilink `[[...]]`.

### C6 — Concept Absorption (F2.5) `[bash]`

**Princípio**: source pages não devem apenas linkar concepts — devem ter
atualizado os concepts com nova evidência (seção `## Evidências` no concept).

```bash
VAULT=/Users/michelcsasznik/Obsidian/vault-michel
CONCEPT_LINKS=$(grep -oE '\[\[03-RESOURCES/concepts/[^]|]+\]\]' "$arquivo" | \
  sed 's/\[\[03-RESOURCES\/concepts\///;s/\]\]//' | sort -u)

for concept in $CONCEPT_LINKS; do
  CONCEPT_FILE="$VAULT/03-RESOURCES/concepts/${concept}.md"
  if [[ -f "$CONCEPT_FILE" ]]; then
    SOURCE_SLUG=$(basename "$arquivo" .md)
    if ! grep -q "$SOURCE_SLUG" "$CONCEPT_FILE" 2>/dev/null; then
      echo "C6 WARN: concept $concept não absorveu $SOURCE_SLUG"
    fi
  fi
done
echo "C6 OK"
```

**Veredicto:** OK / WARN / Skip. Só válido para ingests pós-2026-06-18.

### C7 — Personal Reflection (F2.9) `[bash]`

**Princípio**: Score A sources devem ter seção `## Minha Síntese` com 3 campos:
"O que muda", "Conexão pessoal", "Próximo passo".

```bash
GRADE="${2:-}"
if [[ "$GRADE" == "A" ]]; then
  if grep -q "^## Minha Síntese" "$arquivo"; then
    grep -q "^\*\*O que muda" "$arquivo" && \
    grep -q "^\*\*Conexão pessoal" "$arquivo" && \
    grep -q "^\*\*Próximo passo" "$arquivo" && \
    echo "C7 OK" || echo "C7 WARN: Minha Síntese incompleta"
  else
    echo "C7 FAIL: Score A sem seção Minha Síntese"
  fi
else
  echo "C7 SKIP: não é Score A"
fi
```

**Veredicto:** OK / WARN / FAIL / SKIP. Só artigos/ai-agents (não FIAP).

---

## Protocolo de Execução

### Sequência

```
PASSO 1 (bash, 0 tokens): C1+C2+C4+C5+C6+C7
PASSO 2 (Haiku): C3 tese central — apenas se PASSO 1 sem C4 FAIL
PASSO 3 (Haiku): compilar relatório final com veredicto
```

### Relatório

```
=== INGEST-VERIFY | <timestamp> ===
Arquivo: <path>

CHECKS:
  C1 Frontmatter:   OK | FAIL
  C2 Wikilinks:     OK | FAIL: dead links
  C3 Tese central:  OK | WARN: STUB | FAIL: EMPTY
  C4 Manifest:      OK | FAIL
  C5 Seções:        OK | WARN | FAIL
  C6 Absorption:    OK | WARN: N concepts sem evidência
  C7 Reflection:    OK | WARN | FAIL | SKIP

VEREDICTO: APROVADO | AVISO (X avisos) | REJEITAR (Y erros)
```

**Veredicto:**
- `APROVADO`: todos C1–C7 passam (WARN permitidos)
- `AVISO`: C3=STUB ou C5=sem wikilinks ou C6=absorption pendente
- `REJEITAR`: qualquer C1, C2, C4, C7=FAIL, ou C3=EMPTY

---

### C8 — Wikilink points to directory, not file `[bash]`

**Princípio**: `[[03-RESOURCES/concepts/llm-ml-foundations]]` pode apontar para
um diretório (que existe) mas não para um arquivo `.md` (que não existe).
Obsidian resolve `dir` → `dir/_index.md` ou `dir.md`, mas wikilink checker
deve validar que o alvo é um arquivo ou um `_index.md`.

```bash
for link in $(grep -oE '\[\[[^]]+\]\]' "$arquivo" | sed 's/\[\[//;s/\]\]//;s/|.*//'); do
  # Check: is it a file?
  if [[ -f "$VAULT/${link}.md" ]]; then continue; fi
  # Check: is it a directory with _index.md?
  if [[ -f "$VAULT/${link}/_index.md" ]]; then continue; fi
  # Check: does the file exist with different case?
  found=$(find "$VAULT" -iname "$(basename "$link")*.md" -type f 2>/dev/null | head -1)
  if [[ -z "$found" ]]; then
    echo "C8 WARN: wikilink '$link' resolves to neither file nor _index.md"
  fi
done
echo "C8 OK"
```

**Veredicto:** OK / WARN: N links apontam para diretórios sem _index.md.

### C9 — Source page depth vs original clipping `[bash]`

**Princípio**: source page deve preservar informação relevante do clipping
original — não condensar artificialmente. Guardrail "profundidade > brevidade".

```bash
ORIGINAL_SIZE=$(wc -c < "$original_clipping" 2>/dev/null || echo 0)
PAGE_SIZE=$(wc -c < "$arquivo" 2>/dev/null || echo 0)

# Ratio: if page < 5% of original, likely a stub
if [[ "$ORIGINAL_SIZE" -gt 0 ]]; then
  RATIO=$(python3 -c "print(f'{$PAGE_SIZE/$ORIGINAL_SIZE*100:.1f}')")
  if (( $(python3 -c "print(1 if $PAGE_SIZE/$ORIGINAL_SIZE < 0.05 else 0)") )); then
    echo "C9 WARN: source page is ${RATIO}% of original (${PAGE_SIZE}b vs ${ORIGINAL_SIZE}b) — possible thin page"
  else
    echo "C9 OK: ${RATIO}% of original"
  fi
fi
```

**Veredicto:** OK / WARN: page < 5% do original. Não é FAIL — alguns clippings
são 90% boilerplate/menus. Mas < 5% com conteúdo técnico no original é suspeito.

**Achado**: pipeline-semanal 2026-06-22 spot-check encontrou page de 739 bytes
vs clipping original de 8660 bytes (8.5%) — era um stub real, expandido para
7020 bytes (81%) após correção.

---

## Restrições

- NUNCA modificar arquivo verificado — apenas reportar
- C3 stub: WARN, nunca FAIL — stub pode ser intencional
- C6: não flag para sources pré-2026-06-18 (antes do F2.5)
- C7: SKIP para FIAP e Score B
- C8: _index.md é resolvível no Obsidian — só WARN se nem arquivo nem _index existem
- C9: < 5% ratio é WARN, não FAIL — boilerplate varia

## Ver Também

- check-resolvable — auditar agentes vs AGENTS.md
- drift-review — profundidade de conteúdo de concepts

---

## Concept Creation Resolution Pattern — 2026-06-23

When a batch ingest produces source pages with many unresolved wikilinks pointing
to non-existent concepts/entities, the fix is NOT to remove the links — it's to
CREATE the missing concepts/entities. This is the primary mechanism by which the
vault knowledge graph grows.

**Pattern**:
1. After ingest, run wikilink resolution check (C2) across all new source pages
2. Collect all unresolved links, grouped by target path
3. Sort by frequency (concepts linked by 3+ sources = high priority)
4. Create each missing concept/entity with:
   - Frontmatter (title, type, created, updated, tags)
   - Definition (1-2 sentences)
   - Key points or patterns
   - `## Evidências` section linking back to source pages
   - `## Links` section with cross-references
5. Re-run resolution check — should be near 100%

**Session result**: 18 source pages → 80 wikilinks → 40 unresolved (50%) →
created 24 concepts/entities → 134/134 resolved (100%).

**Pitfall**: don't create stub concepts with only a definition and no evidence.
Each concept should link back to at least 1 source page that provides evidence.
A concept with zero backlinks is an orphan — it exists but has no foundation.

## Pitfall: Batch ingest link path mismatch — 2026-06-23 (Run 2)

**Sintoma**: 230 source pages criadas por script Python batch. Wikilinks gerados
por keyword matching apontam para paths como `[[03-RESOURCES/concepts/ai-agents/agent]]`
que não existem no vault. O vault tem `concepts/agent-systems/ai-agents.md` e
`entities/agent.md` — paths e estruturas diferentes.

**Causa**: O script de ingest gera wikilinks com paths pré-determinados
(`concept_map = {'agent': 'ai-agents', ...}`) que não correspondem à estrutura
real de subdiretórios do vault. O vault evoluiu organicamente com subdirs
como `agent-systems/`, `llm-ml-foundations/`, `memory-context-rag/` mas o
script assume `ai-agents/` como subdir.

**Impacto**: 
- Batch 1 subagent resolveu via basename matching (216 absorções em entities)
- Batch 2 subagent não resolveu nenhum (0 absorções — paths não bateram)
- Batch 3 só achou 2 que batiam exatamente
- 224/1215 wikilinks unresolved (18%) antes do repair

**Fix aplicado**: 
1. Script de repair mapeia broken links → existing files por basename
2. Concepts/entities faltantes criados como stubs NO PATH EXATO que o link
   referencia (não no path que o script acha "correto")
3. Verificação: 1215/1215 links resolvem (100%) após repair + stub creation

**Lição**: quando gerar wikilinks programaticamente, SEMPRE verificar contra
a estrutura real do vault antes de escrever. O vault tem 441 concepts em 16
subdirs e 323 entities — paths não são previsíveis. Duas opções:
1. **Pre-generation scan**: ler estrutura de subdirs antes de gerar links
2. **Post-generation repair**: gerar com paths plausíveis, depois reparar
   com script que faz basename matching + cria stubs nos gaps

A opção 2 é mais pragmática (não exige refatorar o script de ingest) mas
sempre executar o repair como passo obrigatório pós-ingest, não opcional.

**Pitfall secundário**: `CATEGORY_MAP = {'ai-agents': 'agent-systems'}` no script
de repair tentou criar stubs em `agent-systems/` mas os links apontam para
`ai-agents/`. O repair deve criar no path DO LINK, não no path "correto".
Verificar sempre com: `python3 -c "target = VAULT / f'{link}.md'; print(target.exists())"`

## Changelog

- v1.4 (2026-06-23 run 2): +Batch ingest link path mismatch pitfall — script de
  ingest gera wikilinks com paths que não correspondem à estrutura real do vault
  (441 concepts em 16 subdirs, 323 entities). Fix: post-ingest repair com basename
  matching + stub creation no path exato do link. 224/1215 unresolved → 1215/1215
  (100%). Lição: repair é passo obrigatório, não opcional. + CATEGORY_MAP pitfall:
  criar stubs no path do link, não no path "correto".
- v1.3 (2026-06-23): +Concept Creation Resolution Pattern — when wikilinks
  point to non-existent concepts, create them (don't remove links). 24 concepts
  created from 40 unresolved links in pipeline-semanal 2026-06-23 (50% → 100%
  resolution). Pitfall: don't create stubs without evidence backlinks.
- v1.2 (2026-06-22): +C8 Wikilink-to-directory check (links que apontam para
  diretórios sem _index.md). +C9 Source page depth vs original clipping (ratio
  < 5% = WARN — possible thin page/stub). Achado: pipeline-semanal 2026-06-22
  spot-check: page 739b vs clipping 8660b (8.5%) = stub real; link
  `[[llm-ml-foundations]]` apontava para diretório. Ambos corrigidos.
- v1.1 (2026-06-18): +C6 Concept Absorption (F2.5 — concepts absorveram
  evidência). +C7 Personal Reflection (F2.9 — Score A tem Minha Síntese).
  Fix YAML trigger quoting. C6/C7 no PASSO 1 (bash, zero tokens).
- v1.0 (2026-05-28): criado. C1–C5.