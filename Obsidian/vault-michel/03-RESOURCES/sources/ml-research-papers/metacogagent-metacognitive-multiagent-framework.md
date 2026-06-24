---
title: "MetaCogAgent: A Metacognitive Multi-Agent LLM Framework with Self-Aware Task Delegation"
type: source
source: "Clippings/MetaCogAgent A Metacognitive Multi-Agent LLM Framework with Self-Aware Task Delegation.md"
author: "Chenyu Wang, Yang Shu (Zhejiang University)"
created: 2026-05-24
ingested: 2026-05-28
tags: [ai-agents, multi-agent, metacognition, delegation, source, ml-research]
url: "https://arxiv.org/html/2605.17292v1"
---

## Tese central

Sistemas multi-agente falham porque os agentes não sabem o que não sabem — "metacognitive blindness". MetaCogAgent equipa cada agente com uma Metacognitive Self-Assessment Unit (MCU) que avalia alinhamento tarefa-capacidade *antes* da execução, e delega automaticamente quando a confiança cai abaixo do threshold.

## Argumentos principais

1. **O problema central**: frameworks atuais (AutoGen, MetaGPT, CAMEL) atribuem tarefas por roles predefinidos sem checar se o agente tem competência para executar. Resultado: erros em cascata — agentes downstream constroem sobre outputs incorretos de upstream.
2. **Metacognição como solução**: humanos avaliam sua própria competência antes de agir e buscam ajuda quando necessário. Isso é exatamente o que LLMs não fazem por padrão.
3. **Duas fontes de confiança**: (a) Verbalized confidence — o agente verbaliza numericamente sua confiança para a tarefa específica; (b) Profile-based confidence — histórico de sucesso por dimensão cognitiva. Score final: `c = λ·cᵛ + (1-λ)·cᵖ`.
4. **Conflict detection de segunda ordem**: se cᵛ e cᵖ divergem muito (δ > 0.3), o sistema aperta o threshold de delegação — capturando incerteza sobre a própria auto-avaliação.

## Key insights

- **Metacognitive Unit (MCU)**: cada agente carrega um Capability Profile P[i] = [p_i,1, ..., p_i,D] — taxa de sucesso histórica por dimensão cognitiva (raciocínio, retrieval, código, matemática, commonsense).
- **Adaptive delegation protocol**: quando c < θ', agente transmite tarefa para todos os peers, que calculam sua própria confiança; ganhador executa. Se nenhum agente ultrapassa θ, fallback para Collaborative Mode (weighted vote por confiança).
- **Capability Boundary Learning**: EMA update após cada tarefa: `p^(t+1) = p^t + α(rₖ - p^t)`. Com α=0.1, horizonte efetivo ≈ 10 tarefas — desconta dados obsoletos automaticamente.
- **MetaCog-Eval benchmark**: 700 tarefas em 5 dimensões cognitivas + 100 cross-domain, anotadas com assignment ótimo. Gap de 8.7% sobre melhor baseline de routing (AutoGen) com 5% menos chamadas de API.
- **Eficiência real**: 1382 API calls vs 2100 do Majority-Vote, com acurácia +5.3%. O overhead de delegação (N-1 avaliações de confiança por tarefa delegada) compensa amplamente pelos ganhos.

## Exemplos e evidências

- MetaCogAgent: 82.4% accuracy vs Single-Agent 65.3%, AutoGen 73.7%, Majority-Vote 77.1%
- ECE = 0.087: agentes são bem calibrados — score de confiança prediz performance real
- Delegation precision = 0.841: 84.1% das tarefas delegadas vão para o agente que produz a resposta correta
- Hard tasks: MetaCogAgent -11.5% degradação Easy→Hard vs -18.5% Single-Agent, -17.5% AutoGen
- Cross-domain: +13% sobre AutoGen — justamente onde metacognição importa mais

## Implicações para o vault

- O MCU é um componente plug-in que poderia ser adicionado ao [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — mudança de roteamento estático para roteamento baseado em confiança.
- O Capability Profile P[i] é análogo ao conceito de [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]] — avaliação contínua de competência por domínio.
- **Relevância prática para o vault**: o [[04-SYSTEM/AGENTS]] do vault usa designação de role fixa (Nexus, Guard, Hill, etc). MetaCogAgent sugere benefício de auto-avaliação de confiança antes de executar — especialmente para tarefas cross-domain.
- O "segundo-order self-doubt" (conflict detection) é um padrão interessante para implementar em agentes do vault que lidam com domínios heterogêneos.

## Links

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — orquestração multi-agente
- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]] — framework de avaliação de agentes
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]] — delegação hierárquica
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]] — roteamento de modelos/agentes
- [[03-RESOURCES/concepts/agent-systems/coordination-layer-llm]] — camada de coordenação
