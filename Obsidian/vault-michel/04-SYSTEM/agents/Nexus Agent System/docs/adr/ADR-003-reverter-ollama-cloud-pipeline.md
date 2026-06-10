---
title: "ADR-003: Reversão parcial do Ollama Cloud no pipeline diário (Claude-only)"
date: 2026-06-09
status: accepted
agent: nexus (via usuário)
reviewed-by: shield
model-scope: ambos
---

# ADR-003: Reversão parcial do Ollama Cloud no pipeline diário (Claude-only)

## Contexto

ADR-001 (mesmo dia, 2026-06-09) introduziu Ollama Cloud para `triagem-agent`,
`ingest-agent`, `report-agent` e `vault-reconcile`, prometendo redução de
70-80% de tokens Claude. Antes da primeira execução real, o usuário rejeitou
a premissa:

1. Não quer pagar licença Ollama Cloud (free tier não cobre uso planejado).
2. Scoring do `minimax-m3:cloud` diverge do scoring que o Haiku faria — e
   F1 (triagem) **é** justamente scoring. Trocar o modelo de avaliação muda
   o que entra no vault, não é uma troca neutra.

Os 3 agentes vault-nativos (`triagem-agent`/`ingest-agent`/`report-agent`)
têm boa estrutura "fat skill" (propósito, regras, anti-padrões, critério de
done) — não precisam ser descartados, só trocar o modelo de Ollama→Claude.

## Decisão

Reverter o roteamento Ollama→Claude para os 3 agentes do pipeline diário,
mantendo a arquitetura de 3 agentes decompostos (validada por
`llm-pipeline-slow-agents-do-too-much.md` — decomposição eleva
instruction-following accuracy 60%→92% ao reduzir tokens de instrução por
agente). Substituir o ganho de custo prometido por reduções reais
Claude-only:

| Agente | Antes (ADR-001) | Depois (ADR-003) |
|--------|-----------------|-------------------|
| triagem-agent | minimax-m3:cloud | claude-haiku-4-5 (só borderline 4-6) |
| ingest-agent | minimax-m3:cloud + kimi-k2.6:cloud (FIAP) | claude-sonnet-4-6 (único) |
| report-agent | deepseek-v4-pro:cloud + nemotron-3-ultra:cloud | claude-sonnet-4-6 (+ haiku F3.5) |

**Reduções reais incorporadas:**

1. **Pré-filtro heurístico** (`04-SYSTEM/skills/core/triagem-scoring.md`,
   criado 2026-05-23, nunca conectado): score 0-10 via regex em
   título+conteúdo, bash puro. Score 0-3→D direto, 7-10→A/B direto, só
   4-6 (borderline) vai para AI. Estimativa da própria skill: ≥60% dos
   arquivos resolvidos sem AI call. Maior lever Claude-only — corta direto
   o termo `80×N_t` do custo.
2. **Batch em vez de loop** no scoring borderline: `triagem-agent.md` fazia
   loop per-file (1 call Haiku por arquivo); `triagem-scoring.md` já
   especificava batch. Corrigido. Bônus de prompt-cache: Haiku só cacheia
   acima de 4096 tokens — loop per-file quase certo ficava abaixo do floor
   (0% cache hit, full-price sempre); batch aumenta o tamanho por call e
   reduz overhead repetido de sistema.
3. **Cap de leitura Clippings/X**: `cat "$f" | CLEAN` (sem limite) →
   `head -c 8000 "$f" | CLEAN` — thread X longa não explode tokens.
4. **F3.0 skip condicional**: `sources_today < 2` → pular F3.1
   (clusters)/F3.2 (cross-connections), que produziam ruído vazio
   (regra "Convergências ≥2 sources" não se aplica a 1 source).
