---
title: Multiagent sessions
type: source
source: "Clippings/Multiagent sessions.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, multi-agent-orchestration, anthropic-api]
---

## Tese central

Documenta como **coordenar múltiplos agentes dentro de uma única session** — o modelo de coordenador/roster, threads isolados de contexto, compartilhamento de sandbox/credenciais e os eventos que surfam atividade multiagent no thread primário. É a extensão mais avançada do modelo Agent/Session/Events introduzido em [[03-RESOURCES/sources/claude-managed-agents-overview]], construída diretamente sobre o campo `multiagent` definido em [[03-RESOURCES/sources/define-your-agent]] e o modelo de eventos de [[03-RESOURCES/sources/session-event-stream]].

## Argumentos principais

- **Definição central**: "multiagent orchestration lets one agent coordinate with others to complete complex work". Agentes podem agir em paralelo com seu próprio contexto isolado, o que ajuda a melhorar qualidade de output e também pode melhorar tempo de conclusão.
- Todas as requisições requerem o header beta `managed-agents-2026-04-01`.
- **Como funciona**:
  - Todos os agentes compartilham o **mesmo sandbox, filesystem e vault credentials**, mas cada um roda em sua própria **session thread** — um event stream isolado por contexto, com seu próprio histórico de conversa
  - O coordenador reporta atividade no **primary thread** (o mesmo que o event stream em nível de session); threads adicionais são criados em runtime quando o coordenador delega trabalho
  - **Threads são persistentes**: o coordenador pode enviar um follow-up a um agente chamado anteriormente, e esse agente retém tudo de seus turnos anteriores
  - Cada agente usa sua própria configuração (model, system prompt, tools, MCP servers, skills) conforme definida na criação daquele agent — **tools, MCP servers e contexto não são compartilhados**
- **O que delegar** — coordenação multiagent é mais adequada para tarefas complexas que exigem trabalho através de superfícies variadas, ou onde múltiplas tarefas bem definidas contribuem para um objetivo geral. Três padrões que funcionam bem:
  - **Parallelization**: espalhar subtarefas independentes simultaneamente (buscar em múltiplas fontes, analisar arquivos separados) e ter o coordenador sintetizando os resultados
  - **Specialization**: rotear para agentes com system prompts e tools focados em domínio (ex.: um security agent ou documentation agent) em vez de carregar um único agent com todas as capacidades
  - **Escalation**: consultar um agente/modelo mais capaz para um subconjunto de subtarefas complexas
- **Configurar o coordenador**: ao definir o agent, declare `multiagent: {type: coordinator, agents: [...]}` listando o roster de agentes para os quais ele pode delegar.
- **`multiagent.agents` aceita três formas de referência**:
  - `{"type": "agent", "id": agent.id}` — referencia um agent previamente criado por ID; se nenhuma `version` é especificada, a referência é fixada na **última versão no momento em que o coordenador é criado**
  - `{"type": "agent", "id": agent.id, "version": agent.version}` — fixa uma versão específica do agent
  - `{"type": "self"}` — permite que o coordenador gere cópias de si mesmo
- **Snapshotting do roster**: a configuração do coordenador, incluindo seu roster `multiagent.agents`, é "snapshotada" quando o coordenador é criado ou atualizado. Agentes referenciados ficam fixados nas versões resolvidas naquele momento e **não recebem automaticamente** atualizações posteriores às suas definições. Para delegar a uma versão mais nova, é preciso atualizar o coordenador para que seu roster a referencie.
- **Limites de delegação**: o coordenador só pode delegar para **um nível** de agentes — profundidade > 1 é ignorada. Um **máximo de 20 agentes únicos** pode ser listado em `multiagent.agents`, mas o coordenador pode chamar **múltiplas cópias** de cada agent.
- **Criar a session**: cria-se uma session referenciando o coordenador como agent — ele delega aos agentes do seu roster conforme necessário.
- **Conectar agentes a MCP servers** — duas regras de escopo distintas:
  - **MCP servers são agent-scoped** (cada definição de agent declara seus próprios servers e tools)
  - **Vault credentials são session-scoped** (`vault_ids` passados na criação da session se aplicam a todos os threads)
  - Implicações: (1) para autenticar MCP servers, inclua uma credencial de vault para cada MCP server usado em todos os agentes; (2) para limitar o acesso de um agente, declare apenas os servers que ele precisa em sua definição
  - Detalhe operacional crítico: se chamadas MCP de um agente falharem na autenticação, confirme que `mcp_server_url` da credencial corresponde **exatamente** a `agent.mcp_servers[].url` — incluindo scheme e barra final
