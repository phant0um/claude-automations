#!/bin/bash

# Script de normalização de nomes em RESOURCES/sources
# Regras:
# 1. Remove números iniciais (não-semânticos)
# 2. Converte underscores em hífens
# 3. Trunca nomes >75 chars (mantém semântica)
# 4. Converte tudo pra lowercase (já é assim, mas garante)

set -e

SOURCES_DIR="./03-RESOURCES/sources"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
LOG_FILE="normalize-sources-${TIMESTAMP}.log"
DRY_RUN="${1:-true}"  # Default: true (mostra o que seria feito, não executa)

if [ "$DRY_RUN" != "true" ] && [ "$DRY_RUN" != "false" ]; then
  echo "Uso: $0 [true|false]"
  echo "  true  = dry-run (mostra mudanças, não executa)"
  echo "  false = executa mudanças reais"
  exit 1
fi

echo "═══════════════════════════════════════════════════════════"
echo "NORMALIZAR SOURCES: $SOURCES_DIR"
echo "Modo: $([ "$DRY_RUN" = "true" ] && echo "DRY-RUN" || echo "EXECUÇÃO REAL")"
echo "Log: $LOG_FILE"
echo "═══════════════════════════════════════════════════════════"
echo ""

normalize_name() {
  local name="$1"

  # Remove .md extension pra processar
  local base="${name%.md}"

  # Regra 1: Remove números iniciais simples (1-2 dígitos puros + hífen)
  # Remove: "3-formulas", "10-claude", "25-skills"
  # Mantém: "29k-stars" (tem letra), "100-things" (3+ dígitos)
  base=$(echo "$base" | sed -E 's/^[0-9]{1,2}-//')

  # Regra 2: Converte underscores em hífens
  base=$(echo "$base" | tr '_' '-')

  # Regra 3: Trunca em 75 chars se necessário (mantém semântica)
  local len=${#base}
  if [ "$len" -gt 75 ]; then
    # Tenta remover sufixos redundantes
    base=$(echo "$base" | sed 's/-part-[0-9].*$//' | sed 's/-continued.*$//')

    # Se ainda >75, corta
    len=${#base}
    if [ "$len" -gt 75 ]; then
      base=$(echo "$base" | cut -c1-75)
      # Remove hífen no final se houver
      base=$(echo "$base" | sed 's/-$//')
    fi
  fi

  # Regra 4: Lowercase (paranoia, já deve estar assim)
  base=$(echo "$base" | tr '[:upper:]' '[:lower:]')

  # Readdiona .md
  echo "${base}.md"
}

# Processa cada arquivo
CHANGES=0
TOTAL=0

while IFS= read -r file; do
  ((TOTAL++))
  normalized=$(normalize_name "$file")

  if [ "$file" != "$normalized" ]; then
    ((CHANGES++))

    if [ "$DRY_RUN" = "true" ]; then
      echo "CHANGE [$CHANGES]: $file → $normalized"
    else
      echo "Moving: $file → $normalized"
      mv "$SOURCES_DIR/$file" "$SOURCES_DIR/$normalized"
      echo "$file → $normalized" >> "$LOG_FILE"
      git add "$SOURCES_DIR/$file" "$SOURCES_DIR/$normalized" 2>/dev/null || true
    fi
  fi
done < <(cd "$SOURCES_DIR" && ls -1 *.md 2>/dev/null | sort)

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "RESUMO"
echo "─────────────────────────────────────────────────────────"
echo "Total arquivos: $TOTAL"
echo "Mudanças necessárias: $CHANGES"
echo ""

if [ "$DRY_RUN" = "true" ]; then
  echo "✓ Dry-run concluído. Nenhum arquivo foi modificado."
  echo ""
  echo "Para executar as mudanças, rode:"
  echo "  bash normalize-sources.sh false"
else
  echo "✓ Mudanças aplicadas!"
  echo "Log salvo em: $LOG_FILE"
  echo ""
  echo "Próximo passo: atualizar backlinks no vault"
  echo "  git diff --name-status pra verificar mudanças"
fi

echo "═══════════════════════════════════════════════════════════"
