---
title: "Azure SDK Release (May 2026)"
type: source
source: "Clippings/Azure SDK Release (May 2026).md"
created: 2026-06-23
ingested: 2026-06-23
score: C
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Azure SDK Release (May 2026)"
source: "
author:
  - "[[Justin Bettencourt]]"
published: 2026-06-22
created: 2026-06-23
description: "Azure SDK releases every month. In this post, you'll find this month's highlights and release notes."
tags:
  - "clippings"
---
Thank you for your interest in the new Azure SDKs! We release new features, improvements, and bug fixes every month.

## Argumentos principais
### The Azure SDK for Rust reaches general availability Copy link
The Azure SDK for Rust is now stable. This month’s GA delivers production-ready 1.0.0 crates for Core, Identity, Key Vault (Secrets, Keys, and Certificates), and Storage (Blobs and Queues), built on the same design patterns you already know from the.NET, Java, JavaScript, Python, Go, and C++ SDKs. For the full story, see [From beta to stable: Announcing the Azure SDK for Rust]().

### Azure AI Search adds agentic retrieval with knowledge bases Copy link
The [.NET Azure AI Search library (12.0.0)]() and [Python azure-search-documents (12.0.0)]() introduce knowledge bases and a new `KnowledgeBaseRetrievalClient` for agentic retrieval. You can now define knowledge sources backed by Azure Blob storage, a search index, OneLake, or the web, then run retrieval requests against a knowledge base, all on the new `2026-04-01` service version. The [JavaScript @azure/search-documents (13.0.0)]() release adds a `debug` property to inspect non-semantic search queries and an `oversampling` option for vector search.

### New Azure AI Agent Server libraries enter preview Copy link
A new family of preview libraries for hosting agents arrived this month, led by [.NET Azure.AI.AgentServer.Core (1.0.0-beta.23)]() and [Python azure-ai-agentserver-core (2.0.0b3)]()..NET also ships companion `Invocations` and `Responses` packages, while Python ships a companion `Responses` package this month. They provide an `AgentServerHost` hosting model with built-in health probes, graceful shutdown, request-ID middleware, and a centralized `PlatformHeaders` set of HTTP header constants shared across the packages. As preview releases, these libraries are still changing quickly; the latest.NET beta, for example, consolidated six separate setup calls into a single `AddAgentServerCore()` / `UseAgentServerCore()` pair.

### Azure Batch client library reaches general availability for.NET Copy link
The [.NET Azure.Compute.Batch (1.0.0)]() library is now generally available. The GA release includes breaking changes carried over from beta, including the removal of `AuthenticationTokenSettings` and `BatchAccessScope` and a number of property renames (such as `BatchJobScheduleConfiguration.DoNotRunUntil` to `DoNotRunBefore`). Cross-language Batch modernization continued as well with [JavaScript @azure/batch (13.0.0)]() and [Python azure-batch (15.1.0)](), which ship their own type and option renames.

### Initial stable releases Copy link
- **Client Library for.NET**
- [Compute Batch 1.0.0]()
- **Management Libraries for.NET**

### Initial beta releases Copy link
- **Client Libraries for.NET**
- [Agent Server – Invocations 1.0.0-beta.1]()
- [Agent Server – Responses 1.0.0-beta.1]()


## Key insights
- "[[Justin Bettencourt]]"
- Client Library for.NET**
- [Compute Batch 1.0.0]()
- Management Libraries for.NET**
- [Resource Management – Compute Limit 1.0.0]()
- [Resource Management – Customer Insights 1.0.0]()
- [Resource Management – Dev Spaces 1.0.0]()
- [Resource Management – DevOps Infrastructure 1.0.0]()
- [Resource Management – File Shares 1.0.0]()
- [Resource Management – Informatica Data Management 1.0.0]()

## Exemplos e evidências
See original source at `Clippings/Azure SDK Release (May 2026).md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/token]]
- [[03-RESOURCES/entities/Azure]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Python]]
- [[03-RESOURCES/entities/Kubernetes]]
