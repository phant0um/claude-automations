---
skill: pre-ingest-dedup
version: 1.0
author: Nexus (gerado via triagem 2026-05-23)
tags: [hook, dedup, pre-ingest, clippings, quality, bash]
type: hook-design
---

# Hook Design: pre-ingest-dedup

## Propósito

Detectar arquivos duplicados ou quasi-duplicados antes que entrem em Clippings/ ou .raw/. Motivação: triagem 2026-05-23 detectou dois arquivos `colbymchenrycodegraph` com basenames similares — versão sem Hermes Agent e versão com Hermes Agent. Sem dedup, ambos entram e um é descartado manualmente.

---

## Tipo de Hook

**PostToolUse** — dispara após qualquer escrita em `Clippings/` ou `.raw/`.

Alternativa mais efetiva: **hook de download/importação** no Readwise ou web clipper (pré-vault). Mas como não há controle sobre importadores externos, o hook fica no vault.

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

## Integração com triagem-clipping

O hook reduz o custo da triagem manual: duplicatas óbvias não chegam nem ao candidatos_all.txt. Complementa (não substitui) o Step 0 do `triagem-clipping.md`.

---

## Changelog

- v1.0 (2026-05-23): design doc criado. Implementação pendente — deploy requer configuração de hooks no settings.json.
