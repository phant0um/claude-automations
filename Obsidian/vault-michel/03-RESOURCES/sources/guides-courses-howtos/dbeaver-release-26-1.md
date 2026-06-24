---
title: "DBeaver release 26.1"
type: source
source_url: "https://dbeaver.com/2026/06/10/dbeaver-26-1/"
author: "DBeaver"
published: 2026-06-10
created: 2026-06-22
updated: 2026-06-22
score: B
category: guides-courses-howtos
tags: [source, dbeaver, mcp, sql, database-management, ai-chat, dbvr, release-notes]
---

# DBeaver release 26.1

DBeaver 26.1 traz mais formas de trabalhar com IA e melhora a experiência de SQL scripting: external MCP servers no AI Chat, dbvr como MCP server, novo Query Execution Plan, e três novos database drivers.

## Tese Central

DBeaver 26.1 integra MCP (Model Context Protocol) profundamente em seu ecossistema — tanto consumindo (external MCP servers no AI Chat para dar ao modelo conhecimento que não tem) quanto expondo (dbvr como MCP server para que Claude CLI e outras tools possam browse catalogs, schemas, tabelas e rodar SQL). Lança também dbvr Community (open-source, Apache 2.0), novo Query Execution Plan visual, e suporte a Microsoft Fabric, Valkey, e GizmoSQL.

## Pontos-Chave

### Connect External AI MCP Servers

- External MCP servers disponíveis em DBeaver PRO apps
- AI model já conhece schema; MCP server adiciona conhecimento que o modelo não tem (ex: sintaxe do PostgreSQL mais recente)
- Múltiplos servers, cada um cobrindo área diferente
- Em CloudBeaver Enterprise / DBeaver Team Edition Web: admins adicionam MCP servers centralmente

### Run dbvr as MCP Server

- dbvr pode rodar como MCP server para conexão específica
- Gera JSON snippet pronto para colar em IDE ou tool de IA
- Claude CLI conectado via MCP: browse catalogs, schemas, tabelas, ler estrutura, rodar SQL
- Trabalha dentro das permissões do database user

### dbvr Community (Open Source)

- CLI database management tool, Apache License 2.0
- Free, disponível no GitHub
- vs dbvr (PRO): sem NoSQL, cloud databases, cloud storages, enterprise SSO, MCP server config

### Novo Query Execution Plan

- Tree view redesenhado, node collapsing melhorado, visual cost indicator
- Node details em right-side panel
- Pode enviar plano para AI Chat: explicação em linguagem natural + identificação de bottlenecks
- Disponível em todos DBeaver PRO desktop, CloudBeaver Enterprise, DBeaver Team Edition

### Novos Database Drivers

- **Microsoft Fabric**: enterprise analytics platform com data lake foundation
- **Valkey**: fork open-source Linux Foundation do Redis 7.2, key-value store
- **GizmoSQL**: OLAP engine com DuckDB + Apache Arrow Flight SQL

## Conceitos

- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — MCP
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-server-curation]] — curadoria de MCP servers
- [[03-RESOURCES/concepts/dev-foundations/sql]] — SQL

## Links

- [[03-RESOURCES/entities/MCP]] — protocolo usado