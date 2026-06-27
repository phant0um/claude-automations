---
title: "Adversarial Gate v2 — Batch Ingest Quality Gate"
name: adversarial-gate-v2
description: "Use when running batch ingest (>20 source pages) in pipeline-semanal. Injects adversarial subagent that validates batch-level quality: link integrity, categorization accuracy, placeholder detection, concept absorption completeness. Prevents 'beautiful nonsense' at scale."
skill: adversarial-gate-v2
version: 2.0
trigger: "@adversarial-gate-v2 [batch] or auto-triggered when ingest >20 files"
model: claude-sonnet-4-6
tags: [quality-gate, adversarial, batch, ingest, pipeline, link-integrity, anti-pattern]
source: "Evolved from [[04-SYSTEM/skills/orchestration/adversarial-gate]] v1.1"
---

# Skill: Adversarial Gate v2 — Batch Ingest

## Propósito

Adversarial gate para batches de ingest >20 source pages. Enquanto v1 valida
tarefas de desenvolvimento tarefa-a-tarefa, v2 valida qualidade de batch:
links quebrados, categorização errada, placeholders, concept absorption
incompleta. Previne "beautiful nonsense" — batches que parecem completos
mas têm defeitos sistêmicos invisíveis source-a-source.

**Diferença de v1**: v1 = gate por tarefa em planos de dev. v2 = gate
pós-batch em pipeline de ingest. v1 = in-flight. v2 = post-batch.

**Diferença de ingest-verify**: ingest-verify roda per-file. adversarial-gate-v2
roda no agregado do batch — detecta problemas sistêmicos que per-file não vê.

---

## Condições de Ativação

- **Obrigatório**: batch ingest >20 source pages no pipeline-semanal
- **Opcional**: batch <20 se qualidade é crítica (meta-coaching, AGENTS.md changes)
- **Auto-trigger**: se pipeline-semanal detecta >20 aprovados, disparar antes do commit

---

## Protocolo

### Fase 1 — Coletar amostra representativa

3 source pages aleatórias + 3 com maior score + 3 com menor score (dentro de A/B).

```python
import random
random.seed(42)
batch = open('/tmp/sources_created.txt').readlines()
sample = random.sample(batch, min(9, len(batch)))
# Adicionar 3 maior score e 3 menor score se disponível
```

### Fase 2 — Validar 5 dimensões (subagente isolado)

Subagente recebe as 9 source pages + critérios abaixo. Contexto ISOLADO
(sem história da sessão do pipeline).

```
Você é um auditor adversarial de batch ingest. Seu papel é encontrar
por que este batch NÃO está completo. Seja cético.

DIMENSÕES A AVALIAR:

1. LINK INTEGRITY: quantos wikilinks nas 9 pages resolvem para arquivos
   existentes? Se >5% quebrados → FAIL.

2. CATEGORIZAÇÃO: as 9 pages estão no diretório correto?
   (ai-agents → 03-RESOURCES/sources/, concurso → 02-AREAS/concurso/sources/,
   fiap → 02-AREAS/fiap/sources/). Se >1 categoria errada → FAIL.

3. PLACEHOLDER DETECTION: Score A pages têm Minha Síntese com conteúdo real?
   Se qualquer Score A tem "A ser analisado" ou "placeholder" → FAIL.

4. CONCEPT ABSORPTION: concepts linkados têm seção ## Evidências com
   entrada do batch atual? Se >50% dos concepts sem evidência → WARN.

5. TESSE CENTRAL QUALITY: cada page tem ao menos 1 parágrafo que captura
   o argumento principal? Se qualquer page com tese <1 frase → WARN.

VEREDICTO: PASS | FAIL
Se FAIL: lista exata de issues por dimensão.
```

### Fase 3 — Decisão

```
ADVERSARIAL GATE v2: Batch [date]

Sample: 9/230 source pages (3 random + 3 top + 3 bottom)

1. Link Integrity: PASS/FAIL (X/Y resolved, Z%)
2. Categorização: PASS/FAIL (N/9 correct)
3. Placeholders: PASS/FAIL (N Score A with placeholders)
4. Concept Absorption: PASS/WARN (N% concepts with evidence)
5. Tese Quality: PASS/WARN (N/9 adequate)

VEREDICTO: PASS | FAIL

[Se FAIL:]
  Bloqueantes:
    - [dimensão]: [issue específico]
  Próxima ação: reparar antes do commit gate
```

**Regra de bloqueio**:
- Link Integrity FAIL → BLOCK (reparar links)
- Categorização FAIL → BLOCK (recategorizar)
- Placeholders FAIL → BLOCK (escrever reflections reais)
- Concept Absorption WARN → PASS com flag (absorption pode ser assíncrono)
- Tese Quality WARN → PASS com flag (não bloqueia mas deve melhorar)

### Fase 4 — Se BLOCK

Executar repair:

1. **Links**: rodar connection-finder step 7 (link repair)
2. **Categorização**: rerodar categorize() com fix (2+ keywords para concurso)
3. **Placeholders**: dispatch subagentes para escrever Minha Síntese reais

Após repair, re-rodar Fase 2. Se 3× FAIL consecutivo → escalar para usuário.

---

## Anti-padrões do batch (detectados em 2026-06-23 run 2)

Estes são os padrões que este gate foi desenhado para catchar:

| Padrão | Sintoma | Dimensão |
|--------|---------|----------|
| Wikilink path mismatch | 18% links quebrados | Link Integrity |
| Concurso false-positive | 32% miscategorizados | Categorização |
| Placeholder Minha Síntese | 100 "A ser analisado" | Placeholders |
| F2.5 skipped | 0 concept absorptions | Concept Absorption |
| Frontmatter bleeding | tese central = YAML | Tese Quality |

---

## Completion

- [ ] Subagente adversarial disparado com contexto isolado (não shared com pipeline)
- [ ] Sample ≥9 pages (3 random + 3 top + 3 bottom) verificadas
- [ ] 5 checks executados: link integrity, categorização, placeholders, concept absorption, beautiful nonsense
- [ ] Veredito: PIPELINE OK ou PIPELINE FAIL com issues específicas
- [ ] Se 3× FAIL consecutivo: escalado (não iterado)

## Failure modes

- **Shared context**: subagente recebe contexto da sessão do pipeline → isolamento é obrigatório
- **Auto-pass**: batch aprovado sem rodar o gate → se não rodou, não está aprovado
- **Small sample**: verificar <9 pages → sem representatividade para detectar problemas sistêmicos

---

## Restrições## Restrições

- **Isolamento obrigatório**: subagente NÃO recebe contexto da sessão do pipeline
- **Sample ≥9**: mínimo 9 pages (3 random + 3 top + 3 bottom) para representatividade
- **3 strikes**: 3× FAIL consecutivo → escalar, não iterar
- **Nunca auto-pass**: se não rodou o gate, batch não está aprovado

---

## Relacionado

- [[04-SYSTEM/skills/orchestration/adversarial-gate]] v1 — gate por tarefa em planos
- [[04-SYSTEM/skills/core/ingest-verify]] — checks per-file (C1-C7, C8, C9)
- [[03-RESOURCES/concepts/ai-agents/beautiful-nonsense]] — o anti-padrão que este gate previne
- [[03-RESOURCES/concepts/ai-agents/llm-as-judge-audit]] — o judge precisa de auditoria