5. **Caveman ultra em handoffs**: triagem § "Sugestões de Complementos" /
   "Melhorias Identificadas no Vault" viram flags 1-linha (rascunho) — a
   versão canônica/priorizada com `[[wikilinks]]` fica em F3.2/F3.3 do
   report-agent (que já lê o relatório de triagem como input). Evita gerar
   prosa 2x para o mesmo insight.
6. **Guardrail de cache**: nunca injetar data/timestamp ao vivo na prosa de
   agent-spec files ou CLAUDE.md (maior cache-killer documentado) — só em
   bash blocks/texto de invocação de tarefa. Verificado nos 6 arquivos do
   pipeline: nenhuma ocorrência do anti-padrão hoje.

## Alternativas rejeitadas

| Alternativa | Motivo da rejeição |
|-------------|---------------------|
| Manter ADR-001 como está | Usuário rejeitou explicitamente (custo + qualidade scoring) |
| Reverter para v3.5 (tudo Claude, sem decomposição) | Perde ganhos de decomposição (Sully.ai) e do pré-filtro heurístico |
| Fundir os 3 agentes em 1 monólito | Eleva tokens de instrução por chamada — instruction-following cai 92%→60% (Gupta et al. 2025) |
| Merge `triagem-*.md` + `ingest-diario-*.md` em 1 relatório | Ganho marginal (~100-200 tokens), perde checkpoint independente se F2/F3 falhar, cria cross-ownership de arquivo entre agentes |

## Consequências

### Positivas
- Sem dependência de licença/infra Ollama Cloud
- Scoring de triagem usa Haiku (mesma família de qualidade que o resto do vault)
- Pré-filtro heurístico finalmente conectado — zero risco de qualidade (bash)
- Cost budget realista, sem promessa baseada em troca de modelo

### Negativas / trade-offs
- Redução honesta ~35-45% (dia típico) / ~60% (dia leve) — bem abaixo dos
  70-80% prometidos em ADR-001 (que vinham de modelo mais barato, não de
  menos chamadas)
- Heurística bash tem ~10% de falsos positivos conhecidos (padrão GitHub
  README) — aceitável, score 4 sempre vai para AI

## Itens não afetados / follow-up

- **ADR-002 / `vault-reconcile`**: continua em `nemotron-3-ultra:cloud`
  (1M contexto para varrer archive inteiro). Trocar para Sonnet (200K)
  exige redesenho (chunking/batch ou índice semântico via context-mode),
  não é troca de 1 linha — fora deste pass, documentado como follow-up em
  `model-router.md`.

## Implementação

| Arquivo | Mudança |
|---------|---------|
| `00-SYSTEM-PROMPTS/triagem-agent.md` | model→haiku, pré-filtro heurístico + batch borderline, cap Clippings/X, seções rascunho→ultra |
| `00-SYSTEM-PROMPTS/ingest-agent.md` | model único→sonnet, remove split FIAP/kimi |
| `00-SYSTEM-PROMPTS/report-agent.md` | model único→sonnet (+haiku F3.5), F3.0 skip condicional, F3.2/F3.3 = canônico |
| `00-SYSTEM-PROMPTS/model-router.md` | 3 linhas Ollama→"—"/Claude, nota de reversão, vault-reconcile flagged |
| `07-QUEUE/rotinas/pipeline-diario.md` | v4.1 — framing, cost budget, caveman scoping, guardrail cache, changelog |

## Validação

- [x] Heurística testável standalone (títulos conhecidos → bucket esperado)
- [x] Frontmatter dos 3 agentes sem `:cloud`
- [x] `model-router.md` wikilinks intactos
- [ ] Próxima execução real: `triagem-<data>.md` mostra `motivo: heurística (score X)` para auto-bucketed

## Links relacionados

- ADR anterior: ADR-001 (supersede parcial — triagem/ingest/report)
- ADR-002: `vault-reconcile-agent.md` (não afetado, flagged)
- Pipeline: `07-QUEUE/rotinas/pipeline-diario.md` (v4.1)
- Skill: `04-SYSTEM/skills/core/triagem-scoring.md`
