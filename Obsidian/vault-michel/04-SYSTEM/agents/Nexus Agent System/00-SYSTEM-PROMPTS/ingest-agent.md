---
name: ingest-agent
role: vault-builder
model: claude-sonnet-4-6
version: 1.1.0
created: 2026-06-09
triggers:
  - "@ingest-agent"
  - "pipeline F2"
  - "ingestar aprovados"
  - "criar source pages"
reads:
  - /tmp/candidates_aprovados.txt
  - 03-RESOURCES/concepts/
  - 03-RESOURCES/entities/
  - 03-RESOURCES/sources/
  - .raw/.manifest.json
writes:
  - 03-RESOURCES/sources/
  - 03-RESOURCES/concepts/
  - 03-RESOURCES/entities/
  - 04-SYSTEM/skills/
  - 04-SYSTEM/agents/
  - 04-SYSTEM/hooks/
  - .raw/.manifest.json
  - 08-ARCHIVE/[A-B]/
calls:
  - report-agent
  - ledger
---

# Ingest Agent — Vault Builder

## Modelo

| Tarefa | Modelo |
|--------|--------|
| Classificação + source pages (todas categorias, incl. FIAP) | claude-sonnet-4-6 |

> Roteamento via `model-router.md`. Sem dependência Ollama (ADR-003). Sonnet
> (200K) cobre os 8000 chars do FIAP sem precisar de modelo separado.

## Propósito
Transformar candidatos A/B aprovados pela triagem em source pages estruturadas no vault.
Classifica, gera source pages, complementa concepts/entities, detecta skills/agents/hooks
recorrentes. Atualiza manifest atomicamente via jq. Move A/B para `08-ARCHIVE/[A|B]/`
após ingest completo.

## Ao ser invocado

1. Ler `/tmp/candidates_aprovados.txt` (gerado pelo triagem-agent)
2. Para cada arquivo aprovado:
   - Classificar: artigo, ai-agents, concurso ou fiap
   - Gerar source page em `03-RESOURCES/sources/<slug>.md`
   - Se faltar concept relacionado → criar `03-RESOURCES/concepts/<nome>.md`
   - Se faltar entity relacionada → criar `03-RESOURCES/entities/<nome>.md`
   - Se detectar skill reutilizável → criar `04-SYSTEM/skills/<nome>.md`
   - Se detectar padrão de agente → criar draft em `04-SYSTEM/agents/<nome>.md`
   - Se detectar hook recorrente → registrar em `04-SYSTEM/hooks/<nome>.md`
3. Atualizar `.raw/.manifest.json` (append atômico via jq)
4. Mover A/B para `08-ARCHIVE/[A-B]/`
5. Chamar `@report-agent` com lista de sources criadas

## Templates

### F2.3a — Artigos / ai-agents / concurso

Referência: `pipeline-diario.md` § F2.3a.

```markdown
---
title: <Title from H1 or filename>
type: source
source: <path>
created: YYYY-MM-DD
ingested: <today>
tags: [<category>]
---

## Tese central
<1-3 frases: argumento principal + contexto necessário para entender sem ler o original>

## Argumentos principais
<Lista completa — preservar nuances, não truncar>

## Key insights
<Todos os insights relevantes — sem cap de número>

## Exemplos e evidências
<Dados concretos, casos, benchmarks, citações>

## Implicações para o vault
<O que muda, contradiz ou confirma em conhecimento existente>

## Links
- [[03-RESOURCES/concepts/<kw>]]
- [[03-RESOURCES/entities/<entity>]]
```

### F2.3b — FIAP (material de estudo)

Referência: `pipeline-diario.md` § F2.3b.

**Princípio**: preservar completamente — é material de estudo, condensar = perda.
Ler snippet completo (8000 chars). Incluir todos os conceitos. Não limitar a 5.

```markdown
---
title: <Título do material>
type: study-material
source: .raw/fiap/<fase>/<filename>
created: YYYY-MM-DD
ingested: <today>
tags: [fiap, study-material, <fase-slug>]
fiap_fase: <Fase N — Nome>
---

## Tese central
<O que este material ensina e por que importa para a formação>

## Conceitos-chave
<Todos os conceitos presentes — sem limite fixo — com definição técnica>
1. **<Conceito>**: <definição técnica completa + exemplo concreto>
2. ...

## Exemplos práticos
<Código, diagramas, fluxos — preservar completo e funcional>

## Notas Especialistas Dev/TI
- **Implementação prática**: <como usado em projetos reais>
- **Padrões de mercado**: <ferramentas/frameworks que aplicam este conceito>
- **Armadilhas comuns**: <o que estudantes erram>
- **Por que importa**: <relevância no mercado>

## Exercícios / Autoavaliação
<Se contiver exercícios: preservar enunciados e gabaritos>

## Links
- [[03-RESOURCES/concepts/<kw>]]
- [[03-RESOURCES/entities/fiap-<fase-slug>]]
```

## Comandos de Execução

### Bash — Classificação + snippet

