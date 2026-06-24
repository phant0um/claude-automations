---
title: Context7
type: entity
category: tool
tags: [mcp, documentacao, codigo, llm, developer-tools]
created: 2026-05-31
updated: 2026-05-19
---

# Context7

## O que é

Servidor MCP que injeta **documentação sempre atualizada** de qualquer biblioteca diretamente no contexto do Claude. Elimina alucinações de API, métodos deprecated e tempo perdido debugando código que não existe.

## Uso
Adicionar "use context7" no prompt. Claude recebe automaticamente a documentação atual de Next.js, React, Supabase, MongoDB, e milhares de outras bibliotecas.

## Problema que resolve
Sem Context7: Claude usa conhecimento de treinamento (possivelmente desatualizado) → APIs inexistentes → 30 min de debug desnecessário.
Com Context7: docs atuais injetadas → código correto na primeira vez.

## Onde aparece no vault
- [[03-RESOURCES/sources/skills-prompting-mcp/mcp-servers-complete-guide-khairallah]] — terceiro dos 5 MCPs essenciais; "não negociável para quem escreve qualquer código"

## Conceito relacionado
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
