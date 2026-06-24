---
title: Wiki Linting
type: concept
status: developing
origin: Andrej Karpathy
tags: [pkm, qualidade, llm-wiki-pattern]
created: 2026-04-14
updated: 2026-05-19
---

# Wiki Linting

Prática de executar "health checks" de LLM sobre uma wiki para manter integridade dos dados, sugerida por [[03-RESOURCES/entities/Andrej Karpathy|Karpathy]].

## O que o LLM faz num lint

| Verificação | O que resolve |
|---|---|
| Dados inconsistentes | Fatos conflitantes entre páginas |
| Lacunas (gaps) | Informação ausente; usa web search para imputar |
| Conexões novas | Candidatos a novos artigos / wikilinks faltando |
| Perguntas adicionais | Sugere o que investigar a seguir |

## No claude-obsidian

O skill `/wiki-lint` automatiza este processo: varre páginas órfãs, links mortos, seções vazias, frontmatter faltando, e gera relatório estruturado.

## Ver também

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern|LLM Wiki Pattern]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/karpathy-llm-knowledge-bases|Fonte: Karpathy LLM Knowledge Bases]]

## Evidências
- **[2026-06-19]** Step-level checkpointing reduz custo (evita re-chamar LLM em retry do zero) e dá observabilidade post-hoc — relevante para evoluir logs append-only de ingest para checkpoints reais — [[03-RESOURCES/sources/the-agent-loop-architecture]]
