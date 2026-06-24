---
title: "A simple framework to build Agentic Systems that just works"
type: source
source: "Clippings/A simple framework to build Agentic Systems that just works.md"
original_url: "https://x.com/neural_avb/status/2027721962479288566"
author: "@neural_avb"
published: 2026-02-28
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, harness, framework, context-management, system-prompt, subagents]
---

## Tese central

Construir sistemas agênticos não é puramente arte nem puramente ciência — é os dois. O problema com tratar como arte pura é deixar de lado melhores práticas empiricamente provadas. O framework central é simples: **"coloque-se no lugar do agente"**. A partir disso, tudo — system prompt, carregamento de contexto, action space, delegação e persistência — pode ser desenhado de forma racional.

## Argumentos principais

1. **System Prompt** — definir: (a) quais observações o agente receberá, (b) qual é o resultado esperado para conclusão bem-sucedida, (c) quais ferramentas externas estão disponíveis. Também incluir: role assignment, guardrails, formato de output, few-shot examples.
2. **Lazy Loading Context** — assim como humanos constroem contexto peça por peça em uma tarefa de longo prazo, agentes operam melhor quando carregam informação quando precisam, não quando tudo é despejado de uma vez. O agente tem acesso a um índice curto (como sumário de livro); busca detalhes quando necessário. Deixar agentes ler informação quando precisam é melhor política do que alimentá-los com tudo de uma vez.
3. **Action Space** — coleção de tudo que o agente pode fazer. Minimalismo é o objetivo. Humanos sofrem de paralisia de decisão com opções demais; agentes também. Nomear corretamente as ferramentas, descrevê-las corretamente, adicionar exemplos no system prompt sobre quando chamá-las. Se o agente não sabe quando chamar qual ferramenta, é sinal de "demência agêntica" — simplificar.
4. **Delegação** — subagentes são ideais quando: (a) o agente principal faz workloads diversos e não relacionados, (b) as ferramentas retornam outputs muito longos para destilar, (c) as tarefas são muito longas, (d) as tarefas podem rodar em paralelo. O paralelismo e a limpeza do contexto raiz são os dois benefícios principais.
5. **Persistência** — o ponto em que o framework "colocar-se no lugar do agente" quebra um pouco, pois LLMs são transacionais. Tipos de persistência: chat history para chatbots, sistema de memória para info de usuários passados, logs de entidades para info persistente sobre objetos específicos, scratchpad compartilhado para equipes de agentes, todo list para tarefas longas.

## Key insights

- "Demência agêntica": se o agente se confunde sobre quando chamar qual ferramenta, o problema é complexidade excessiva no action space, não a capacidade do modelo.
- LLMs são "grupos de pessoas transacionais" — você passa texto, eles geram texto, contexto gerenciado externamente. Colocar-se no lugar deles exige entender que eles não têm memória automática.
- Compactação de contexto — comprimir memórias quando excedem certo comprimento — é uma prática essencial para agentes de longa duração.
- KV Cache: para melhor performance e custo menor, manter o prefixo dos prompts o mais estático possível; conteúdo estático no começo; não atualizar respostas antigas; a lista de mensagens user-assistant deve permanecer intacta.
- Tool calls e reasoning steps antigos devem fazer parte do contexto para evitar que o agente repita trabalho anterior.
- A ciência agêntica exige: (1) logar traces do que os agentes fazem, (2) harness para replay de prompts anteriores com recompensas numéricas, (3) experimentar com hiperparâmetros para encontrar o que supera o sistema atual.
- Framework do classical AI já tinha isso: contracts de software (o que o sistema precisa, quais ferramentas tem, o que deve outputar), PEAS (Performance Measure, Environment, Actuators, Sensors), MDP/POMDP de RL.
- LLMs são treinados com tantos dados humanos que condicionar dados gerados por IA em vieses humanos quase sempre é boa ideia — por isso parece arte.

## Exemplos e evidências

- Analogia do carro: se pedido para construir um carro do zero em 1 ano, humano lazily carrega novo contexto peça por peça, focado na tarefa, evitando distrações.
- Agente de coding pode ter milhares de skills instaladas mas não as carrega todas de uma vez — usa um índice curto e busca quando necessário.
- `search("attention")` → retornou 250 parágrafos e 1M tokens → caso claro para subagente.
- Analogia do time de engenharia: dev júnior resolve maioria das tarefas; consulta sênior para problemas arquiteturais ou arriscados.

## Implicações para o vault

- Formaliza o framework "coloque-se no lugar do agente" como método de diagnóstico — útil para o vault quando debugging agentes com comportamento estranho
- A tipologia de persistência (chat history / memory system / entity logs / scratchpad / todo list) é um mapa útil para decisões de arquitetura no vault
- O conceito de "demência agêntica" é um nome útil para o problema de action space excessivo
- Confirma a importância de KV Cache e prefixo estático — alinha com práticas já no vault

## Links
- [[03-RESOURCES/concepts/agent-systems/agentic-harness]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-systems]]
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