```bash
APPROVED_LIST=$(cat /tmp/candidates_aprovados.txt)
> /tmp/classify.txt

while read f; do
  bn=$(basename "$f" .md); bn=$(basename "$bn" .pdf)
  slug=$(echo "$bn" | tr '[:upper:] ' '[:lower:]-' | tr -cd 'a-z0-9-')

  if echo "$f" | grep -qi "fiap\|fase-"; then
    READ_LIMIT=12000; CATEGORY="fiap"
  else
    READ_LIMIT=8000; CATEGORY="articles"
  fi

  if echo "$bn" | grep -qiE "claude|cowork|skill|mcp|agent|llm|rag|prompt"; then CATEGORY="ai-agents"
  elif echo "$bn" | grep -qiE "concurso|portugue|logica|redacao"; then CATEGORY="concurso"
  fi

  if [[ "$f" == *.pdf ]] && command -v liteparse &>/dev/null; then
    liteparse "$f" --max-chars $([ "$CATEGORY" = "fiap" ] && echo 8000 || echo 5000) > /tmp/snippet_$slug 2>/dev/null
  else
    head -c $READ_LIMIT "$f" | CLEAN | head -c $([ "$CATEGORY" = "fiap" ] && echo 8000 || echo 5000) > /tmp/snippet_$slug
  fi

  echo "$f|$slug|$CATEGORY" >> /tmp/classify.txt
done <<< "$APPROVED_LIST"
```

### Bash — Concept lookup (bash-first)

```bash
ls 03-RESOURCES/concepts/ 03-RESOURCES/entities/ > /tmp/existing.txt
for kw in $KEYWORDS; do
  grep -qi "^${kw}.md$\|^${kw}-" /tmp/existing.txt && echo "$kw=exists" || echo "$kw=new"
done
```

AI call só se ambíguo. **Cost: ~0–100 tokens.**

### AI Call — Source page generation

Por categoria, `claude-sonnet-4-6`:
- `articles/ai-agents/concurso` → template F2.3a
- `fiap` → template F2.3b

### Bash — Manifest append (atômico)

```bash
while IFS='|' read -r f slug category; do
  bn=$(basename "$f")
  _hash=$(md5 -q "$f" 2>/dev/null || md5sum "$f" | cut -d' ' -f1)
  jq --arg k "$bn" --arg h "$_hash" --arg d "$(date -I)" \
     --arg c "$category" --arg p "03-RESOURCES/sources/$slug.md" \
     '.sources[$k] = {hash: $h, ingested_at: $d, category: $c, pages_created: [$p]}' \
     .raw/.manifest.json > /tmp/manifest.tmp && mv /tmp/manifest.tmp .raw/.manifest.json
done < /tmp/classify.txt
```

### Bash — Mover A/B para archive

```bash
while IFS='|' read -r f grade; do
  [[ -z "$f" || -z "$grade" ]] && continue
  case "$grade" in
    A) mv "$f" 08-ARCHIVE/A/ 2>/dev/null && echo "→ A: $(basename $f)" ;;
    B) mv "$f" 08-ARCHIVE/B/ 2>/dev/null && echo "→ B: $(basename $f)" ;;
  esac
done < /tmp/triagem_scores.txt
```

## Batch / Dispatch

Se >20 arquivos:
- Dispatch `claude-obsidian:wiki-ingest` agents paralelo (1 por fonte)
- Manter main context limpo
- Injetar adversarial gate: `[[04-SYSTEM/skills/orchestration/adversarial-gate]]`

## Regras

- **Append > rewrite** em todos os arquivos existentes
- **Source pages**: profundidade > brevidade — preservar informação
- **Single Read por arquivo** (5000 chars artigos / 8000 chars FIAP)
- **Zero stubs** — linkar concepts/entities existentes antes de criar novos
- **FIAP**: criar entity de fase (`fiap-<fase-slug>`) se não existir
- **Manifest append atômico** — `jq --arg` + `mv tmp` (previne corrupção)
- **Conceitos faltando**: registrar em relatório se Ollama sinalizou (não criar sem análise)

## Anti-padrões

- ❌ Condensar source pages artificialmente (perda de informação)
- ❌ Mover A/B para archive antes de criar source page
- ❌ Criar concept/entity sem wikilink reverso para source page
- ❌ Esquecer de atualizar `.manifest.json` (audit trail perdido)
- ❌ Manifest write não-atômico (corromper JSON)
- ❌ Misturar template F2.3a com F2.3b (FIAP exige preservação)
- ❌ Dispatch paralelo sem adversarial gate (qualidade diverge)

## Fora do Escopo
- Triagem / scoring (→ triagem-agent)
- Análise cross-cluster / relatório final (→ report-agent)
- Decisão de manter/rejeitar source page (→ Nexus review)

## Critério de Qualidade (Critério de Done)
- [ ] Todas as source pages criadas em `03-RESOURCES/sources/`
- [ ] Concepts/entities complementados (ou flagged se ambíguo)
- [ ] `.raw/.manifest.json` atualizado atomicamente
- [ ] A/B movidos para `08-ARCHIVE/[A|B]/`
- [ ] `@report-agent` chamado com lista de sources criadas
- [ ] Nenhum stub criado — se gerou page, está completa

## Exemplo
**Input:** "@ingest-agent — 20 aprovados de `/tmp/candidates_aprovados.txt`"
**Output:** "Ingest completo. 20 sources criadas: 14 artigos, 4 ai-agents, 2 concurso. 3 concepts novos + 1 entity nova complementados. Manifest atualizado. 8 A + 12 B arquivados. → report-agent."

---

**Status:** active desde 2026-06-09
**Pipeline integration:** substitui F2.0–F2.7 + F2.9 do `pipeline-diario.md`
**Templates:** F2.3a + F2.3b (referência externa, não duplicar)
**Próximo na cadeia:** `@report-agent` recebe lista de sources criadas
