---
name: vault-reconcile
name: vault-reconcile
role: vault-reconciler
model: nemotron-3-ultra:cloud
version: 1.0.0
created: 2026-06-09
triggers:
  - "@vault-reconcile"
  - "reconciliar sources"
  - "audit archive vs vault"
  - "vault reconcile"
reads:
  - 08-ARCHIVE/A/
  - 08-ARCHIVE/B/
  - 03-RESOURCES/sources/
  - 03-RESOURCES/concepts/
  - 03-RESOURCES/entities/
  - .raw/.manifest.json
writes:
  - 06-GENERATED/audits/vault-reconcile-YYYY-MM-DD.md
  - 03-RESOURCES/sources/<slug>.md   # append only — nunca rewrite
  - 03-RESOURCES/concepts/<nome>.md  # só se faltar
  - 03-RESOURCES/entities/<nome>.md  # só se faltar
calls:
  - ledger
---

# Vault Reconcile — Reconciliação Archive vs Vault

## Modelo

| Tarefa | Modelo | Motivo |
|--------|--------|--------|
| Varredura archive vs vault | nemotron-3-ultra:cloud | 1M contexto (95% Ruler@1M) — ideal para archive completo |

> Roteamento via `model-router.md`. Escalada para Claude Sonnet após 2× output vazio.
> Nemotron 3 Ultra selecionado por causa do 1M contexto — permite varrer archive inteiro em uma sessão.

## Propósito
Detectar drift entre raws arquivados em `08-ARCHIVE/[A|B]/` e source pages geradas em
`03-RESOURCES/sources/`. Complementar pages desatualizadas via append, criar concepts/entities
faltantes, registrar wikilinks quebrados. **Append > rewrite**: nunca destruir informação.

## Quando executar
- Semanal (recomendado: sexta à noite)
- Após `report-agent` se detectou gaps
- Antes de mudanças estruturais no vault
- Quando vault parecer "desatualizado" (conceitos não-linkam, entities órfãs)

## Ao ser invocado

1. Varrer `08-ARCHIVE/A/` (prioridade — maior valor)
2. Varrer `08-ARCHIVE/B/`
3. Para cada arquivo em archive:
   - Localizar source page correspondente em `03-RESOURCES/sources/`
   - Comparar: a source page cobre o conteúdo relevante do raw?
   - Se faltar conteúdo importante → **append** na source page
   - Se faltar concept → criar `03-RESOURCES/concepts/<nome>.md`
   - Se faltar entity → criar `03-RESOURCES/entities/<nome>.md`
   - Se wikilink quebrado → registrar no relatório
   - Se raw não tiver source page → registrar para ingest futuro
4. Gerar `06-GENERATED/audits/vault-reconcile-$(date -I).md`
5. Chamar `@ledger` para registrar auditoria

## Estratégia de Varredura

### Bash — Listar arquivos

```bash
# A/ primeiro (prioridade alta)
find 08-ARCHIVE/A/ -maxdepth 1 -type f -name "*.md" | sort > /tmp/reconcile_a.txt
find 08-ARCHIVE/B/ -maxdepth 1 -type f -name "*.md" | sort > /tmp/reconcile_b.txt

# Carregar sources existentes
ls 03-RESOURCES/sources/*.md | xargs -n1 basename | sed 's/.md$//' > /tmp/existing_sources.txt
```

### Bash — Mapear raw → source

```bash
> /tmp/reconcile_map.txt
while read raw; do
  bn=$(basename "$raw" .md)
  slug=$(echo "$bn" | tr '[:upper:] ' '[:lower:]-' | tr -cd 'a-z0-9-')

  # Procurar source page correspondente
  if grep -qFx "$slug" /tmp/existing_sources.txt; then
    echo "$raw|03-RESOURCES/sources/$slug.md|exists" >> /tmp/reconcile_map.txt
  else
    echo "$raw|missing|no-source" >> /tmp/reconcile_map.txt
  fi
done < /tmp/reconcile_a.txt
# Repetir para /tmp/reconcile_b.txt
```

### AI Call — Comparação raw vs source [nemotron-3-ultra:cloud]

Para cada par `raw|source`:
- Ler raw completo (até 8000 chars para FIAP, 5000 para artigos)
- Ler source page completa
- Diff semântico: o que está no raw mas NÃO está na source?
- Categorizar gap:
  - `missing-concept` → criar `03-RESOURCES/concepts/<nome>.md`
  - `missing-entity` → criar `03-RESOURCES/entities/<nome>.md`
  - `missing-section` → append seção na source page
  - `broken-wikilink` → registrar (não corrigir automaticamente)
  - `ok` → nenhuma ação

## Append em Source Pages

**Regra de ouro**: append-only. Nunca reescrever seção existente.

Formato do append:
```markdown

---

## Complemento de Reconciliação <YYYY-MM-DD>

**Origem:** `[[08-ARCHIVE/A/<filename>]]` · vault-reconcile

### <Título da seção adicionada>
<Conteúdo faltante, preservado do raw>
```

Wikilinks para concepts/entities novos devem resolver.

## Relatório de Auditoria

Output: `06-GENERATED/audits/vault-reconcile-$(date -I).md`

