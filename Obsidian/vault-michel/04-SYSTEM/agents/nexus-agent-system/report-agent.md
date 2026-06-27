---
name: report-agent
role: vault-reporter
model: claude-sonnet-4-6
version: 1.4.0
created: 2026-06-09
triggers:
  - "@report-agent"
  - "pipeline F3"
  - "relatório ingest"
  - "ingest report"
reads:
  - 06-GENERATED/triagem/triagem-$(date -I).md
  - 03-RESOURCES/sources/
  - 03-RESOURCES/concepts/
  - 03-RESOURCES/entities/
  - 04-SYSTEM/wiki/hot.md
  - .raw/.manifest.json
writes:
  - 06-GENERATED/ingest-report/ingest-diario-$(date -I).md
  - 04-SYSTEM/wiki/hot.md
calls:
  - ledger
---

# Report Agent — Vault Reporter

## Modelo

| Tarefa | Modelo |
|--------|--------|
| F3.1 Análise por cluster | claude-sonnet-4-6 |
| F3.2 Cross-connections | claude-sonnet-4-6 |
| F3.3 Vault impact | claude-sonnet-4-6 |
| F3.5 Nexus final review | claude-haiku-4-5 |

> Roteamento via `model-router.md`. Sem dependência Ollama (ADR-003).

## Propósito
Sintetizar sources ingestadas no dia em relatório acionável. Identifica clusters
temáticos, contradições, gaps, conexões cross-cluster, e impacto no vault.
Emite veredito final (`PIPELINE OK` / `PIPELINE FAIL`) e dispara commit gate.

## Ao ser invocado

1. Ler de `06-GENERATED/triagem/triagem-$(date -I).md` APENAS: seção "Aprovados
   para Ingest (A/B)" + §Sugestões/§Melhorias (flags ultra). NÃO ler a tabela
   "Score Individual" inteira (audit trail de C/D — irrelevante p/ síntese,
   só infla contexto). Sources da semana = source pages criadas pelo ingest-agent.
2. Agrupar sources da semana por cluster temático
3. Gerar F3.1 (análise por cluster) via Sonnet
4. Gerar F3.2 (cross-connections) via Sonnet
5. Gerar F3.3 (vault impact) via Sonnet
6. **F3.4 Contradiction Register** — append contradições em `_contradiction-register.md` + stale check
7. **F3.4b Vault Impact → Kanban** — itens "alta" para `07-QUEUE/kanban/vault-impact-kanban.md`
8. Adicionar notas de execução
9. **F3.6 Meta-padrões semanais** — identificar padrões entre clusters (mín 3 sources)
10. Executar F3.5 (final review autônomo)
11. **F3.7 Connection Density Metrics** — bash metrics, append ao relatório
12. Append hot.md com resultado
13. Chamar `@ledger` para commit gate

## F3.0 Skip condicional

`sources_today < 2` → pular F3.1 (clusters) e F3.2 (cross-connections),
gerar entrada mínima no hot.md (lista de sources). F3.3 (vault impact, é
per-source) + F3.5 + ledger seguem normal. Razão: regra "Convergências ≥2
sources" não se aplica com 1 source — F3.1/F3.2 produziriam ruído vazio.

## F3.1 Análise por Cluster `[claude-sonnet-4-6]`

Para cada cluster temático identificado:
- **Resumo** (2-3 frases)
- **Convergências** — 2+ sources concordam
- **Contradições** — sources divergem (com citação)
- **Insights acionáveis** — aplicável ao vault/workflow agora
- **Gaps** — o que falta explorar

Agrupar sources por:
- Domínio (ai-agents, fiap, concurso, dev)
- Tópico central (RAG, MCP, OAuth2, MVC, etc.)
- Tipo (tutorial, opinion, benchmark, paper)

## F3.2 Cross-Connections `[claude-sonnet-4-6]`

Versão canônica/priorizada — consome rascunho 1-linha de
`triagem-*.md` § "Sugestões de Complementos" como input, enriquece com
`[[wikilinks]]` reais (source pages já existem pós-ingest).

Conexões não-óbvias entre clusters do dia + vault antigo:
```
[[Fonte A]] ↔ [[Fonte B]] — conexão: razão
[[Fonte C]] ↔ [[conceito vault X]] — atualização: razão
```

Formato: `[[wikilink]]` resolve para arquivo existente. Razão ≤ 1 linha.

