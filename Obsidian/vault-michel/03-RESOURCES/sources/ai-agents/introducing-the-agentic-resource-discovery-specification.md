---
title: "Introducing the Agentic Resource Discovery specification"
type: source
source: "https://commandline.microsoft.com/agentic-resource-discovery-specification-ard/"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, agentic-resource-discovery, ard, microsoft, mcp, open-specification]
---

## Tese Central

A Agentic Resource Discovery (ARD) specification é uma camada comum e aberta para publishing, indexing e discovery de capabilities de AI. Assim como search engines resolveram o problema de discovery na web早期, ARD resolve o problema de discovery no ecossistema agentic — onde agents só podem usar resources explicitamente conectados, mas o ecossistema já número na casa das centenas de milhares. ARD permite que um AI client pergunte "que resource pode ajudar com esta task?" e receba capabilities matching com tudo necessário para invocá-las.

## Pontos-Chave

1. **Problema**: Cada AI client só usa resources explicitamente conectados. Orders of magnitude entre o que qualquer agent pode ver e o que realmente existe. Manual wiring não escala — worked quando havia handful de resources, break down quando toda empresa/publica tools próprias.
2. **Analogia web inicial**: Milhões de páginas existiam mas pessoas só visitavam bookmarks prefilled. Directories manuais não acompanhavam. Search engines resolveram com discovery layer. ARD faz o mesmo para agentic resources.
3. **ARD vs web search**: Web search funcionou porque a web já tinha surface discoverable (links, HTML, HTTP). Agentic resources não tinham surface equivalente — nome + URL não basta. Precisa de structured info: o que faz, quando usar, inputs, authority requerida, quem opera, como invocar, se é apropriado para user/org/policy.
4. **Architectural property tipo DNS**: Não é single global catalog. Múltiplos discovery services, cada um indexando/ servindo/ rankeando diferentemente. Local control + upstream sources + ecosystem maior. Org resolve private + public names pelo mesmo resolver.
5. **Reference implementations**: GitHub agent finder (Copilot dynamically descobre e chama MCP servers/skills/tools/agents em runtime, previne context bloat); Hugging Face Discover Tool (search access a thousands de skills, ML apps, MCP servers).
6. **Collaborators**: Cisco, Databricks, GitHub, GoDaddy, Google, Hugging Face, Nvidia, Salesforce, ServiceNow, Snowflake.
7. **Sits before invocation**: ARD ajuda o client a decidir qual capability usar. Invocação acontece pelo protocolo próprio do resource (MCP, API, workflow). ARD não substitui auth, authorization, governance, ou organizational trust.

## Conceitos

- **Agentic Resource Discovery (ARD)**: specification aberta para publishing, indexing e discovery de AI capabilities
- **Discovery service**: serviço que indexa resources e retorna ranked matches para queries em natural language
- **Agent finder**: capability do GitHub Copilot que dynamically descobre e chama resources em runtime
- **Discovery surface**: structured info necessária para discover/use um resource com segurança

## Links

- [[03-RESOURCES/entities/MCP]]
- [[03-RESOURCES/entities/GitHub]]
- [[03-RESOURCES/entities/Microsoft]]
- [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]