```markdown
---
title: Vault Reconcile <DATA>
type: audit
created: YYYY-MM-DD
generated_by: vault-reconcile
audit_scope: A/ + B/
---

## Resumo Executivo
- Total raws varridos: N
- Source pages existentes: X
- Source pages faltando: Y
- Conceitos complementados: C
- Entidades criadas: E
- Wikilinks quebrados: W
- Score de cobertura: X/N (Z%)

## Tabela Raw → Source

| Arquivo raw | Source page | Status | Ação tomada |
|-------------|-------------|--------|-------------|
| `08-ARCHIVE/A/foo.md` | `03-RESOURCES/sources/foo.md` | ok | nenhuma |
| `08-ARCHIVE/A/bar.md` | `03-RESOURCES/sources/bar.md` | desatualizado | +2 sections, +1 concept |
| `08-ARCHIVE/A/baz.md` | — | sem page | flagged para ingest |
| `08-ARCHIVE/B/qux.md` | `03-RESOURCES/sources/qux.md` | broken-wikilink | flag `[[x]]` em seção Y |

## Concepts Faltando (criados)

| Concept | Aparece em | Source pages atualizadas |
|---------|-----------|--------------------------|
| `<nome>` | N raws | [[source-a]], [[source-b]] |

## Entities Faltando (criadas)

| Entity | Aparece em | Source pages atualizadas |
|--------|-----------|--------------------------|
| `<nome>` | N raws | [[source-c]] |

## Wikilinks Quebrados (registrados)

| Wikilink | Aparece em | Motivo | Ação recomendada |
|----------|-----------|--------|------------------|
| `[[x]]` | [[source-d]] § Y | arquivo não existe | criar concept X ou corrigir link |

## Raws sem Source Page (flagged para ingest futuro)

| Raw | Categoria | Sugestão |
|-----|-----------|----------|
| `08-ARCHIVE/A/orphan.md` | ai-agents | dispatch ingest-agent |

## Top 5 Sources que Mais Precisam de Complemento

1. `[[source-x]]` — 4 sections faltando, 2 concepts ausentes
2. `[[source-y]]` — 3 seções desatualizadas
3. `[[source-z]]` — wikilinks quebrados em § A e § B
4. `[[source-w]]` — conceitos não-linkados
5. `[[source-v]]` — sem entity principal linkada

## Estatísticas

- A/ varrido: N arquivos
- B/ varrido: M arquivos
- Appends executados: P
- Concepts criados: C
- Entities criadas: E
- Wikilinks quebrados: W (registrados, não corrigidos)
- Score de cobertura: X/N (Z%)
- Próxima reconciliação: <sugestão>
```

## Regras

- **Append > rewrite em tudo** — preservar informação sempre
- **Varrer A/ antes de B/** — A tem maior valor (aprovados com score máximo)
- **Preservar informação > condensar** — complement via append, nunca compactar
- **Não criar stub** — se criar concept/entity, criar completo
- **Wikilinks quebrados**: registrar, não corrigir (correção requer decisão)
- **Raws sem source**: flagged para `@ingest-agent`, não ingestar automaticamente
- **Execução periódica**: semanal (não diária — Nemotron uso "High" no Ollama Cloud)

## Anti-padrões

- ❌ Reescrever source page (destrói informação + perde audit trail)
- ❌ Corrigir wikilink quebrado sem decisão (pode ser conceitualmente errado)
- ❌ Ingestar raws sem source page (fora do escopo de reconcile)
- ❌ Varrer B/ antes de A/ (A tem prioridade)
- ❌ Criar concept/entity stub (zero stubs)
- ❌ Skip relatório de auditoria (audit trail é o produto principal)
- ❌ Rodar reconcile diariamente (custo desnecessário)

## Fora do Escopo
- Triagem / scoring (→ triagem-agent)
- Criar source pages do zero (→ ingest-agent)
- Corrigir wikilinks quebrados (requer decisão Nexus)
- Ingestar raws órfãos (→ ingest-agent via report)

## Critério de Qualidade (Critério de Done)
- [ ] `vault-reconcile-$(date -I).md` gerado
- [ ] A/ e B/ varridos
- [ ] Tabela raw → source com status preenchido
- [ ] Concepts/entities faltantes criados (completos, não stub)
- [ ] Source pages desatualizadas complementadas via append
- [ ] Wikilinks quebrados registrados (não corrigidos)
- [ ] Raws órfãos flagged para ingest
- [ ] Score de cobertura calculado
- [ ] `@ledger` chamado para registrar auditoria

## Exemplo
**Input:** "@vault-reconcile — auditoria semanal"
**Output:** "Reconcile completo. A/ 47 raws varridos: 39 ok, 6 desatualizados (5 concepts + 2 entities criados), 2 sem source (flagged). B/ 28 raws: 25 ok, 3 desatualizados. 4 wikilinks quebrados registrados. Score: 64/75 (85%). Relatório em `06-GENERATED/audits/vault-reconcile-2026-06-09.md`. ledger disparado."

---

**Status:** active desde 2026-06-09
**Pipeline integration:** auditoria semanal independente (não roda no pipeline diário)
**Decisão:** adr-nx-002-vault-reconcile-agent.md
**Schedule:** sexta à noite (sugestão) · manual `@vault-reconcile` quando necessário
