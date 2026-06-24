---
title: Authenticate with vaults
type: source
source: "Clippings/Authenticate with vaults.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, auth, security]
---

## Tese central
Documentação de referência sobre **vaults e credentials** — as primitivas de autenticação do sistema Claude Managed Agents (`managed-agents-2026-04-01` beta) que permitem registrar credenciais de serviços terceiros **uma vez por usuário final** e referenciá-las por ID na criação de sessões. É a peça de infraestrutura que sustenta autenticação per-user em toda a stack — sem precisar rodar um secret store próprio, retransmitir tokens em cada chamada, ou perder rastreabilidade de "em nome de quem" o agente agiu.

## Argumentos principais
- **Modelo conceitual — produto no nível do agente, usuários no nível da sessão:** "the vault reference is a per-session parameter, so you can manage your product at the agent level and your users at the session level." Vault = coleção de `credentials` associada a um usuário final, com `display_name` e `metadata` opcional (ex: `external_user_id`) para mapear de volta a registros próprios.
- **Escopo de workspace:** vaults e credentials são **workspace-scoped** — qualquer pessoa com API key do mesmo workspace pode referenciá-los ao criar uma sessão. Para revogar acesso: deletar o vault/credential.
- **Criação de vault:**
  ```bash
  VAULT_ID=$(ant beta:vaults create --display-name "Alice" \
    --metadata '{external_user_id: usr_abc123}' --transform id --raw-output)
  ```
  Retorna registro completo: `{"type": "vault", "id": "vlt_01ABC...", "display_name", "metadata", "created_at", "updated_at", "archived_at": null}`.
- **Adicionar credencial — vínculo 1:1 com `mcp_server_url`:** cada credential se liga a um único `mcp_server_url`; em runtime, a API casa a URL do servidor MCP que o agente conecta com credenciais ativas no vault referenciado e injeta o token automaticamente.
  - Tipo `mcp_oauth` para servidores que usam OAuth 2.0; bloco `refresh` opcional faz a Anthropic renovar o access token automaticamente quando expira.
  - `refresh.token_endpoint_auth.type` define como autenticar a chamada de refresh: `none` (cliente público), `client_secret_basic` (HTTP Basic), `client_secret_post` (secret no corpo POST).
  - **Campos secretos são write-only**: `token`, `access_token`, `refresh_token`, `client_secret` nunca são retornados nas respostas da API.
  - **Credenciais não são validadas na criação** — só em runtime da sessão. Um token ruim aparece como erro de autenticação MCP, que é emitido mas **não bloqueia a sessão de continuar**.
- **Constraints de credentials:**
  - **Uma credencial ativa por `mcp_server_url` por vault** — criar uma segunda para a mesma URL retorna **409**.
  - **`mcp_server_url` é imutável** — para apontar a outro servidor, é preciso arquivar e criar nova.
  - **Máximo 20 credenciais por vault** (mesmo limite do número máximo de servidores MCP por agente).
- **Referenciar o vault na sessão:** `vault_ids` é passado na criação da sessão (`--vault-id "$VAULT_ID"`).
- **Comportamento em runtime:**
  - Sem credencial casando com o servidor MCP → conexão tentada sem autenticação, gera erro se o servidor exigir auth.
  - Múltiplos vaults cobrindo o mesmo servidor MCP → **o primeiro vault com match vence**.
  - Em sessões multiagente, credenciais de vault aplicam-se a **todos os threads**; um agente cuja própria definição declara o servidor MCP correspondente autentica com essas credenciais.
- **Refresh periódico:** credenciais são re-resolvidas periodicamente — durante a sessão e durante o ciclo de vida do vault — propagando rotação/arquivamento/deleção a sessões em execução **sem necessidade de restart**.
- **Webhooks de ciclo de vida:** `vault.archived` (cascata para `vault_credential.archived` por credencial), `vault.deleted` (cascata para `vault_credential.deleted`), `vault_credential.archived`, `vault_credential.deleted`, `vault_credential.refresh_failed` (token de refresh inválido ou erro irrecuperável do servidor OAuth).
- **Diagnóstico de falha de refresh OAuth:** `POST /v1/vaults/{vault_id}/credentials/{credential_id}/mcp_oauth_validate` retorna objeto `vault_credential_validation` com `status`:
  - `valid`: token funciona, sem ação necessária.
  - `invalid`: grant perdido ou servidor OAuth rejeitou com 4xx → reautorizar usuário final.
  - `unknown`: erro transitório (5xx, 429, falha de rede) → aguardar e tentar novamente.
