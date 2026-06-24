---
title: REST API
type: concept
status: developing
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [api, http, web, backend]
---

# REST API

Representational State Transfer — estilo arquitetural p/ APIs web baseado em HTTP, recursos e statelessness. Proposto por Roy Fielding (2000).

## Conceitos-chave

- **Recursos** identificados por URL (`/api/produtos/42`)
- **Verbos HTTP**: `GET` (leitura), `POST` (criação), `PUT` (substituição), `PATCH` (atualização parcial), `DELETE` (remoção)
- **Stateless**: server não guarda estado de cliente entre requests
- **JSON** como formato dominante de payload
- **Status codes**: 2xx sucesso, 3xx redirect, 4xx erro cliente, 5xx erro server
- **HATEOAS** (links no response) — nível 3 Richardson

## Verbos + Status

| Verbo | Sucesso | Erro comum |
|---|---|---|
| GET | 200 OK | 404 Not Found |
| POST | 201 Created | 400 Bad Request |
| PUT | 200 / 204 No Content | 404 |
| DELETE | 204 No Content | 404 |

## Maturidade Richardson

- **Nível 0:** RPC sobre HTTP (1 endpoint, 1 verbo)
- **Nível 1:** múltiplos recursos (URLs)
- **Nível 2:** verbos HTTP + status codes
- **Nível 3:** HATEOAS (hipermídia)

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 02 (Spring Boot REST), cap. 08 (Next.js API Routes)

## Relacionado

- [[03-RESOURCES/concepts/dev-foundations/spring-boot|Spring Boot]]

## Evidências
- [[03-RESOURCES/sources/build-a-spring-boot-rest-api-with-amazon-aurora-dsql]] — RESTful product inventory API com optimistic concurrency control e multi-region active-active
