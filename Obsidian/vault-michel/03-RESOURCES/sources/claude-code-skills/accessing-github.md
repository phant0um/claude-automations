---
title: Accessing GitHub
type: source
source: "Clippings/Accessing GitHub.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, github, integration]
---

## Tese central
Documentação de referência sobre como conectar um agente do sistema Claude Managed Agents (`managed-agents-2026-04-01` beta) a repositórios GitHub — tanto para **montar (mount) o código no sandbox** quanto para **abrir pull requests via GitHub MCP**. É uma das três formas documentadas neste lote de trazer conteúdo externo para dentro de uma sessão (as outras são [[03-RESOURCES/sources/adding-files]] e [[03-RESOURCES/sources/files-api]]).

## Argumentos principais
- **Dois mecanismos distintos e complementares:** (1) montar um repositório GitHub no sandbox da sessão (clone read/write no filesystem), e (2) conectar ao GitHub MCP server para que o agente possa criar branches, commits, PRs.
- **Cache de repositórios:** repositórios montados são cacheados — sessões futuras que usem o mesmo repositório iniciam mais rápido.
- **Fluxo em duas etapas — agente declara o servidor MCP, sessão fornece o token:**
  1. O **agent definition** declara o GitHub MCP server (URL `https://api.githubcopilot.com/mcp/`) mas **não contém token de autenticação**:
     ```bash
     AGENT_ID=$(ant beta:agents create \
       --name "Code Reviewer" \
       --model '{id: claude-opus-4-8}' \
       --system "You are a code review assistant with access to GitHub." \
       --mcp-server '{type: url, name: github, url: https://api.githubcopilot.com/mcp/}' \
       --tool '{type: agent_toolset_20260401}' \
       --tool '{type: mcp_toolset, mcp_server_name: github}' \
       --transform id --raw-output)
     ```
  2. A **sessão** monta o repositório fornecendo URL, `mount_path` e `authorization_token` no array `resources`:
     ```yaml
     resources:
       - type: github_repository
         url: https://github.com/org/repo
         mount_path: /workspace/repo
         authorization_token: ghp_your_github_token
     ```
- **Segurança do token:** `resources[].authorization_token` autentica a operação de clone e **não é ecoado nas respostas da API** (write-only, como os secrets de vault).
- **Permissões mínimas recomendadas (tabela de escopos):**
  | Ação | Escopo necessário |
  |---|---|
  | Clonar repos privados | `repo` |
  | Criar PRs | `repo` |
  | Ler issues | `repo` (privado) ou `public_repo` |
  | Criar issues | `repo` (privado) ou `public_repo` |
  Recomendação explícita: usar fine-grained personal access tokens com permissões mínimas; evitar tokens com acesso amplo à conta GitHub.
- **Múltiplos repositórios:** basta adicionar mais entradas `type: github_repository` ao array `resources`, cada uma com seu `mount_path` e token próprios.
- **Gerenciamento em sessão ativa:** cada resource recebe um `id` no momento da criação (ou via `resources.list`), usado para rotacionar o token (`resources update --resource-id ... --authorization-token ...`). **Repositórios ficam montados pela vida inteira da sessão** — para mudar quais repositórios estão montados, é preciso criar uma nova sessão (não há "remontagem" dinâmica).
- **Criação de PRs via stream de eventos:** o agente cria branches, comita e dá push através de comandos enviados como `user.message` events no stream da sessão (ex: "Fix the type error in src/utils.ts, commit it to a new branch, and push it.").

## Key insights
- A separação entre "agent declara o servidor MCP" e "sessão fornece o token" é o mesmo padrão de design de **separação de definição vs. credencial por usuário** que aparece em [[03-RESOURCES/sources/authenticate-with-vaults]] — sugere uma filosofia consistente em todo o sistema Managed Agents: a definição do agente é compartilhável/versionável e nunca carrega segredos; segredos entram apenas no momento da sessão, escopados por usuário/recurso.
- A imutabilidade da lista de repositórios montados durante a vida de uma sessão (só rotação de token, não troca de repo) é uma restrição de design que força arquiteturas de "uma sessão por escopo de trabalho" em vez de sessões longas reconfiguráveis — reforça o padrão observado de sessões como unidades efêmeras e bem escopadas.
- O cache de repositório entre sessões é uma otimização importante para workflows recorrentes (ex: "Code Reviewer" rodando todo dia no mesmo repo) — reduz latência de cold-start.
- O modelo de permissões GitHub (tabela de escopos mínimos) reflete o mesmo princípio de menor privilégio reforçado em [[03-RESOURCES/sources/cloud-environment-setup]] (networking `limited`) — um tema transversal em toda a stack Managed Agents.

## Exemplos e evidências
- Comando completo de criação de agente com MCP server GitHub e dois tools (`agent_toolset_20260401`, `mcp_toolset`).
- YAML de criação de sessão com `resources: [{type: github_repository, url, mount_path, authorization_token}]`.
- YAML de múltiplos repositórios montados em paths distintos (`/workspace/frontend`, `/workspace/backend`).
- Comandos de gestão: `ant beta:sessions:resources list --session-id "$SESSION_ID"` e `... update --resource-id "$RESOURCE_ID" --authorization-token "ghp_your_new_github_token"`.
- Evento de comando ao agente via stream:
```yaml
events:
  - type: user.message
    content:
      - type: text
        text: Fix the type error in src/utils.ts, commit it to a new branch, and push it.
```
- URL canônica do GitHub MCP server da Anthropic: `https://api.githubcopilot.com/mcp/`.

## Implicações para o vault
Esta página, junto com [[03-RESOURCES/sources/adding-files]] e [[03-RESOURCES/sources/files-api]], forma o conjunto de **mecanismos de injeção de conteúdo em sessões** Managed Agents — todos usam o mesmo padrão de array `resources` na criação da sessão, mas com `type` diferente (`github_repository` vs. `file`). A dependência de `authorization_token` write-only conecta diretamente a [[03-RESOURCES/sources/authenticate-with-vaults]] (que documenta o mecanismo mais robusto de gestão de credenciais por usuário via `vault_ids` — uma alternativa a passar tokens crus por `resources`). O sandbox onde o repositório é montado é o mesmo descrito em [[03-RESOURCES/sources/cloud-sandbox-reference]] (com `git` pré-instalado) e configurado em [[03-RESOURCES/sources/cloud-environment-setup]]. Alimenta [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] (separação agent definition / session resource) e [[03-RESOURCES/concepts/agent-systems/harness-adaptation]] (integração com ferramentas externas como parte do harness).

## Links
- [[03-RESOURCES/sources/adding-files]]
- [[03-RESOURCES/sources/files-api]]
- [[03-RESOURCES/sources/authenticate-with-vaults]]
- [[03-RESOURCES/sources/cloud-sandbox-reference]]
- [[03-RESOURCES/sources/cloud-environment-setup]]
- [[03-RESOURCES/sources/claude-platform-on-aws]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
- [[03-RESOURCES/sources/ai-agents-harness/claude-managed-agents-beginners-guide]]
