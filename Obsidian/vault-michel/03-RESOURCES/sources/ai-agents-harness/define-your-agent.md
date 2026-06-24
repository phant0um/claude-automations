---
title: Define your agent
type: source
source: "Clippings/Define your agent.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, agent-configuration, anthropic-api]
---

## Tese central

Documenta como criar, configurar, atualizar e gerenciar o ciclo de vida do recurso **Agent** dentro de Claude Managed Agents — a unidade reutilizável e versionada que define persona e capacidades (model, system prompt, tools, MCP servers, skills). É o detalhamento do passo 1 ("Create an agent") do fluxo descrito em [[03-RESOURCES/sources/claude-managed-agents-overview]], e o pré-requisito direto para [[03-RESOURCES/sources/start-a-session]].

## Argumentos principais

- **Definição central**: um agent é "a reusable, versioned configuration that defines persona and capabilities" — agrupa model, system prompt, tools, MCP servers e skills que moldam como Claude se comporta durante uma session.
- **Padrão de uso**: crie o agent uma vez como recurso reutilizável e referencie-o por ID a cada vez que iniciar uma session. Agents são versionados e mais fáceis de gerenciar através de muitas sessions.
- Todas as requisições da Managed Agents API requerem o header beta `managed-agents-2026-04-01` (SDK seta automaticamente).
- **Campos de configuração do agent** (tabela completa):
  | Campo | Descrição |
  | --- | --- |
  | `name` | Obrigatório. Nome legível por humanos |
  | `model` | Obrigatório. Modelo Claude que potencializa o agent — toda a família Claude 4.5 e posteriores é suportada |
  | `system` | System prompt que define comportamento e persona — distinto das *user messages*, que devem descrever o trabalho a ser feito |
  | `tools` | Combina pre-built agent tools, MCP tools e custom tools |
  | `mcp_servers` | MCP servers que provêm capacidades padronizadas de terceiros |
  | `skills` | Skills que fornecem contexto específico de domínio com progressive disclosure |
  | `multiagent` | Declaração de coordenador listando agents para os quais este agent pode delegar (ver [[03-RESOURCES/sources/multiagent-sessions]]) |
  | `description` | Descrição do que o agent faz |
  | `metadata` | Pares chave-valor arbitrários para tracking próprio |
- **Criar um agent** — exemplo de comando CLI (`ant beta:agents create`) define um "coding agent" usando Claude Opus 4.8 com `agent_toolset_20260401` (toolset pré-construído que permite escrever código, ler arquivos, buscar na web etc.)
- **Fast mode**: para usar Claude Opus 4.8, 4.7 ou 4.6 com fast mode, passe `model` como objeto, ex.: `{"id": "claude-opus-4-8", "speed": "fast"}`. **Fast mode para Claude Opus 4.6 está deprecated** a partir do lançamento do Opus 4.8 e será removido ~30 dias depois.
- **Resposta da criação**: ecoa a configuração e adiciona `id`, `type`, `version`, `created_at`, `updated_at`, `archived_at`. `version` começa em 1 e incrementa a cada update que muda a configuração.
- **Atualizar um agent**: gera nova versão quando a configuração muda. Passe a `version` atual para garantir update a partir de estado conhecido (`ant beta:agents update --version "$AGENT_VERSION"`).
- **Semântica detalhada de update** (lista crítica de regras):
  - **Campos omitidos são preservados** — só é preciso incluir os campos a alterar
  - **Campos escalares** (`model`, `system`, `name`, `description`) são substituídos pelo novo valor; `system` e `description` podem ser limpos passando `null`; `model` e `name` são obrigatórios e não podem ser limpos
  - **Campos de array** (`tools`, `mcp_servers`, `skills`) são **totalmente substituídos** pelo novo array — para limpar, passe `null` ou array vazio
  - **`multiagent`** é substituído como um todo, incluindo seu roster `agents`; passe `null` para limpar
  - **Metadata é mesclada no nível de chave** — chaves fornecidas são adicionadas/atualizadas, chaves omitidas são preservadas; para deletar uma chave específica, defina seu valor como string vazia
  - **Detecção de no-op** — se o update não produz mudança em relação à versão atual, nenhuma nova versão é criada e a versão existente é retornada
  - **Rosters de coordenadores não são atualizados automaticamente** — coordenadores que referenciam este agent em seu `multiagent.agents` mantêm a versão fixada quando o coordenador foi criado/atualizado pela última vez, mesmo que a referência omita `version`. Para delegar à nova versão, é preciso atualizar o coordenador para que seu roster referencie a nova versão
- **Lifecycle do agent** (tabela):
  | Operação | Comportamento |
  | --- | --- |
  | Update | Gera nova versão de agent quando a configuração muda |
  | List versions | Retorna histórico completo de versões para rastrear mudanças ao longo do tempo |
  | Archive | Torna o agent read-only — novas sessions não podem referenciá-lo, mas sessions existentes continuam rodando |
