---
title: "50 Claude Plugins & MCP Integrations That Most Users Don't Know"
type: source-summary
source_type: social-media-thread
author: "@eng_khairallah1"
source_url: "https://x.com/eng_khairallah1/status/2049784265613967730"
published: 2026-04-30
created: 2026-05-01
tags: [mcp, claude, integrations, connectors, plugins]
triagem_score: 7
---

# 50 Claude Plugins & MCP Integrations

**Author:** @eng_khairallah1 (Khairallah AL-Awady)
**Signal:** Comprehensive catalog of Claude integrations — built-in connectors + MCP servers organized by domain.

## Three Integration Types

| Type | Install method | Config required |
|------|---------------|----------------|
| **Built-in Connectors** | Click in Desktop settings | None |
| **MCP Servers** | npm/pip + config file | Yes (5-10 min) |
| **Plugins** | Marketplace | Varies |

## Built-In Connectors (01-10)

Gmail, Google Calendar, Google Drive, Slack, Notion, OneDrive, SharePoint, Microsoft 365, Google Docs, Google Sheets.
No API keys. Click to enable in Claude Desktop.

## Essential MCP Servers (11-20)

| # | Server | What it does |
|---|--------|-------------|
| 11 | **Tavily** | Real-time web search; 4 tools: search/extract/crawl/map |
| 12 | **Context7** | Injects live library docs; add "use context7" to prompt |
| 13 | **Task Master AI** | PRD → structured tasks with dependencies |
| 14 | **GitHub MCP** | Read repos, issues, PRs |
| 15 | **Postgres MCP** | Direct DB queries (read-only recommended) |
| 16 | **Supabase MCP** | DB + auth + storage |
| 17 | **Linear MCP** | Issues, status, tasks |
| 18 | **Sentry MCP** | Error reports, stack traces, pattern detection |
| 19 | **Jira MCP** | Enterprise project management |
| 20 | **Confluence MCP** | Enterprise wiki search |

## Communication & Collaboration (21-28)

Discord, Teams, Telegram, Twilio (SMS/voice), Intercom, Zendesk, HubSpot, Salesforce.

## Development & DevOps (29-36)

Docker, Vercel, AWS (S3/CloudWatch/DynamoDB), Cloudflare, GitLab, npm, Playwright, Stealth Browser.

## Data & Analytics (37-42)

BigQuery, Snowflake, MongoDB, Airtable, Google Analytics, Mixpanel.

## File & Document (43-47)

Markdownify (PDF/image→markdown), Excel MCP, Firecrawl (site→LLM data), Dropbox, Box.

## Specialized (48-50)

| # | Tool | Purpose |
|---|------|---------|
| 48 | **FastMCP** | Build custom MCP servers in Python (one decorator) |
| 49 | **MCPHub** | Manage 10+ servers via HTTP |
| 50 | **Codebase Memory MCP** | Persistent knowledge graph of codebase across sessions |

## Recommended Power Stack (5 First)

1. Gmail + Google Calendar — daily operating view
2. Google Drive — frictionless file access
3. Tavily — real-time research
4. Slack or Microsoft 365 — team comms
5. GitHub or GitLab — code access

> "Covers 90% of knowledge work."

## MCP Install Steps

1. Find GitHub repo
2. `npm install` or `pip install`
3. Add server config to Claude config file
4. Restart Claude Desktop
5. Test with simple request

## Por que o MCP se tornou o padrão de fato

O Model Context Protocol (MCP) foi open-sourced pela Anthropic em novembro de 2024 e rapidamente se tornou o padrão de integração para LLMs — não apenas Claude. O sucesso tem razões técnicas claras:

**Protocolo agnóstico de modelo:** um MCP server escrito para Claude funciona com qualquer cliente que implemente o protocolo (GPT-4o via wrapper, Gemini via Claude Desktop fork). O ecossistema cresce para todos os modelos simultaneamente.

**Separação limpa de responsabilidades:** o MCP server expõe tools com schema JSON definido; o modelo decide como e quando usar essas tools. O server não precisa saber que modelo está chamando — só precisa implementar o protocolo.

**Descoverability:** servers anunciam suas tools com descrições que o modelo usa para decidir qual chamar. Isso permite que o modelo aprenda a usar novas ferramentas sem training específico — apenas lendo as descrições das tools.

