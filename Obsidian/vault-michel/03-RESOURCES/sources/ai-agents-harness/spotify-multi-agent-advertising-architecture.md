---
title: "Our Multi-Agent Architecture for Smarter Advertising"
type: source
source: "Clippings/Our Multi-Agent Architecture for Smarter Advertising.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central

A engenharia de Ads da Spotify substituiu workflows de planejamento de mídia fragmentados (um por canal de compra — Direct, Self-Serve, Programmatic — e por superfície — Ads Manager, Salesforce, Slack) por uma camada de decisão agêntica unificada ("Ads AI"), construída com Google ADK + Vertex AI (Gemini 2.5 Pro), que decompõe o planejamento em agentes especializados executados em paralelo, reduzindo o tempo de criação de um plano de mídia de 15-30 minutos para 5-10 segundos.

## Argumentos principais

- **Problema estrutural, não de feature de IA**: a infraestrutura já estava consolidada no backend, mas o comportamento permanecia fragmentado — cada canal de compra reimplementa as mesmas decisões centrais (alocação de orçamento, escolha de inventário, balanço reach vs. eficiência vs. STR), que vão divergindo ao longo do tempo.
- **Por que não o playbook padrão (novo serviço + state machine + REST + UIs)**: não cabe na forma do trabalho porque (1) workflows são combinatórios — planejamento, forecasting, seleção de audiência, criativo, pacing e otimização dependem de usuário, inventário disponível, prioridades de negócio e metas do anunciante, não cabendo em "happy paths" hardcoded; (2) as mesmas decisões precisam aparecer consistentemente em todas as superfícies (Ads Manager, Salesforce, Slack) — reimplementar 3x gera dívida técnica e comportamento inconsistente; (3) falta uma **camada de intenção** — sistemas atuais são bons em *fazer* (criar line item, rodar forecast, buscar insights), mas não em traduzir um objetivo ("maximizar reach no Brasil, proteger inventário de vídeo, ainda atingir STR") em sequência de tool calls, trade-offs e checagens.
- **Também rejeitaram o extremo oposto**: uma rules engine gigante seria frágil, pois a lógica de Ads é "messy, probabilística e em constante mudança" — forecasting, otimização e insights já dependem fortemente de ML.
- **Aposta agêntica**: tratar o planejamento/gestão de campanhas como conjunto de agentes modulares que (1) consomem os mesmos sinais subjacentes (inventário, audiências, STR, qualidade/risco, histórico de performance), (2) otimizam conjuntamente para metas do anunciante e restrições de negócio do Spotify, e (3) usam os serviços de Ads existentes como *ferramentas* em vez de reimplementar capacidades.
- **Mudança de mental model** — passa a exigir: APIs desenhadas como ferramentas para agentes (não só CRUD); testes como avaliação comportamental (não só unit/integration); observability como "o que o agente decidiu e por quê" (não só p95s/error budgets); segurança como guardrails sobre decisões semi-autônomas (não só validação de input).
- **Caso de uso inicial: Media Planning** — escolhido por concentrar toda a complexidade (sales, advertisers, inventário, pacing, ad products) e por ser cedo no ciclo de vida, beneficiando tudo a jusante (booking, trafficking, delivery, otimização) se acertarem as decisões aqui.

## Key insights

- **Stack**: Google ADK 0.2.0 (orquestração de agentes, sessão, integração de tools) + Vertex AI Gemini 2.5 Pro (NLU/geração) + gRPC (comunicação de serviço) + Google Cloud (persistência de sessão) + PostgreSQL + cache em memória (dados históricos de performance) + Apollo (framework de serviço da Spotify — lifecycle, config, observability).
- **Decomposição em agentes**:
  - **RouterAgent** — "controlador de tráfego": analisa a mensagem do usuário, determina quais informações já estão presentes, evita chamadas LLM desnecessárias e habilita execução condicional de agentes.
  - **Agentes resolvedores especializados** (cada um com responsabilidade focada): GoalResolverAgent (mapeia intenção → objetivos de campanha REACH/CLICKS/APP_INSTALLS etc. e busca categorias de anúncio apropriadas); AudienceResolverAgent (extrai critérios de targeting — interesses de taxonomia predefinida, alvos geográficos, faixa etária, gênero); BudgetAgent (parseia formatos de orçamento variados — $5000, 5k, €10.000 — convertendo para micro-units); ScheduleAgent (parseia datas, incluindo relativas — "próximo mês", "30 dias").
  - **MediaPlannerAgent** — "o otimizador": consolida as informações resolvidas e gera recomendações de ad sets via engine baseada em heurísticas + dados históricos de performance.
