---
title: "MCP Connector (Managed Agents)"
type: source
source: "Clippings/MCP connector 1.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, mcp, managed-agents, vaults, api-reference]
---

## Tese central

Documentação de como conectar servidores MCP a agentes na **Managed Agents API** (`platform.claude.com/docs/.../managed-agents/mcp-connector`) — superfície distinta da Messages API documentada em [[03-RESOURCES/sources/mcp-connector]]. A diferença estrutural central: aqui a configuração de MCP é **deliberadamente partida em duas etapas separadas no tempo** — declaração na criação do agente (sem credenciais) e fornecimento de auth na criação da sessão (via vaults). Isso mantém segredos fora de definições de agente reutilizáveis.

## Argumentos principais

- **Configuração MCP em dois passos distintos:**
  1. **Criação do agente** — declara quais servidores MCP o agente conecta, por nome e URL (sem tokens de auth nesta etapa)
  2. **Criação da sessão** — fornece auth para esses servidores referenciando um [vault](https://platform.claude.com/docs/en/managed-agents/vaults) pré-registrado
  
  Essa separação **mantém segredos fora de definições de agente reutilizáveis**, permitindo que cada sessão autentique com suas próprias credenciais.
- **Beta header obrigatório:** `managed-agents-2026-04-01` (mesmo header de [[03-RESOURCES/sources/skills]] — confirma que ambas as features pertencem à mesma geração da API). SDK seta automaticamente.
- **Declaração de servidores MCP no agente** — array `mcp_servers`, cada entrada com `type`, `name` único, `url`. **Nenhum token de auth é fornecido nesta etapa.** O `name` atribuído é usado para referenciar entradas `mcp_toolset` no array `tools`.
- **Política de permissão default:** o MCP toolset assume `always_ask` por padrão — **requer aprovação do usuário antes de cada chamada de tool**. Configurável via [permission policies](https://platform.claude.com/docs/en/managed-agents/permission-policies).

### Referência de campo `mcp_servers`

| Campo | Descrição |
|---|---|
| `type` | Obrigatório. Deve ser `"url"` |
| `name` | Obrigatório. Nome único dentro do agente (1–255 caracteres). Usado como `mcp_server_name` no array `tools` e surfaced em eventos de tool MCP no event stream da sessão |
| `url` | Obrigatório. Endpoint do servidor MCP remoto (até 2048 caracteres) |

**Constraints documentadas:**
- Um agente pode declarar **até 20 servidores MCP**; nomes devem ser únicos no array
- **Toda** entrada `mcp_servers` deve ser referenciada por um `mcp_toolset`, e todo `mcp_toolset` deve referenciar um servidor declarado — a API **rejeita** definições de agente com servidores não-referenciados ou toolsets órfãos (regra idêntica à da Messages API descrita em [[03-RESOURCES/sources/mcp-connector]])

- **Configuração de quais tools MCP ficam disponíveis:** `mcp_toolset` suporta o **mesmo shape** `default_config`/`configs` do toolset built-in do agente, aplicado às tools expostas pelo servidor MCP. O `name` em cada entrada `configs` é o nome "puro" da tool conforme reportado pelo servidor.
  - Por padrão, **todas** as tools do servidor MCP estão habilitadas
  - Para habilitar apenas tools específicas: setar `default_config.enabled: false` e habilitar explicitamente as desejadas (útil quando "um servidor expõe muitas tools mas o agente só precisa de poucas, ou quando se quer manter tools adicionadas pelo operador do servidor desabilitadas até revisão")
  - Para desabilitar tools específicas mantendo o resto: omitir `default_config` e setar `enabled: false` em entradas individuais
- **Tratamento de output grande de tool MCP:** quando o output de uma tool MCP **excede 100.000 tokens**, é automaticamente **escrito em arquivo no sandbox**. O modelo recebe um preview truncado com o caminho do arquivo e pode ler o conteúdo completo de lá.

### Autenticação na criação da sessão

- Passar `vault_ids` ao iniciar a sessão para fornecer credenciais aos servidores MCP. Vaults = coleções de credenciais registradas uma vez e referenciadas por ID.
- **Matching de credencial é por URL** — o vault deve conter uma credencial cujo `mcp_server_url` **casa exatamente** com a `url` declarada em `mcp_servers`; se nenhuma casar, **a conexão é tentada sem autenticação**. Tipos de credencial suportados: `static_bearer` e `mcp_oauth`.

### Tratamento de falhas de conexão e autenticação

- **A criação da sessão não valida conectividade nem credenciais MCP** — se um servidor está inacessível ou rejeita a credencial, a sessão **ainda inicia** e a interação permanece possível.
- Um evento `session.error` é emitido com o `mcp_server_name` afetado e um `retry_status`:
  | Tipo de erro | Significado |
  |---|---|
  | `mcp_connection_failed_error` | Servidor inalcançável (erro de rede, timeout, ou falha HTTP não-relacionada a auth) |
  | `mcp_authentication_failed_error` | Servidor alcançado mas rejeitou a credencial do vault anexado |
  
  O desenvolvedor decide se bloqueia interação adicional, dispara rotação de credencial, ou deixa a sessão continuar sem as tools do servidor afetado. **A conexão é retentada na próxima transição `session.status_idle` → `session.status_running`.**

## Key insights

- **A separação "declarar servidor sem credencial" / "autenticar na sessão via vault" é a diferença arquitetural fundamental** entre esta superfície e a Messages API ([[03-RESOURCES/sources/mcp-connector]]), onde `authorization_token` é fornecido diretamente na definição do servidor MCP da requisição. A Managed Agents API trata definições de agente como **artefatos reutilizáveis e compartilháveis** que não devem carregar segredos — um padrão de design de segurança explícito que a Messages API (orientada a requisições pontuais) não precisa adotar da mesma forma.
- **"Sessão inicia mesmo com MCP quebrado" é uma escolha deliberada de resiliência** — prioriza disponibilidade de interação sobre validação antecipada, deixando a decisão de "bloquear ou continuar" para o desenvolvedor via `session.error`. Isso contrasta com a abordagem mais rígida de validação síncrona de configuração (servidores não-referenciados são rejeitados) descrita na mesma doc para a fase de **declaração**.
- **O matching de credencial por URL exata é uma fonte provável de erro silencioso** — "se nenhuma credencial casa, a conexão é tentada sem autenticação" significa que um typo na URL do vault não gera erro de configuração, apenas uma conexão não-autenticada que falhará (ou pior, terá acesso parcial) silenciosamente até o runtime.
- **O limite "100.000 tokens → escreve em arquivo no sandbox"** é um mecanismo de proteção de contexto que generaliza além de MCP — é o mesmo problema (output de tool grande demais para o contexto) que `defer_loading` resolve no nível de *descrição* de tool em [[03-RESOURCES/sources/mcp-connector]]; aqui a solução atua no nível de *resultado* de execução.
- **`always_ask` como permission policy default para MCP toolsets** é mais conservador que o padrão "enable all" da Messages API — reflete que agentes Managed rodam autonomamente por períodos longos (consistente com a descrição de [[03-RESOURCES/entities/Claude-Managed-Agents]] como "minutos a horas sem supervisão"), exigindo guard-rails mais fortes por padrão.

## Exemplos e evidências

Criação de agente com servidor MCP declarado (sem credencial):
```bash
AGENT_ID=$(ant beta:agents create \
  --name "GitHub Assistant" \
  --model claude-opus-4-8 \
  --mcp-server '{type: url, name: github, url: "https://api.githubcopilot.com/mcp/"}' \
  --tool '{type: agent_toolset_20260401}' \
  --tool '{type: mcp_toolset, mcp_server_name: github}' \
  --transform id --raw-output)
```

Allowlist de tools (habilita apenas 3 de potencialmente muitas):
```json
{
  "type": "mcp_toolset",
  "mcp_server_name": "github",
  "default_config": { "enabled": false },
  "configs": [
    { "name": "get_issue", "enabled": true },
    { "name": "list_issues", "enabled": true },
    { "name": "add_issue_comment", "enabled": true }
  ]
}
```

Denylist pontual (desabilita uma tool destrutiva):
```json
{
  "type": "mcp_toolset",
  "mcp_server_name": "github",
  "configs": [{ "name": "delete_repository", "enabled": false }]
}
```

Criação de sessão fornecendo vault de credenciais:
```bash
SESSION_ID=$(ant beta:sessions create \
  --agent "$AGENT_ID" \
  --environment-id "$ENVIRONMENT_ID" \
  --vault-id "$VAULT_ID" \
  --transform id --raw-output)
```

Limites concretos: até **20 servidores MCP por agente**; nome do servidor entre **1–255 caracteres**; URL até **2048 caracteres**; truncamento de output de tool em **100.000 tokens**.

## Implicações para o vault

- Esta página completa o quadro arquitetural junto com [[03-RESOURCES/sources/mcp-connector]]: a mesma primitiva conceitual (`mcp_servers` + `mcp_toolset` com `default_config`/`configs`) reaparece em duas superfícies de API com **modelo de segurança e ciclo de vida de credenciais radicalmente diferentes**. Isso é o ponto de comparação mais valioso do sub-cluster MCP.
- O padrão "declaração sem segredo + auth via vault na sessão" é diretamente relevante para qualquer design de agente persistente/compartilhável no vault — contraste com o modelo "token na própria requisição" de [[03-RESOURCES/sources/mcp-connector]].
- Conecta-se à entidade [[03-RESOURCES/entities/Claude-Managed-Agents]] (que já documenta "Suporte a MCP servers para conexão com serviços externos" de forma genérica) — esta fonte detalha exatamente como esse suporte funciona, incluindo o detalhe não-óbvio de truncamento de output em 100k tokens.
- Junto com [[03-RESOURCES/sources/skills]] (mesmo beta header `managed-agents-2026-04-01`, mesma estrutura de criação de agente), confirma que Skills e MCP servers são **anexados ao agente da mesma forma estrutural** (arrays declarativos na criação), reforçando [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] — ambos operam na "camada de capacidades do agente hospedado".
- Padrão de denylist para tools destrutivas (`delete_repository`, `delete_all_events`) é informação operacional reutilizável para qualquer agente do vault que conecte a serviços com ações irreversíveis.

## Links

- [[03-RESOURCES/sources/mcp-connector]]
- [[03-RESOURCES/sources/remote-mcp-servers]]
- [[03-RESOURCES/sources/skills]]
- [[03-RESOURCES/entities/Claude-Managed-Agents]]
- [[03-RESOURCES/entities/MCP]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-managed-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
