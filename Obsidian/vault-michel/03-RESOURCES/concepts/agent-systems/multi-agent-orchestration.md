---
title: multi-agent-orchestration
type: concept
status: developing
tags: [multi-agent, orchestration, ai-coding, parallelism, decomposition]
created: 2026-04-17
updated: 2026-05-19
---

# Multi-Agent Orchestration

Arquitetura onde um agente orquestrador decompõe tarefas complexas em subtarefas menores e verificáveis, delegando cada uma a subagentes especializados com contexto mínimo necessário.

## Motivação: o Single-Agent Ceiling

Qualquer projeto que passa de um toy demo atinge o teto do agente único:
- Contexto incha com tool calls, histórico, resultados
- Qualidade despenca com mais objetivos simultâneos
- Tokens se esgotam; compaction perde informação crítica

Pesquisa quantifica: instruction-following accuracy cai de 92% (200 tokens) para 60% (4.000 tokens de instruções).

## Componentes Fundamentais

**Orquestrador (Head Chef)**
- Recebe o pedido do humano
- Decompõe em tickets verificáveis
- Única ferramenta: `delegate_task`
- Não lê/escreve arquivos diretamente
- Vê apenas resumos dos outputs dos subagentes

**Subagentes (Line Cooks)**
- Recebem um ticket com contexto mínimo
- Têm janela de contexto fresca (sem histórico)
- Podem usar tools, MCPs, etc.
- Retornam summary ao orquestrador

## Benefícios

| Dimensão | Single-Agent | Multi-Agent |
|----------|-------------|-------------|
| Context window efetiva | ~200K | 25M+ |
| Intervenções manuais | baseline | -84.3% |
| Velocidade em paralelo | 1x | ~5x |
| Qualidade por tarefa | degradada | focalizada |

## 5 Padrões

1. **Prep Line** — brigade paralela para variações/exploração
2. **Dinner Rush** — swarm simultâneo para componentes independentes
3. **Courses in Sequence** — fases paralelas com dependência entre fases
4. **Prep-to-Plate** — pipeline sequencial com handoff limpo
5. **Gordon Ramsay** — builder separado de verifiers (aplicar sempre)

## Context Engineering vs. Iteração

São **substitutos**, não complementos:
- **Contexto largo + iteração**: agente vê tudo, first pass fraco, loop corrige. Lento.
- **Contexto focado + single pass**: agente vê apenas o necessário, first pass confiável, sem loop. Rápido.

Sully.ai: latência p50 de 37s → 7.5s eliminando loop de correção com decomposição.

## Regras Práticas

- Estado vive em arquivos e task queues, NÃO em conversation history
- Cada fase recebe apenas o contexto relevante ao seu ticket
- Tarefas com shared files precisam de padrão sequencial (evitar conflitos)
- Adicionar verificação é praticamente gratuito com modelos rápidos

## Ver também

- [[context-engineering]]
- [[claude-agent-harness-architecture]]
- [[resolver-pattern]]
- [[agent-memory-architecture]]
- [[03-RESOURCES/concepts/pkm-obsidian/file-as-bus]] — mecanismo de state continuity para long-horizon (AiScientist)
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]] — thin control over thick state; Agent-as-Tool pattern

## Relação com Multi-Principal

[[03-RESOURCES/concepts/agent-systems/multi-principal-agent]] é um problema diferente mas relacionado: enquanto Multi-Agent Orchestration trata de **múltiplos agentes** coordenados por um orquestrador para executar tarefas, Multi-Principal trata de **um único agente** servindo múltiplos usuários com objetivos conflitantes. Em produção, os dois co-existem: o orquestrador pode ser o agente central que medeia entre principals.

## Escala Extrema: Kimi K2.6

[[03-RESOURCES/entities/Kimi-K2.6]] (Moonshot AI) demonstra o estado da arte em escala multi-agent (abr/2026):
- **300 sub-agentes paralelos** em execução simultânea
- **4.000+ tool calls** por sessão
- **12–13 horas** de horizonte autônomo
- Output: revisões de literatura de 104 páginas em sessão única

