---
title: Spring Boot
type: concept
status: developing
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [java, backend, framework, spring]
---

# Spring Boot

Framework Java opinativo (Pivotal/VMware) p/ apps stand-alone production-ready. Auto-configuração, embedded server (Tomcat/Jetty), starters Maven/Gradle. Reduz boilerplate vs Spring puro.

## Conceitos-chave

- **Spring Initializr** (`start.spring.io`) — scaffolding inicial
- **Auto-configuration** baseada em classpath
- **Starters**: `spring-boot-starter-web`, `-data-jpa`, `-security`, `-test`
- **Embedded Tomcat** — sem deploy de WAR
- **`application.properties`** / `application.yml` — config externa
- **Actuator** — endpoints de health/metrics

## Annotations principais

- `@SpringBootApplication` — bootstrap
- `@RestController` — REST endpoint
- `@RequestMapping` / `@GetMapping` / `@PostMapping` etc.
- `@RequestBody` / `@PathVariable` / `@RequestParam`
- `@Service` / `@Repository` / `@Component`
- `@Autowired` — DI
- `@Entity` (JPA) + `@Id`, `@GeneratedValue`

## Estrutura em camadas

```
Controller → Service → Repository (JpaRepository) → DB
```

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 02 (Estudo de Caso Back-end), cap. 09 (consumo via Next)

## Relacionado

- [[03-RESOURCES/concepts/dev-foundations/rest-api|REST API]]
- [[03-RESOURCES/entities/Java|Java]]
- [[03-RESOURCES/concepts/dev-foundations/jdbc|JDBC]]