- **List versions**: `ant beta:agents:versions list --agent-id "$AGENT_ID"` — busca histórico completo de versões
- **Archive**: torna o agent read-only; sessions existentes continuam, novas sessions não podem referenciá-lo; resposta seta `archived_at` com timestamp do arquivamento (`ant beta:agents archive --agent-id "$AGENT_ID"`)

## Key insights

- O **versionamento de agents é first-class e tem consequências em cascata**: atualizar um agent não propaga automaticamente para coordenadores que o referenciam — eles ficam "pinados" na versão resolvida no momento da criação/atualização do coordenador. Isso é uma decisão deliberada de design para estabilidade de rollout, mas cria um ponto de atenção operacional real (esquecer de atualizar o roster do coordenador = ele continua usando a versão antiga silenciosamente).
- A **distinção explícita entre `system` (persona/comportamento) e user messages (descrição do trabalho)** reforça uma boa prática de prompt engineering como restrição arquitetural do próprio produto — não é apenas "dica", é estruturalmente imposto pela separação de campos.
- A **substituição total (não-merge) de campos array** (`tools`, `mcp_servers`, `skills`, `multiagent`) é uma fonte comum de bugs de integração: para "adicionar uma tool" é preciso primeiro ler a configuração atual e reenviar o array completo. Isso contrasta com a semântica de merge de `metadata`, que é por chave — uma assimetria que vale a pena ter em mente ao desenhar integrações.
- **Deprecação programada do fast mode para Opus 4.6** (~30 dias após lançamento do Opus 4.8) é um sinal concreto do ritmo de obsolescência de modelos dentro do ecossistema Claude — relevante para quem planeja pipelines de longo prazo.
- A **detecção de no-op em updates** evita poluição do histórico de versões com mudanças vazias — um detalhe de design que sinaliza maturidade da API.

## Exemplos e evidências

- Comando de criação: `ant beta:agents create --name "Coding Assistant" --model '{id: claude-opus-4-8}' --system "You are a helpful coding agent." --tool '{type: agent_toolset_20260401}'`
- JSON de resposta completo da criação, incluindo `id: "agent_01HqR2k7vXbZ9mNpL3wYcT8f"`, `version: 1`, `created_at: "2026-04-03T18:24:10.412Z"`, tool config com `permission_policy: {type: always_allow}`
- Comando de update: `ant beta:agents update --agent-id "$AGENT_ID" --version "$AGENT_VERSION" --system "You are a helpful coding agent. Always write tests."`
- Exemplo de objeto `model` com fast mode: `{"id": "claude-opus-4-8", "speed": "fast"}`
- Comando de listagem de versões: `ant beta:agents:versions list --agent-id "$AGENT_ID"`
- Comando de archive: `ant beta:agents archive --agent-id "$AGENT_ID"`

## Implicações para o vault

Esta página é o detalhamento do conceito **Agent** introduzido em [[03-RESOURCES/sources/claude-managed-agents-overview]] (passo 1 do fluxo "how it works"). Ela alimenta diretamente:

- [[03-RESOURCES/sources/start-a-session]] — uma session sempre referencia um agent (por ID, opcionalmente fixando uma `version` específica); a página de sessions remete de volta a esta para detalhes de configuração
- [[03-RESOURCES/sources/multiagent-sessions]] — o campo `multiagent` aqui descrito é exatamente o mecanismo de declaração de coordenador detalhado naquela página; as regras de versionamento e "rosters não são atualizados automaticamente" descritas aqui são repetidas e expandidas lá
- [[03-RESOURCES/sources/define-outcomes]] — outcomes operam sobre sessions que rodam um agent já configurado; a separação `system` (persona) vs user messages (trabalho) descrita aqui é o que possibilita o padrão `user.define_outcome` daquela página

Conecta-se a [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]: a estrutura de campos do agent (model + system + tools + mcp_servers + skills + multiagent) é, em si, uma pilha de camadas de abstração compactada em um único recurso versionado — o "Framework Layer" do produto Managed Agents. Também conecta-se a [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]: a ideia de "skills com progressive disclosure" e "tools combinando pre-built + MCP + custom" é exatamente o vocabulário de componentes adaptáveis do harness (environment contracts, procedural skills) aplicado como produto comercial.

> [!contradiction] Naming convention
> A entidade [[03-RESOURCES/entities/Claude-Managed-Agents]] descreve a arquitetura como "3 componentes desacoplados" (Brain / Hands / Session). Esta fonte oficial usa uma taxonomia diferente e mais granular — 4 conceitos (Agent / Environment / Session / Events). Não é exatamente uma contradição factual (são níveis de abstração diferentes — Brain≈Agent+model, Hands≈Environment+tools, Session≈Session), mas vale reconciliar a entidade com a nomenclatura oficial da API ao atualizá-la com os links desta fonte.

## Links

- [[03-RESOURCES/sources/claude-managed-agents-overview]]
- [[03-RESOURCES/sources/start-a-session]]
- [[03-RESOURCES/sources/multiagent-sessions]]
- [[03-RESOURCES/sources/define-outcomes]]
- [[03-RESOURCES/entities/Claude-Managed-Agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