Arquitetura swarm (distribuída) vs hierárquica — coordenação sem orchestrator central.

## Subagentes Especializados: VoltAgent Library

[[03-RESOURCES/entities/VoltAgent]] (`awesome-claude-code-subagents`) disponibiliza 131+ agentes prontos para uso em Claude Code (2026-05-14). Cada agente é um markdown file com papel, skill set e comportamento definidos. Cobrem: Core Dev, Infrastructure/DevOps, Security, Meta-orchestration.

Deploy por escopo:
- `.claude/agents/` — projeto-local
- `~/.claude/agents/` — global

Ver [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]] para como documentar o repositório para esses agentes.

## Internalização de Debate Multi-Agente

[[03-RESOURCES/concepts/agent-systems/internalized-multi-agent-debate]] (IMAD) oferece uma abordagem alternativa: em vez de orquestrar múltiplos agentes em runtime, o processo de debate é destilado em um único LLM via SFT+GRPO. Resultado: 6–21% dos tokens do debate explícito com performance comparável. O modelo internaliza múltiplas perspectivas na latent space, criando agent subspaces identificáveis via [[03-RESOURCES/concepts/llm-ml-foundations/activation-steering]].

## Camada de Coordenação como Objeto Analítico

Nechepurenko & Shuvalov (2026) propõem tratar a coordenação como uma **camada arquitetural separável** — não só como escolha de engenharia mas como substrate para previsões falsificáveis de failure modes. Ver [[03-RESOURCES/concepts/agent-systems/coordination-layer-llm]]. Achado empírico (n=100 Polymarket markets): orchestrator-specialist e peer-critique-debate são **Pareto-dominados** por ensemble independente e pipeline sequencial em custo-qualidade. Ver [[03-RESOURCES/sources/ai-agents-harness/coordination-architectural-layer-multi-agent-prediction-markets]].

## Plataformas Unificadas

[[03-RESOURCES/concepts/agent-systems/agent-platform-architecture]] (Ashpreet Bedi / Agno, 2026) consolida os padrões acima em um OS de agentes: runtime, storage, connectors, interfaces e scheduler em stack único. Os modos Coordinate / Route / Broadcast mapeiam diretamente sobre os padrões de orquestração aqui. Ver [[03-RESOURCES/sources/guides-courses-howtos/how-to-build-an-agent-platform]].

## RL Conductor: Aprendendo Estratégias de Orquestração via RL

[[03-RESOURCES/concepts/agent-systems/rl-conductor-orchestration]] (Sakana AI, 2026) elimina o design manual ao treinar um modelo 7B via GRPO para descobrir topologias de coordenação end-to-end. Resultado: supera todos os workers individuais (GPT-5, Gemini 2.5 Pro, Claude Sonnet 4) e baselines multi-agente manuais com ~6x menos tokens. Comportamentos emergentes: decomposição de problemas, engenharia de prompts por worker, rounds de verificação, roteamento por papel (planejador/escritor/verificador). Extensão: topologias recursivas criam novo eixo de test-time scaling. Ver [[03-RESOURCES/sources/ml-research-papers/conductor-rl-orchestration-sakana]].

## Caso de Estudo: Coordenador/Roster em Claude Managed Agents

[[03-RESOURCES/sources/multiagent-sessions]] documenta como a Anthropic implementa orquestração multiagente como **infraestrutura de produto** (beta `managed-agents-2026-04-01`), com limites operacionais explícitos e concretos:

