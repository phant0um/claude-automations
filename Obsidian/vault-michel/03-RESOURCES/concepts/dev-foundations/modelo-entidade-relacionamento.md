---
title: MER — Modelo Entidade-Relacionamento
type: concept
status: developing
tags: [banco-de-dados, modelagem, fiap, fase-3]
created: 2026-04-14
updated: 2026-05-19
---

# MER — Modelo Entidade-Relacionamento

Técnica de modelagem de dados que representa a estrutura lógica de um banco de dados através de **entidades**, **atributos** e **relacionamentos**.

## Componentes

| Elemento | Descrição | Notação |
|----------|-----------|---------|
| **Entidade** | Objeto do mundo real (ex: `CLIENTE`) | Retângulo |
| **Atributo** | Propriedade de uma entidade (ex: `nome`) | Elipse |
| **Relacionamento** | Associação entre entidades (ex: `REALIZA`) | Losango |
| **Chave primária (PK)** | Atributo que identifica unicamente | Sublinhado |
| **Chave estrangeira (FK)** | Referência à PK de outra entidade | — |

## Cardinalidade

- **1:1** — Um cliente tem um CPF
- **1:N** — Um cliente faz várias transações
- **N:N** — Um produto aparece em vários pedidos e vice-versa

## Projeto Fintech (FIAP)

O modelo MER do projeto Fintech foi desenvolvido na Fase 3 usando Oracle SQL Developer Data Modeler (`RM567709_FINTECH_MER.dmd`).

## Ver também

- [[03-RESOURCES/concepts/dev-foundations/sql|SQL]]
- [[03-RESOURCES/concepts/dev-foundations/normalizacao|Normalização]]
- [[03-RESOURCES/entities/Oracle-SQL|Oracle SQL]]
- [[02-AREAS/fiap/fase-3/fase-3-index|Fase 3 — Modelling]]
