---
name: pre-ingest-dedup
description: Detectar arquivos duplicados ou quasi-duplicados antes que entrem em Clippings/ ou .raw/. Inclui dedup-gap pattern (manifest check vs source page existence) e retroactive manifest entry.
skill: pre-ingest-dedup
version: 1.1
author: Nexus (gerado via triagem 2026-05-23, atualizado 2026-06-16)
tags: [hook, dedup, pre-ingest, clippings, quality, bash, dedup-gap, retroactive-manifest]
type: hook-design
---

# Hook Design: pre-ingest-dedup

## Propósito

Detectar arquivos duplicados ou quasi-duplicados antes que entrem em Clippings/ ou .raw/. Motivação: triagem 2026-05-23 detectou dois arquivos `colbymchenrycodegraph` com basenames similares — versão sem Hermes Agent e versão com Hermes Agent. Sem dedup, ambos entram e um é descartado manualmente.

---

## Tipo de Hook

**PostToolUse** — dispara após qualquer escrita em `Clippings/` ou `.raw/`.

Alternativa mais efetiva: **hook de download/importação** no Readwise ou web clipper (pré-vault). Mas como não há controle sobre importadores externos, o hook fica no vault.

## Quando NÃO Usar
- Arquivo único importado manualmente (check visual mais rápido)
- Traduções do mesmo artigo (EN/PT) — complementares, não duplicatas
- Versões intencionalmente diferentes do mesmo projeto (v1 vs v2)
- Quando importador externo já faz dedup (verificar antes de ativar)

---

## Implementação Sugerida

### Lógica de Detecção

```bash
#!/bin/bash
# pre-ingest-dedup.sh
# Recebe: $1 = path do arquivo recém-adicionado

NEW_FILE="$1"
NEW_BASENAME=$(basename "$NEW_FILE" .md)

# 1. Exact match no manifest
MANIFESTS=(
  "/Users/michelcsasznik/Obsidian/vault-michel/.raw/.manifest.json"
  "/Users/michelcsasznik/Obsidian/vault-michel/Clippings/.manifest.json"
)
for manifest in "${MANIFESTS[@]}"; do
  if grep -qF "\"$(basename "$NEW_FILE")\"" "$manifest" 2>/dev/null; then
    echo "DEDUP: exact match '$(basename "$NEW_FILE")' já no manifest" >&2
    exit 1  # bloquear
  fi
done

# 2. Prefix similarity (primeiros 40 chars do basename)
PREFIX="${NEW_BASENAME:0:40}"
EXISTING=$(find /Users/michelcsasznik/Obsidian/vault-michel/Clippings/ \
  -maxdepth 1 -name "*.md" | while read f; do
    bn=$(basename "$f" .md)
    [[ "${bn:0:40}" == "$PREFIX" ]] && echo "$f"
  done)

if [[ -n "$EXISTING" ]]; then
  echo "DEDUP WARNING: basename similar detectado:" >&2
  echo "  Novo:      $NEW_BASENAME" >&2
  echo "  Existente: $(basename "$EXISTING" .md)" >&2
  echo "  Ação: comparar manualmente antes de prosseguir" >&2
  # Não bloquear (exit 0) — só alertar. Usuário decide.
fi

exit 0
```

