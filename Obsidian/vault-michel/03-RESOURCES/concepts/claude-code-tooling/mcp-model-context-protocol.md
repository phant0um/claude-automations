---
title: MCP — Model Context Protocol
type: concept
status: developing
tags: [mcp, model-context-protocol, claude, ai-agents, integrations, tools, context-costs]
created: 2026-04-17
updated: 2026-05-14
---

# MCP — Model Context Protocol

## O que é

Padrão aberto da Anthropic que conecta Claude (e outros LLMs) a ferramentas e fontes de dados externas: bancos de dados, apps de produtividade, repositórios, documentação, data streams em tempo real.

**Premissa:** muito do contexto relevante existe fora do código. MCP é a ponte.

Sem MCP: Claude isolado (brain in a jar).
Com MCP: Claude opera diretamente nas ferramentas do mundo real.

---

## Como funciona

1. Servidor MCP roda localmente (Node.js, Python, etc.) ou remoto via HTTP
2. Registrado em config: `~/.claude/.mcp.json`
3. Claude invoca ferramentas do servidor durante respostas
4. Dados fluem servidor externo → Claude → resposta

---

## Tipos de Servers

| Tipo | Descrição | Exemplo |
|------|-----------|---------|
| **HTTP** | Serviços remotos hospedados; conectam via rede | Linear, Slack, Context7 |
| **Stdio** | Processos locais que rodam na máquina | Scripts, CLIs custom |

---

## Adicionando + Gerenciando

```bash
# Adicionar server
claude mcp add

# Dentro de sessão: ver conectados, status, desabilitar
/mcp
```

### Escopos

| Escopo | Configuração | Acesso |
|--------|--------------|--------|
| **Local** | Default ao adicionar | Apenas você, projeto atual |
| **User** | Flag user scope | Apenas você, todos projetos |
| **Project** | `.mcp.json` commitado no repo | Time todo, automático |

**Best practice times:** `.mcp.json` no repo → todos recebem mesmos servers automaticamente.

---

## Context Costs (custo oculto)

**Crítico:** tool definitions de MCP servers carregadas no context window **mesmo sem uso ativo**.

- Cada server ativo consome context
- Muitos servers = menos espaço para conversa/arquivos
- **Threshold: > 10% do context window** → Claude Code muda para **tool search mode**

### Tool Search Mode
Quando MCP tools excedem 10%, Claude descobre ferramentas on-demand em vez de pré-carregar. Funciona, mas menos confiável que modo normal.

### Mitigações

**1. Desative servers não usados**
```
/mcp → desabilitar irrelevantes para projeto atual
```

**2. CLI equivalente quando disponível**
| Em vez de | Use |
|-----------|-----|
| GitHub MCP | `gh` CLI |
| AWS MCP | `aws` CLI |

CLIs não adicionam tool definitions persistentes — mais eficientes em bulk.

**3. Skills > MCP para ferramentas reutilizáveis**
- Skills: nome+descrição no contexto; conteúdo só quando Claude decide usar
- MCP: catálogo todo carregado constantemente

---

## 5 MCPs Essenciais (por prioridade)

| Servidor | Sistema | Função |
|----------|---------|--------|
| [[03-RESOURCES/entities/Tavily]] | Web | Search em tempo real, dados estruturados |
| Google Drive | Arquivos | Acesso direto a docs sem upload |
| [[03-RESOURCES/entities/Context7]] | Docs | Documentação de bibliotecas sempre atualizada |
| Slack | Comunicação | Leitura de canais, histórico, drafts |
| GitHub | Código | Code review, issues, PRs em contexto |

---

## Construção Customizada (FastMCP)

```python
from fastmcp import FastMCP

mcp = FastMCP("my-custom-tool")

@mcp.tool()
def get_client_data(client_name: str) -> str:
    """Pull client data from internal database"""
    return result
```

Código simples. Valor está no **conhecimento de domínio** embutido.

---

## Workflow Encadeado

Poder real = encadear múltiplos MCPs:

1. **Pull externo** — Tavily busca web
2. **Pull interno** — Drive puxa contexto existente
3. **Processamento** — Claude analisa/compara
4. **Output** — Drive, Slack ou arquivo

**Antes:** 2-3h/semana manual. **Com MCP:** 5min, output mais completo.

---

## Casos de Uso Conhecidos no Vault

| MCP | Conecta | Fonte |
|-----|---------|-------|
| [[03-RESOURCES/entities/TradingView-MCP]] | TradingView Desktop (charts reais) | [[03-RESOURCES/sources/financial-trading/claude-tradingview-full-guide]] |
| Composio | 250+ APIs externas (auth gerenciado) | [[03-RESOURCES/sources/financial-trading/polymarket-1m-year-claude-bot]] |

---

## Escala do Ecossistema (2026-05-14)

Ecossistema MCP atingiu **14,000+ servidores** disponíveis cobrindo: Version Control (GitHub, GitLab, Bitbucket), Databases (Postgres, MySQL, MongoDB, Redis, Supabase), Browser (Playwright, Chrome), Cloud (AWS, GCP, Azure, Cloudflare, Vercel), Communication (Slack, Discord, Gmail, Linear, Jira), Code Execution (sandboxed envs, test runners), Security (vulnerability scanners, auth).

