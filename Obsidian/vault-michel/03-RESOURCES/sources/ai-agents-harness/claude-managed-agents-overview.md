---
title: Claude Managed Agents overview
type: source
source: "Clippings/Claude Managed Agents overview.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, harness-architecture, anthropic-api]
---

## Tese central

Documento de entrada da família "Claude Managed Agents" — define o produto como uma alternativa "harness gerenciado" à Messages API direta, introduz os quatro conceitos centrais do sistema (Agent, Environment, Session, Events) e estabelece o fluxo de alto nível ("how it works") que as demais páginas do lote (Define your agent, Define outcomes, Start a session, Session operations, Session event stream, Multiagent sessions) detalham peça por peça.

## Argumentos principais

- **Duas formas de construir com Claude**, lado a lado em tabela comparativa:
  - **Messages API**: acesso direto ao prompting do modelo — "custom agent loops and fine-grained control"
  - **Claude Managed Agents**: "pre-built, configurable agent harness that runs in managed infrastructure" — "long-running tasks and asynchronous work"
- Managed Agents fornece o **harness e a infraestrutura completos**: você não constrói seu próprio agent loop, execução de tools ou runtime — recebe um ambiente totalmente gerenciado onde Claude lê arquivos, roda comandos, navega na web e executa código com segurança.
- O harness inclui otimizações **built-in**: prompt caching, compaction e outras técnicas de performance para outputs de agente eficientes e de alta qualidade.
- **Disponível também no Claude Platform on AWS**, com diferenças de disponibilidade de features e comportamento de sessão em relação à versão direta da Anthropic.
- **Quatro conceitos centrais** (tabela):
  | Conceito | Descrição |
  | --- | --- |
  | Agent | O modelo, system prompt, tools, MCP servers e skills |
  | Environment | Configuração de onde sessions rodam: cloud sandbox gerenciado pela Anthropic, ou sandbox self-hosted na própria infraestrutura |
  | Session | Uma instância de agente rodando dentro de um environment, executando uma tarefa específica e gerando outputs |
  | Events | Mensagens trocadas entre a aplicação e o agente (turnos do usuário, resultados de tools, status updates) |
- **Fluxo "how it works" em 5 passos** (mapeia diretamente para as outras páginas do lote):
  1. Criar um agent (definir model, system prompt, tools, MCP servers, skills — referenciável por ID em múltiplas sessions) → ver [[03-RESOURCES/sources/define-your-agent]]
  2. Criar um environment (cloud sandbox ou self-hosted sandbox)
  3. Iniciar uma session (referenciando agent + environment) → ver [[03-RESOURCES/sources/start-a-session]]
  4. Enviar mensagens de usuário como events; Claude executa tools autonomamente e transmite resultados via Server-Sent Events (SSE); histórico persistido server-side e recuperável integralmente → ver [[03-RESOURCES/sources/session-event-stream]]
  5. Direcionar ou interromper — enviar novos eventos de usuário para guiar o agente em meio à execução, ou interrompê-lo para mudar de direção
- **Quando usar Managed Agents** — lista de cenários ideais:
  - Execução de longa duração (tarefas de minutos a horas, múltiplas tool calls)
  - Infraestrutura cloud (sandboxes seguros com pacotes pré-instalados e acesso à rede)
  - Execução self-hosted (sandboxes em infraestrutura própria por compliance ou residência de dados)
  - Infraestrutura mínima (não precisa construir agent loop, sandbox ou camada de execução de tools própria)
  - Sessions stateful (filesystems persistentes e histórico de conversa entre múltiplas interações)
- **Tools suportadas nativamente**:
  - Bash — rodar comandos shell no sandbox
  - File operations — read, write, edit, glob, grep
  - Web search and fetch — buscar e recuperar conteúdo de URLs
  - MCP servers — conectar a provedores externos de tools
- **Status: beta**. Todos os endpoints de Managed Agents requerem o header `managed-agents-2026-04-01`. O SDK seta o header automaticamente. Comportamentos podem ser refinados entre releases.
- **Pré-requisitos para começar**:
  1. Uma Claude API key
  2. O header beta `managed-agents-2026-04-01` em todas as requisições
  3. Acesso a Claude Managed Agents (habilitado por padrão em todas as contas API)
- **Funcionalidades em research preview mais restrito** dentro do beta: MCP tunnels e "dreaming" — requerem solicitação de acesso separada.
- **Stateful por design** — implicações sérias de retenção de dados:
  - Sessions são de longa duração, retomam de pausas, e armazenam histórico de conversa, estado do sandbox e outputs server-side
  - **Não elegível para Zero Data Retention (ZDR) nem para HIPAA Business Associate Agreement (BAA)**
  - O usuário mantém controle: pode deletar sessions e, separadamente, deletar arquivos enviados, a qualquer momento via API

## Key insights

