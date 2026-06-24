---
title: "Normalização de Banco de Dados"
type: concept
status: developing
tags: [banco-de-dados, modelagem, sql, fiap-fase-3]
source: ".raw/fiap/Fase 3 - Modelling/1TDS - Fase 03 - 06 - Aprendendo a armazenar.docx_RevFinal.pdf"
created: 2026-04-14
updated: 2026-05-19
---

# Normalização de Banco de Dados

Processo de organizar as tabelas de um banco de dados relacional para **reduzir redundância** e **melhorar a integridade dos dados**. Coberto na Fase 3 (apostila 06 — "Aprendendo a armazenar de maneira correta").

## Objetivo

- Eliminar dados duplicados
- Garantir dependências lógicas entre os atributos
- Facilitar manutenção e evitar anomalias de inserção, atualização e exclusão

## Formas Normais

### 1FN — Primeira Forma Normal
**Regra:** Eliminar grupos repetitivos. Cada célula deve conter um único valor atômico.

- Não pode ter colunas com múltiplos valores
- Cada linha deve ser única (chave primária definida)

**Exemplo:** Uma nota fiscal com múltiplos produtos na mesma linha viola 1FN. Solução: separar em entidades `NOTA_FISCAL` e `ITEM_NF`.

### 2FN — Segunda Forma Normal
**Regra:** Estar em 1FN + todos os atributos não-chave devem depender **totalmente** da chave primária (sem dependências parciais).

- Aplica-se apenas a tabelas com chave primária composta
- Se um atributo depende só de parte da chave, deve ir para outra tabela

**Exemplo:** `ITEM_NF(nf_id, produto_id, nome_produto, quantidade)` — `nome_produto` depende só de `produto_id`, não da chave composta inteira. Mover `nome_produto` para `PRODUTO`.

### 3FN — Terceira Forma Normal
**Regra:** Estar em 2FN + nenhum atributo não-chave pode depender transitivamente de outro atributo não-chave.

- Se A → B → C (onde A é a chave), então B → C é uma dependência transitiva violando 3FN
- Solução: extrair B e C para uma nova tabela

**Exemplo:** `NOTA_FISCAL(nf_id, cliente_id, nome_cliente, endereco_cliente)` — `nome_cliente` e `endereco_cliente` dependem de `cliente_id`, não de `nf_id`. Extrair para tabela `CLIENTE`.

## Formas Normais Avançadas

- **BCNF (Forma Normal de Boyce-Codd)** — versão mais rigorosa da 3FN
- **4FN** — elimina dependências multivaloradas
- **5FN** — elimina dependências de junção

Na prática, chegar em 3FN já é suficiente para a maioria dos sistemas.

## Atributos especiais (tratamento na normalização)

- **Atributos compostos** — dividir em atributos atômicos antes de normalizar
- **Atributos multivalorados** — criar tabela associativa (entidade fraca)

## Fontes

- [[02-AREAS/fiap/sources/normalizacao-banco-dados-overview|Normalização — Overview]] (2026-04-18)

## Relacionado

- [[03-RESOURCES/concepts/dev-foundations/modelo-entidade-relacionamento|MER — Modelo Entidade-Relacionamento]]
- [[03-RESOURCES/concepts/dev-foundations/sql|SQL]] — DDL que implementa o modelo normalizado
- [[02-AREAS/fiap/fase-3/fase-3-index|Fase 3 — Modelling]]