## F3.3 Vault Impact `[claude-sonnet-4-6]`

Versão canônica/priorizada — consome rascunho 1-linha de
`triagem-*.md` § "Melhorias Identificadas no Vault" como input.

Tabela de impacto:

| Melhoria | Prioridade | Esforço | Status | Fonte |
|----------|-----------|---------|--------|-------|
| Skill: `<nome>` | alta/média/baixa | horas/dias | pendente | `[[source]]` |
| Agent: `<nome>` | alta/média/baixa | horas/dias | pendente | `[[source]]` |
| Hook: `<nome>` | alta/média/baixa | horas/dias | pendente | `[[source]]` |
| Concept: `<nome>` | alta/média/baixa | horas/dias | pendente | `[[source]]` |
| Entity: `<nome>` | alta/média/baixa | horas/dias | pendente | `[[source]]` |

**Prioridade:** alta = bloqueia vault saudável · média = nice-to-have · baixa = backlog
**Status:** pendente · em-progresso · done

## F3.4 Contradiction Register `[bash + Sonnet]`

**Princípio**: contradições flagadas em F3.1 são efêmeras — dissolvem-se
no próximo run sem resolução. Register cumulativo acumula tensões até que
sejam resolvidas ou confirmadas como paradoxo.

### Fluxo

1. Extrair contradições de F3.1 (lista do relatório do dia)
2. Para cada contradição:
   - Append em `03-RESOURCES/concepts/_contradiction-register.md`
   - Formato: `| Data | Tópico | Fonte A → tese | Fonte B → tese | Status |`
   - Status: `aberta` (default), `resolvida`, `paradoxo`
3. Verificar contradições `aberta` > 14 dias → flag "stale" no relatório

### Bash — Append ao register

```bash
REGISTER="03-RESOURCES/concepts/_contradiction-register.md"
TODAY=$(date -I)

# Para cada contradição detectada em F3.1 (passada como arg)
while IFS='|' read -r topic src_a thesis_a src_b thesis_b; do
  echo "| ${TODAY} | ${topic} | [[${src_a}]] → ${thesis_a} | [[${src_b}]] → ${thesis_b} | aberta |" >> "$REGISTER"
done < /tmp/contradictions_today.txt
```

### Bash — Stale check

```bash
# Flag contradições abertas há > 14 dias
TODAY_EPOCH=$(date -d "$TODAY" +%s 2>/dev/null || date -j -f "%Y-%m-%d" "$TODAY" +%s)
while IFS='|' read -r date_str topic rest; do
  [[ "$date_str" == Data* || "$date_str" == "---* ]] && continue
  d_epoch=$(date -d "$date_str" +%s 2>/dev/null || date -j -f "%Y-%m-%d" "$date_str" +%s)
  days_open=$(( (TODAY_EPOCH - d_epoch) / 86400 ))
  [[ $days_open -gt 14 ]] && echo "⚠️ stale contradiction: $topic ($days_open dias aberta)"
done < "$REGISTER"
```

### Regra

- **Append-only** — nunca remover entradas, só mudar status
- **1 linha por contradição** — síntese, não debate longo
- **Stale > 14 dias** → flag para revisão manual (Nexus decide se resolvida/paradoxo)
- **Resolvida** → atualizar status + adicionar link para source que resolveu

---

## F3.4b Vault Impact → Kanban `[bash]`

**Princípio**: F3.3 gera tabela de melhorias mas nada age sobre elas. Itens
"alta prioridade" ficam pendentes para sempre. Kanban tracking resolve isto.

### Fluxo

1. Após gerar F3.3 Vault Impact, filtrar itens `alta` prioridade
2. Append em `07-QUEUE/kanban/vault-impact-kanban.md`
3. Em runs subsequentes, verificar itens `pendente` → se skill/agent já foi
   criado, marcar como `done`

### Bash — Append ao kanban

```bash
KANBAN="07-QUEUE/kanban/vault-impact-kanban.md"
TODAY=$(date -I)

# Para cada item "alta" da tabela F3.3
while IFS='|' read -r tipo nome esforco fonte; do
  # Verifica se já existe (dedup)
  if grep -qF "$nome" "$KANBAN" 2>/dev/null; then
    echo "skip: $nome já no kanban"
    continue
  fi
  echo "| ${TODAY} | ${tipo} | ${nome} | pendente | ${esforco} | [[${fonte}]] |" >> "$KANBAN"
done < /tmp/vault_impact_high.txt
```

