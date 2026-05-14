---
title: "Normalização de Banco de Dados — Overview"
type: source
source: ".raw/normalizacao-banco-dados-2026-04-18.md"
date: 2026-04-18
tags: [banco-de-dados, modelagem, sql, normalizacao]
---

# Normalização de Banco de Dados — Overview

> Consolidação de conceitos-chave sobre normalização de banco de dados relacional com foco nas três primeiras formas normais.

## Source Summary

This source provides a concise explanation of database normalization as a process for organizing relational database data to reduce redundancy and improve data integrity. It emphasizes the decomposition of large tables into smaller ones with defined relationships.

## Key Concepts

### Atomicity & Atomic Values
- **1NF requirement:** Each column must contain atomic (indivisible) values
- **Example:** A "Hobbies" column containing comma-separated values violates 1NF

### Primary Key Dependence
- **2NF requirement:** All non-key attributes must depend on the complete primary key
- **Violation:** Partial dependencies occur when an attribute depends on only part of a composite key
- **Implication:** Eliminate partial dependencies by moving dependent attributes to separate tables

### Transitive Dependencies
- **3NF requirement:** No non-key attribute can depend on another non-key attribute
- **Pattern:** A → B → C violates 3NF when A is the primary key
- **Resolution:** Extract transitive dependencies into separate tables

## Redundancy Elimination

The source emphasizes that proper normalization guarantees:
- Each piece of information is stored exactly once
- Reduction of data anomalies (insertion, update, deletion anomalies)
- Improved data integrity and consistency

## Related Pages

- [[03-RESOURCES/concepts/normalizacao|Normalização de Banco de Dados (Completo)]] — detailed coverage from FIAP phase 3
- [[03-RESOURCES/concepts/sql|SQL — Structured Query Language]]
- [[03-RESOURCES/concepts/modelo-entidade-relacionamento|MER — Modelo Entidade-Relacionamento]]
- [[02-AREAS/fiap/fase-3/fase-3-index|Fase 3 — Modelling]]

## Cross-References

**WikiLinks:**
- [[03-RESOURCES/concepts/sql]]
- [[02-AREAS/fiap/fase-3/fase-3-index|Fase 3]]

**Concepts touched:**
- Redundancy reduction
- Data integrity
- Relational database design
- Table decomposition
- Atomic values
- Primary key design
- Transitive vs. partial dependencies
