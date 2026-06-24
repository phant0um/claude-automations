---
title: "Post by @KingBootoshi on X — ADR + Coding Agents"
type: source
source: "Clippings/Post by @KingBootoshi on X.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, claude-code, adr, software-architecture, coding-agents]
---

## Tese central
Manter um ADR (Architectural Decision Records) local no codebase e fazer agentes de código (Claude Code, Codex) referenciarem esses docs durante sessões de trabalho alinha completamente as decisões do agente com o "gosto" arquitetural do desenvolvedor, transformando a qualidade da colaboração de forma exponencial.

## Argumentos principais
- Arquitetura de alto nível é a camada mais importante da engenharia de software; escrita de código manual virou detalhe de implementação que agentes executam bem
- ADR captura decisões críticas (ex: tenant scoping obrigatório em todas as queries de banco) que seriam re-discutidas em cada nova sessão de agente sem documentação
- Decisões arquiteturais podem ser enforcement-adas via ESLint rules customizadas — se o agente gerar código sem tenant scoping, o linter não deixa commitar
- Futuras sessões de agentes leem os ADR docs e "instantaneamente entendem o taste do codebase" sem que o desenvolvedor repita contexto

## Key insights
- Workflow: conversa com agente → decisão crítica emerge → "Add this to our ADR" → decisão capturada → próximos agentes herdam o contexto
- ADR pequeno e focado é melhor que ADR grande; decisões de estilo/pattern devem ir em Constitution ou Guidelines (não ADR)
- Quality Gates como ESLint rules = ADR enforcement automatizado: agente não pode commitar código que viole a decisão arquitetural
- Codex 5.5 é "very good" em seguir ESLint rules customizadas — validação prática de enforcement via linter
- /armor skill: KingBootoshi menciona skill própria para "armar" o codebase com quality gates
- Spec tests (referência a @mattpocockuk): suite de testes que valida que o que está documentado está implementado e vice-versa

## Exemplos e evidências
- Caso concreto: tenant scoping em banco de dados → "mistaking what role can access what data is a company shattering error" → centralizado em sistema de scoping que todos os agentes devem usar
- Referência a TLA+ specs como equivalente formal de spec-driven development
- Projeto Specter mencionado: TypeScript framework para specs que compilam, executam e scaffoldam a app — agentes trabalhando em codebases grandes de forma confiável

## Implicações para o vault
O conceito de ADR como memória arquitetural persistente para agentes é diretamente análogo ao uso de AGENTS.md e CLAUDE.md no vault. Fortalece a prática existente de documentar decisões de design para agentes. Adiciona o padrão de enforcement via linter (quality gates) como extensão natural de documentação arquitetural.

## Links
- [[03-RESOURCES/entities/everything-claude-code]]
- [[03-RESOURCES/concepts/agent-security]]
- [[03-RESOURCES/concepts/externalized-memory]]
- [[03-RESOURCES/concepts/agentic-memory-taxonomy]]
