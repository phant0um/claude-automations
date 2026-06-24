---
title: SQL — Structured Query Language
type: concept
status: developing
tags: [banco-de-dados, oracle, fiap, fase-3, fase-6]
created: 2026-04-14
updated: 2026-05-19
---

# SQL — Structured Query Language

Linguagem padrão para criação, manipulação e consulta de bancos de dados relacionais.

## Sublinguagens

| Sublinguagem | Comandos | Função |
|---|---|---|
| **DDL** (Data Definition) | `CREATE`, `ALTER`, `DROP` | Define estruturas |
| **DML** (Data Manipulation) | `INSERT`, `UPDATE`, `DELETE` | Manipula dados |
| **DQL** (Data Query) | `SELECT` | Consulta dados |
| **DCL** (Data Control) | `GRANT`, `REVOKE` | Controla permissões |
| **TCL** (Transaction Control) | `COMMIT`, `ROLLBACK` | Controla transações |

## Consultas Essenciais

```sql
-- Seleção básica
SELECT nome, saldo FROM conta WHERE ativa = 1;

-- JOIN
SELECT c.nome, t.valor
FROM cliente c
INNER JOIN transacao t ON c.id = t.cliente_id;

-- Agregação
SELECT categoria, COUNT(*), SUM(valor)
FROM transacao
GROUP BY categoria
HAVING SUM(valor) > 1000;
```

## No curso FIAP

- Fase 3: Modelagem e DDL
- Fase 6: DML, SELECT avançado, JOINs, GROUP BY, JDBC

## Ver também

- [[03-RESOURCES/concepts/dev-foundations/modelo-entidade-relacionamento|MER]]
- [[03-RESOURCES/concepts/dev-foundations/jdbc|JDBC]]
- [[03-RESOURCES/concepts/joins-sql|JOINs em SQL]]
- [[03-RESOURCES/entities/Oracle-SQL|Oracle SQL]]

## Evidências
- **[2026-06-24]** Introduction Migration assessment and planning is rarely a single-pass exercise. Inventory data is incomplete; assumptio — [[accelerating-migration-assessments-and-planning-with-aws-transform]]
- [[03-RESOURCES/sources/ai-powered-bi-with-snowflake-and-amazon-quick]] — Snowflake semantic views: business logic na camada de dados unifica AI e BI, reduz hallucinations