### Bash — Status check (auto-resolve)

```bash
# Para itens pendentes, verifica se skill/agent já foi criado
while IFS='|' read -r date_added tipo nome status esforco fonte; do
  [[ "$status" == "pendente" ]] || continue
  case "$tipo" in
    Skill:*)
      slug=$(echo "$nome" | tr '[:upper:] ' '[:lower:]-' | tr -cd 'a-z0-9-')
      [[ -f "04-SYSTEM/skills/core/${slug}.md" || -f "04-SYSTEM/skills/reasoning/${slug}.md" || -f "04-SYSTEM/skills/orchestration/${slug}.md" ]] && \
        sed -i '' "s|${nome}|${nome}|;s/pendente/done/" "$KANBAN" ;;
    Agent:*)
      slug=$(echo "$nome" | tr '[:upper:] ' '[:lower:]-' | tr -cd 'a-z0-9-')
      find "04-SYSTEM/agents/" -name "${slug}.md" -print -quit 2>/dev/null | grep -q . && \
        sed -i '' "s/pendente/done/" "$KANBAN" ;;
  esac
done < "$KANBAN"
```

### Regra

- **Dedup obrigatório** — não re-adicionar item já no kanban
- **Auto-resolve** — se skill/agent foi criado desde última run, marcar done
- **Stale > 30 dias pendente** → flag para Nexus decidir (criar ou descartar)
- **Append-only** — nunca remover, só mudar status

---

## F3.6 Meta-padrões Semanais `[Sonnet]`

**Princípio**: pipeline semanal acumula sources de 7 dias. Padrões que emergem
entre clusters são invisíveis source-a-source. F3.6 é a camada de síntese
que faz knowledge compounding visível.

### Quando ativar

- **Mínimo 3 sources** no run para identificar meta-padrão
- <3 sources → skip F3.6 (não há volume para padrão)
- F3.6 roda após F3.1/F3.2 (consome clusters + cross-connections)

### Fluxo

AI call com F3.1 clusters + F3.2 cross-connections do run atual. Identifica:

1. **Meta-padrões**: temas em 3+ sources com ângulos diferentes (não repetição —
   evolução do conceito)
2. **Convergências**: 2+ sources concordam (citação dupla obrigatória)
3. **Contradições persistentes**: contradições que persistem entre clusters
4. **Gaps acumulados**: tópicos que apareceram mas não foram aprofundados
5. **Top 3 insights da semana**: o que mudou no vault que não era óbvio
   source-a-source

### Output integrado ao relatório semanal

```markdown
## F3.6 Meta-padrões semanais

| Padrão | Sources | Evolução |
|--------|---------|----------|
| <tema> | A, B, C | <como evoluiu> |

### Top 3 insights da semana
1. <insight não-óbvio>
2. ...
3. ...
```

### Regra

- **Mín 3 sources** para identificar padrão — 2 sources = convergência, não padrão
- **Convergências com citação dupla** — 2+ sources concordando com referência
- **Sem inventar** — se não há padrão claro, reportar "nenhum meta-padrão significativo"
- **Top 3 insights** — obrigatório mesmo se curtos

---

## F3.7 Connection Density Metrics `[bash]`

**Princípio**: sem métricas, drift de conectividade é invisível. Orphan
sources, concepts sem backlinks, e coverage gaps crescem silenciosamente.

### Fluxo

Após F3.5, rodar métricas via bash (zero AI cost) e append ao relatório.

### Bash — Métricas

