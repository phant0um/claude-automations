---
title: "9 Agentic Patterns, Simply Explained"
type: source
source: "Clippings/9 Agentic Patterns, Simply Explained.md"
author: "[[Neo Kim]]"
published: 2026-04-22
created: 2026-05-23
ingested: 2026-05-23
tags: [ai-agents, clippings, agentic-patterns, system-design]
---

## Tese central

Padrões agênticos são decisões de arquitetura sobre quanto controle dar ao modelo. Workflow patterns = código controla cada etapa; Agent patterns = LLM decide o que fazer a seguir. A primeira pergunta não é qual padrão usar — é se você precisa de algum.

## Argumentos principais

- **Escalada de controle**: spectrum de "seu código controla tudo" até "LLM define próximos passos". Cada ponto no spectrum tem tradeoffs específicos de previsibilidade vs flexibilidade.
- **Workflow patterns primeiro**: a maioria dos sistemas de produção não precisa ir além de paralelização. Agent patterns introduzem failure modes imprevisíveis.
- **Decisão de controle ≠ decisão de tecnologia**: LLM pode participar de sistema altamente controlado (prompt chaining) ou altamente autônomo (reflexion, multi-agent).
- **Custo escalona com autonomia**: chaining e routing são baratos e previsíveis; orchestrator-workers introduz falhas que você não consegue prever upfront.

## Key insights — 9 padrões

### Workflow Patterns (código controla o fluxo)
1. **Prompt Chaining** — outputs viram inputs de próximo passo. Previsível. Bom para tarefas sequenciais bem definidas.
2. **Routing** — LLM classifica input e direciona para handler especializado. Barato. Use quando há subcategorias distintas.
3. **Parallelization** — múltiplos subproblemas simultâneos. Economiza tempo, custa mais tokens. Só quando subproblemas são independentes.
4. **Orchestrator-Workers** — orchestrator decompõe problema, workers executam. LLM controla decomposição; você não sabe os passos upfront. Introduz failure modes imprevisíveis.

### Agent Patterns (LLM controla o fluxo)
5. **Reflection** — LLM gera, revisa seu próprio output, corrige. Melhora qualidade mas adiciona latência. Bom para tarefas onde qualidade > velocidade.
6. **Tool Use** — LLM chama ferramentas (APIs, search, calculadora) e usa resultados. Fundamento de agentes práticos. Requer constraint nos tools disponíveis.
7. **Planning** — LLM cria plano antes de executar. Bom para tarefas longas com múltiplos steps. Plano pode ficar obsoleto conforme execução progride.
8. **Multi-agent Collaboration** — múltiplos agentes com roles diferentes. Poderoso mas difícil de debugar. Falhas se propagam entre agentes.
9. **Autonomous Agent** — LLM decide não só o quê mas como e quando agir, com acesso a memória de longo prazo. Máxima autonomia; máximo risco.

## Exemplos e evidências

- **Pattern adequado ao problema**: customer support → routing + tool use. Pesquisa profunda → planning + reflection. Tarefa desconhecida → orchestrator-workers.
- **Quando não usar agents**: se você consegue mapear os steps upfront, use workflow. Agents = overhead sem ganho para problemas bem definidos.
- Artigo é teaser; subscriber-only tem arquitetura de sistemas reais (Netflix, Uber, Spotify implicados).

## Implicações para o vault

- Define framework completo que organiza os source pages existentes em [[03-RESOURCES/sources/ai-agents-harness/]]
- Complementa [[03-RESOURCES/sources/ai-agents-harness/clipping-multi-agent-architectures-explained]] com foco em spectrum, não só multi-agent
- Conecta com [[03-RESOURCES/sources/ai-agents-harness/clipping-29-llm-eval-concepts]] — cada padrão tem diferentes desafios de eval

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/entities/Neo Kim]]
