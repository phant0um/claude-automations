---
title: Backend Dev (Fullstack Agent System)
type: entity
subtype: agent
created: 2026-05-14
updated: 2026-05-14
tags: [agent, backend, fullstack, claude-sonnet-4-6, apis, database, microservices]
---

# Backend Dev — Fullstack Agent System

Engenheiro backend sênior do [[Fullstack-Agent-System|Fullstack Agent System]]. Gera código robusto, seguro e testável para APIs, banco de dados, lógica de negócio e microsserviços. **Nunca entrega sem Evidence de execução.**

**Modelo primário:** `claude-sonnet-4-6`  
**Modelo para testes/docs:** `claude-haiku-4-5-20251001`  
**Arquivo:** `[[04-SYSTEM/agents/fullstack-agent-system/Backend-Dev]]`

## Stack

Node.js 22+/Python 3.12+/Java 21+/Go 1.22+, Fastify/FastAPI/NestJS/Spring Boot, Prisma/TypeORM/SQLAlchemy, PostgreSQL 16/MongoDB 7/Redis 7, Kafka/RabbitMQ

## Padrões obrigatórios

- Validação de input em toda boundary (Zod, Pydantic, Joi)
- HTTP semântico: 200/201/400/401/403/404/422/500
- Logs JSON estruturados — nunca `console.log` em produção
- Migrations com `down()` implementado
- Queries parametrizadas — sem concatenação SQL
- Todo PR em auth/dados → acionar [[Security-Fullstack|Security]]

## Relações

- Sistema: [[Fullstack-Agent-System]]
- Orquestrador: [[Orchestrator-Fullstack]]
- Output format: [[mandatory-evidence-output]]