- **Threads**:
  - O **session-level event stream** (`/v1/sessions/:id/events/stream`) é considerado o **primary thread**, contendo uma visão condensada de toda atividade através de todos os threads. Você não vê a atividade completa de subagentes, mas vê início/fim do trabalho deles e eventos bloqueantes (ex.: pedidos de permissão de tool)
  - **Session threads** são onde se investiga a atividade de um agente específico
  - O **status da session é uma agregação** de toda a atividade de agentes — se ao menos um thread está `running`, o status geral da session também é `running`
  - **Máximo de 25 threads concorrentes** suportados. O coordenador pode chamar múltiplas cópias de um único agente do roster, criando múltiplos threads associados a um mesmo `agent`
  - Listar threads: `ant beta:sessions:threads list --session-id "$SESSION_ID"` — a lista completa inclui o thread primário (`parent_thread_id` é `null` para ele)
- **Eventos que surfam atividade multiagent no thread primário** (tabela completa):
  | Tipo | Descrição |
  | --- | --- |
  | `session.thread_created` | Um thread foi criado. Inclui `session_thread_id` e `agent_name` |
  | `session.thread_status_running` | Um thread iniciou atividade |
  | `session.thread_status_idle` | O agente associado ao thread está aguardando input. Inclui `stop_reason` indicando por que parou |
  | `session.thread_status_terminated` | Um thread foi arquivado ou encontrou erro terminal |
  | `agent.thread_message_received` | Um agente entregou seu resultado ao coordenador. Inclui `from_session_thread_id`, `from_agent_name`, `content` |
  | `agent.thread_message_sent` | O coordenador enviou um follow-up a outro agente. Inclui `to_session_thread_id`, `to_agent_name`, `content` |
- **Eventos críticos são "proxied" ao thread primário** — mesmo assim pode ser necessário investigar o raciocínio e tool calls de um agente específico fazendo stream/list dos eventos do thread associado: `ant beta:sessions:threads:events stream --session-id "$SESSION_ID" --thread-id "$THREAD_ID"`
- **Permissões de tool e custom tools em subagentes**: se um subagente precisa de algo do cliente (permissão para rodar uma tool `always_ask`, ou resultado de custom tool), o evento é "cross-posted" ao **primary thread** com `session_thread_id` identificando o thread de origem. O builder posta `user.tool_confirmation` (com `tool_use_id`) ou `user.custom_tool_result` (com `custom_tool_use_id`) — **o servidor roteia a resposta automaticamente para o thread correto**.

## Key insights

- A frase **"the coordinator can only delegate to one level of agents; depth > 1 is ignored"** é uma restrição arquitetural deliberada que **previne hierarquias de delegação recursivas e potencialmente explosivas** — um trade-off claro entre flexibilidade ilimitada e previsibilidade/limites de custo. Isso contrasta com a "Hierarchical delegation" listada como padrão válido em [[03-RESOURCES/concepts/agent-orchestration]] no contexto geral do vault — Managed Agents explicitamente *não* suporta esse padrão em profundidade, apenas um nível.
- O **`{"type": "self"}`** (coordenador gerando cópias de si mesmo) é um mecanismo elegante para "fan-out homogêneo" sem precisar definir um segundo agent idêntico — reduz a sobrecarga de configuração para o caso comum de "preciso de N workers idênticos".
- O **snapshot/pinning do roster do coordenador** repete e reforça a mesma armadilha operacional descrita em [[03-RESOURCES/sources/define-your-agent]] (rosters não atualizam sozinhos) — agora com consequências potencialmente maiores, pois um coordenador pode ter até 20 agentes referenciados, cada um podendo ficar "preso" silenciosamente em versões antigas.
- A **separação de escopo MCP servers (agent-scoped) vs vault credentials (session-scoped)** cria uma superfície de configuração não-trivial: para autenticar corretamente um sistema multiagent, é preciso pensar em duas dimensões de escopo simultaneamente — "quem declara o server" (agent) e "quem fornece a credencial" (session, para todos os threads). Erros de configuração aqui (como mismatch de `mcp_server_url`) são citados explicitamente como fonte comum de falhas de autenticação.
- O **modelo "primary thread = visão condensada + cross-posting de eventos bloqueantes"** resolve elegantemente o problema de "como observar N agentes em paralelo sem ser inundado de ruído": você vê o essencial (criação/status/mensagens entre threads/bloqueios) no stream principal, e mergulha em um thread específico só quando precisa de profundidade. Isso é uma instância concreta e bem desenhada de um padrão de observabilidade hierárquica para sistemas multiagentes — relevante para [[03-RESOURCES/concepts/agent-systems/agent-observability]].
- O **roteamento automático de respostas pelo servidor** ("the server routes the response to the correct thread automatically") com base apenas no ID do evento é o que torna o modelo multiagent tratável do ponto de vista do builder — sem isso, gerenciar correlação de IDs através de N threads concorrentes seria um pesadelo de estado.
- Os limites concretos — **20 agentes no roster, 25 threads concorrentes, profundidade máxima 1** — formam um "envelope operacional" claro que qualquer arquitetura multiagent sobre Managed Agents precisa respeitar. Esses números são úteis como referência de capacidade ao desenhar sistemas reais.

