---
title: "Amazon S3 annotations: attach rich, queryable context directly to your objects"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://aws.amazon.com/pt/blogs/aws/amazon-s3-annotations-attach-rich-queryable-context-directly-to-your-objects/"
author: "Daniel Abib"
published: 2026-06-16
grade: B
tags: [articles, aws, s3, metadata, annotations, athena, iceberg, ai-agents, queryable, source]
---

# Amazon S3 annotations: attach rich, queryable context directly to your objects

**Tese central**: Amazon S3 agora permite attachar até 1 GB de rich, mutable, queryable context diretamente a objetos via annotations — purpose-built para AI agents e autonomous workflows que precisam discover, understand, e act on data at scale sem manter metadata systems separados.

## O que são S3 annotations

Nova metadata capability para Amazon S3 que permite attachar rich, large-scale business context diretamente a objetos. Pode armazenar até 1,000 named annotations por objeto, cada uma até 1 MB, totalizando até 1 GB por objeto, em formats flexíveis como JSON, XML, YAML, ou plain text. Pode modify ou delete uma annotation a qualquer momento sem re-write do objeto.

Organizations estão building AI agents e autonomous workflows que precisam find, understand, e act on data sem human intervention. Para suportar agentic workflows, precisa metadata que evolve alongside data, escale a petabytes, e remain queryable sem expensive retrieval.

Com S3 annotations, context como AI-generated transcripts, content ratings, ou technical specifications vivem alongside objects. Context moves automaticamente com o object durante copy, replication, cross-region transfers, e S3 remove quando delete. Quando S3 Metadata é enabled, annotations flow automaticamente em fully managed annotation tables queryable via Amazon Athena.

## Common use cases

- **Media & Entertainment**: Track transcripts, content moderation results, subtitle files, licensing metadata como annotations separadas em video assets — elimina sync entre múltiplos media asset management systems
- **Financial Services**: Attach AI-generated investment summaries e sentiment analysis a research documents — autonomous research agents discover relevant datasets via natural-language queries sem metadata databases separados
- **Life Sciences**: Annotate clinical trial data com regulatory status, patient cohort details, approval chains — compliance audits mais rápidas com full context accessible para archived data em S3 Glacier sem retrieval charges

## How annotations address metadata challenges

Amazon S3 já suporta várias formas de descrever objetos:

| **Capability** | **Max size** | **Mutable?** | **Best for** |
| --- | --- | --- | --- |
| System-defined metadata | Fixed | No | Object properties (size, storage class, creation time) |
| User-defined metadata | 2 KB | No (set at upload) | Small custom key-value pairs |
| Object tags | 10 tags, 128/256 chars per key/value | Yes | Access control, lifecycle rules, cost allocation |
| **Annotations** | **1 GB (1,000 × 1 MB)** | **Yes** | **Rich business context (JSON, XML, YAML, plain text)** |

Annotations oferecem metadata capabilities em scale e flexibility fundamentalmente diferente: mutable, queryable context per object comparado a 10 immutable tags ou 2 KB de headers.

Metadata describing S3 objects frequentemente vive em databases separados ou sidecar files, requiring complex synchronization workflows que podem exceder data storage costs. Com S3 Metadata annotation tables, context se torna queryable at scale via Athena. AI agents podem discover data via natural language com S3 Tables MCP server — standardized interface para AI models query annotations. Queryable para objects em qualquer storage class, sem restore ou retrieval charges.

## Getting started with annotations

IAM policy ou bucket policy precisa conceder `s3:PutObjectAnnotation` e `s3:GetObjectAnnotation`. Adicione annotations a qualquer objeto via `PutObjectAnnotation` API.

Exemplo: media company attacha technical specifications e AI-produced summary a video asset:
```bash
# JSON com technical metadata
aws s3api put-object-annotation --bucket my-media-bucket \
  --key videos/documentary-2026.mp4 \
  --annotation-name mediainfo \
  --annotation-payload ./mediainfo.json

# Plain-text AI-generated summary
aws s3api put-object-annotation --bucket my-media-bucket \
  --key videos/documentary-2026.mp4 \
  --annotation-name ai_summary \
  --annotation-payload ./ai_summary.txt
```