- **Regras-chave de otimização do MediaPlannerAgent**: (1) minimizar custo (CPM/CPC/CPI) vs. medianas históricas; (2) buscar delivery rate próximo de 100%; (3) casar campanhas históricas de orçamento similar; (4) casar duração de campanha com performers comprovados; (5) score por overlap demográfico/de interesses; (6) garantir diversidade de combinações formato/objetivo; (7) escalar nº de recomendações pelo orçamento — €0-1k → 1 recomendação; €1k-5k → 2; €5k-15k → 3; €15k+ → 4-5.
- **Tool integration via function calling**: ADK FunctionTool dá aos agentes acesso a dados reais; anotações `@Schema` informam ao LLM a estrutura dos parâmetros das tools.
- **Trade-offs explícitos**: (1) single vs. multi-agent — single agent teria prompt gigante e não paralelizaria; multi-agent adiciona complexidade mas melhora latência e manutenibilidade; (2) cache em memória vs. banco — escolheram in-memory para minimizar latência (dados de performance são limitados e atualizados periodicamente); (3) síncrono vs. streaming — optaram por síncrono inicialmente por simplicidade, reconhecendo que streaming daria melhor UX para operações longas.

## Exemplos e evidencias

| Métrica | Manual | Agêntico |
|---|---|---|
| Tempo de criação de plano de mídia | 15-30 min | 5-10 segundos |
| Inputs do usuário necessários | 20+ campos de formulário | 1-3 mensagens em linguagem natural |
| Dados de otimização usados | Nenhum (intuição humana) | Histórico de performance de milhares de campanhas |
| Latência de resposta do agente | N/A | ~3-5s com execução paralela |

- **Aprendizado 1 — prompt engineering é engenharia de software**: tratar prompts como código (versionamento, testes, iteração) foi essencial; pequenas mudanças de wording afetam drasticamente a consistência do output. Práticas: ser explícito sobre formato de output exigido, fornecer exemplos concretos no prompt, construir guardrails tanto na camada de prompt quanto na de parsing.
- **Aprendizado 2 — fronteiras entre agentes importam**: regra de ouro adotada — um agente por skill/fonte de dados distinta. Agentes demais → mais latência e overhead de coordenação; agentes de menos → prompts monolíticos difíceis de manter.
- **Aprendizado 3 — tools habilitam grounding**: LLMs alucinam; dar aos agentes tools que acessam dados reais (geo targets, categorias de anúncio, histórico de performance) ancora os outputs na realidade — o LLM raciocina sobre *o que fazer*, as tools fornecem *dados precisos* para trabalhar.
- **Trabalho futuro**: respostas via streaming (SSE); refinamento multi-turn melhor ("ciclos frequentes de avaliação de dados"); integração de A/B testing (testar planos recomendados pela IA contra baselines); expansão de capacidades de agentes (sugestões criativas, análise competitiva, otimização cross-campaign); fine-tuning de modelos específicos para terminologia de advertising.

## Implicacoes para o vault

- Caso real, com métricas, do padrão **router + resolver agents + planner agent**, complementando `[[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]` e `[[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]` com um exemplo de produção em escala (Spotify Ads).
- Reforça a regra de ouro "um agente por skill/fonte de dados distinta" como heurística de design de fronteiras de agentes — aplicável ao desenho de subagentes do vault (`04-SYSTEM/agents/`).
- "Prompt engineering como engenharia de software" (versionamento, testes, guardrails de prompt + parsing) é diretamente relevante para `[[03-RESOURCES/concepts/claude-code-tooling/skill-authoring]]` e para a manutenção de prompts dos agentes do vault.
- "Tools habilitam grounding" reforça o princípio já adotado no vault de agentes consultarem fontes via MCP/ferramentas em vez de confiar em conhecimento paramétrico.

## Links

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agentic-patterns]]
- [[03-RESOURCES/concepts/claude-code-tooling/skill-authoring]]
