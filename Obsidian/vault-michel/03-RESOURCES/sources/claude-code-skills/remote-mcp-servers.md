---
title: "Remote MCP Servers (Directory)"
type: source
source: "Clippings/Remote MCP servers.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, mcp, remote-servers, directory, third-party]
---

## Tese central

Catálogo oficial da Anthropic (`platform.claude.com/docs/.../agents-and-tools/remote-mcp-servers`) listando **mais de 250 servidores MCP remotos de terceiros** prontos para conectar via [[03-RESOURCES/sources/mcp-connector]] (Messages API). Não é documentação de API — é um **diretório curado com disclaimer explícito de não-endosso**, complementar às duas docs de connector ao fornecer o "onde conectar" depois que ambas explicam o "como conectar".

## Argumentos principais

- **Disclaimer central e repetido:** "These servers are not owned, operated, or endorsed by Anthropic. Users should only connect to remote MCP servers they trust and should review each server's security practices and terms before connecting." Esse aviso de confiança/segurança é o enquadramento institucional de toda a página.
- **Fluxo de conexão recomendado (3 passos):** (1) revisar a documentação do servidor específico, (2) garantir que se tem as credenciais de autenticação necessárias, (3) seguir as instruções de conexão específicas de cada empresa.
- **Comportamento de trigger idêntico ao de qualquer outra tool:** "Once connected, remote MCP tools follow the same triggering behavior as any other tool" — referência direta à seção "When Claude uses MCP tools" de [[03-RESOURCES/sources/mcp-connector]]. Não há regra especial para servidores de terceiros vs servidores próprios.
- **A lista cobre dezenas de categorias e domínios** — alguns exemplos representativos do volume e diversidade (não exaustivo):
  - **Produtividade/PM:** Linear, monday.com, ClickUp, Asana-like (Smartsheet), Notion, Todoist
  - **CRM/Vendas:** HubSpot, Attio, Salesforce-adjacent (Close), Clay, Klaviyo, Zoho CRM
  - **Financeiro/Pagamentos:** Stripe, PayPal, Brex, Ramp, Mercury, Xero, QuickBooks, Plaid-like (GoCardless)
  - **Dev/Infra:** Cloudflare, Vercel, Netlify, Sentry, Databricks, Snowflake, Supabase, BigQuery
  - **Reuniões/transcrição:** Otter.ai, Fireflies, Fathom, Granola, Read AI, Krisp, Circleback
  - **Dados/pesquisa:** Exa, Tavily, Hugging Face, PubMed, ICD-10 Codes, Context7, Sourcegraph
  - **Viagens/lazer:** Expedia, Booking.com, Uber, Tripadvisor, Kiwi.com, AllTrails
  - **Jurídico:** CourtListener, Courtroom5, Definely, Everlaw, Descrybe Legal Engine, Trellis
  - **Design/criação:** Figma, Canva, Gamma, Lucid, tldraw, Adobe (múltiplos produtos)
  - Empresas próprias da Anthropic também aparecem como remote MCP servers: **Microsoft 365** (`microsoft365.mcp.claude.com`), **PubMed** (`pubmed.mcp.claude.com`), **ICD-10 Codes** (`hcls.mcp.claude.com`)
- **Formatos de URL variam por servidor:** maioria expõe URL pública fixa (ex: `https://mcp.linear.app/mcp`), mas vários exigem **URL específica do usuário** obtida via fluxo próprio (ex: Port IO, Tray.ai, Databricks, Glean, Snowflake, Sigma, Benchling, Workato, Natoma, Customer.io, n8n, Pendo, Starburst, Metabase, Tines, Sourcegraph, Smartsheet, ActiveCampaign, Dremio Cloud, Retool, Hex, SandboxAQ, Relativity, Lloyd by The L Suite).
- **Apontamento para mais opções:** "Looking for more? Find hundreds more MCP servers on GitHub" → [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) — reconhece explicitamente que esta lista oficial é apenas um subconjunto curado de um ecossistema muito maior.

## Key insights

