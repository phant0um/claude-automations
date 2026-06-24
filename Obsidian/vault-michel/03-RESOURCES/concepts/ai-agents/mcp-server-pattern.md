---
title: MCP Server Pattern
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, mcp, server, integration, tools]
---

# MCP Server Pattern

Model Context Protocol (MCP) como padrão para conectar systems externos ao agent loop. Specialist agent como MCP server = decomposition of expertise.

## Princípio

- Knowledge it should just know → Skill
- Context from a system → MCP connector
- A new ability (run code, query DB) → MCP tool
- Add only tools the job needs — every extra tool is another thing it can misuse

## Pattern: orchestrator + specialist via MCP

```
Agent principal (orchestrator)
  ├── MCP server 1 (specialist: Spark troubleshooting)
  ├── MCP server 2 (specialist: database)
  └── MCP server 3 (specialist: monitoring)
```

## Evidências

- [[03-RESOURCES/sources/articles/aws-devops-agent-spark-troubleshooting]] — AWS DevOps Agent + Apache Spark Troubleshooting Agent como MCP server

## Links

- [[04-SYSTEM/agents/nexus-agent-system/model-router]]
- [[03-RESOURCES/concepts/ai-agents/agent-loop-pattern]]