**Transporte standard:** stdio (local) ou HTTP/SSE (remoto). A simplicidade do transporte facilita debugging e integração em qualquer linguagem.

## Os 5 primeiros que cobrem 90% do conhecimento de trabalho — análise

A recomendação de 5 MCPs iniciais não é arbitrária. Ela reflete uma análise de onde a maioria do knowledge work acontece:

**Gmail + Google Calendar:** a caixa de entrada e o calendário são o centro de gravidade do trabalho de conhecimento. A maioria das decisões, follow-ups, e agendamentos passa por email. Com acesso a Gmail, Claude pode ver contexto de conversas anteriores antes de redigir um email — eliminando o problema de "lembra do que discutimos na semana passada?".

**Google Drive:** onde documentos reais vivem. Spec documents, contratos, relatórios, apresentações. Sem acesso ao Drive, Claude só tem acesso ao que o usuário copia e cola — uma fração pequena do contexto disponível.

**Tavily:** web em tempo real. Claude sem Tavily tem cutoff de agosto de 2025. Para qualquer task com componente de "o que está acontecendo agora", Tavily é indispensável.

**Slack ou Microsoft 365:** onde as conversas de trabalho acontecem. Decisões informais, contexto de projetos, histórico de discussões — tudo isso está no Slack/Teams, não em documentos formais.

**GitHub ou GitLab:** para qualquer profissional técnico, o código e os PRs são o artefato principal do trabalho. Acesso ao repositório permite que Claude veja contexto de código sem copy-paste.

## FastMCP — construindo MCPs customizados

O FastMCP (tool #48) merece atenção especial porque resolve o problema de long-tail de integrações: para cada ferramenta específica que não tem MCP server pronto, FastMCP permite construir um em minutos:

```python
from fastmcp import FastMCP

mcp = FastMCP("my-tool")

@mcp.tool()
def get_customer_data(customer_id: str) -> dict:
    """Get customer data from internal CRM."""
    return internal_crm.get(customer_id)

mcp.run()
```

Um decorator, uma função, e o server está pronto. O schema de input/output é inferido da assinatura Python. Para empresas com sistemas internos (CRM próprio, ERPs, APIs internas), FastMCP é o caminho para integrar essas fontes sem esperar que o vendor construa um MCP server oficial.

## MCPHub — gerenciamento de múltiplos servers

Com 10+ MCP servers ativos, gerenciamento vira problema. O MCPHub (tool #49) resolve isso com um gateway HTTP que:
- Gerencia processos de múltiplos MCP servers
- Expõe um endpoint único para o cliente Claude
- Permite hot-reload de servers sem reiniciar Claude Desktop
- Fornece logging centralizado de todas as tool calls

Para times que compartilham configuração de MCPs, o MCPHub também facilita deployment: em vez de cada máquina configurar 10+ servers individualmente, o MCPHub pode ser rodado em servidor compartilhado.

## Padrões de instalação e segurança

O processo de instalação em 5 passos (find GitHub → npm/pip → config file → restart → test) esconde considerações de segurança importantes:

**Permissões:** MCPs de leitura de email (Gmail) ou banco de dados (Postgres) têm acesso a dados sensíveis. Configurar como read-only onde possível (ex: Postgres MCP no modo read-only recomendado) minimiza risco de operações destrutivas acidentais.

**Autenticação:** servers que usam API keys armazenam essas keys em config files. Garantir que o config file não seja commitado em repositórios públicos é responsabilidade do usuário.

**Trust dos servers:** MCPs são código de terceiros executando na máquina local com acesso a tools. Preferir servers de organizações conhecidas (Anthropic, empresas com repositórios estabelecidos) a servidores de autores anônimos.

**Scoping via tools:** alguns servers expõem dezenas de tools. Verificar quais tools estão sendo expostas e desabilitar as que não são necessárias reduz superfície de ataque e ruído de decisão do modelo.

## Connections
- [[03-RESOURCES/entities/Khairallah-AL-Awady]] — author entity
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — MCP concept page
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — protocol details
- [[03-RESOURCES/concepts/claude-code-tooling/claude-connectors]] — connectors overview
- Prior guide: [[03-RESOURCES/sources/skills-prompting-mcp/mcp-servers-complete-guide-khairallah]]
