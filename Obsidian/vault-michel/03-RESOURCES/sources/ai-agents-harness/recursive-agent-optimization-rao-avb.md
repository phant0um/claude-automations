---
title: "Recursive Agent Optimization using RL (RAO) — Explained Clearly"
type: source
created: 2026-05-18
updated: 2026-05-18
tags: [ai-agents, reinforcement-learning, recursive-agents, subagents, rl-training]
source_url: "https://x.com/neural_avb/status/2056358393892540552"
author: "@neural_avb (AVB)"
published: 2026-05-08
category: ai-agents
triagem_score: 9
---

## Tese central

RAO (Recursive Agent Optimization) usa RL para treinar LLMs a decompor tarefas em subagentes recursivos dentro de um Python REPL, resolvendo o problema de credit assignment em hierarquias profundas com um sinal de recompensa local por nó.

## Key insights

1. **Arquitetura:** agente raiz gera uma árvore de execução; cada nó é uma instância de agente resolvendo uma subtarefa delegada. Subagentes podem criar sub-subagentes (profundidade ilimitada).
2. **Python REPL como backbone:** permite retornos de tipo irrestrito, composição com Python normal, execução concorrente via `asyncio.gather`, e gestão deliberada de contexto (output vai para variável Python, não direto ao contexto).
3. **Launch subagent como tool call:** `await async_launch_subagent(goal=..., ...)` — a política decide se delega, o que delegar, formato de saída, e como agregar resultados.
4. **Problema de credit assignment:** em RLVR padrão só a raiz recebe sinal. RAO usa LLM-judge (gpt-5-mini) para avaliar cada nó individualmente com recompensa local = sucesso próprio + bônus de delegação ponderado (fator 0.4) pelos filhos.
5. **Modelos treinados:** Qwen3-4B-Instruct (denso) e Qwen3-VL-30B-A3B-Instruct (MoE) — propositalmente pequenos para validar que a técnica é o diferencial, não o tamanho.
6. **Benchmarks usados:** TextCraft-Synth (Minecraft texto), Oolong-Real (D&D transcripts longos), DeepDive (multi-hop web research), ART-E (busca em emails).
7. **Controle:** mesmo setup mas sem `launch_subagent` — confirma que a recursão é o diferencial.

## Como o credit assignment funciona em detalhe

O problema de credit assignment em hierarquias profundas é o maior obstáculo para treinar agentes recursivos com RL. Em RLVR padrão, apenas a raiz recebe o sinal de recompensa — se a tarefa foi bem-sucedida, todos os nós da hierarquia recebem crédito igual independentemente da sua contribuição real. Se a raiz falhou, nós filhos que executaram bem são penalizados injustamente.

### A solução RAO: recompensa local por nó

Cada nó $i$ recebe uma recompensa local calculada como:

```
R_local(i) = sucesso_próprio + 0.4 × média(sucessos dos filhos)
```

O fator 0.4 para filhos calibra o incentivo de delegação: delegar é bom (o agente que delega bem recebe bônus), mas não ao ponto de o nó não precisar ser competente por si só. O LLM-judge (gpt-5-mini) avalia cada nó individualmente — não apenas o output final da raiz.

### Por que Python REPL como backbone

A escolha do Python REPL não é arbitrária. Ela oferece quatro propriedades críticas que um ambiente de execução de agentes recursivos precisa:

1. **Retornos de tipo irrestrito:** um subagente pode retornar um DataFrame, uma string, um dicionário, uma imagem — qualquer objeto Python. Isso é impossível com tool calls JSON convencionais.
2. **Composição natural:** Python permite que o agente faça `resultado = await async_launch_subagent(...) + outro_resultado` — composição direta de resultados sem parsear JSON.
3. **Concorrência via asyncio:** `asyncio.gather(subagent_a(), subagent_b())` paraleliza subagentes nativamente.
4. **Gestão deliberada de contexto:** o output do subagente vai para uma variável Python, não automaticamente para o contexto do agente pai. O agente decide o que extrair e injetar.

## Os benchmarks em detalhe

### TextCraft-Synth (Minecraft texto)
Tarefas de construção hierárquica: "faça uma espada de ferro" requer minerar ferro, fazer lingotes, fazer espada — hierarquia natural de subtarefas. Ideal para testar se o agente aprende a decompor.

### Oolong-Real (D&D transcripts longos)
Documentos muito longos que precisam de análise em múltiplos níveis — entender o que aconteceu em cada sessão, depois entender padrões entre sessões, depois responder perguntas sobre o arco global da campanha. Testa se a recursão ajuda quando o contexto é maior do que qualquer janela individual.

### DeepDive (multi-hop web research)
Perguntas que requerem encontrar informação A, que leva a B, que leva a C — sem saber de antemão o caminho. Testa planejamento dinâmico de busca.

### ART-E (busca em emails)
Encontrar e relacionar informações em grandes volumes de email. Testa filtragem hierárquica de informação não estruturada.

## Por que modelos pequenos (Qwen3-4B, 30B)

A escolha deliberada de modelos pequenos para validação é metodologicamente importante: demonstra que RAO é uma técnica de treino, não um efeito de escala. Se RAO só funcionasse com modelos de 100B+, seria difícil separar o contributo da técnica do contributo do tamanho. Com Qwen3-4B funcionando, a evidência de que a recursão treinada por RL é o diferencial é mais limpa.

## Controle experimental: sem `launch_subagent`

O grupo de controle usa o mesmo setup (mesmo ambiente, mesmo modelo, mesmo treino RLVR) mas sem a tool `launch_subagent` disponível. O agente precisa resolver tudo sem delegar. A diferença de performance entre os dois grupos é atribuível exclusivamente à capacidade de delegação recursiva — não ao modelo, não ao ambiente, não ao algoritmo de RL.

## Limitações e open questions

- **Profundidade ótima:** não está claro qual profundidade de recursão é ótima para diferentes tipos de tarefa. Recursão muito profunda pode gerar overhead de comunicação maior que o benefício de especialização.
- **Loop de LLM-judge:** usar gpt-5-mini para avaliar nós individuais é custoso durante o treino. Em produção, seria necessário um verifier mais barato ou um verifier treinado especificamente para a tarefa.
- **Generalização:** os benchmarks são específicos. Não está demonstrado que agentes treinados com RAO em TextCraft generalizam para domínios não-sintéticos de forma diferente de agentes padrão.

## Links

- Thread: https://x.com/neural_avb/status/2056358393892540552
- Relacionado: [[03-RESOURCES/concepts/agent-systems/agentic-rl]], [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]], [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]
