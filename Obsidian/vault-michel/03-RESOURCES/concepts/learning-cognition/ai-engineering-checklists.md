---
title: AI Engineering Checklists
type: concept
status: developing
created: 2026-05-15
updated: 2026-05-15
tags: [ai-engineering, career, backend, infra, checklist]
---

# AI Engineering Checklists

Coleção de checklists tipo "skills/projects/roadmap" que circulam em X/Threads para AI/backend/infra engineers. Agrega posts curtos que ficariam soltos como sources individuais.

## Senior → Staff Backend Engineer (@0xlelouch_)

Staff = projetar o **sistema certo pro negócio**, explicar tradeoffs, influenciar múltiplos times, reduzir dor operacional de longo prazo.

**Arquitetura:** limites do sistema, plataforma, build-vs-buy, decomposição monolito, multi-region, retrocompatibilidade, API contracts, ADRs, technology boring, design pra estrutura organizacional.

**Escalabilidade:** cache, queue, partitioning, sharding, replicação, leader election, rate limiting, backpressure, fan-out/fan-in, idempotência, retry storms, eventual consistency, distributed txs, hot partitions, graceful degradation, capacity planning, failure mode analysis.

**Dados:** modelagem, indexing strategy, OLTP vs OLAP, CDC, WAL, isolation levels, schema evolution, retention, hot/cold storage, multi-tenant, event sourcing, CQRS, denormalização, data correction, reprocessing pipelines, analytics vs product DB.

**Confiabilidade:** SLO/SLI/SLA, error budgets, alert quality, incident response, postmortems, runbooks, canary, rollback, feature flags, disaster recovery, load test, chaos test, health checks, circuit breakers, distributed tracing.

**Execução:** design docs, alignment, mentoring de séniores.

Source: [[03-RESOURCES/sources/claude-code-skills/staff-engineer-skills-checklist]]

## 10 API Design Concepts (@avrldotdev)

0. Idempotência · 1. Paginação (cursor/offset) · 2. Rate Limiting · 3. Versionamento · 4. Filtering/Sorting · 5. Timeouts & Retries · 6. HATEOAS · 7. API Gateway · 8. Partial Responses · 9. Error Modeling

Source: [[03-RESOURCES/sources/guides-courses-howtos/10-api-design-concepts-backend]]

## 10 Projects for AI Engineer Portfolio (@DanKornas)

0. Eval harness · 1. RAG + reranking · 2. Prompt registry · 3. LLM gateway · 4. Tool-calling agent · 5. Synthetic data pipeline · 6. LoRA fine-tune · 7. Batch inference worker · 8. Hallucination monitor · 9. Cost/latency dashboard · 10. Context Router

Source: [[03-RESOURCES/sources/guides-courses-howtos/10-ai-engineer-projects-portfolio]]

## 12-Stage AI Infra Engineer Roadmap (@jahirsheikh8)

1. Linux + Networking (processes, memory, GPUs, TCP/IP)
2. Python + Backend (async, FastAPI, queues, concurrency)
3. GPU fundamentals (CUDA, VRAM, batches, quantization, throughput)
4. LLM Inference (vLLM, TensorRT-LLM, speculative decoding, KV cache)
5. Distributed Systems (load balancing, queues, retries, autoscaling, workers)
6. AI Serving (model APIs, streaming, rate limit, observability)
7. Data Pipelines (Kafka, Airflow, ETL, vector index)
8. Kubernetes + Cloud (Docker, K8s, AWS/GCP, infra automation)
9. Monitoring + Reliability (Prometheus, Grafana, tracing, AI cost monitoring)
10. Real AI Systems (chat apps, RAG pipelines, inference clusters)
11. Open Source contributions
12. Job apply (AI Infra Engineer, Platform Engineer, ML Systems)

Source: [[03-RESOURCES/sources/guides-courses-howtos/6-month-ai-infra-engineer-roadmap]]

## AI Agent Anatomy — 6 Parts (@alexxubyte)

Agente = while-loop. LLM seleciona ação → executa → avalia → repete.

1. **Brain** — LLM toma DECISÕES, não escreve texto
2. **Planning** — CoT, Tree of Thoughts, Reflexion
3. **Tools** — funções (geralmente MCP)
4. **Memory** — curto (context window) + longo (vector store, files, KB)
5. **Loop** — orquestração das 4 partes
6. **Guardrails** — sandbox, human checks, token limits, scope, validation

Source: [[03-RESOURCES/sources/ai-agents-harness/ai-agent-anatomy-6-parts]]

## 23 Tasks to Delegate to /goal (@sairahul1)

Ver [[03-RESOURCES/concepts/claude-code-tooling/goal-command]] para lista completa.

Source: [[03-RESOURCES/sources/guides-courses-howtos/23-tasks-to-delegate-to-goal]]

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]]
- [[03-RESOURCES/concepts/ai-strategy-org/ai-engineer-skills]]
