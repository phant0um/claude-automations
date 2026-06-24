---
title: Multi-Model Orchestration
type: concept
status: developing
created: 2026-04-24
updated: 2026-04-24
tags: [ai-agents, orchestration, routing, multi-model, perplexity]
---

# Multi-Model Orchestration

Padrão de arquitetura onde um sistema AI **roteia cada subtarefa para o modelo mais adequado**, em vez de usar um único modelo para tudo.

## Princípio central

Nenhum modelo é bom em tudo. Roteamento por especialidade produz resultados melhores do que forçar um único modelo a fazer tudo.

## Implementação no Perplexity Computer

[[03-RESOURCES/entities/Perplexity-Computer]] usa 19 modelos com roteamento automático:

| Modelo | Especialidade |
|--------|---------------|
| Claude Opus 4.7 | Raciocínio core, decisões complexas, coordenação |
| GPT-5.2 | Long-context recall, web search, síntese de informação |
| Gemini | Pesquisa profunda de tópico |
| Grok | Operações rápidas, baixo overhead |
| Nano Banana (Google) | Geração de imagens |
| Veo 3.1 | Produção de vídeo |

**Exemplo:** Uma tarefa de coding pode usar Claude para decisões de arquitetura, GPT-5.2 para buscar documentação, e Grok para syntax checks — tudo no mesmo workflow, sem input do usuário.

## Distinção com Multi-Agent Orchestration

| Dimensão | Multi-Model Orchestration | [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] |
|---------|--------------------------|---------------------------------------------|
| Foco | Qual modelo executa cada subtarefa | Como agentes coordenam entre si |
| Granularidade | Por subtarefa dentro de uma task | Por responsabilidade/domínio entre agentes |
| Decisão | Automática pelo sistema | Pode ser explícita (orchestrator/subagent) |

Os dois padrões são complementares — um sistema como Perplexity Computer usa multi-model orchestration internamente enquanto também pode usar multi-agent orchestration (subagent spawning).

## Vantagem prática

Evita o "one-size-fits-all" problem: modelos com pontos fortes diferentes compensam fraquezas uns dos outros. O usuário não precisa decidir qual modelo usar — o sistema decide.

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/perplexity-computer-masterclass-beginners]] — Corey Ganim descreve os 19 modelos e o roteamento do Perplexity Computer
