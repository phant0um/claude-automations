---
title: Data Metadata Patterns
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, software-engineering, metadata, data, annotations]
---

# Data Metadata Patterns

Padrões para anexar contexto a dados: inline vs external metadata systems.

## S3 Annotations

- Até 1 GB de annotations por objeto (1.000 × 1 MB)
- Mutável e queryable (JSON, XML, YAML, plain text)
- Move com o objeto durante copy/replication
- Queryable via Amazon Athena sem retrieval do objeto

## Inline vs External

| Approach | Pros | Cons |
|----------|------|------|
| Inline (annotations, frontmatter) | Co-localizado, viaja com dado, não sincroniza | Size limit |
| External (metadata DB, manifest) | Sem limit de size, queryable | Sync overhead, can diverge |

## Aplicação no vault

Frontmatter inline = annotations. Manifest externo = metadata DB. O vault usa ambos — frontmatter em cada .md + .manifest.json como index.

## Evidências

- [[03-RESOURCES/sources/articles/amazon-s3-annotations]]

## Links

- [[03-RESOURCES/sources/ai-agents/new-in-amazon-bedrock-agentcore]]