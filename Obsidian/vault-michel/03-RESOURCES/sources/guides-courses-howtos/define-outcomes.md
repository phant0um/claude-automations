---
title: Define outcomes
type: source
source: "Clippings/Define outcomes.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, outcome-evaluation, anthropic-api]
---

## Tese central

Documenta o mecanismo de **outcomes** — o recurso que "eleva uma session de *conversa* para *trabalho*": você define o que o resultado final deve parecer e como medir qualidade (via rubric), e o agente trabalha em direção a esse alvo, se autoavaliando e iterando até atingi-lo. É uma camada construída sobre o modelo Session + Events já descrito em [[03-RESOURCES/sources/claude-managed-agents-overview]] e [[03-RESOURCES/sources/start-a-session]], introduzindo um segundo agente (o "grader") e um ciclo de avaliação fechado.

## Argumentos principais

- **Definição central**: o `outcome` "elevates a session from *conversation* to *work*". Você define o resultado-alvo e como medir qualidade; o agente trabalha rumo a esse alvo, se autoavaliando e iterando até cumpri-lo.
- **Mecanismo do grader**: ao definir um outcome, o harness automaticamente provisiona um *grader* — um avaliador separado que julga o artefato contra uma rubric. **Crucialmente, o grader usa uma janela de contexto separada** para evitar ser influenciado pelas escolhas de implementação do agente principal (evita "auto-avaliação enviesada").
- O grader retorna uma **explicação** resumindo quais critérios passaram/falharam, ou confirmando que o artefato satisfaz a rubric — esse feedback é devolvido ao agente para a próxima iteração.
- Todas as requisições requerem o header beta `managed-agents-2026-04-01`.
- **Criar uma rubric**: documento markdown descrevendo scoring por critério — **obrigatório**. Exemplo completo no documento é uma rubric de "DCF Model" (modelo de fluxo de caixa descontado) com seções: Revenue Projections, Cost Structure, Discount Rate, Terminal Value, Output Quality — cada uma com bullet points de critérios objetivos e mensuráveis.
- A rubric pode ser passada como **texto inline** em `user.define_outcome`, ou enviada via **Files API** para reuso entre sessions (requer headers beta `managed-agents-2026-04-01` **e** `files-api-2025-04-14`).
- **Criar uma session com outcome**: após criar a session, envie um evento `user.define_outcome` — o agente começa a trabalhar imediatamente; **nenhuma mensagem de usuário adicional é necessária**. Campos do evento: `description` (o que construir), `rubric` (`{type: file, file_id: ...}` ou `{type: text, content: "..."}`), `max_iterations` (opcional; **default 3, máximo 20**).
- **Eventos de outcome** surfam no event stream:
  - Eventos `agent.*` (mensagens, uso de tools) mostram progresso rumo ao outcome
  - Eventos `span.outcome_evaluation_*` são emitidos **apenas** para sessions orientadas a outcome e mostram o número de loops de iteração e o processo de feedback do grader
  - Você pode enviar eventos `user.message` a uma session orientada a outcome para direcionar o trabalho do agente em progresso, mas **não é obrigatório** — o agente trabalha rumo ao outcome sozinho, iterando até suceder ou esgotar iterações
  - Um evento `user.interrupt` pausa o trabalho no outcome atual e marca `span.outcome_evaluation_end.result` como `interrupted`, permitindo iniciar um novo outcome
  - Após a avaliação final do outcome, a session pode continuar como session conversacional, ou um novo outcome pode ser iniciado — **a session retém o histórico do outcome anterior**
- **Apenas um outcome por vez é suportado**, mas é possível encadear outcomes em sequência: envie um novo `user.define_outcome` após o evento terminal do outcome anterior.
- **Evento `user.define_outcome`** — é ecoado de volta no recebimento, incluindo timestamp `processed_at` e `outcome_id`.
- **Evento `span.outcome_evaluation_start`**: emitido quando o grader inicia uma avaliação sobre um loop de iteração. O campo `iteration` é um contador de revisão **0-indexado**: `0` = primeira avaliação, `1` = reavaliação após primeira revisão, etc.
- **Evento `span.outcome_evaluation_ongoing`**: heartbeat emitido enquanto o grader roda. **O raciocínio interno do grader é opaco** — você vê que ele está trabalhando, não o que está pensando.
- **Evento `span.outcome_evaluation_end`**: emitido após o grader terminar de avaliar uma iteração. O campo `result` indica o que acontece a seguir — tabela completa de resultados:
  | Result | Próximo passo |
  | --- | --- |
  | `satisfied` | Session transiciona para `idle` |
  | `needs_revision` | Agente inicia novo ciclo de iteração |
  | `max_iterations_reached` | Sem mais ciclos de avaliação; o agente pode rodar uma revisão final antes da session ir para `idle` |
  | `failed` | Session transiciona para `idle`. Retornado quando a rubric fundamentalmente não corresponde à tarefa — ex.: descrição e rubric se contradizem |
  | `interrupted` | Emitido apenas se `outcome_evaluation_start` já tiver disparado antes da interrupção |
- **Checar status do outcome**: ouvir o event stream por `span.outcome_evaluation_end`, ou fazer polling em `GET /v1/sessions/:id` lendo `outcome_evaluations[].result`.
- **Recuperar deliverables**: o agente escreve arquivos de output em `/mnt/session/outputs/` dentro do sandbox. Uma vez que a session está `idle`, busque-os via Files API com escopo na session (`--scope-id "$SESSION_ID"`).

## Key insights

