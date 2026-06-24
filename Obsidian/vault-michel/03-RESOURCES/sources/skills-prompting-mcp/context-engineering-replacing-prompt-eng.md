---
title: "Context Engineering Is Replacing Prompt Engineering"
type: source
source: Clippings/Context Engineering Is Replacing Prompt Engineering. Here's How It Works.md
author: "@eng_khairallah1"
published: 2026-05-28
ingested: 2026-05-28
tags: [context-engineering, prompt-engineering, claude-code, mcp, ai-agents]
---

## Tese central

Claude 4.6 não precisa mais de role-playing nem de templates elaborados — o bottleneck mudou de "quais palavras escrever" para "qual ambiente de informação construir". Context engineering é a prática de projetar e manter o ambiente completo que Claude usa para gerar respostas.

## Argumentos principais

- **Prompt engineering = evento isolado** — reinicia do zero cada sessão, re-explica contexto, resultados inconsistentes
- **Context engineering = construção de ambiente** — o que Claude precisa ter acesso para produzir resultados consistentes independente da sessão
- **Trade-off central**: gastar tempo em prompts elaborados vs gastar tempo construindo context rico → context ganha
- **Quando o ambiente certo existe**: você mal precisa de prompt — "escreva o relatório semanal" já funciona

## Os 5 Layers de Context Engineering

1. **Identity Context (Quem você é)** — custom instructions com nome, role, indústria, audiência, estilo preferido; Projects por área de trabalho separados
2. **Knowledge Context (O que Claude precisa saber)** — upload de documentos permanentes: style guide, brand docs, product specs, exemplos de trabalho passado, coding standards
3. **Memory Context (O que Claude aprendeu sobre você)** — persistência cross-session; construção ativa ("remember that..."); compound effect enorme após 1 mês
4. **Tool Context (O que Claude pode acessar)** — MCP servers: Gmail, Drive, Slack, GitHub, databases, web search; cada tool = novo contexto disponível
5. **Conversation Context (Esta sessão específica)** — o que aconteceu nesta conversa; limpeza periódica de contexto irrelevante (/compact)

## Key insights

- **Brilliant new employee analogy**: prompt engineering = instruir para 1 tarefa; context engineering = dar onboarding completo
- **"The more knowledge context Claude has, the less prompting you need"** — inversão contraintuitiva
- **Memory compound effect**: após 1 mês de construção ativa, Claude antecipa preferências, formata automaticamente
- **MCP como "tool context"**: cada integração é contexto que Claude não tinha antes
- **Limpeza de contexto**: purgar informação irrelevante é tão importante quanto adicionar

## Exemplos e evidências

- Projects separados por área (content, business analysis, coding) com system prompts e knowledge files dedicados
- Upload de brand guide, product docs, customer personas, coding standards — done once, referenced forever
- Centenas de integrações via MCP já disponíveis

## Implicações para o vault

Diretamente relacionado ao design do vault-michel como ambiente de context engineering para o Nexus. Reforça [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — adiciona framework de 5 layers. Complementa [[04-SYSTEM/agents/nexus]] — vault como layer de Knowledge + Memory Context para Claude Code sessions.

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-projects]]
- [[04-SYSTEM/agents/nexus]]