- Coordenador delega a um **roster de até 20 agentes únicos**, cada um rodando em sua própria **session thread** isolada por contexto (mas compartilhando sandbox/filesystem/vault credentials)
- **Máximo de 25 threads concorrentes**; o coordenador pode invocar múltiplas cópias de um mesmo agent (`{"type": "self"}` para clonar a si mesmo)
- **Profundidade de delegação limitada a 1 nível** — depth > 1 é ignorada, restrição deliberada que contrasta com o padrão "Hierarchical delegation" listado em [[03-RESOURCES/concepts/agent-orchestration]] (ver nota de contradição/limitação naquela fonte)
- Roster é **snapshotado** na criação/atualização do coordenador — agentes referenciados ficam fixados em versões pinadas, não recebem updates automaticamente
- Padrões recomendados pela doc: **Parallelization** (fan-out de subtarefas independentes), **Specialization** (roteamento por domínio/system prompt), **Escalation** (consultar agente mais capaz para subtarefas complexas) — mapeiam diretamente sobre os "5 Padrões" listados acima
- Observabilidade hierárquica: **primary thread** dá visão condensada de toda atividade; eventos bloqueantes (tool confirmation, custom tool results) são "cross-postados" ao thread primário com roteamento automático de respostas pelo servidor

Ver também [[03-RESOURCES/sources/define-outcomes]] para o padrão crítico-ator implementado como infraestrutura automática (grader com contexto isolado avaliando o trabalho do agente principal contra rubric).

## Casos de Produção: Dados Quantitativos (Anthropic 2026)

Evidências de escala real — não benchmarks, sistemas em produção:

| Empresa | Sistema | Métricas |
|---------|---------|---------|
| **Coinbase** | Customer support agentico ($226B/trimestre em volume) | Milhares msgs/hora, **99.99% availability**, 35–50 internal AI apps |
| **Tines** | Security/IT workflow orchestration | **100x time-to-value**; multi-step ops → single-agent |
| **Gradient Labs** | Customer ops em financial services | **80–90% resolution rate** com intervenção humana limitada |
| **Intercom Fin** | AI agent (25k+ clientes) | **86% resolution rate**, 30min → segundos, 45 idiomas |
| **Assembled** | Assist platform | **+20% CSAT**, -50% escalations, +30% cases/hour |

Multi-agent outperforms single-agent by **90.2%** em tarefas com múltiplas direções simultâneas (Anthropic internal research).

Custo: multi-agent consome **10–15x mais tokens** que single. Do the math antes de escalar.

Ver [[03-RESOURCES/sources/building-effective-ai-agents-anthropic]] para tabela completa de cases.

## Evidências
- **[2026-06-19]** Cinco padrões de workflow da Anthropic (prompt chaining, routing, parallelization, orchestrator-workers, evaluator-optimizer) explicados como base para decidir workflow vs. agente dinâmico — [[how-to-build-ai-workflows-when-youre-tired-of-optimizing-prompts]]
- **[2026-06-19]** Pipeline Scout→Analyst→Briefer com perfis isolados (próprio SOUL.md/modelo/memória/skills) coordenados só por um diretório compartilhado evita poluição de contexto e degradação por responsabilidade acumulada — [[hermes-agent-notebooklm-obsidian-3-agent-research-department]]

