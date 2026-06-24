---
title: "4 alavancas para um agente de IA 10x mais barato"
type: source
source: "Clippings/4 alavancas para um agente de IA 10x mais barato.md"
original_url: "https://x.com/nett0eth/status/2060480665922019589"
author: "@nett0eth"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, token-economy, prompt-caching, cost-optimization, advisor-pattern]
---

## Tese central

A maioria dos custos excessivos de agentes em produção não vem do modelo em si, mas da forma como ele é usado. No workshop "Getting more out of the Claude Platform" (Anthropic), um agente real teve seu custo reduzido a ~1/3 ao vivo, sem alterar o que entrega, usando apenas 4 ajustes de engenharia — chegando a 10x de redução combinando todos.

## Argumentos principais

1. **Prompt caching** — o ajuste de maior retorno pelo menor esforço (1 linha de código). O modelo guarda conteúdo estável na memória por 5 minutos; chamadas seguintes pagam 10% do preço normal (90% de desconto). Tokens em cache não contam para o limite de requisições — se 80% dos tokens vierem do cache, o limite efetivo aumenta 5x. A resposta também começa mais rápido.
2. **Tool search** — em vez de passar a descrição de todas as ferramentas em todas as chamadas, expor uma única ferramenta `busca_de_ferramentas`. Claude chama quando precisa, recebe só o que é relevante. A Lovable cortou 10% do consumo de tokens e o modelo passou a responder melhor (contexto mais limpo).
3. **Chamada programática** — não jogar dados brutos no modelo. Pedir ao Claude que escreva um script pequeno para pré-processar os dados antes. Uma transcrição de 1h no Gong tem 50K tokens — o script filtra e devolve apenas o resumo. A Quora usou a mesma lógica para limpar HTML pesado. Compactação automática de contexto (Hex) sustenta tarefas autônomas longas.
4. **Advisor strategy** — usar o modelo caro (Opus) apenas quando o modelo barato (Sonnet) identifica decisão de alto risco ou resultado incerto. Como um dev júnior consultando o sênior só em arquitetura ou risco. No demo: executor = Sonnet 4.6, advisor = Opus 4.7. A Bolt usa essa arquitetura para decisões de design de software.

## Key insights

- O erro mais destrutivo para o cache: colocar data/hora dentro do system prompt — invalida o cache inteiro a cada segundo. Conteúdo variável deve ir no final, depois do conteúdo estável.
- Threshold mínimo para cache funcionar: 1.024 tokens no Sonnet; 4.096 tokens no Opus e Haiku.
- Taxa de acerto de cache dos melhores players: Claude Code 97%, Cursor 94%, Replit 93%, Perplexity 90%. O agente demo estava em 0% antes da otimização; chegou a 58% e o custo caiu pela metade só com isso.
- Tokens em cache não contam para rate limits — implicação frequentemente ignorada para capacidade efetiva.
- O paradigma correto: "não precisar de mais inteligência, precisar de melhor engenharia."
- A ordem de prioridade para quem começa do zero: (1) caching, (2) verificar taxa de acerto no console, (3) tool search, (4) chamadas programáticas, (5) advisor strategy.

## Exemplos e evidências

- Agente demo no workshop: custo reduzido para ~1/3 ao vivo em 4 etapas
- Taxa de cache zero → 58% apenas ativando cache automático → custo caiu pela metade
- Lovable: -10% de consumo de tokens com tool search + melhor qualidade de resposta
- Gong: transcrições de 1h = 50K tokens → evitáveis com chamada programática
- Bolt: usa advisor strategy para decisões de design de software em produção
- Hex: compactação automática de contexto para tarefas autônomas longas
- Combinando as 4 alavancas: potencial de 10x de redução de custo documentado no workshop

## Implicações para o vault

- Detalha implementação concreta do que o vault já tem como conceito em [[04-SYSTEM/wiki/hot]] sobre KV cache
- O padrão advisor strategy (Sonnet executor + Opus revisor) é uma arquitetura a documentar em conceitos de multi-agent
- A ordenação de prioridade (caching primeiro) é um guia acionável para qualquer agente novo no vault
- O número 97% de cache hit do Claude Code valida o design da hot.md para maximizar cache hits

## Links
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/concepts/agent-systems/token-economy]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-systems]]
- [[03-RESOURCES/entities/Claude]]