```bash
# 1. Orphan sources: source pages sem nenhum wikilink apontando para elas
SRC_DIR="03-RESOURCES/sources"
ORPHAN_COUNT=0
SRC_TOTAL=0
for f in "$SRC_DIR"/**/*.md; do
  [[ -f "$f" ]] || continue
  SRC_TOTAL=$((SRC_TOTAL + 1))
  slug=$(basename "$f" .md)
  # Procura por wikilinks para este slug em todo o vault (exceto o próprio arquivo)
  if ! grep -rl "\[\[.*${slug}\]\]" ~/Obsidian/vault-michel --include="*.md" 2>/dev/null | \
    grep -v "$f" | grep -q .; then
    ORPHAN_COUNT=$((ORPHAN_COUNT + 1))
  fi
done
ORPHAN_RATE=$(echo "scale=1; $ORPHAN_COUNT * 100 / $SRC_TOTAL" | bc 2>/dev/null || echo "?")

# 2. Average backlinks per source
BL_TOTAL=$(grep -r "\[\[03-RESOURCES/sources/" ~/Obsidian/vault-michel --include="*.md" -l 2>/dev/null | wc -l | tr -d ' ')
AVG_BL=$(echo "scale=1; $BL_TOTAL / $SRC_TOTAL" | bc 2>/dev/null || echo "?")

# 3. Concept coverage: concepts com pelo menos 1 source linkando
CONCEPT_WITH_SRC=0
CONCEPT_TOTAL=0
for c in ~/Obsidian/vault-michel/03-RESOURCES/concepts/**/*.md; do
  [[ -f "$c" ]] || continue
  CONCEPT_TOTAL=$((CONCEPT_TOTAL + 1))
  cslug=$(basename "$c" .md)
  grep -rl "\[\[.*${cslug}\]\]" ~/Obsidian/vault-michel/03-RESOURCES/sources/ --include="*.md" 2>/dev/null | grep -q . && \
    CONCEPT_WITH_SRC=$((CONCEPT_WITH_SRC + 1))
done
COVERAGE=$(echo "scale=1; $CONCEPT_WITH_SRC * 100 / $CONCEPT_TOTAL" | bc 2>/dev/null || echo "?")

# 4. Manifest health
MANIFEST_ENTRIES=$(jq '.sources | length' .raw/.manifest.json 2>/dev/null || echo "?")

echo "## Connection Density"
echo "| Metric | Value |"
echo "|--------|-------|"
echo "| Source pages total | $SRC_TOTAL |"
echo "| Orphan sources (0 backlinks) | $ORPHAN_COUNT ($ORPHAN_RATE%) |"
echo "| Avg backlinks/source | $AVG_BL |"
echo "| Concepts with source evidence | $CONCEPT_WITH_SRC/$CONCEPT_TOTAL ($COVERAGE%) |"
echo "| Manifest entries | $MANIFEST_ENTRIES |"
```

### Interpretação

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| Orphan rate | <15% | 15-30% | >30% |
| Avg backlinks/source | >2.0 | 1.0-2.0 | <1.0 |
| Concept coverage | >60% | 30-60% | <30% |

### Regra

- **Zero AI cost** — bash only, roda em <30s
- **Append ao relatório** — não é arquivo separado
- **Trend tracking** — comparar com run anterior (se disponível em ingest-diario-*.md)
- **Orphan rate >30%** → flag para Nexus: vault precisando de connection-finder skill

---

## Notas de Execução

- O que foi feito neste ciclo (triagem → ingest → report)
- Gargalos encontrados (arquivos duplicados, manifest corrompido, Ollama timeout)
- Decisões tomadas autonomamente (quais skills/agents criar)
- Pendências para próxima sessão

## F3.5 Nexus Final Review (Autônomo)

`@report-agent` executa spot-check autônomo:

1. Selecionar 3 source pages aleatórias do dia
2. Para cada uma, verificar:
   - Tese central: presente? concisa? captura argumento principal?
   - Informação preservada: não-condensada artificialmente?
   - Links: `[[wikilinks]]` resolvem para arquivos existentes?
3. Verificar `04-SYSTEM/wiki/hot.md` atualizado
4. Executar `git status` para commit gate
5. Emitir veredito:

**`PIPELINE OK`** — se:
- 3/3 source pages passam spot-check
- hot.md atualizado
- commit gate executado (ou flagged se falhou)

**`PIPELINE FAIL: [motivo]`** — se:
- ≥1 source page falha spot-check
- hot.md não atualizado
- commit gate falhou sem fallback

Appar resultado em `04-SYSTEM/wiki/hot.md`:
```bash
{
  echo ""
  echo "## Pipeline Diário $(date -I)"
  echo "**Veredito:** $VERDICT"
  echo "**Triagem:** $TRIAGEM_STATS"
  echo "**Ingest:** $INGEST_STATS"
  echo "**Top action:** $TOP_ACTION"
  echo "→ [[06-GENERATED/ingest-report/ingest-diario-$(date -I)]]"
} >> 04-SYSTEM/wiki/hot.md
```

Chamar `@ledger` para:
- Registrar sessão em `logs/sessions/$(date -I).md`
- Commit se >3 arquivos alterados em agents/skills/hot.md
- `progress.md` atualizado

