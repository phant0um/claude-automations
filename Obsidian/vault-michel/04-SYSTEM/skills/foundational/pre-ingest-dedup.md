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

### Slug-Normalization Layer (2026-06-16 fix aplicado ao pipeline-diario.md)

**Problema:** F1.0b normaliza aspas curvas→retas (`norm()`) mas não normaliza
outros caracteres que divergem entre filename original e chave do manifest.
Arquivos com `$15,000` vs `15000`, `Cómo` vs `Como`, aspas duplas `"company brain"`
vs sem aspas, acentos — tudo gera falso "novo" no manifest check.

**Fix aplicado:** Adicionada função `slug()` no F1.0b do pipeline-diario.md v4.3
como última camada de verificação:

```bash
# slug normalizado: lowercase, remove tudo exceto alnum, colapsa hífens
slug() { python3 -c "import sys,re;d=sys.stdin.read().strip();d=re.sub(r'[^a-z0-9]','-',d.lower());d=re.sub(r'-+','-',d).strip('-');print(d,end='')"; }

# No loop de candidatos:
slug_stem=$(echo "$stem" | slug)
# ... após todos os outros checks falharem:
grep -qF "$slug_stem" /tmp/manifest_norm.json 2>/dev/null || echo "$f"
```

Isto pega casos onde o manifest guarda `clippings/karpathy-s-4-claude-md-rules-cut-claude-mistakes`
mas o find retorna `Karpathy's 4 CLAUDE.md rules cut Claude mistakes from 41% to 11%.md`.
O slug de ambos colapsa para o mesmo padrão alnum-hifen.

**Limitação:** slug matching é greedy — pode gerar falsos negativos (arquivo
realmente novo com slug coincidente a entry existente). Mitigação: slug é
última camada, após todas as outras checks mais precisas falharem.

---

### File Evaporation Pattern (2026-06-16)

**Problema recorrente:** `find` escaneia Clippings/ no início do pipeline e
gera `candidates_all.txt`. Mas entre o scan e o processamento (segundos a
minutos depois), arquivos somem do disco. Causas:

1. **Readwise sync** limpa/substitui arquivos durante o cycle
2. **Pipeline anterior** moveu arquivos para 08-ARCHIVE/ mas não atualizou manifest
3. **Obsidian sync** (iCloud/Dropbox) remove arquivos temporariamente

**Sintoma:** `[ -f "$f" ]` retorna false para caminhos em candidates_new.txt.
`cp` falha silenciosamente. Pipeline reporta "0 files ingested" mesmo com
N candidatos aprovados.

**Diagnóstico rápido:**

```bash
EXISTING=0; MISSING=0
while IFS= read -r f; do
  [ -f "$f" ] && EXISTING=$((EXISTING+1)) || MISSING=$((MISSING+1))
done < /tmp/candidates_concurso.txt
echo "Existing: $EXISTING, Missing: $MISSING"
```

Se MISSING > 0, arquivos evaporaram. Verificar 08-ARCHIVE/ para confirmar
que já foram processados:

```bash
# Para cada arquivo "missing", checar se está no archive
while IFS= read -r f; do
  [ -f "$f" ] && continue
  bn=$(basename "$f")
  find 08-ARCHIVE/ -name "$bn" 2>/dev/null | head -1
done < /tmp/candidates_new.txt
```

**Mitigação:** Não tratar file evaporation como erro — tratar como sinal de
que processamento retroativo é necessário (manifest entry + source page check).
O pipeline-diario deve ter um passo de "retroactive manifest reconciliation"
após detectar file evaporation.

---

## Integração com triagem-clipping

O hook reduz o custo da triagem manual: duplicatas óbvias não chegam nem ao candidatos_all.txt. Complementa (não substitui) o Step 0 do `triagem-clipping.md`.

---

### Manifest Key Dual-Registration (2026-06-18 fix)

**Problema:** F1.0b grep testa múltiplos formatos de key (`"basename.md"`,
`/basename"`, `"stem"`, `slug_stem`) mas o manifest-write registrava só
uma key (basename com extensão). Se o grep procurava sem extensão, não batia.
Triagem 2026-06-17: 19/19 falsos positivos por mismatch.

**Fix:** registrar AMBAS as variantes de key (com e sem extensão) no
manifest-write:

```bash
bn=$(basename "$f")          # "The Log Is the Agent.md"
bn_noext="${bn%.*}"           # "The Log Is the Agent"
jq --arg k "$bn" --arg k2 "$bn_noext" --arg h "$_hash" --arg d "$(date -I)" \
   --arg c "$category" --arg p "$_page" \
   '.sources[$k] = {hash: $h, ingested_at: $d, category: $c, pages_created: [$p]}
  | .sources[$k2] = {hash: $h, ingested_at: $d, category: $c, pages_created: [$p], alias_of: $k}' \
   .raw/.manifest.json > /tmp/manifest.tmp && mv /tmp/manifest.tmp .raw/.manifest.json
```