- **Rotação de credencial:** apenas o payload secreto e poucos campos de metadata são mutáveis — `mcp_server_url`, `token_endpoint` e `client_id` ficam travados após a criação.
- **Outras operações:** listagem paginada (mais recentes primeiro, arquivados excluídos por default — `include_archived=true` para incluir); arquivar vault (`POST .../archive`, cascateia, purga secrets, mantém registro para auditoria, sessões futuras falham mas as em execução continuam); arquivar credential (purga secret, mantém `mcp_server_url` visível, libera a URL para nova credencial); deletar (hard delete, irreversível — usar archive se precisar de trilha de auditoria).

## Key insights
- O modelo "produto no nível do agente, usuário no nível da sessão" é o insight arquitetural central — desacopla a definição do agente (compartilhável, sem segredos) da identidade/credenciais do usuário final (per-session, revogável independentemente). É o mesmo padrão observado em [[03-RESOURCES/sources/accessing-github]] (agent declara servidor MCP sem token; sessão fornece token).
- A re-resolução periódica de credenciais "sem restart" é um detalhe operacional crítico para confiabilidade em produção — rotação de token não derruba sessões longas, o que é essencial para os agentes autônomos de longa duração que o sistema Managed Agents claramente visa suportar.
- O fato de que **credenciais ruins não bloqueiam a sessão** (apenas geram erro de autenticação MCP emitido) reflete uma filosofia de "fail gracefully, observe, don't crash" — conecta-se ao conceito [[03-RESOURCES/concepts/agent-systems/agent-observability]] (erros emitidos como eventos observáveis em vez de exceções fatais).
- O endpoint `mcp_oauth_validate` com status de três vias (`valid`/`invalid`/`unknown`) é um padrão de diagnóstico elegante que distingue claramente "ação do usuário necessária" de "espere e tente de novo" — um modelo replicável para qualquer sistema de credenciais com OAuth refresh.
- O limite de 20 credenciais por vault espelhando o limite de 20 servidores MCP por agente não é coincidência — sugere um design 1:1 consciente entre "quantos serviços terceiros um agente pode tocar" e "quantas identidades um usuário pode autenticar para esses serviços".

## Exemplos e evidências
- Resposta de criação de vault:
```json
{
  "type": "vault", "id": "vlt_01ABC...", "display_name": "Alice",
  "metadata": { "external_user_id": "usr_abc123" },
  "created_at": "2026-03-18T10:00:00Z", "updated_at": "2026-03-18T10:00:00Z", "archived_at": null
}
```
- Criação de credential `mcp_oauth` com bloco `refresh` completo (token_endpoint, client_id, scope, refresh_token, token_endpoint_auth).
- Validação de refresh OAuth via cURL com beta `managed-agents-2026-04-01`, retornando `vault_credential_validation` com `mcp_probe.http_response.status_code: 401` e `body: "{\"error\":\"invalid_token\"}"`.
- Tabela de eventos webhook (`vault.archived`, `vault.deleted`, `vault_credential.archived/deleted/refresh_failed`).
- Limites numéricos exatos: 1 credencial ativa por `mcp_server_url`/vault (409 se duplicar), 20 credenciais/vault.

## Implicações para o vault
Esta página documenta a **infraestrutura de autenticação que sustenta** boa parte do restante do lote: [[03-RESOURCES/sources/accessing-github]] usa `authorization_token` cru por sessão como alternativa mais simples (e menos robusta) ao mesmo padrão; [[03-RESOURCES/sources/claude-platform-on-aws]] lista "credential vaults" entre os recursos Managed Agents disponíveis via AWS. O padrão write-only de secrets, a validação apenas em runtime, e o refresh automático com webhooks formam um modelo de segurança consistente que merece anotação em [[03-RESOURCES/concepts/agent-security]] (se existir) e em [[03-RESOURCES/concepts/agent-systems/agent-observability]] (webhooks de ciclo de vida como sinal observável). Reforça também [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] — vault como camada de identidade desacoplada da definição do agente.

## Links
- [[03-RESOURCES/sources/accessing-github]]
- [[03-RESOURCES/sources/claude-platform-on-aws]]
- [[03-RESOURCES/sources/cloud-environment-setup]]
- [[03-RESOURCES/sources/adding-files]]
- [[03-RESOURCES/sources/files-api]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
- [[03-RESOURCES/sources/ai-agents-harness/claude-managed-agents-beginners-guide]]