- **[2026-06-19]** Swarm de 300 sub-agentes Kimi K2.6 decompõe automaticamente a tarefa sem grafo definido pelo usuário, com Opus 4.8 como gate único de verificação — [[03-RESOURCES/sources/self-improving-loop-300-agent-swarm-kimi]]
- **[2026-06-21]** A maioria dos usuários raspa a superfície do Hermes Agent usando-o como chatbot; o valor real está em 12 casos de uso de alto ROI que tratam o agente como funcionário autônomo — desde caça de empregos até coordenação multi-agente — sempr... — [[hermes-agent-12-high-roi-use-cases]]
- **[2026-06-21]** RL multi-turn multi-task em agentes LLM trava em infraestrutura não-escalável e algoritmos instáveis. AgentRL (Tsinghua/Z.AI) resolve com pipeline geração-treino totalmente assíncrono, API unificada baseada em function-call, ambientes co... — [[agentrl-scaling-agentic-reinforcement-learning-with-a-multi-turn-multi-task-fram]]
- **[2026-06-21]** Coletânea crowdsourced de features pouco conhecidas do Hermes Agent (Nous Research): handoff cross-plataforma de sessão, resume de sessão CLI, mecânica interna de compressão de contexto, conexão a browser local via CDP, e API REST própri... — [[hidden-features-in-hermes-you-should-know-about]]
- **[2026-06-21]** A maioria dos times de agentes adota um harness monolítico (LangChain, CrewAI, AutoGen etc.) em vez de compor um — e isso é o motivo pelo qual todo time de agente de longa duração acaba reescrevendo o harness do zero. O harness não é uma... — [[how-to-build-your-own-agent-harness]]
- **[2026-06-21]** Hermes deixa de ser um chat para se tornar um "worker que você roda" (não uma janela que você abre) quando ganha memória persistente, playbooks ensinados, jobs agendados e a capacidade de gerenciar outros agentes abaixo dele — o artigo d... — [[how-we-turned-hermes-from-an-assistant-into-our-chief-of-staff-and-how-you-can-t]]
- **[2026-06-21]** A maioria trata MCPs como forma elegante de deixar o Claude ler dados — perde o ponto. O valor real é Claude operar a stack de vendas inteira (sourcing, enriquecimento, CRM, outreach) a partir de um prompt. A pergunta central para avalia... — [[mcps-for-lead-generation-the-operator-s-cheat-sheet-2026]]
- **[2026-06-21]** O ponto de leverage mudou de "escrever o melhor prompt" para "desenhar o melhor loop" — roteiro de 14 passos para sair de prompter manual (escreve→espera→revisa→escreve de novo) para designer de sistemas autônomos que encontram trabalho,... — [[prompting-is-dead-loop-engineering-is-eating-software-development]]
- **[2026-06-21]** Swarms grandes de agentes (300 agentes) sozinhos não resolvem confiabilidade — volume escala output e erro na mesma taxa ("mais mãos, mais erros"). A solução é tornar verificação um estágio de primeira classe num loop fechado: Opus 4.8 p... — [[the-self-verifying-loop-300-agents-4-000-steps-5-live-data-feeds-on-autopilot-wi]]
- **[2026-06-21]** Split maker/checker (um agente escreve, outro mais forte avalia) é o conselho padrão de loop engineering — mas o verificador não é um árbitro neutro: dentro do loop, ele É o objetivo, e um agente não tenta satisfazer um objetivo, tenta v... — [[your-agent-is-trying-to-beat-the-verifier-not-the-task]]

## Perspectivas

- **[2026-06-21]** MCPs com dados ao vivo conectados a agentes especializados (não um agente generalista) é o padrão recorrente nos casos de alto ROI — orquestração vence monolito. — [[hermes-agent-12-high-roi-use-cases]]

## Fontes

- [[03-RESOURCES/sources/building-effective-ai-agents-anthropic]] — enterprise cases + framework decisão (Anthropic, 2026)
- [[03-RESOURCES/sources/ai-agents-harness/single-agent-ai-coding-nightmare]]
- [[03-RESOURCES/sources/ai-agents-harness/llm-pipeline-slow-agents-do-too-much]]
- [[03-RESOURCES/sources/ai-agents-harness/multi-user-llm-agents]]
- [[03-RESOURCES/sources/ml-research-papers/toward-autonomous-long-horizon-engineering-ml-research]] — evidência empírica: durable state continuity é o bottleneck principal em long-horizon ML research engineering
- [[03-RESOURCES/sources/ml-research-papers/automated-weak-to-strong-researcher]] — 9 Claude Opus 4.6 AARs paralelos alcançam PGR 0.97 vs. PGR 0.23 humano
- `Clippings/How Kimi K2.6 Deploys 300 Sub Agents...` — benchmark de escala extrema (300 agents, 4K tool calls)