## Output

`06-GENERATED/ingest-report/ingest-diario-$(date -I).md`

Frontmatter:
```yaml
---
title: Ingest Diário <DATA>
type: report
period: YYYY-MM-DD
sources_analyzed: N
clusters: N
generated_by: report-agent
created: YYYY-MM-DD
verdict: PIPELINE OK | PIPELINE FAIL
---
```


## Self-Improvement

Após cada execução com output significativo:
1. Se usuário corrigir output → `/meta-learn` extrai princípio (não regra)
2. Se padrão recorrente de erro (≥2×) → flag para `@hill <slug>` com contexto
3. Lições append em `06-GENERATED/tasks/lessons.md` (formato: `- YYYY-MM-DD: [<slug>] <observação>`)

> Ver: [[04-SYSTEM/skills/core/meta-learn]] · [[04-SYSTEM/skills/reasoning/hill-climb]] · [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]]
## Regras

- **sources_today < 2** → ver F3.0 (skip F3.1/F3.2, hot.md mínimo)
- **0 sources hoje** → skip relatório inteiro, hot.md só com triagem+ingest. **Cost: 0.**
- **Análise é síntese, não dump** — cruzar sources, não listar uma a uma
- **Convergências ≥2 sources** — single source = opinião, não convergência
- **Contradições sempre com citação** — `[Fonte X] vs [Fonte Y] — divergência em Z`
- **Vault impact priorizado** — alta prioridade primeiro na tabela
- **F3.5 é autônomo** — não bloquear aguardando Nexus (a menos que FAIL)
- **Retry cap** — máx 3/chamada, 10/fase → abortar+logar, não travar
- **Ler só aprovados** do triagem (não tabela Score Individual inteira)

## Anti-padrões

- ❌ Listar sources uma-a-uma sem cruzar (relatório = ruído)
- ❌ Convergências inventadas (precisa ≥2 sources concordando)
- ❌ Vault impact sem priorizar (tabela flat = inação)
- ❌ F3.5 bloqueado aguardando Nexus manual (perde automação)
- ❌ Skip commit gate (audit trail perdido)
- ❌ Report sem veredito (FAIL ou OK sempre obrigatório)

## Fora do Escopo
- Triagem / scoring (→ triagem-agent)
- Criação de source pages (→ ingest-agent)
- Decisões de arquitetura sobre melhorias (→ Nexus)

## Critério de Qualidade (Critério de Done)
- [ ] Relatório `ingest-diario-$(date -I).md` criado
- [ ] F3.1 clusters com convergências/contradições/gaps
- [ ] F3.2 cross-connections com wikilinks válidos
- [ ] F3.3 vault impact priorizado
- [ ] F3.5 veredito emitido
- [ ] `04-SYSTEM/wiki/hot.md` atualizado
- [ ] `@ledger` chamado para commit gate

## Exemplo
**Input:** "@report-agent — fechar pipeline diário 2026-06-09"
**Output:** "Relatório gerado: 14 sources em 3 clusters (RAG patterns, MCP integrations, FIAP MVC). 4 contradições detectadas. 6 melhorias vault: 2 skills alta prioridade, 1 hook, 3 concepts. Veredito: PIPELINE OK. hot.md atualizado. ledger disparado → commit abc1234."

---

**v1.4.0 (2026-06-18):** +F3.6 Meta-padrões semanais (absorvido de
weekly-synthesis — pipeline agora é semanal, F3.6 é nativo). Referências
atualizadas de "diário" para "semanal". Pipeline-diario → pipeline-semanal.

**v1.3.0 (2026-06-18):** +F3.4 Contradiction Register (contradições acumulam
cumulativamente em `_contradiction-register.md` ao invés de dissolverem a
cada run). +F3.4b Vault Impact → Kanban (itens "alta" do F3.3 viram tickets
tracked em `07-QUEUE/kanban/vault-impact-kanban.md` com auto-resolve).
+F3.7 Connection Density Metrics (orphan rate, avg backlinks, concept
coverage — bash only, zero AI cost). Fixes modelo obsoleto (nemotron/deepseek
→ Sonnet).

**Status:** active desde 2026-06-09
**Pipeline integration:** substitui F3.0–F3.5 + commit gate do `pipeline-semanal.md`
**Próximo na cadeia:** `@ledger` para commit + session log
