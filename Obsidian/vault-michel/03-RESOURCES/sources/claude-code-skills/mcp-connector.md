---
title: "MCP Connector (Messages API)"
type: source
source: "Clippings/MCP connector.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, mcp, messages-api, api-reference, beta-mcp-client]
---

## Tese central

Referência técnica completa do **MCP connector na Messages API direta** (`platform.claude.com/docs/.../agents-and-tools/mcp-connector`) — permite conectar a servidores MCP remotos diretamente da Messages API **sem implementar um cliente MCP separado**. Esta é a doc "raiz" do sub-cluster MCP: define o `mcp_servers` array, o `mcp_toolset`, beta header atual (`mcp-client-2025-11-20`), e inclui o guia de migração da versão deprecada (`mcp-client-2025-04-04`). Diferencia-se de [[03-RESOURCES/sources/mcp-connector-1]] (variante Managed Agents) e de [[03-RESOURCES/sources/remote-mcp-servers]] (catálogo de servidores remotos de terceiros).

## Argumentos principais

- **Beta header atual:** `"anthropic-beta": "mcp-client-2025-11-20"`. A versão anterior `mcp-client-2025-04-04` está **deprecada** (guia de migração detalhado ao final da doc).
- **Não elegível para ZDR** — dados retidos conforme política padrão da feature.
- **Funcionalidades-chave:** integração direta sem cliente MCP próprio; suporte a tool calling via Messages API; configuração flexível de tools (habilitar todas, allowlist, denylist); configuração por-tool individual; autenticação OAuth via Bearer tokens; conexão a múltiplos servidores MCP em uma única requisição.
- **Quando Claude usa tools MCP:** Claude chama tools quando o pedido do usuário mapeia para a capacidade descrita de uma tool — explícito ("search Jira for open bugs") ou implícito ("what's blocking the release?" com servidor Jira anexado). **Claude NÃO chama uma tool MCP para perguntas de conhecimento geral** sobre o serviço conectado: "how do Notion databases work?" é respondida diretamente; "what's in my Projects database?" dispara a tool. O system prompt pode direcionar quão prontamente Claude chama tools MCP.
- **Limitações documentadas:**
  - Da especificação MCP, **apenas tool calls** são suportados atualmente (não prompts/resources nativamente nesta via).
  - Servidor deve ser **publicamente exposto via HTTP** (Streamable HTTP ou SSE); **servidores STDIO locais não podem conectar diretamente**.
  - Disponível em: Claude API, Claude Platform on AWS, Microsoft Foundry. **Não disponível** em Amazon Bedrock ou Vertex AI.
- **Dois componentes da arquitetura:**
  1. **MCP Server Definition** (`mcp_servers` array) — define detalhes de conexão (URL, autenticação)
  2. **MCP Toolset** (`tools` array, `type: "mcp_toolset"`) — configura quais tools habilitar e como

### Configuração de servidor MCP

| Propriedade | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `type` | string | Sim | Atualmente só `"url"` |
| `url` | string | Sim | URL do servidor MCP; deve começar com `https://` |
| `name` | string | Sim | Identificador único; deve ser referenciado por exatamente um MCPToolset |
| `authorization_token` | string | Não | Token OAuth se exigido pelo servidor |

### Configuração de MCP Toolset

| Propriedade | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `type` | string | Sim | Deve ser `"mcp_toolset"` |
| `mcp_server_name` | string | Sim | Deve casar com um nome em `mcp_servers` |
| `default_config` | object | Não | Config default para todas as tools do set; `configs` individuais sobrescrevem |
| `configs` | object | Não | Overrides por-tool; chaves = nomes de tools |
| `cache_control` | object | Não | Configuração de cache breakpoint (prompt caching) |

