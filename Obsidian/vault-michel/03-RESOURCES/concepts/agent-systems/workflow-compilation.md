---
title: Workflow Compilation
type: concept
created: 2026-05-24
updated: 2026-05-24
tags: [agent-systems, fine-tuning, token-economy, workflow]
status: developing
---

# Workflow Compilation

Técnica de **fine-tuning** que "compila" um workflow agentico orquestrado externamente nos pesos de um modelo pequeno. O modelo compilado executa o workflow como memória procedural implícita — sem precisar de orquestrador externo ou modelo frontier a cada turno.

## Mecanismo

1. Workflow definido com orquestrador (LangGraph, etc.) + modelo frontier
2. Geração de dados sintéticos: orquestrador executa milhares de conversas → grava inputs/outputs
3. Fine-tune em modelo pequeno (3B–8B parâmetros) com esses dados
4. Modelo compilado: executa workflow sem orquestrador — prompt de tamanho constante independente da complexidade do procedimento

## Ganhos (empiricamente)

| Dimensão | Ganho |
|----------|-------|
| Custo | **128–462×** mais barato por conversa |
| Token volume | 2–7× menos tokens |
| Latência | 2.8× mais rápido (inference local) |
| Qualidade | 87–98% da qualidade frontier |
| Failure rate | menor que orquestrador (travel: 5.5% vs 24%) |

## Por que funciona

- Orquestrador frontier injeta instruções a cada turno → consome context window
- Modelo compilado: instrução de roteamento está nos pesos → prompt fixo pequeno
- Complexidade do workflow não cresce o prompt — escala melhor
- Recompile cycle: 30–50 min (CI/CD cycle, não retraining longo)

## Trade-offs

- Compilado = especializado: não generaliza fora do workflow treinado
- Mudanças no workflow = recompile (mas 30–50 min é aceitável)
- Flexibilidade sacrificada por custo/latência
- Casos de uso complexos (55 nós) precisam de 8B para fechar gap de qualidade

## Relação com o vault

Agentes do vault (nexus, guard, hill) são candidatos a compilação:
- Nexus: workflow de orquestração repetitivo → compilável em modelo local
- Pipeline-diario: 24 conversas estruturadas = dataset sintético em 1 semana

## Conceito relacionado: "Subterranean Agent"

Agente compilado age como especialista de domínio. Não "chama" ferramentas visíveis — executa procedimento internamente. Workflow fica "submerso" nos pesos.

## Links

- [[03-RESOURCES/sources/ml-research-papers/compiling-agentic-workflows-llm-weights]]
- [[03-RESOURCES/concepts/llm-ml-foundations/fine-tuning]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]
- [[03-RESOURCES/concepts/agent-systems/token-economy]]
