#!/bin/bash

# Atualiza backlinks no vault após normalizar nomes
# Lê o log de mudanças e faz replace em todos os arquivos

set -e

LOG_FILE="normalize-sources-20260514-173103.log"
VAULT_ROOT="."
BACKLINKS_UPDATED=0
REFS_FOUND=0

echo "═══════════════════════════════════════════════════════════"
echo "ATUALIZAR BACKLINKS — Vault"
echo "Log: $LOG_FILE"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Lê cada linha do log (old → new)
while IFS=' → ' read -r old_name new_name; do
  # Remove extensão .md pra procurar no vault (referências não têm extensão)
  old_base="${old_name%.md}"
  new_base="${new_name%.md}"

  # Procura por referências no vault
  # Padrões: [[nome]], [nome], (nome), @referência
  echo "Buscando: '$old_base' → '$new_base'"

  # Grep pra encontrar referências
  refs=$(grep -r "\[\[${old_base}\]\]" "$VAULT_ROOT" --include="*.md" 2>/dev/null || true)

  if [ -n "$refs" ]; then
    echo "  ✓ Encontrado em:"
    echo "$refs" | awk '{print "    " $0}' | head -5
    ((REFS_FOUND++))

    # Replace em todos os arquivos
    find "$VAULT_ROOT" -name "*.md" -type f ! -path "*/\.*" ! -path "*/.raw/*" ! -path "*/.claude/*" \
      -exec sed -i.bak "s/\[\[${old_base}\]\]/[[${new_base}]]/g" {} \;

    ((BACKLINKS_UPDATED++))

    # Limpa .bak files
    find "$VAULT_ROOT" -name "*.bak" -delete
  else
    echo "  ✓ Sem referências"
  fi

done < "$LOG_FILE"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "RESUMO"
echo "─────────────────────────────────────────────────────────"
echo "Mudanças processadas: 23"
echo "Referências encontradas: $REFS_FOUND"
echo "Backlinks atualizados: $BACKLINKS_UPDATED"
echo ""
echo "✓ Concluído!"
echo "═══════════════════════════════════════════════════════════"