## Exemplos e evidências

- Comando de criação de coordenador "Engineering Lead" com roster de 2 agentes (`$REVIEWER_AGENT_ID`, `$TEST_WRITER_AGENT_ID`)
- Exemplo completo de pipeline de pesquisa: cria um `research_agent` (Claude Haiku 4-5, com MCP server GitHub), depois um `coordinator` (Claude Opus 4-8) referenciando-o, depois cria a session passando `--vault-id`
- Comando de criação de session referenciando coordenador: `ant beta:sessions create --agent "$COORDINATOR_ID" --environment-id "$ENVIRONMENT_ID"`
- Comando de listagem de threads: `ant beta:sessions:threads list --session-id "$SESSION_ID"`
- Tabela completa de 6 tipos de evento multiagent (`session.thread_created`, `session.thread_status_running/idle/terminated`, `agent.thread_message_received/sent`)
- JSON de exemplo de `session.thread_status_idle` com `session_thread_id`, `agent_name: "code-reviewer"`, `stop_reason: {type: requires_action, event_ids: [...]}`
- Comando de stream de eventos de thread específico: `ant beta:sessions:threads:events stream --session-id "$SESSION_ID" --thread-id "$THREAD_ID"`
- Limites numéricos concretos: máximo 20 agentes no roster, máximo 25 threads concorrentes, profundidade máxima de delegação = 1

## Implicações para o vault

Esta página representa o ponto mais avançado do modelo Managed Agents documentado no lote — constrói sobre praticamente todas as outras peças:

- Depende diretamente do campo `multiagent` definido em [[03-RESOURCES/sources/define-your-agent]] — esta página é a expansão completa daquele campo, incluindo as três formas de referência de agent e a regra de pinning/snapshot que aquela página já antecipava
- Estende o modelo de Session de [[03-RESOURCES/sources/start-a-session]] e [[03-RESOURCES/sources/session-operations]] — a noção de "status agregado" (`running` se qualquer thread está `running`) generaliza a máquina de estados de status de uma única conversa para N threads concorrentes
- Reaproveita e estende diretamente os mecanismos de "tool confirmation" e "custom tool calls" descritos em [[03-RESOURCES/sources/session-event-stream]] — o mesmo fluxo `requires_action`/correlação por ID, agora com a camada adicional de roteamento entre threads via `session_thread_id`
- O conceito de "vault credentials são session-scoped, aplicam-se a todos os threads" reaproveita o mecanismo de `vault_ids` introduzido em [[03-RESOURCES/sources/start-a-session]], agora com uma implicação multiagent específica (uma credencial de vault precisa cobrir todos os MCP servers usados por qualquer agente do roster)

Esta é provavelmente a fonte mais rica do lote para alimentar [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] e [[03-RESOURCES/concepts/agent-orchestration]] com um exemplo concreto, com limites numéricos reais, de como um provedor de plataforma resolve os problemas centrais de orquestração multiagente (isolamento de contexto, compartilhamento seletivo de recursos, observabilidade hierárquica, roteamento de respostas). Vale revisar [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] para acrescentar esta implementação como caso de estudo de referência.

> [!contradiction] Hierarquia de delegação
> [[03-RESOURCES/concepts/agent-orchestration]] lista "Hierarchical delegation (subagents spawn their own subagents)" como um padrão válido de orquestração no vault em geral. Esta fonte documenta que Claude Managed Agents **explicitamente não suporta** esse padrão — "the coordinator can only delegate to one level of agents; depth > 1 is ignored". Não é uma contradição entre fontes do vault, mas um ponto de atenção: o padrão geral existe na literatura/prática de orquestração, mas esta implementação específica da Anthropic o restringe deliberadamente a um nível — vale anotar essa limitação ao referenciar Managed Agents como exemplo de orquestração hierárquica.

## Links

- [[03-RESOURCES/sources/claude-managed-agents-overview]]
- [[03-RESOURCES/sources/define-your-agent]]
- [[03-RESOURCES/sources/start-a-session]]
- [[03-RESOURCES/sources/session-operations]]
- [[03-RESOURCES/sources/session-event-stream]]
- [[03-RESOURCES/sources/define-outcomes]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
