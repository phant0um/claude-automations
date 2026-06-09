---
title: "ADR-001: Introdução de Ollama Cloud como Model Router Layer"
date: 2026-06-09
status: accepted
agent: nexus (via usuário)
reviewed-by: shield
model-scope: ambos
---

# ADR-001: Introdução de Ollama Cloud como Model Router Layer

## Contexto

Operações de alto volume (triagem, ingest, relatórios, reconciliação)
consumiam tokens Claude desnecessariamente. Atividades operacionais
não precisam de julgamento premium.

O pipeline diário `pipeline-diario.md` (v3.5) já tem template F1–F3
mas cada step chama Claude explicitamente, sem abstração de roteamento.
Isso gera 3 problemas:

1. **Custo**: ~2.800 tokens fixos por dia (Nexus gates + scoring + relatório)
   escalam para ~50+ tokens/arquivo em batches grandes.
2. **Acoplamento**: agents e pipeline conhecem provider (Anthropic)
   diretamente — sem flexibilidade para rotacionar modelos.
3. **Drift operacional**: tarefas rotineiras (triagem, ingest) usam
   Claude Sonnet, mesmo Ollama sendo suficiente.

## Decisão

Criar **Model Router Layer** com 4 novos agentes vault-nativos
(`triagem-agent`, `ingest-agent`, `report-agent`, `vault-reconcile`)
executando 100% via Ollama Cloud. Claude permanece apenas para
orquestração (Nexus), segurança (Shield), auditoria/git (Ledger)
e escaladas de conflito.

**Modelos Ollama selecionados:**

| Agente | Modelo Ollama | Motivo |
|--------|--------------|--------|
| triagem-agent | minimax-m3:cloud | 512K contexto, scoring estruturado, baixo custo |
| ingest-agent | minimax-m3:cloud / kimi-k2.6:cloud (FIAP) | M3 padrão; kimi para FIAP (preservação completa) |
| report-agent | deepseek-v4-pro:cloud / nemotron-3-ultra:cloud (clusters) | Raciocínio profundo + 1M contexto para cluster |
| vault-reconcile | nemotron-3-ultra:cloud | 1M contexto (95% Ruler@1M) para varrer archive inteiro |

**Regra de escalada:** Ollama retornou output vazio 2× → escalar para Claude Sonnet.

## Alternativas rejeitadas

| Alternativa | Motivo da rejeição |
|-------------|-------------------|
| Manter tudo em Claude | Custo alto sem ganho proporcional em tarefas operacionais |
| Substituir Claude completamente | Nexus/Shield/Ledger requerem julgamento estável e confiável |
| Usar apenas modelo local | Latência e hardware limitado — cloud mais confiável |
| Fine-tune Claude para tarefas operacionais | Custo de setup > economia gerada |
| Multi-model por step (M3 + Sonnet) sem abstração | Acoplamento pior, debug mais difícil |

## Consequências

### Positivas
- Redução estimada de 70–80% de tokens Claude na rotina diária
- Flexibilidade para rotacionar modelos por tipo de tarefa
- Custo zero no free tier do Ollama Cloud para operações em lote
- Abstração clara: `model-router.md` é single source of truth para roteamento
- Agents vault-nativos conhecem pipeline (não precisam wrapper bash)

### Negativas / trade-offs
- Dependência de Ollama Cloud (free tier tem limites de uso)
- Fallback necessário: Ollama → Claude se 2× output vazio
- Latência variável nos modelos cloud (P50 ~3s, P95 ~12s)
- Vault-reconcile com Nemotron é "High" usage — execução semanal, não diária
- 4 novos agents = 4 novos pontos de manutenção

## Implementação

| Arquivo | Conteúdo |
|---------|----------|
| `00-SYSTEM-PROMPTS/model-router.md` | Tabela de roteamento + env vars + regra de escalada |
| `00-SYSTEM-PROMPTS/triagem-agent.md` | F1 — scoring A–D via minimax-m3 |
| `00-SYSTEM-PROMPTS/ingest-agent.md` | F2 — vault builder via minimax-m3 / kimi |
| `00-SYSTEM-PROMPTS/report-agent.md` | F3 — relatório via deepseek + nemotron |
| `00-SYSTEM-PROMPTS/vault-reconcile.md` | Auditoria semanal via nemotron-3-ultra |

**Atualizações em agents existentes** (append, não rewrite):
- `Nexus.md` — tabela de roteamento F1–F3 + detecção proativa
- `Scout.md` — model_tier Ollama adicionado
- `Herald.md` — model_tier Ollama adicionado
- `README.md` — arquitetura atualizada (11 agentes)
- `0000-template.md` — campo `model-scope` no frontmatter

## Validação

- [x] Pipeline `pipeline-diario.md` v3.5 não regrediu (continua funcional)
- [x] Agents vault-nativos cobrem F1, F2, F3 do pipeline
- [x] `vault-reconcile` é independente do pipeline diário
- [x] Guardrails preservados: SOUL, Shield, Ledger não modificados
- [x] Fallback Ollama → Claude documentado

## Links relacionados

- ADR anterior: nenhum (primeiro ADR do sistema)
- Documentação: `model-router.md`
- Pipeline: `07-QUEUE/rotinas/pipeline-diario.md` (v3.5)
- ADR-002: `vault-reconcile-agent.md` (decisão complementar)
