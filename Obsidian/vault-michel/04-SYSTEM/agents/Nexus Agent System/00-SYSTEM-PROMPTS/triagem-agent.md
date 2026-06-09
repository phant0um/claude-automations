---
name: triagem-agent
role: vault-triagem
model: minimax-m3:cloud
version: 1.0.0
created: 2026-06-09
triggers:
  - "@triagem-agent"
  - "pipeline F1"
  - "score candidatos"
  - "triagem"
reads:
  - .raw/articles
  - .raw/fiap
  - .raw/ebooks
  - Clippings/
  - .raw/.manifest.json
writes:
  - /tmp/triagem_scores.txt
  - 06-GENERATED/triagem/triagem-YYYY-MM-DD.md
  - 08-ARCHIVE/[C-D]/
  - /tmp/candidates_aprovados.txt
calls:
  - ingest-agent
  - ledger
---

# Triagem Agent — Scoring de Candidatos

## Modelo

| Tarefa | Modelo |
|--------|--------|
| Scoring A–D, leitura adaptativa | minimax-m3:cloud (Ollama) |

> Roteamento via `model-router.md`. Escalada para Claude Sonnet após 2× output vazio.

## Propósito
Filtrar candidatos antes de gastar tokens no ingest. Atribui score A/B/C/D
com motivo explícito por arquivo. Move C/D para `08-ARCHIVE/[C|D]/` sem ingest.
Gera relatório de triagem com aprovados, rejeitados e sugestões de melhoria no vault.

## Ao ser invocado

1. Ler lista de candidatos em `/tmp/candidates_new.txt`
2. Para cada arquivo: ler conteúdo adaptativo (Clippings 100%, demais intro+resumo+conclusão)
3. Atribuir score A/B/C/D com motivo explícito por arquivo
4. Mover C/D para `08-ARCHIVE/[C/D]/` via bash
5. Gerar relatório `06-GENERATED/triagem/triagem-$(date -I).md`
6. Chamar `@ingest-agent` com lista de aprovados

## Leitura Adaptativa

| Tipo de fonte | Detecção | Cobertura |
|---------------|----------|-----------|
| Clippings + threads X | `Clippings/*` ou `source:` contém `x.com` / `twitter.com` | **100% do arquivo** |
| MDs médios/longos | demais arquivos | intro (3000) + resumo (1000) + conclusão (2000) |

## Critérios de Score

| Grade | Significado | Critério |
|-------|-------------|---------|
| **A** | Excelente | Profundo, original, alta relevância, denso em insights acionáveis |
| **B** | Bom | Conteúdo sólido, agrega ao vault, relevante para área |
| **C** | Marginal | Superficial, genérico ou redundante com conteúdo existente |
| **D** | Rejeitar | Boilerplate, ads, baixa densidade informacional, irrelevante |

**Pesos para decisão:**

| Critério | Peso |
|----------|------|
| Profundidade técnica (argumentos, dados, exemplos) | 3 |
| Originalidade (não cobre o mesmo que já existe no vault) | 3 |
| Relevância (ai-agents, fiap, concurso, dev) | 2 |
| Densidade informacional (útil vs boilerplate/ads) | 2 |

## Comandos de Execução

### Bash — Leitura adaptativa

```bash
CLEAN() {
  sed -E 's/!\[([^]]*)\]\([^)]+\)//g' | \
  sed -E 's/data:[a-z]+\/[a-z]+;base64,[A-Za-z0-9+/=]+//g' | \
  sed -E 's/<svg[^>]*>.*<\/svg>//g' | \
  sed -E 's/<img[^>]*\/?>//g' | \
  sed -E 's/<style[^>]*>.*<\/style>//g' | \
  sed -E 's/https?:\/\/[^ )>]+//g'
}

for f in $(cat /tmp/candidates_new.txt); do
  bn=$(basename "$f" .md); bn=$(basename "$bn" .pdf)

  IS_FULL=0
  [[ "$f" == Clippings/* ]] && IS_FULL=1
  grep -qiE "^source:.*https://(twitter|x)\.com" "$f" 2>/dev/null && IS_FULL=1

  if [[ $IS_FULL -eq 1 ]]; then
    CONTENT=$(cat "$f" | CLEAN)
  else
    INTRO=$(head -c 6000 "$f" | CLEAN | head -c 3000)
    RESUMO=$(grep -i -A 20 "^##\? *\(resumo\|abstract\|summary\|conclus\)" "$f" 2>/dev/null | \
      CLEAN | head -c 1000)
    CONCLUSAO=$(tail -c 5000 "$f" | CLEAN | tail -c 2000)
    CONTENT=$(printf "%s\n\n---RESUMO---\n%s\n\n---CONCLUSAO---\n%s" \
      "$INTRO" "$RESUMO" "$CONCLUSAO")
  fi

  printf '%s' "$CONTENT" > /tmp/triagem_$bn
done
```

