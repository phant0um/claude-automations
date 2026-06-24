---
title: Medallion Architecture
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, data-engineering, medallion, architecture, layers]
---

# Medallion Architecture

Arquitetura de dados em camadas: Bronze → Silver → Gold. Cada camada aumenta qualidade e refinamento.

## Camadas

- **Bronze**: dados brutos, formato original
- **Silver**: dados limpos, filtrados, enriquecidos
- **Gold**: dados agregados, prontos para consumo/analytics

## Paralelo com vault-michel

| Medallion | Vault |
|-----------|-------|
| Bronze | 00-INBOX / Clippings |
| Silver | 06-GENERATED/triagem |
| Gold | 03-RESOURCES/sources (curated, wikilinked) |

## Evidências

- [[03-RESOURCES/sources/articles/aws-devops-agent-spark-troubleshooting]] — Diagnóstico de falhas multi-layer em pipelines Medallion
- [[03-RESOURCES/sources/automated-schema-evolution-in-pinterest-s-next-generation-db-ingestion-framework]] — Pinterest CDC pipeline: Kafka → Flink → Spark → Iceberg com schema evolution automatizada

## Links

- [[03-RESOURCES/concepts/ai-agents/mcp-server-pattern]]