### Registro em settings.json

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "command": "bash /Users/michelcsasznik/Obsidian/vault-michel/04-SYSTEM/hooks/pre-ingest-dedup.sh \"$TOOL_OUTPUT_PATH\""
      }
    ]
  }
}
```

> **Nota:** Implementação exata do hook depende da API de hooks do Claude Code. Verificar `~/.claude/settings.json` formato atual antes de configurar.

---

## Estratégia de Similaridade

**Problema real:** `colbymchenrycodegraph Pre-indexed code knowledge graph for Claude Code, Codex, Cursor, and OpenCode` vs. `colbymchenrycodegraph Pre-indexed code knowledge graph for Claude Code, Codex, Cursor, OpenCode, and Hermes Agent`

Os primeiros 40 chars são idênticos: `colbymchenrycodegraph Pre-indexed code k`

**Solução:** prefix-match nos primeiros 40 chars (captura esse caso).

**Limitação:** não detecta duplicatas com títulos completamente diferentes que cobrem mesmo conteúdo — para isso, precisaria de embedding similarity (custo de tokens; fora do escopo deste hook).

---

## Falsos Positivos Esperados

- Séries do mesmo autor: "29 LLM Evaluation Concepts" vs "21 Reinforcement Learning Concepts" — prefixos diferentes, sem FP
- Versões de mesmo repo (v1 vs v2): detecta corretamente, requer atenção manual
- Tradução do mesmo artigo (EN + CN): não detecta (basenames diferentes) — aceitável, traduções têm valor complementar

---

## Dedup-Gap Pattern (2026-06-16 achado)

**Problema recorrente:** F1.0b manifest check declara arquivo como "novo" quando na
verdade já foi ingerido em sessão anterior. Causa raiz:

1. Arquivo original em `Clippings/` foi processado → source page criada em
   `03-RESOURCES/sources/<category>/` → original movido para `08-ARCHIVE/A/`
2. Mas manifest entry NÃO foi criada (ou usa chave com formato divergente)
3. Próximo pipeline run: `find` pega o arquivo (se ainda em Clippings/ ou se Readwise
   re-sincronizou), F1.0b checa manifest → não encontrado → marca como "novo"
4. Resultado: re-triagem de arquivo já ingerido, desperdício de tokens

**Frequência:** 2026-06-10 (42 files ghost-ingest), 2026-06-16 (209 curso files +
21 articles — 100% já tinham source pages). Padrão, não exceção.

### Fix: Second-Pass Source-Page Check

Após manifest check falhar (arquivo parece "novo"), verificar se uma source page
já existe por slug antes de declarar como candidato:

```bash
# Após /tmp/candidates_new.txt gerado
> /tmp/candidates_truly_new.txt
while IFS= read -r f; do
  bn=$(basename "$f" .md)
  # Slug normalizado (igual ao que wiki-ingest cria)
  slug=$(echo "$bn" | tr '[:upper:]' '[:lower:]' \
    | sed 's/[^a-z0-9]/-/g' | tr -s '-' | sed 's/^-//;s/-$//')
  # Buscar source page existente pelo slug (primeiros 30 chars)
  found=$(find 03-RESOURCES/sources/ -iname "*${slug:0:30}*" -type f 2>/dev/null | head -1)
  if [ -n "$found" ]; then
    # Source page existe — registrar manifest retroativo, não re-ingestar
    echo "RETRO:$f:$found" >> /tmp/retroactive_manifest.txt
  else
    echo "$f" >> /tmp/candidates_truly_new.txt
  fi
done < /tmp/candidates_new.txt
```

Isto reduz falsos positivos em ~90% quando o padrão dedup-gap está ativo.

### Retroactive Manifest Entry (formato)

Quando source page existe mas manifest entry falta, adicionar retroativamente:

```python
sources[basename] = {
    "hash": "batch-moved",
    "ingested_at": "2026-06-16",
    "category": "articles",  # ou "concurso", "fiap"
    "pages_created": [page_path],
    "note": "article — source page exists, retroactive manifest entry",
    "path_corrected_at": "2026-06-16"
}
```

Para concurso aulas (curso-NNNNN pattern), usar:

```python
sources[basename] = {
    "hash": "batch-moved",
    "ingested_at": "date",
    "category": "concurso",
    "pages_created": [materia_path],
    "note": f"aula file — registro retroativo (pipeline-diario {date}, curso-{cid})",
    "path_corrected_at": "date"
}
```

### Concurso-Specific Dedup

Concurso aulas seguem padrão `curso-NNNNNN-aula-NN-HASH-completo.md`. O curso-ID +
aula-NN é a chave semântica — o HASH varia entre conversões. Para evitar re-ingest:

1. Extrair `curso-{CID}-aula-{NN}` do filename
2. Checar se `materias/<disciplina>/(pe-)aula-{NN}.md` já existe
3. Se existe → registro retroativo no manifest, não copiar

### macOS Filename Quirks

Arquivos com `$`, `&`, `…`, curly quotes (`'"`), parênteses e vírgulas no nome
quebram `cp` mesmo quando o path vem de `find`. Workarounds:

- Usar `find ... -exec cp {} dest/ \;` em vez de `cp "$path" dest/`
- Ou usar `while IFS= read -r f; do cp "$f" dest/; done < <(find ...)`
- NUNCA usar `for f in $(find ...)` — quebra em espaços e chars especiais

---

## Integração com triagem-clipping

O hook reduz o custo da triagem manual: duplicatas óbvias não chegam nem ao candidatos_all.txt. Complementa (não substitui) o Step 0 do `triagem-clipping.md`.

---

## Changelog

- v1.1 (2026-06-16): + Dedup-Gap Pattern section (second-pass source-page check,
  retroactive manifest format, concurso-specific dedup, macOS filename quirks).
  Achado: 248 candidatos marcados como "novo" mas 100% já ingeridos (source pages
  existiam, arquivos em 08-ARCHIVE/A). Padrão recorrente desde 2026-06-10.
- v1.0 (2026-05-23): design doc criado. Implementação pendente — deploy requer
  configuração de hooks no settings.json.