Cada annotation identificada por unique name, read e modify independentemente. Unique names permitem múltiplos concurrent enrichment workflows (uma team add technical metadata, outra add content classifications) sem interferência.

APIs disponíveis:
- `GetObjectAnnotation` — retrieve annotation específica
- `ListObjectAnnotations` — lista todas annotations de um objeto
- `DeleteObjectAnnotation` — remove annotation
- `PutObjectAnnotation` (novamente) — update annotation existente
- Para multipart upload: attach annotations após completar o multipart upload

## Querying annotations at scale with S3 Metadata tables

O real power vem quando query across all annotations at scale. Enable S3 Metadata annotation tables no bucket → S3 automaticamente indexes annotations em fully managed Apache Iceberg table (annotation table). Queryable via Amazon Athena ou qualquer Iceberg-compatible engine.

Enable via S3 console ou `CreateBucketMetadataConfiguration` API. Config example com annotation tables enabled, journal tables para change tracking, live inventory disabled:
```json
{
  "JournalTableConfiguration": { "RecordExpiration": { "Expiration": "DISABLED" } },
  "InventoryTableConfiguration": { "ConfigurationState": "DISABLED" },
  "AnnotationTableConfiguration": {
    "ConfigurationState": "ENABLED",
    "Role": "arn:aws:iam::123456789012:role/S3MetadataAnnotationRole"
  }
}
```

Uma vez applied, qualquer annotation attachada a objects no bucket aparece na table em ~1 hora. Journal tables update em near real time; annotation tables refresh em 1 hora. Annotation tables automaticamente adaptam a qualquer JSON, XML, ou YAML structure — sem schema migrations. Cada annotation vira uma row com content em `text_value` column. Backfill automático para buckets com annotated objects existentes (background, horas a dias dependendo do volume).

Query examples via Athena:
```sql
-- Encontrar video assets com >8 audio tracks
SELECT DISTINCT bucket, object_key
FROM "s3tablescatalog/aws-s3"."b_my_media_bucket"."annotation"
WHERE name = 'mediainfo'
AND CAST(json_extract_scalar(text_value, '$.audio_tracks') AS INTEGER) > 8

-- Objects com new annotations nas últimas 24h (via journal table)
SELECT bucket, key, version_id, record_timestamp, annotation.name
FROM "s3tablescatalog/aws-s3"."b_my_media_bucket"."journal"
WHERE record_timestamp >= (current_date - interval '1' day)
AND annotation.name IS NOT NULL
AND record_type IN ('CREATE_ANNOTATION', 'DELETE_ANNOTATION')
```

Natural language search via agents em Amazon SageMaker Unified Studio ou qualquer IDE com S3 Tables MCP server: "find all PG-rated movies with Spanish subtitles from 2023" retorna em segundos em vez de horas querying multiple disconnected systems.

## Availability e pricing

Disponível today em all AWS Regions, incluindo AWS China Regions. Annotation tables disponíveis em all Regions onde S3 Metadata é available. Annotation storage sempre billed at S3 Standard rates, mesmo se parent object está em S3 Glacier ou outra storage class.

## Por que importa para o vault

- **Metadata alongside data**: annotations são metadata que vivem com o objeto — princípio de manter contexto junto ao conteúdo, relevante para como o vault estrutura frontmatter + body em cada note
- **Queryable at scale via Iceberg + Athena**: pattern de indexar metadata em tables queryable — modelo para como o vault poderia expor seu metadata (tags, frontmatter) via query estruturada
- **Mutable metadata**: annotations são mutáveis sem re-write do objeto — diferenciação importante vs immutable metadata, relevante para vault notes que evoluem
- **AI agent discovery via MCP server**: S3 Tables MCP server permite agents discover data via natural language — exatamente o pattern do vault onde agents precisam encontrar notes por contexto
- **Concurrent enrichment workflows**: múltiplas annotations nomeadas permitem paralelismo — modelo para como múltiplos agents podem enriquecer a mesma note sem conflito
- **1 GB per object**: scale de metadata que habilita agentic workflows — contexto rico não apenas tags

## Links

- [[03-RESOURCES/sources/ai-agents/new-in-amazon-bedrock-agentcore]]
- [[03-RESOURCES/sources/ai-agents/agentic-resource-discovery-let-agents-search]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]