Fonte: [[03-RESOURCES/sources/ai-agents-harness/from-one-chatbot-to-131-specialists-agentsmd]]
| [[03-RESOURCES/entities/NotebookLM]] (`notebooklm-mcp`) | Google NotebookLM (35 tools: notebooks, fontes, studio, research) | [[03-RESOURCES/sources/memory-context-rag/jacob-bd-notebooklm-mcp-cli]] |

### Diferença vs Screenshot
- Sem MCP: Claude vê screenshot, "adivinha" dados
- Com MCP: Claude lê valores reais subjacentes — como dev lendo console

---

## MCP no Workflow EPCC

- **Explore/Plan:** servers de docs (Context7) → docs sempre atual
- **Code:** servers de projeto (Linear, GitHub) → contexto de tasks integrado
- **Commit:** Slack MCP → PR publicado automaticamente

---

## Cowork Connectors

No [[03-RESOURCES/entities/Claude-Cowork]]: MCPs expostos como "Connectors" via GUI — mesma tecnologia, sem JSON manual.

---

## Mindset

Cada vez que copia dados manualmente entre apps = uma conexão MCP faltando.

**Meta:** zero transferência manual entre usuário e Claude.

> [!stat] Adoção (2026)
> Menos de 5% dos usuários Claude configuraram um servidor MCP. Maior gap de vantagem competitiva disponível.

> [!stat] Ecossistema (2026)
> 14.000+ servidores MCP disponíveis publicamente (maio/2026).

---

## Subagents e Escopo dos Agents

Agents do Claude Code são definidos em arquivos `.md` com frontmatter YAML e residem em dois escopos:

| Escopo | Caminho | Alcance |
|--------|---------|---------|
| **Projeto** | `.claude/agents/` | Só o projeto atual |
| **Global** | `~/.claude/agents/` | Todos os projetos do usuário |

Cada agent roda em sua própria context window isolada. Claude auto-delega quando a tarefa bate com o campo `description`, ou pode ser invocado manualmente via `@agent-name`. Agents paralelos retornam apenas resumos ao contexto principal — isolamento que reduz token waste em ~90%.

Ver padrões completos em [[03-RESOURCES/sources/guides-courses-howtos/8-claude-code-agents-10-minutes-each]].

---

## Relações

- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] — context costs dos MCP servers
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — MCP em cada fase EPCC
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — alternativa para ferramentas reutilizáveis
- [[03-RESOURCES/concepts/claude-code-tooling/claude-connectors]] — GUI do MCP no Cowork
- [[03-RESOURCES/entities/Claude Code]] — client principal MCPs

## Fontes

- [[03-RESOURCES/sources/skills-prompting-mcp/mcp-servers-complete-guide-khairallah]] — guia completo
- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-101]] — seção MCP do curso oficial
- [[03-RESOURCES/sources/claude-code-cowork/cowork-setup-guide-coreyganim]] — MCPs como Connectors
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/second-brain-claude-code-ryanwiggins]] — MCPs/CLIs (Drive, Linear, Notion, Metabase)
- [[03-RESOURCES/sources/guides-courses-howtos/8-claude-code-agents-10-minutes-each]] — subagent scope (.claude/agents/ vs ~/.claude/agents/); 8 agents práticos; 90% token reduction
- [[03-RESOURCES/sources/mcp-core-architecture-explained]] — modelo arquitetural em camadas (host/client/server/capabilities/backend); distinção tool (ação) vs resource (leitura) vs prompt (template reutilizável); padrão 1-host-N-servers por domínio

## Evidências
- **[2026-06-19]** MCP filesystem server como ponte controlada entre Claude Desktop e um vault Obsidian local — usuário escolhe exatamente qual diretório é acessível, Claude pede aprovação antes de ações de escrita — [[03-RESOURCES/sources/ai-second-brain-obsidian-guide]]
- **[2026-06-19]** Vercel Connect usado como camada MCP para integrar Linear e Slack em template de agente pessoal durável — [[03-RESOURCES/sources/vercel-labs-personal-agent-template]]
- **[2026-06-22]** Bridge Claude↔Obsidian via plugin "Local REST API" expondo API key local consumida por `claude mcp add-json` apontando para `127.0.0.1:27124` — passo-a-passo replicável de setup — [[03-RESOURCES/sources/how-to-build-an-ai-second-brain-with-claude-and-obsidian-full-guide-he-s-getting-smarter-every-da]]
- **[2026-06-22]** Agent-Native (BuilderIO) gera capability MCP automaticamente a partir da mesma definição de "action" que serve UI/API/CLI — MCP como uma de seis superfícies de exposição, não destino único. — [[03-RESOURCES/sources/builderioagent-native-a-framework-for-building-agent-native-applications]]
- **[2026-06-22]** Connectors MCP como o que diferencia um loop que só lê arquivos de um que age no mundo real (broker API, banco, Slack, exchange) — [[03-RESOURCES/sources/how-to-use-loop-engineering-to-build-a-self-improving-quant-trading-system]]
