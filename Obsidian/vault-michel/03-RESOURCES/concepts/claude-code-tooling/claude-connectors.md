---
title: Claude Connectors
type: concept
status: developing
tags: [claude, connectors, mcp, integrações, tools, workflow]
created: 2026-04-19
updated: 2026-04-19
---

# Claude Connectors

Integrações que ligam Claude às ferramentas e dados que você já usa. Transformam Claude de assistente genérico em colaborador que trabalha com suas informações reais — sem copy-paste.

> [!key-insight] MCP por baixo
> Connectors são a face de usuário do [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — o padrão aberto que permite qualquer ferramenta se conectar ao Claude com uma interface única. Funciona como "USB-C para IA".

## Dois tipos de connectors

### Web connectors
Serviços cloud — Google Drive, Notion, Slack, Asana, Linear, Stripe, Gmail, e muito mais.
- Instalados via `claude.ai/directory`
- Autenticam com OAuth (login normal da sua conta)
- Permissões específicas por connector (scoped access)

### Desktop extensions
Rodam localmente no app desktop. Dão ao Claude acesso a apps nativos e arquivo locais.
- Requerem o app Claude Desktop
- Instalados via Settings > Extensions
- Exemplos: acesso a arquivos locais, controle de browser, integração com Figma

## Como conectar

1. **Navegar** para `claude.ai/directory` ou "Search and tools" > "Add connectors"
2. **Clicar Connect** no serviço escolhido
3. **Autenticar** — redirecionamento para login da plataforma
4. **Revisar permissões** — quais acessos Claude vai ter
5. **Testar**: "Can you access my [tool name]?"

## Uso em prática

**Project management (Asana, Linear, Jira)**
- "What are my highest priority tasks due this week?"
- "Create a new task for reviewing the Q4 budget proposal"

**Communication (Slack, Gmail)**
- "Find the email thread where we discussed the vendor contract"
- "Draft a reply to the latest message in the #marketing channel"

**Documentation (Notion, Google Drive, Confluence)**
- "Search our documentation for brand voice guidelines"
- "Summarize the meeting notes from last week's product review"

**Business tools (Stripe, Salesforce)**
- "Show me revenue trends for the past quarter"
- "List recent transactions over $1,000"

## Segurança

- **Scoped access** — permissões específicas; toggle individual por app
- **Claude vê o que você vê** — se você não tem acesso ao inbox do CEO, Claude também não tem
- **Revogável a qualquer momento** — via Settings do Claude ou configurações do serviço de terceiro
- **Instale apenas de fontes confiáveis** — mesmo princípio das Skills

## Cowork + connectors

No modo Cowork, Claude pode cruzar dados de múltiplos connectors numa única tarefa:
- *"Review what we decided about pricing last quarter across meeting notes, Slack, and email, then update our Q3 deck with the findings"*
- Research mode usa connectors Google Workspace (Drive, Gmail, Calendar) junto com busca na web

## Relação com outros conceitos

- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — o protocolo técnico por baixo dos connectors
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — perspectiva de developer (instalação e configuração de MCP servers)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-projects]] — Projects podem usar connectors (ex: Google Drive)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]] — Plugins do Cowork têm papel similar para o modo Cowork

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/claude-101-anthropic-course]]
- [[03-RESOURCES/sources/skills-prompting-mcp/mcp-servers-complete-guide-khairallah]]