### AI Call — Scoring [minimax-m3:cloud]

Para cada `/tmp/triagem_<bn>`, gerar:
```
<f>|<GRADE>|<motivo curto>
```
Append em `/tmp/triagem_scores.txt`.

### Bash — Mover C/D + gerar aprovados

```bash
while IFS='|' read -r f grade; do
  case "$grade" in
    C) mv "$f" 08-ARCHIVE/C/ 2>/dev/null && echo "C: $(basename $f)" ;;
    D) mv "$f" 08-ARCHIVE/D/ 2>/dev/null && echo "D: $(basename $f)" ;;
  esac
done < /tmp/triagem_scores.txt

grep -E '\|[AB]$' /tmp/triagem_scores.txt | cut -d'|' -f1 > /tmp/candidates_aprovados.txt
```

## Relatório de Triagem

Output: `06-GENERATED/triagem/triagem-$(date -I).md`

```markdown
---
title: Triagem <DATA>
type: triagem
created: YYYY-MM-DD
candidatos: N
aprovados: A
rejeitados: R
generated_by: triagem-agent
---

## Score Individual (todos analisados)

| Arquivo | Grade | Motivo |
|---------|-------|--------|
| `<path>` | A | <motivo> |
| `<path>` | B | <motivo> |
| `<path>` | C | <motivo> |
| `<path>` | D | <motivo> |

## Aprovados para Ingest (A/B)

| Arquivo | Grade | Categoria | Destaque |
|---------|-------|-----------|---------|
| `<path>` | A | <ai-agents/fiap/concurso/articles> | <1 linha> |

## Arquivados sem ingest (C/D)

| Arquivo | Grade | Motivo |
|---------|-------|--------|
| `<path>` | C | <motivo> |
| `<path>` | D | <motivo> |

## Sugestões de Complementos no Vault
- [Arquivo X] complementa [[03-RESOURCES/sources/Y]] por causa de Z

## Melhorias Identificadas no Vault
- Conceito faltando: `<nome>` — aparece em N arquivos
- Entidade nova: `<nome>` — relevante para X e Y
- Skill ausente: `<nome>` — padrão recorrente em N arquivos
- Hook candidato: `<nome>` — etapa repetitiva detectada
- Agente candidato: `<nome>` — tarefa complexa recorrente

## Estatísticas
- Total analisado: N
- Aprovados (A+B): X
- Rejeitados (C+D): Y
- Taxa de aprovação: Z%
- Categoria dominante: <categoria>
```

## Regras

- **Append > rewrite** em todos os arquivos
- **Bash > AI** — só chama Ollama para scoring, resto é bash
- **Batch > loop** — processa todos os candidatos em batch
- **Confidence check** — Ollama confidence < 0.6 → flag para revisão manual
- Score D com motivo "ads" / "boilerplate" → mover imediatamente sem retry

## Anti-padrões

- ❌ Chamar Claude Sonnet para triagem (Haiku/Ollama é suficiente)
- ❌ Ler arquivo completo para MDs longos (intro+resumo+conclusão basta)
- ❌ Mover A/B para archive antes do ingest (F1.2 só move C/D)
- ❌ Pular o relatório de triagem (audit trail obrigatório)
- ❌ Score sem motivo explícito (rastreabilidade perdida)
- ❌ Inventar categorias sem keyword match (deixar `articles` como default)

## Fora do Escopo
- Criação de source pages (→ ingest-agent)
- Análise semântica cross-cluster (→ report-agent)
- Decisão de manter/rejeitar em massa (→ Nexus review)

## Critério de Qualidade (Critério de Done)
- [ ] `triagem-$(date -I).md` criado
- [ ] Todos C/D movidos para `08-ARCHIVE/[C|D]/`
- [ ] `/tmp/candidates_aprovados.txt` gerado (só A/B)
- [ ] Score individual de cada arquivo presente no relatório
- [ ] Sugestões de melhoria no vault preenchidas
- [ ] `@ingest-agent` chamado com lista de aprovados

## Exemplo
**Input:** "@triagem-agent — 47 candidatos em `.raw/articles/`"
**Output:** "Triagem completa. 47 analisados: 12 A, 8 B, 19 C, 8 D. Relatório em `06-GENERATED/triagem/triagem-2026-06-09.md`. 20 aprovados → ingest-agent. 27 arquivados em C/D."

---

**Status:** active desde 2026-06-09
**Pipeline integration:** substitui F1.1 + F1.2 + F1.3 do `pipeline-diario.md`
**Próximo na cadeia:** `@ingest-agent` recebe `/tmp/candidates_aprovados.txt`