- **A escala da lista (250+) é, por si só, um indicador de maturidade do ecossistema MCP** — em poucos meses (a julgar pelas datas de criação relativamente recentes de muitas dessas integrações), o protocolo passou de "novo padrão experimental" a "superfície de integração padrão da indústria", com players de peso pesado (Stripe, Shopify, Snowflake, Databricks, Google Cloud, AWS Marketplace, Adobe) publicando servidores oficiais.
- **A presença de domínios sensíveis (jurídico, financeiro, saúde/PubMed/ICD-10, RH/recrutamento)** torna o disclaimer de confiança/segurança não-cosmético — conectar a um servidor MCP de terceiros em domínio regulado herda os riscos de dados e compliance desse terceiro. Esse é o ponto onde "Limitations" e "Authentication" de [[03-RESOURCES/sources/mcp-connector]] (OAuth, ZDR não-elegível) se tornam criticamente relevantes na prática, não apenas teoricamente.
- **A divisão entre "URL pública fixa" e "URL específica do usuário"** revela dois modelos de distribuição de servidor MCP: (a) servidor multi-tenant compartilhado com auth por token (a maioria), e (b) servidor provisionado/roteado por conta, exigindo um passo extra de configuração antes mesmo de chegar ao `mcp_servers` da API. Essa distinção não está em nenhuma das docs de connector — só se torna visível ao examinar o catálogo real.
- **A própria Anthropic publica servidores MCP remotos sob domínios `*.mcp.claude.com`** (Microsoft 365, PubMed, ICD-10) — confirma que a empresa não é só fornecedora do protocolo/connector, mas também operadora de servidores MCP de produção, especialmente em integrações de alto valor/baixo risco regulatório (dados públicos biomédicos, conectores empresariais de primeira parte).
- **O link final para o repositório GitHub `modelcontextprotocol/servers`** posiciona esta página como apenas a "ponta visível" de um ecossistema descentralizado muito maior — relevante para qualquer trabalho de descoberta/curadoria de servidores MCP no vault.

## Exemplos e evidências

URLs representativas (formato fixo, prontas para usar em `mcp_servers.url`):
```
https://mcp.linear.app/mcp
https://mcp.stripe.com
https://mcp.notion.com/mcp
https://microsoft365.mcp.claude.com/mcp
https://pubmed.mcp.claude.com/mcp
https://hcls.mcp.claude.com/icd10_codes/mcp
https://github.com/modelcontextprotocol/servers   (diretório com "hundreds more")
```

Exemplos de servidores que requerem URL específica do usuário (não há URL fixa publicável):
```
Port IO, Tray.ai, Databricks, Glean, Snowflake, Sigma, Benchling,
Workato, Natoma, Customer.io, n8n, Pendo, Starburst, Metabase
```

Texto do disclaimer (citação direta, relevante para qualquer política de confiança do vault):
> "These servers are not owned, operated, or endorsed by Anthropic. Users should only connect to remote MCP servers they trust and should review each server's security practices and terms before connecting."

Volume: a contagem de entradas distintas listadas excede **250 servidores** cobrindo dezenas de verticais de negócio.

## Implicações para o vault

- Esta página é o **catálogo de referência** que torna [[03-RESOURCES/sources/mcp-connector]] acionável na prática — qualquer entidade `*-MCP.md` já existente no vault (ex: [[03-RESOURCES/entities/Notion-MCP]], [[03-RESOURCES/entities/Slack-MCP]], [[03-RESOURCES/entities/Stripe-MCP]], [[03-RESOURCES/entities/Figma-MCP]], [[03-RESOURCES/entities/Google-Calendar-MCP]], [[03-RESOURCES/entities/Google-Drive-MCP]], [[03-RESOURCES/entities/Gmail-MCP]], [[03-RESOURCES/entities/Zapier-MCP]], [[03-RESOURCES/entities/Canva-MCP]], [[03-RESOURCES/entities/Excalidraw-MCP]], [[03-RESOURCES/entities/Perplexity-MCP]], [[03-RESOURCES/entities/TradingView-MCP]]) tem agora uma fonte oficial de URL e contexto de catálogo — vale checar se as URLs registradas nessas entidades batem com as listadas aqui, e se entradas estão desatualizadas.
- O disclaimer de confiança/segurança é diretamente relevante a [[03-RESOURCES/concepts/agent-security]] e [[03-RESOURCES/concepts/claude-code-tooling/mcp-server-curation]] — esta fonte é evidência primária de que a própria Anthropic trata o ecossistema MCP de terceiros como **zona de confiança não-verificada por padrão**.
- A descoberta de que servidores se dividem entre "URL fixa" e "URL específica do usuário" é um detalhe operacional que faltaria em qualquer trabalho de automação/onboarding de MCP no vault — vale documentar em [[03-RESOURCES/concepts/claude-code-tooling/mcp-server-curation]] se esse conceito for expandido.
- Confirma que [[03-RESOURCES/entities/MCP]] como protocolo está em adoção de mercado real e ampla — não é mais "padrão emergente", é infraestrutura padrão com 250+ integrações de produção catalogadas oficialmente.

## Links

- [[03-RESOURCES/sources/mcp-connector]]
- [[03-RESOURCES/sources/mcp-connector-1]]
- [[03-RESOURCES/entities/MCP]]
- [[03-RESOURCES/entities/Notion-MCP]]
- [[03-RESOURCES/entities/Slack-MCP]]
- [[03-RESOURCES/entities/Stripe-MCP]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-server-curation]]
- [[03-RESOURCES/concepts/agent-security]]