O `alias_of` field marca a secondary key como espelho, não duplicata real.
Isso alinha com F1.0b que testa ambos formatos via grep -F.

**Quando aplicar:** todo manifest-write pós-ingest (ingest-agent F2.6).
**Quando NÃO aplicar:** retroactive entries onde só uma variante é conhecida.

---

### Slug Prefix Length Tuning (2026-06-22 achado)

O second-pass check usa `slug[:30]` como prefix de busca. Para filenames longos
(títulos de blog posts com 60+ chars), 30 chars não é suficiente para match
único — retorna 0 encontrados mesmo quando source page existe.

**Sintoma:** `TRULY_NEW=0, RETRO=0` para todos os 157 candidatos, mas source
pages claramente existem no vault (1243+ pages). Second-pass não reduziu
falsos positivos.

**Fix:** Para batches grandes (>50 arquivos), aumentar prefix para 40-50 chars
ou usar match fuzzy (Levenshtein distance < 5):

```python
# Instead of: found = find(... -iname "*slug[:30]*" ...)
# Use longer prefix or fuzzy match:
from difflib import SequenceMatcher
def slug_match(s1, s2, threshold=0.6):
    return SequenceMatcher(None, s1, s2).ratio() > threshold

# For each candidate slug, compare against all source page stems
for page_stem in all_page_stems:
    if slug_match(candidate_slug, page_stem, 0.6):
        # Found existing source page — retroactive manifest entry
```

**Trade-off:** prefix mais longo = menos falsos negativos mas mais falsos
positivos. Para batches pequenos (<20), 30 chars é adequado. Para >50, usar
fuzzy match ou 40+ chars.

**Quando NÃO otimizar:** se file evaporation já removeu os C/D files (como
observado em 2026-06-22), o second-pass é menos crítico — evaporation age
como dedup natural.

---

### Slug Prefix Length Tuning (2026-06-22 achado)

**Problema:** O second-pass source-page check usa `slug:0:30` (primeiros 30 chars)
como prefix de busca. Para vaults com filenames longos (40-80 chars), 30 chars
é insuficiente — gera 0 matches mesmo quando source page existe.

**Exemplo real:** filename `Claude Code Skills The Hidden System Prompt Layer That Turns Claude Into a Senior Engineer.md`
→ slug = `claude-code-skills-the-hidden-system-prompt-layer...` (70+ chars)
→ source page: `claude-code-skills-the-hidden-system-prompt-layer-that-turns-claude-into-a-senior-engineer.md`
→ prefix 30 = `claude-code-skills-the-hidden-sy` — matcha, mas só por sorte.

Para `Sparser, Faster, Lighter Transformer Language Models`:
→ slug = `sparser-faster-lighter-transformer-language-models`
→ prefix 30 = `sparser-faster-lighter-transfor` — não matcha o full slug.

**Fix:** usar prefix 40-50 chars ou, melhor, buscar pelo slug completo:

```bash
# ANTES (30 chars — muito curto):
found=$(find 03-RESOURCES/sources/ -iname "*${slug:0:30}*" -type f 2>/dev/null | head -1)

# DEPOIS (50 chars — cobre maioria dos filenames):
found=$(find 03-RESOURCES/sources/ -iname "*${slug:0:50}*" -type f 2>/dev/null | head -1)

# MELHOR (slug completo + fallback first-30):
found=$(find 03-RESOURCES/sources/ -iname "*${slug}*" -type f 2>/dev/null | head -1)
[ -z "$found" ] && found=$(find 03-RESOURCES/sources/ -iname "*${slug:0:30}*" -type f 2>/dev/null | head -1)
```

**Trade-off:** prefix mais longo = menos falsos negativos, mais falsos positivos
(2 arquivos com mesmo prefix de 50 chars = raro mas possível). Para vault com
1200+ source pages, 50 chars é o sweet spot.

---

### F1.0 Pre-dedup False Positives — Hidden/System Files (2026-06-23 achado)

**Problema:** O F1.0 stem-dedup (`find ... | sed 's/\.[^.]*$//' | sort | uniq -d`)
detecta falso positivo em arquivos de sistema como `.manifest.json.bak` — o stem
`.manifest.json` existe tanto em `.raw/` quanto em `Clippings/`, mas são arquivos
de infraestrutura (backup, metadata), não duplicatas de conteúdo.

**Sintoma:** `uniq -d` reporta `.raw/.manifest.json.bak` como duplicata, mas não
há par real — é o backup do manifest aparecendo ao lado do original.

**Fix:** Filtrar hidden files e arquivos de metadata antes do stem comparison:

```bash
# ANTES (gera falsos positivos):
find .raw/ Clippings/ -type f | sed 's/\.[^.]*$//' | sort | uniq -d

# DEPOIS (exclui hidden files e metadata):
find .raw/ Clippings/ -type f \
  ! -name ".*" ! -name "*.json" ! -name "*.jsonl" ! -name "*.txt" \
  | sed 's/\.[^.]*$//' | sort | uniq -d
```