- A separação **grader com janela de contexto própria** é a peça mais importante deste design — resolve o problema clássico de "o agente que produziu o trabalho não pode ser o juiz imparcial dele mesmo" sem exigir um segundo agente configurado manualmente. Isso é uma instância concreta do padrão crítico-ator (`critic-actor`) já catalogado em [[03-RESOURCES/concepts/agent-orchestration]] — mas implementado como infraestrutura automática, não como decisão de design do usuário.
- O **`iteration` 0-indexado e `max_iterations` com default 3 / máximo 20** dão um orçamento explícito e limitado ao ciclo de auto-melhoria — evita loops infinitos de revisão, troca "qualidade ilimitada" por "convergência garantida em N passos".
- O resultado `failed` (quando descrição e rubric se contradizem) é um detalhe de design notável: o sistema **detecta inconsistência na própria especificação da tarefa**, não apenas falhas de execução — uma forma de meta-validação de inputs do usuário.
- A opacidade do raciocínio do grader (`outcome_evaluation_ongoing` como heartbeat sem conteúdo) é uma escolha deliberada de design que prioriza eficiência/custo sobre interpretabilidade — você sabe *que* está avaliando, não *como*. Isso é relevante para [[03-RESOURCES/concepts/agent-systems/agent-observability]]: há um limite arquitetural explícito ao que é observável no sistema.
- O fato de **"nenhuma mensagem de usuário adicional é necessária"** após `user.define_outcome` confirma a tese central: outcomes não são "prompts melhores", são um **modo operacional diferente** da session — de "responda ao que eu pedir" para "trabalhe até satisfazer este critério mensurável", uma mudança de paradigma de interação humano-agente.
- **Encadeamento de outcomes com retenção de histórico** permite compor pipelines de trabalho de longa duração dentro de uma única session persistente — um padrão que se conecta a `agent-lifespan-engineering` (sessions que vivem além de uma única tarefa).

## Exemplos e evidências

- Rubric completa de exemplo: "DCF Model Rubric" com 5 seções e ~15 critérios objetivos (ex.: "Uses historical revenue data from the last 5 fiscal years", "WACC is calculated with stated assumptions for cost of equity and cost of debt", "Terminal growth rate does not exceed long-term GDP growth")
- Comando de upload de rubric via Files API: `RUBRIC_ID=$(ant beta:files upload --file /tmp/rubric.md --transform id --raw-output)`
- Fluxo completo de criação de session com outcome — exemplo prático "Build a DCF model for Costco in .xlsx" com `max_iterations: 5`
- JSON de evento `user.define_outcome`: `{"type": "user.define_outcome", "description": "...", "rubric": {"type": "file", "file_id": "file_01..."}, "max_iterations": 5}`
- JSON de `span.outcome_evaluation_start`: inclui `iteration: 0`, `outcome_id: "outc_01a..."`, `processed_at: "2026-03-25T14:01:45Z"`
- JSON de `span.outcome_evaluation_end` completo: `result: "satisfied"`, explicação textual ("All 12 criteria met..."), e bloco `usage` com `input_tokens: 2400`, `output_tokens: 350`, `cache_creation_input_tokens: 0`, `cache_read_input_tokens: 1800`
- Comando de polling: `ant beta:sessions retrieve --session-id "$SESSION_ID" --transform 'outcome_evaluations' --format yaml`
- Comandos de listagem/download de deliverables via Files API com `--scope-id "$SESSION_ID"`

## Implicações para o vault

Outcomes são a camada de "definição de sucesso mensurável" construída sobre o trio Session/Agent/Events descrito em [[03-RESOURCES/sources/claude-managed-agents-overview]]:

- Depende diretamente de [[03-RESOURCES/sources/start-a-session]] — você primeiro cria a session (referenciando agent + environment), depois envia `user.define_outcome` como o evento inicial alternativo a `user.message`
- Estende [[03-RESOURCES/sources/session-event-stream]] — introduz uma família inteira de novos tipos de evento (`span.outcome_evaluation_*`) e reaproveita `user.interrupt` com semântica adicional (`interrupted` no resultado da avaliação)
- Conecta-se a [[03-RESOURCES/sources/session-operations]] — o status final de um outcome sempre leva a session de volta a `idle`, reaproveitando a máquina de estados de status documentada lá
- O padrão grader-com-contexto-isolado prefigura, em escala menor, o modelo de **threads isolados** descrito em [[03-RESOURCES/sources/multiagent-sessions]] — ambos resolvem o problema de "contaminação de contexto" criando fronteiras de contexto independentes dentro da mesma session

Conecta-se fortemente a [[03-RESOURCES/concepts/agent-orchestration]] (padrão critic-actor implementado como infraestrutura automática) e a [[03-RESOURCES/concepts/agent-systems/agent-observability]] (limite explícito de observabilidade no raciocínio do grader — heartbeats sem conteúdo). Também relevante para qualquer concept futuro sobre "agentic self-evaluation loops" ou "rubric-driven agents" — não há concept exato no vault hoje para "avaliação automática por rubric com grader isolado"; pode ser nicho dentro de `managed-agents-harness` (sugerido) ou merecer concept próprio.

## Links

- [[03-RESOURCES/sources/claude-managed-agents-overview]]
- [[03-RESOURCES/sources/start-a-session]]
- [[03-RESOURCES/sources/session-event-stream]]
- [[03-RESOURCES/sources/session-operations]]
- [[03-RESOURCES/sources/multiagent-sessions]]
- [[03-RESOURCES/concepts/agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
