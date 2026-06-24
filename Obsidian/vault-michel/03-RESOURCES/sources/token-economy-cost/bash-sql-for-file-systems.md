---
title: "Bash is the SQL for file systems"
type: source
source_file: .raw/articles/Bash is the SQL for file systems.md
author: Hunter Leath (@jhleath)
ingested: 2026-04-17
tags: [file-systems, serverless-execution, archil, egress, databases, bash]
triagem_score: 6
---

# Bash is the SQL for file systems

> [!summary]
> Hunter Leath (Archil) explica por que sistemas de arquivos têm um problema estrutural de egress que bancos de dados não têm: databases embarcam computação junto ao dado e transferem apenas o resultado. Archil está construindo o mesmo primitivo para file systems via serverless execution com Bash como linguagem de query.

## A Insight Central

**Por que o Databricks não tem problemas de egress e file systems têm?**

- **File system (grep):** cliente baixa TODOS os arquivos que estão sendo buscados, filtra localmente. 100 GBs de egress.
- **Database (SELECT WHERE):** cliente envia instrução ao banco. O banco tem compute embutido, usa índices, otimiza a query, retorna apenas os dados pedidos. <2 KBs de egress.

A diferença: o database não transfere dados diretamente. **Ele transfere instruções sobre como interagir com os dados.**

## A Analogia

```
SQL     : banco de dados  ::  Bash  : sistema de arquivos
```

Bash é a lingua franca que já usamos para interagir com file systems. A solução é permitir que o cliente envie um comando bash completo que é executado dentro do file system, retornando apenas o resultado.

## O que Archil está Construindo

**Serverless execution** para file systems:
- Executa Bash colocado nos servidores onde o storage vive (elimina latência de rede)
- Planner pode otimizar e fazer fan-out do bash para múltiplos compute nodes internos
- Cliente não precisa se preocupar com egress, latência ou sizing de instância

## Relevância para AI Agents

Agentes têm problemas estateful: conversation history, prompts, memória, contexto — tudo stateful. Serverless execution vai se tornar parte vital desse stack.

> [!insight]
> O artigo aplica o princípio de "compute-near-data" ao problema de egress em agent infrastructure. Quando agentes precisam buscar em grandes file systems de memória, o custo de egress se torna proibitivo sem essa arquitetura.

## Conceitos Relacionados

- [[agent-memory-architecture]]
- [[serverless-execution]]

## Entidades Mencionadas

- [[Hunter-Leath]] — autor (@jhleath); Archil
- [[Archil]] — startup de file system com serverless execution
- [[Nikita-Shamgunov]] — @nikitabase; mencionado; Databricks context
