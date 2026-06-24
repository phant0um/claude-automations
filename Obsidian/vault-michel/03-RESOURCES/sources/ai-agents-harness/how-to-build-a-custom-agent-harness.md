---
title: "How to Build a Custom Agent Harness"
type: source
source: "Clippings/How to Build a Custom Agent Harness.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Construir agentes úteis é fundamentalmente uma questão de customização: conectar o agente ao contexto, dados e ambientes corretos para a tarefa. A equação `agent = model + harness` implica que o harness (o scaffolding ao redor do modelo) é onde a maioria do valor é criado — e o padrão de middleware é o mecanismo correto para customizá-lo sem acoplamento.

## Argumentos principais

- **A definição de agente**: modelo chamando tools num loop até completar uma tarefa e retornar resultado. Definição estendida: `agent = model + harness`.
- **O harness é o scaffolding que conecta o modelo ao mundo real**: seu trabalho é fornecer o contexto certo ao modelo em cada step. "An agent is only as good as the context provided to the model" e "The job of a harness is to provide context to the model at every step."
- **`create_agent` da LangChain**: primitiva minimalist para construir um harness. Recebe model, tools, system_prompt. Filosofia similar à do Pi (altamente configurável) — implementa apenas o core agent loop e expõe middleware como primitiva de customização. Contrasta com harnesses opinionated como Deep Agents e Claude Agent SDK que vêm pré-montados.
- **Middleware: como você customiza o harness**:
  - Hookeia no agent loop em cada step: antes/depois de model calls, antes/depois de tool calls, no startup e teardown.
  - Cada peça lida com uma preocupação e compõe livremente com qualquer outra.
  - Quatro alavancas de capability:
    1. **Deterministic Logic**: business logic, policy enforcement, controle dinâmico do agente — swapping de modelo por complexidade de tarefa, ajuste de prompt, atualização do message history (durante compaction). Qualquer coisa que não pode ou não deve viver em um prompt.
    2. **Tools**: middleware pode gerenciar o ciclo de vida completo de tools (setup, teardown, registration) — relevante quando tools têm dependências, requerem inicialização, ou precisam ser desmontadas corretamente. Mantém configuração de tool próxima à lógica que a governa.
    3. **Custom state**: middleware pode estender o estado do agente com propriedades customizadas para rastrear estado através de hooks (contadores, flags, valores que persistem durante runs).
    4. **Stream handlers**: interceptar e transformar o output stream do agente — filtrar eventos, injetar metadata, rotear diferentes event types para diferentes consumidores (UI consumindo token deltas, audit log capturando tool calls, sistema de monitoring rastreando latência).
- **Por que middleware funciona**: (1) habilita customização em qualquer ponto do loop; (2) agrupa lógica relacionada em unidades composable e compartilháveis. O mesmo middleware pode ser reutilizado em todos os agentes de uma organização — novos agentes herdam comportamento battle-tested sem rebuild.
- **Task-harness fit**: quão bem o harness se encaixa nas demandas reais da tarefa — o contexto que precisa, as falhas que vai encontrar, as políticas que deve enforçar, o ambiente em que opera. Um harness para customer service é muito diferente de um para coding agent long-running.
- **Harness capabilities mapeadas para middleware**: capabilities comuns (memória, context management, sandboxing, compaction, guardrails, logging, permissões) mapeadas para middleware específico que as suporta. Agentes de produção normalmente usam vários juntos.

## Key insights

- **A equação `agent = model + harness` é mais do que metáfora**: implica que dois sistemas com o mesmo modelo mas harnesses diferentes são agentes fundamentalmente diferentes, com performance radicalmente diferente (consistente com Harness-Bench e "Stop Comparing Without Disclosing the Harness").
- **Middleware como unidade de organização de código**: ao invés de lógica de negócio espalhada no agente, cada preocupação vira uma peça de middleware isolada — composta, testada e reutilizada independentemente.
- **Lifecycle management de tools via middleware**: não registrar tools diretamente no agente, mas gerenciar setup/teardown/registration via middleware quando tools têm dependências ou requerem inicialização. Mantém a configuração próxima da lógica que a governa.
- **Stream handlers como ponto de integração com infraestrutura**: UI, audit log, monitoring system — cada um consome different event types da mesma execução via stream handlers no middleware.
- **Os melhores agentes não são apenas construídos com modelos capazes — são construídos com harnesses que se encaixam na tarefa**: a LangChain construiu GTM agent, async coding agent (open-swe), e no-code agent builder todos com `create_agent` + middleware stack customizado para a missão.
- **Contraste entre harnesses opinionated e minimalists**: Deep Agents/Claude Agent SDK = opinionated, pre-assembled, rápido para chegar a produção, limitado em customização fina. `create_agent` = minimalist, expõe middleware, para casos que precisam de business logic, guardrails, ou prompting customizado que harnesses opinionated não suportam.

## Exemplos e evidências

- **LangChain create_agent**: `create_agent(model="anthropic:claude-sonnet-4-6", tools=tools, system_prompt="...")` como primitiva base.
- **Casos de uso LangChain internos**: GTM agent, asynchronous coding agent (open-swe no GitHub), no-code agent builder (LangSmith Fleet) — todos construídos com create_agent + middleware stack customizado.
- **Referência ao Pi**: "highly configurable coding agent harness" com filosofia similar.
- **Deep Agents e Claude Agent SDK**: citados como exemplo de harnesses opinionated com middleware pré-montado.
- **Tabela de harness capabilities**: contexto, compaction, memoria, sandboxing, permissões, logging/tracing, guardrails, routing de modelo — mapeadas para middleware específico.

## Implicações para o vault

- A equação `agent = model + harness` é um framework mental útil para analisar os agentes do vault-michel — cada agente em `04-SYSTEM/agents/` tem implicitamente um harness (o scaffolding no CLAUDE.md, skills, hooks).
- O conceito de middleware como unidade de organização é análogo ao sistema de skills do vault-michel — cada skill é uma peça de middleware que hookeia no agent loop em momentos específicos.
- O insight sobre lifecycle management de tools via middleware é relevante para o design de MCPs no vault.
- Task-harness fit como conceito: o vault-michel deveria avaliar se os harnesses dos agentes atuais se encaixam bem nas tarefas que executam — especialmente agentes de ingestão vs. agentes de pesquisa vs. agentes de escrita.
- Complementa e é complementado por [[03-RESOURCES/sources/stop-asking-whether-the-agent-worked-ask-what-the-harness-observed]].

## Links

- [[03-RESOURCES/concepts/ai-agents/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/ai-agents/agent-skills]]
- [[03-RESOURCES/sources/stop-asking-whether-the-agent-worked-ask-what-the-harness-observed]]
- [[03-RESOURCES/sources/how-to-make-agentic-workflows-100x-cheaper-full-guide]]
- [[04-SYSTEM/agents]]
