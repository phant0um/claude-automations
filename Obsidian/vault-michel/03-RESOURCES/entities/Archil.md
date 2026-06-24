---
title: Archil
type: entity
category: product
tags: [file-system, serverless-execution, storage, egress, agents]
created: 2026-04-17
updated: 2026-05-19
---

# Archil

Startup construindo o primeiro file system com serverless execution como primitivo de primeira classe. Resolve o problema de egress em sistemas de arquivo aplicando o mesmo princípio que bancos de dados usam: embarcar compute junto ao dado.

## O Problema que Resolve

File systems tradicionais: cliente baixa todos os arquivos para buscar → egress enorme.
Bancos de dados: compute embarcado no banco, retorna apenas resultado → egress mínimo.

Archil: cliente envia um comando Bash completo que é executado **dentro do file system**, retornando apenas o resultado — mesma economia que SQL oferece para bancos de dados.

## Serverless Execution

- Executa Bash colocado nos servidores onde o storage vive (latência mínima)
- Planner pode otimizar e fazer fan-out para múltiplos compute nodes
- Cliente não se preocupa com egress, latência ou sizing de instância

## Relevância para AI Agents

Agentes têm problemas stateful (conversation history, memória, contexto). Serverless execution vai se tornar parte vital do agent stack quando agentes precisam buscar em grandes file systems de memória.

## Onde aparece no vault

- [[03-RESOURCES/sources/token-economy-cost/bash-sql-for-file-systems]]
- [[03-RESOURCES/sources/filesystem-is-the-agent]] — tese ampliada: o file system não é só storage+compute, mas o próprio agente (harness, histórico, triggers como dados persistidos)

## Links externos

- console.archil.com
- Fundador: Hunter Leath (@jhleath)
