---
title: "Context Rotation"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Context Rotation

Estratégia de gerenciamento da janela de contexto em sessões longas de agentes: evictar conteúdo obsoleto e reinjeta estado relevante, mantendo o modelo orientado sem perder informação crítica.

## O que é

Em sessões de agente com muitas interações, a janela de contexto enche com tokens que não agregam mais valor (saídas antigas, raciocínios intermediários, conteúdo já processado). Context rotation é o processo de substituir esse conteúdo estale por estado fresco e relevante para a tarefa atual.

Difere de compactação (`/compact`) porque é **seletivo** — não comprime tudo, evicta o que não é mais necessário e mantém intacto o que ainda é.

## Como funciona / Detalhes

**Mecânica básica:**
1. Monitor o nível de preenchimento da janela (tipicamente alertar a 70%)
2. Identificar conteúdo "frio" (não referenciado nas últimas N interações)
3. Evictar conteúdo frio da janela ativa
4. Injetar state relevante: hot cache, plano atual, últimos resultados
5. Continuar execução

**Context rotation vs. /compact:**
| | Context Rotation | /compact |
|---|---|---|
| Tipo | Evicção seletiva | Compressão lossy de tudo |
| Controle | Manual / regra | Automático |
| Risco | Baixo (escolha o que sai) | Médio (informação pode ser perdida) |
| Uso ideal | Sessões longas e estruturadas | Sessões exploratórias |

**hot.md como âncora de rotação:**
- O arquivo `04-SYSTEM/wiki/hot.md` no vault é o "warm-up packet" injetado no início de cada sessão
- Contém: contexto do vault, projetos ativos, links críticos — exatamente o que deve ser reinjeto após evicção
- Ver [[04-SYSTEM/wiki/hot.md]]

**Implementação em agentes:**
- Agentes com memória externa (Redis, arquivo) podem serializar estado e recarregar seletivamente
- Padrão: `summarize_and_evict()` → `load_hot_state()` → `continue()`

## Por que importa

Para Michel: o vault já implementa esse padrão com hot.md. Entender context rotation ajuda a projetar agentes mais robustos (FIAP projetos de IA) e é fundamento para agentes de longa duração.

## Evidências
- **[2026-06-19]** "Frequent Intentional Compaction" (Dex Horthy/HumanLayer): cada fase de trabalho produz um artefato compactado; cada fase nova começa com janela fresca contendo só esse artefato — research.md comprime 60-80% de uso para 15-20% — [[03-RESOURCES/sources/ai-agents-harness/context-engineering-complete-playbook]]

## Related
- [[04-SYSTEM/wiki/hot.md]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/selective-refinement]]
