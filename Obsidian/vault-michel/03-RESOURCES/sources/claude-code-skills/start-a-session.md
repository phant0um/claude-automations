---
title: Start a session
type: source
source: "Clippings/Start a session.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, session-lifecycle, anthropic-api]
---

## Tese central

Documenta como criar e iniciar uma **Session** — "an agent instance within an environment" — detalhando o ciclo de vida em duas etapas (criar a session para provisionar o sandbox; depois enviar um evento de usuário para começar o trabalho). É o detalhamento dos passos 2-3 do fluxo "how it works" em [[03-RESOURCES/sources/claude-managed-agents-overview]], ponte direta entre [[03-RESOURCES/sources/define-your-agent]] (o "quem") e [[03-RESOURCES/sources/session-event-stream]] (o "como conversar com ele").

## Argumentos principais

- **Definição central**: uma session é "an agent instance within an environment". Cada session referencia um [agent] e um [environment] (ambos criados separadamente) e mantém histórico de conversa através de múltiplas interações.
- **Lifecycle de duas etapas**: (1) criar a session — provisiona seu sandbox; (2) enviar um evento de usuário — inicia o trabalho. Criar a session **não** inicia trabalho algum por si só.
- Todas as requisições requerem o header beta `managed-agents-2026-04-01`.
- **Criando uma session**: requer um `agent` ID e um `environment` ID. Agents são recursos versionados — passar o `agent` ID como string simples inicia a session com a **última versão** do agent.
- **Fixar versão específica**: para travar uma session a uma versão específica do agent, passe um objeto `{type: agent, id: $AGENT_ID, version: 1}`. Isso permite controlar exatamente qual versão roda e fazer rollout escalonado de novas versões de forma independente.
- O agent define como Claude se comporta dentro da session — modelo, system prompt, tools, MCP servers (remete a [[03-RESOURCES/sources/define-your-agent]] para detalhes).
- **Autenticação MCP via vaults**: se o agent usa MCP tools que requerem autenticação, passe `vault_ids` na criação da session, referenciando um vault contendo credenciais OAuth armazenadas. **A Anthropic gerencia o refresh de tokens em nome do usuário.**
- **Iniciando a session**: criar a session provisiona o sandbox do environment mas não começa nenhum trabalho. Para delegar uma tarefa, envie eventos à session usando um *user event*.
- **A session funciona como uma máquina de estados**: ela rastreia o progresso enquanto os eventos conduzem a execução real — uma distinção arquitetural fundamental entre "estado" (session) e "ação" (events).
- Remete a três páginas complementares: [[03-RESOURCES/sources/session-event-stream]] (como fazer streaming das respostas do agente e lidar com confirmações de tools), "Session statuses" (estados pelos quais a session passa) e [[03-RESOURCES/sources/session-operations]] (retrieve, list, update, archive, delete).

## Key insights

- A separação explícita **"criar ≠ iniciar trabalho"** é uma escolha de design deliberada que separa provisionamento de infraestrutura (custo/latência de cold start do sandbox) da decisão de quando efetivamente começar a consumir tokens/computar — útil para pré-provisionar sessions e reduzir latência percebida pelo usuário final.
- O **fixar de versão de agent na criação da session** (`{type: agent, id, version}`) é o mecanismo que viabiliza rollout gradual e canário de novas versões de agent — você pode rodar sessions antigas na v1 enquanto testa a v2 em sessions novas, sem precisar duplicar a definição do agent.
- A frase **"the session acts as a state machine that tracks progress while events drive the actual execution"** é a melhor síntese textual encontrada no lote sobre a relação Session↔Events: session = estado observável e persistido; events = o motor causal que move esse estado.
- A delegação de **gerenciamento de refresh de credenciais OAuth para a Anthropic** (via `vault_ids`) remove uma classe inteira de complexidade operacional (token expiry, refresh flows) do lado do builder — outra instância do tema "Managed Agents tira do seu prato o que normalmente seria seu trabalho de harness".
- Notar que **passar `agent` como string simples = "latest version"** é um comportamento implícito com risco: pipelines de produção que não fixam versão podem ter comportamento mudando silenciosamente assim que alguém atualiza o agent — reforça o ponto sobre versionamento levantado em [[03-RESOURCES/sources/define-your-agent]].

## Exemplos e evidências

- Comando básico de criação: `ant beta:sessions create --agent "$AGENT_ID" --environment-id "$ENVIRONMENT_ID"`
- Exemplo de criação com versão fixada (YAML):
  ```yaml
  agent:
    type: agent
    id: $AGENT_ID
    version: 1
  environment_id: $ENVIRONMENT_ID
  ```
- Exemplo de criação com `vault_ids`:
  ```yaml
  agent: $AGENT_ID
  environment_id: $ENVIRONMENT_ID
  vault_ids:
    - $VAULT_ID
  ```
- Exemplo de envio do primeiro evento de usuário para iniciar trabalho:
  ```yaml
  events:
    - type: user.message
      content:
        - type: text
          text: List the files in the working directory.
  ```
  via `ant beta:sessions:events send --session-id "$SESSION_ID"`

## Implicações para o vault

Esta página é a dobradiça entre os passos 2 e 3 do fluxo geral em [[03-RESOURCES/sources/claude-managed-agents-overview]]:

- Consome diretamente o conceito **Agent** detalhado em [[03-RESOURCES/sources/define-your-agent]] — uma session sempre referencia um agent (por ID, com ou sem versão fixada); a regra "string = latest version" e "objeto = versão fixada" complementa as regras de versionamento daquela página
- Alimenta [[03-RESOURCES/sources/session-event-stream]] — a "etapa 2" (enviar o primeiro `user.message`) é exatamente onde aquela página assume o relay; ambas compartilham o mesmo exemplo de evento (`user.message` com `content: [{type: text, text: ...}]`)
- Alimenta [[03-RESOURCES/sources/session-operations]] — uma vez criada e iniciada, a session entra no ciclo de operações (retrieve, list, update, archive, delete) e na máquina de status (`idle`, `running`, `rescheduling`, `terminated`) detalhada lá
- Alimenta [[03-RESOURCES/sources/define-outcomes]] — outcomes são iniciados enviando `user.define_outcome` como o evento inicial alternativo, no mesmo ponto do lifecycle onde esta página descreve o envio de `user.message`
- O conceito **Environment** (cloud sandbox vs self-hosted sandbox) aparece aqui apenas referenciado por `environment_id` — esta fonte não detalha sua configuração, apenas seu papel como segundo pilar obrigatório de toda session

Conecta-se a [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]: a relação Agent (definição reutilizável) → Session (instância em execução) é uma instância clássica do padrão "configuração versionada vs instância runtime", paralela à relação framework→instância em outras pilhas de abstração agentic do vault.

## Links

- [[03-RESOURCES/sources/claude-managed-agents-overview]]
- [[03-RESOURCES/sources/define-your-agent]]
- [[03-RESOURCES/sources/session-event-stream]]
- [[03-RESOURCES/sources/session-operations]]
- [[03-RESOURCES/sources/define-outcomes]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