**Quando aplicar:** sempre que F1.0 rodar em diretórios que contêm arquivos de
metadata/manifest/backup alongside conteúdo real.

---

### Shell Variable Persistence Across terminal() Calls (2026-06-23 achado)

**Problema:** Quando a rotina daily-scan é executada via Hermes `terminal()` tool,
variáveis de shell (`NEW_COUNT`, etc.) **não persistem** entre chamadas separadas
de `terminal()`. Cada call inicia um shell fresh. O F1.0c e o Volume threshold flag
rodam em calls separadas — `NEW_COUNT` chega vazia no threshold check.

**Sintoma:** `daily-scan:  candidatos (abaixo de threshold 30)` — string vazia
onde deveria estar o número. O `-ge` comparison falha ou avalia incorretamente.

**Fix:** Recalcular `NEW_COUNT` do arquivo de output no início de cada call que
precisa do valor:

```bash
# No início do threshold check call:
NEW_COUNT=$(wc -l < /tmp/candidates_new.txt | tr -d ' ')
THRESHOLD=30
# ...então usar $NEW_COUNT normalmente
```

Alternativamente, executar F1.0b + F1.0c + threshold em uma única `terminal()`
call (um bloco bash contínuo), garantindo que todas as variáveis estejam no
mesmo escopo de shell.

**Quando aplicar:** qualquer rotina vault que use `terminal()` em múltiplas
chamadas e dependa de variáveis calculadas em calls anteriores. Verificar
sempre com `echo "NEW_COUNT=$NEW_COUNT"` antes do uso.

---

## Completion

- [ ] Dedup por basename similarity executada (F1.0)
- [ ] Cross-check campo source: das source pages existentes (F1.0c)
- [ ] Quasi-duplicatas com slug normalization verificadas
- [ ] File evaporation detectada (arquivos somem entre find e processamento)
- [ ] Output: lista de candidatos genuinely novos (não duplicatas)

## Failure modes

- **Basename-only check**: só comparar basename × manifest → slug temático divergente passa (F1.0c obrigatório)
- **Slug quoting bug**: inline python3 -c com regex quebra no macOS bash 3.x → usar arquivo externo
- **File evaporation misdiagnosis**: arquivos somem por Readwise sync, não por bug → confirmar antes de debugar
- **Short slug match**: slug < 40 chars gera falsos negativos no second-pass → usar 40+ chars ou fuzzy match

---

## Changelog## Changelog

- v1.5 (2026-06-23): + Shell Variable Persistence pitfall — terminal() calls
  não compartilham estado de shell. Variáveis calculadas em uma call (NEW_COUNT)
  chegam vazias na próxima. Recalcular do arquivo ou unir em única call.
  Achado: daily-scan run, threshold flag outputou string vazia.
  + F1.0 False Positive — hidden/system files (.manifest.json.bak) detectados
  como duplicatas por stem. Fix: excluir .* e *.json/*.jsonl do find.
- v1.4 (2026-06-22): + Slug Prefix Length Tuning — 30 chars insuficiente para
  filenames longos (40-80 chars), gera 0 matches no second-pass. Fix: 50 chars
  ou slug completo com fallback. Achado: pipeline-semanal 2026-06-22 run 2,
  157 candidatos, 0 retro matches (esperado ~10-20%).
- v1.3 (2026-06-18): + Manifest Key Dual-Registration pattern
  filenames longos, second-pass não encontra pages existentes. Fix: usar 40+
  chars ou fuzzy match (SequenceMatcher > 0.6). Achado: pipeline-semanal
  2026-06-22, 157 candidatos, 0 retro encontrados (esperado ~10-20).
- v1.3 (2026-06-18): + Manifest Key Dual-Registration pattern (alias_of) —
  fix para triagem-2026-06-17 (19/19 falsos positivos por mismatch de key
  com/sem extensão). Aplicado ao ingest-agent v1.4.0 manifest-write.
- v1.2 (2026-06-16): + Slug-Normalization Layer (fix aplicado ao pipeline-diario.md
  F1.0b — função slug() como última camada de check, pega $/acentos/aspas).
  + File Evaporation Pattern (arquivos somem do Clippings/ entre find e
  processamento — Readwise sync, Obsidian sync, pipeline anterior).
  Achado: 248 candidatos, 100% já ingeridos, mas file evaporation causou
  debugging desnecessário até confirmar que source pages já existiam.
- v1.1 (2026-06-16): + Dedup-Gap Pattern section (second-pass source-page check,
  retroactive manifest format, concurso-specific dedup, macOS filename quirks).
  Achado: 248 candidatos marcados como "novo" mas 100% já ingeridos (source pages
  existiam, arquivos em 08-ARCHIVE/A). Padrão recorrente desde 2026-06-10.
- v1.0 (2026-05-23): design doc criado. Implementação pendente — deploy requer
  configuração de hooks no settings.json.