Cada tool suporta: `enabled` (boolean, default `true`) e `defer_loading` (boolean, default `false` — se `true`, descrição da tool não é enviada inicialmente; usado com [Tool search tool](https://platform.claude.com/docs/en/agents-and-tools/tool-use/tool-search-tool)).

- **Precedência de merge de configuração** (mais alta → mais baixa): (1) settings tool-específicos em `configs`, (2) `default_config` do set, (3) defaults do sistema.
- **Padrões comuns de configuração:**
  - **Enable all** (mais simples): apenas `{type, mcp_server_name}`.
  - **Allowlist:** `default_config.enabled: false` + habilitar tools específicas em `configs`.
  - **Denylist:** habilitar tudo por default, desabilitar tools indesejadas em `configs` — recomendado para "denylistar tools de escrita/destrutivas ao construir assistentes read-only, ou quando se quer um passo de confirmação humana antes de mudanças de estado".
  - **Mixed:** allowlist combinada com configuração por-tool (ex: `defer_loading` diferenciado por tool).
- **Regras de validação enforçadas pela API:**
  - Servidor referenciado em `mcp_toolset` deve existir em `mcp_servers`
  - **Todo** servidor em `mcp_servers` deve ser referenciado por exatamente um `mcp_toolset` — toolsets órfãos ou servidores não-referenciados são **rejeitados**
  - Cada servidor só pode ser referenciado por **um** toolset
  - Nomes de tool desconhecidos em `configs`: gera **warning de backend, sem erro** (servidores MCP podem ter disponibilidade dinâmica de tools)
- **Dois novos tipos de content block na resposta:** `mcp_tool_use` (com `id`, `name`, `server_name`, `input`) e `mcp_tool_result` (com `tool_use_id`, `is_error`, `content`).
- **Múltiplos servidores MCP:** definições múltiplas em `mcp_servers`, cada uma com seu próprio `mcp_toolset` correspondente em `tools`. Com muitas tools, Claude seleciona com base em nomes/descrições — descrições claras melhoram a precisão; para conjuntos grandes (dezenas de tools, vários servidores), considerar `defer_loading` + Tool search tool.
- **Autenticação OAuth:** API consumers lidam com o fluxo OAuth e obtenção/refresh do token; `authorization_token` aceita o token resultante. Para teste, o **MCP inspector** (`npx @modelcontextprotocol/inspector`) guia o "Quick OAuth Flow" até copiar o `access_token`.
- **Helpers client-side TypeScript** (`@anthropic-ai/sdk/helpers/beta/mcp`): para quem gerencia conexão MCP própria (servidores stdio locais, prompts/resources MCP). Disponíveis **só no SDK TypeScript**:
  | Helper | Descrição |
  |---|---|
  | `mcpTools(tools, mcpClient)` | Converte tools MCP → tools Claude API, para uso com `toolRunner()` |
  | `mcpMessages(messages)` | Converte mensagens de prompt MCP → formato de mensagem Claude API |
  | `mcpResourceToContent(resource)` | Converte recurso MCP → content block |
  | `mcpResourceToFile(resource)` | Converte recurso MCP → objeto de arquivo para upload |

  Lançam `UnsupportedMCPValueError` para tipos de conteúdo/MIME não suportados ou links de recursos não-HTTP.
- **Quando usar `mcp_servers` direto vs helpers client-side:** o parâmetro de API quando "se tem servidores remotos acessíveis por URL e só precisa de suporte a tools"; helpers client-side quando "precisa de servidores locais, prompts, resources, ou mais controle sobre a conexão com o SDK base".
- **Batch requests:** `mcp_servers` pode ser incluído em requisições da Message Batches API; precificação de tool calls MCP é **a mesma** que em Messages API regular.

### Guia de migração (mcp-client-2025-04-04 → mcp-client-2025-11-20)

3 mudanças-chave: (1) novo beta header; (2) **configuração de tools migrou** do server definition (`tool_configuration`) para o array `tools` como objetos `MCPToolset`; (3) configuração mais flexível (allowlist, denylist, per-tool).

| Padrão antigo | Padrão novo |
|---|---|
| Sem `tool_configuration` (todas habilitadas) | MCPToolset sem `default_config`/`configs` |
| `tool_configuration.enabled: false` | MCPToolset com `default_config.enabled: false` |
| `tool_configuration.allowed_tools: [...]` | MCPToolset com `default_config.enabled: false` + tools específicas habilitadas em `configs` |

## Key insights

- **A separação "server definition" vs "toolset configuration"** introduzida na versão 2025-11-20 espelha exatamente a separação de responsabilidades de [[03-RESOURCES/sources/mcp-connector-1]] (Managed Agents): conexão/identidade do servidor de um lado, política de habilitação/permissão de tools do outro. Isso sugere uma **convergência arquitetural deliberada** entre as duas superfícies — provavelmente o mesmo backend de toolset por trás de ambas.
- **A regra "servidor não-referenciado é rejeitado pela API"** é uma validação rígida incomum — a maioria das APIs aceita configuração "morta" silenciosamente. Isso força definições limpas e provavelmente reduz superfície de bugs de configuração mal-sincronizada.
- **A distinção entre pergunta de conhecimento geral vs ação que dispara tool** ("how do Notion databases work?" vs "what's in my Projects database?") é o critério mais concreto e replicável encontrado no lote para decidir quando um agente deveria chamar uma tool externa — vale generalizar para qualquer design de skill/tool description no vault.
- **`defer_loading` + Tool search tool** é o padrão recomendado de escala para "dezenas de tools, vários servidores" — conecta-se diretamente ao tema de orçamento de contexto (token economy) que aparece em [[03-RESOURCES/sources/extend-claude-with-skills]] no contexto de skill description budgets. O mesmo problema (muitas opções, contexto limitado) recebe soluções estruturalmente análogas em ambos os domínios.
- **Helpers TS-only para MCP client-side** revela uma assimetria de maturidade entre SDKs — Python não tem equivalente direto a `mcpTools`/`mcpMessages`/`mcpResourceToContent`/`mcpResourceToFile` documentado aqui.

## Exemplos e evidências

Exemplo básico habilitando todas as tools de um servidor:
```python
response = client.beta.messages.create(
    model="claude-opus-4-8",
    max_tokens=1000,
    messages=[{"role": "user", "content": "What tools do you have available?"}],
    mcp_servers=[{
        "type": "url",
        "url": "https://example-server.modelcontextprotocol.io/sse",
        "name": "example-mcp",
        "authorization_token": "YOUR_TOKEN",
    }],
    tools=[{"type": "mcp_toolset", "mcp_server_name": "example-mcp"}],
    betas=["mcp-client-2025-11-20"],
)
```

Padrão denylist (tools destrutivas desabilitadas):
```json
{
  "type": "mcp_toolset",
  "mcp_server_name": "google-calendar-mcp",
  "configs": {
    "delete_all_events": {"enabled": false},
    "share_calendar_publicly": {"enabled": false}
  }
}
```

Resultado de merge — exemplo concreto da doc: com `default_config: {defer_loading: true}` e `configs: {search_events: {enabled: false}}`, o resultado é `search_events`: `enabled: false` + `defer_loading: true`; todas as outras tools: `enabled: true` (default do sistema) + `defer_loading: true` (herdado).

Content blocks de tool MCP:
```json
{"type": "mcp_tool_use", "id": "mcptoolu_014Q35RayjACSWkSj4X2yov1", "name": "echo", "server_name": "example-mcp", "input": {"param1": "value1"}}
{"type": "mcp_tool_result", "tool_use_id": "mcptoolu_014Q35RayjACSWkSj4X2yov1", "is_error": false, "content": [{"type": "text", "text": "Hello"}]}
```

Helper TypeScript para tool runner:
```typescript
const { tools } = await mcpClient.listTools();
const finalMessage = await anthropic.beta.messages.toolRunner({
  model: "claude-opus-4-8",
  max_tokens: 1024,
  messages: [{ role: "user", content: "What tools do you have available?" }],
  tools: mcpTools(tools, mcpClient)
});
```

Constraints concretas: URL deve começar com `https://`; apenas tool calls suportados (não prompts/resources nativamente); STDIO local não conecta diretamente; cada servidor referenciado por **exatamente um** toolset.

## Implicações para o vault

- Esta é a **doc-raiz do sub-cluster MCP** — define a arquitetura `mcp_servers` + `mcp_toolset` que [[03-RESOURCES/sources/mcp-connector-1]] adapta para Managed Agents (com vaults/credenciais) e que [[03-RESOURCES/sources/remote-mcp-servers]] pressupõe ao listar dezenas de servidores remotos prontos para conectar.
- O critério "Claude chama a tool quando o pedido mapeia para a capacidade descrita, não para perguntas de conhecimento geral" deveria informar a redação de descrições de qualquer MCP server/tool usado no vault (`mcp__filesystem-vault__*`, `mcp__context-mode__*`, etc., mencionados em [[03-RESOURCES/entities/MCP]]).
- O guia de migração `mcp-client-2025-04-04 → 2025-11-20` é referência operacional direta caso o vault ou agentes usem o connector com o header antigo — checar se `04-SYSTEM/agents/` ou skills referenciam `mcp-client-2025-04-04`.
- Conecta-se à entidade [[03-RESOURCES/entities/MCP]] e ao conceito [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — esta doc é a referência oficial de implementação que aterra esses conceitos mais abstratos em parâmetros de API concretos.
- A recomendação de denylist para "assistentes read-only ou confirmação humana antes de mudanças de estado" é diretamente aplicável a qualquer design de agente do vault que conecte a serviços externos via MCP (ex: GitHub, Slack, Google Calendar — entidades já presentes).

## Links

- [[03-RESOURCES/sources/mcp-connector-1]]
- [[03-RESOURCES/sources/remote-mcp-servers]]
- [[03-RESOURCES/sources/using-agent-skills-with-the-api]]
- [[03-RESOURCES/sources/get-started-with-agent-skills-in-the-api]]
- [[03-RESOURCES/entities/MCP]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-hub-pattern]]
- [[03-RESOURCES/entities/anthropic]]
