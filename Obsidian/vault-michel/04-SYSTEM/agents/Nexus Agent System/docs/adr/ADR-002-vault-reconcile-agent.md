---
title: "ADR-002: vault-reconcile — Reconciliação Archive vs Vault"
date: 2026-06-09
status: accepted
agent: nexus (via usuário)
reviewed-by: shield
model-scope: ollama
---

# ADR-002: vault-reconcile — Reconciliação Archive vs Vault

## Contexto

Sources, concepts e entities em `03-RESOURCES/` podem ficar desatualizados
em relação aos raws arquivados em `08-ARCHIVE/[A|B]/`. Sem reconciliação periódica,
o vault acumula drift entre o que foi ingestado e o que realmente existe
no arquivo original.

**Sintomas observados:**

1. Source page criada com N concepts no dia da ingestão, mas raw tem N+2
   (conceitos descobertos depois, conceitos órfãos).
2. Entities mencionadas no raw sem wikilink reverso na source page.
3. Wikilinks `[[x]]` que apontam para conceitos que nunca foram criados.
4. Raws arquivados em A/ que nunca foram ingestados (ou foram, mas a source
   page foi deletada acidentalmente).

O pipeline diário **não resolve** isso — ele ingere novos raws, mas não audita
o que já foi ingestado. Sem agente dedicado, o drift acumula silenciosamente.

## Decisão

Criar agente **`vault-reconcile`** com **Nemotron 3 Ultra** (1M contexto, 95% Ruler@1M)
para comparar `08-ARCHIVE/[A|B]/` contra `03-RESOURCES/sources/` e complementar
pages desatualizadas via **append, nunca rewrite**.

**Princípios:**

1. **Append > rewrite** — preservar informação sempre
2. **Varrer A/ antes de B/** — A tem maior valor (aprovados com score máximo)
3. **Wikilinks quebrados**: registrar, não corrigir (correção requer decisão Nexus)
4. **Raws sem source page**: flagged para `@ingest-agent`, não ingestar automaticamente
5. **Execução periódica**: semanal (Nemotron tem uso "High" no Ollama Cloud)

## Alternativas rejeitadas

| Alternativa | Motivo da rejeição |
|-------------|-------------------|
| MiniMax M3 | 512K pode não ser suficiente para archive completo (vault atual ~120+ sources) |
| DeepSeek V4-Pro | Melhor para raciocínio profundo por documento, não para varredura em lote |
| Claude Opus (Shield) | Custo proibitivo para varredura semanal de todo archive |
| Revisão manual | Inescalável conforme o vault cresce (>120 sources, tendência exponencial) |
| Hook automático pós-ingest | Não detecta drift acumulado de ingestações anteriores |
| Script bash puro sem LLM | Diff semântico requer raciocínio (concept/entity = abstração) |

## Consequências

### Positivas
- Vault mantém coerência entre raw e pages geradas
- Wikilinks quebrados detectados automaticamente (registrados, não auto-corrigidos)
- Concepts e entities complementados continuamente
- Audit trail semanal: `06-GENERATED/audits/vault-reconcile-YYYY-MM-DD.md`
- Score de cobertura visível (X/N sources completas)
- Top 5 sources que mais precisam de complemento (próxima ação)

### Negativas / trade-offs
- Nemotron 3 Ultra tem uso marcado como "High" no Ollama Cloud
- Execução periódica recomendada (semanal), não diária — latência na detecção
- Append acumula seções de reconciliação (mitigado: frontmatter `reconciled: YYYY-MM-DD`)
- Wikilinks quebrados não são corrigidos automaticamente (decisão Nexus necessária)
- Sem priorização automática de "o que vale a pena reconciliar agora"

## Implementação

| Arquivo | Conteúdo |
|---------|----------|
| `00-SYSTEM-PROMPTS/vault-reconcile.md` | Spec do agente (model, estratégia, output) |
| `06-GENERATED/audits/vault-reconcile-YYYY-MM-DD.md` | Relatório de auditoria |

**Schedule sugerido:** sexta à noite (após `pipeline-diario` e antes do fim de semana).
Trigger manual: `@vault-reconcile` quando vault parecer desatualizado.

**Output do relatório:**
- Tabela raw → source com status (ok / desatualizado / sem page)
- Concepts/entities faltantes (criados)
- Wikilinks quebrados (registrados)
- Raws órfãos (flagged para ingest)
- Score de cobertura: X de Y sources completas
- Top 5 sources que mais precisam de complemento

## Validação

- [x] Append-only preserva informação (nenhum rewrite destrutivo)
- [x] Wikilinks quebrados registrados, não corrigidos (decisão Nexus)
- [x] Raws órfãos flagged, não ingesados (escopo respeitado)
- [x] Auditoria semanal recomendada (não diária — custo controlado)
- [x] Vault coverage score visível (métrica de saúde)

## Links relacionados

- ADR anterior: `ADR-001-ollama-model-router.md` (decisão complementar — roteamento)
- Agent spec: `00-SYSTEM-PROMPTS/vault-reconcile.md`
- Pipeline: `07-QUEUE/rotinas/pipeline-diario.md` (reconcile é independente)
- Schema: `06-GENERATED/audits/` (novo diretório, criado sob demanda)