- O posicionamento "harness vs Messages API" é a thesis central do produto: Managed Agents *é* a camada de harness que historicamente cada builder tinha que construir do zero — agora oferecida como infraestrutura gerenciada e versionada.
- A decisão arquitetural de tornar sessions **stateful e persistentes server-side** (sandbox + histórico + outputs) é o que viabiliza "retomar de onde parou", mas é exatamente o que **exclui o produto de ZDR/HIPAA** — uma troca explícita entre conveniência operacional e elegibilidade de compliance.
- Os "quatro conceitos centrais" (Agent / Environment / Session / Events) formam um modelo mental limpo e ortogonal: Agent = "quem", Environment = "onde", Session = "instância rodando", Events = "como você se comunica". Cada uma das outras 6 páginas do lote aprofunda exatamente um desses pilares (ou a interação entre eles, no caso de multiagent).
- O fato de o SDK setar o beta header `managed-agents-2026-04-01` automaticamente sinaliza que a Anthropic já trata Managed Agents como superfície de primeira classe do SDK, não apenas um endpoint experimental isolado.
- A disponibilidade simultânea no Claude Platform on AWS (com diferenças de comportamento) sugere que a Anthropic está deliberadamente multiplicando superfícies de distribuição da mesma capacidade de harness — reforça o padrão de "harness como produto" mais amplo já mapeado em [[03-RESOURCES/concepts/agent-systems/harness-adaptation]].

## Exemplos e evidências

- Tabela comparativa Messages API vs Managed Agents (ver "Argumentos principais")
- Tabela dos 4 conceitos centrais (Agent, Environment, Session, Events)
- Lista numerada do fluxo "how it works" (5 passos)
- Lista de 5 cenários "when to use"
- Lista de 4 categorias de tools suportadas (Bash, file ops, web search/fetch, MCP servers)
- Header beta obrigatório: `managed-agents-2026-04-01`
- Links de referência cruzada citados no documento: rate limits e branding guidelines na página de reference; self-hosted sandboxes; tools; dreams; MCP tunnels

## Implicações para o vault

Esta é a página-âncora do lote de 7 fontes sobre Claude Managed Agents ingeridas nesta sessão (FASE 2 do pipeline-diario 2026-06-06). Ela define o vocabulário e o modelo de quatro conceitos que todas as outras detalham:

- [[03-RESOURCES/sources/define-your-agent]] — aprofunda o conceito **Agent** (passo 1 do "how it works"): campos de configuração, versionamento, lifecycle
- [[03-RESOURCES/sources/define-outcomes]] — descreve a camada de avaliação orientada a "outcomes" que transforma uma session de "conversa" em "trabalho", construída sobre o modelo Session + Events
- [[03-RESOURCES/sources/start-a-session]] — aprofunda **Session** e **Environment** (passos 2-3): como criar e iniciar uma session referenciando agent + environment
- [[03-RESOURCES/sources/session-operations]] — operações de gestão de **Session** após sua criação (retrieve, list, update, archive, delete) e o ciclo de status
- [[03-RESOURCES/sources/session-event-stream]] — aprofunda **Events** (passo 4-5): tipos de evento, streaming via SSE, interrupção e steering, confirmação de tools, retomada de sessions
- [[03-RESOURCES/sources/multiagent-sessions]] — estende o modelo de Session/Agent para coordenação de múltiplos agentes dentro da mesma session (threads, coordinator/roster)
- [[03-RESOURCES/sources/tools]] — detalha o **toolset** built-in da plataforma (bash/read/write/edit/glob/grep/web_fetch/web_search) e custom tools, ingerida em batch posterior (FASE 2, mesma sessão de pipeline-diario 2026-06-06)
- [[03-RESOURCES/sources/permission-policies]] — detalha o controle de execução (`always_allow`/`always_ask`) sobre o toolset definido em `tools`, incluindo o fluxo de confirmação via eventos `agent.tool_use`/`user.tool_confirmation`

Conecta-se à entidade já existente [[03-RESOURCES/entities/Claude-Managed-Agents]] (criada em 2026-04-17, atualizada em 2026-05-19), que descreve o produto em alto nível com a arquitetura de "3 componentes desacoplados" (Brain / Hands / Session). Esta fonte e as demais do lote fornecem o detalhamento técnico de API que faltava àquela entidade — recomenda-se atualizá-la com os links para estas 7 fontes.

Relaciona-se também a [[03-RESOURCES/concepts/agent-systems/harness-adaptation]] (o produto *é* uma implementação comercial do padrão de harness como camada de otimização separada do modelo) e a [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] (Agent/Environment/Session/Events constitui mais uma hierarquia de camadas de abstração agentic, paralela à already-mapeada Framework/Metacommand/Skill/Tool).

Sugestão de novo conceito: **`managed-agents-harness`** — haveria valor em consolidar o modelo Agent/Environment/Session/Events como um padrão arquitetural reconhecível (não apenas descrição de produto), comparável a outros padrões de harness já mapeados no vault.

## Links

- [[03-RESOURCES/sources/define-your-agent]]
- [[03-RESOURCES/sources/define-outcomes]]
- [[03-RESOURCES/sources/start-a-session]]
- [[03-RESOURCES/sources/session-operations]]
- [[03-RESOURCES/sources/session-event-stream]]
- [[03-RESOURCES/sources/multiagent-sessions]]
- [[03-RESOURCES/sources/tools]]
- [[03-RESOURCES/sources/permission-policies]]
- [[03-RESOURCES/entities/Claude-Managed-Agents]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/sources/anthropic-ant-cli-managed-agents-guide]] — `ant` CLI: cliente típado para operar Agent/Environment/Session/Events via terminal
