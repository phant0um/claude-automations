---
title: "Introducing Engram: Scaling compute on your context"
type: source
source: "Clippings/Introducing Engram Scaling compute on your context.md"
created: 2026-06-23
updated: 2026-06-23
score: A
tags: [ai-agents, source-page, engram, continual-learning, context-scaling, model-training, notion, harvey, microsoft, memory-architecture]
---

## Tese Central

Modelos de AI hoje não entendem o que você faz — tudo que sabem vem de training na internet pública. Mas o que você pensa todo dia é muito mais que isso. À medida que contextos crescem, modelos ficam mais caros e mais confusos. Engram propõe uma aposta fundamentalmente diferente: em vez de gastar compute massivo em dados públicos, partir de modelos pré-treinados fortes e gastar compute de training no contexto que importa para você. Cada modelo gasta o equivalente a centenas de anos estudando seu contexto: conectando pontos, achando erros, fazendo conexões nunca feitas.

## O Problema

- Modelos são treinados na internet pública — conhecem repos populares do GitHub e things em articles online
- Mas o que você pensa todo dia vai muito além disso: small details, big picture de como vida e trabalho se encaixam
- Ideias importantes se espalham por documentos e files espalhados
- Quando usa um modelo, ele lê e relê muitos documentos da sua empresa antes de começar
- À medida que contextos crescem: modelos ficam [mais caros](https://www.derekthompson.org/p/the-great-ai-cost-panic-of-2026) e [mais confusos](https://www.trychroma.com/research/context-rot)
- Leitura é shallow e temporária — mesmo quando o modelo vê seu contexto, esquece quando você fecha o chat
- "Right now, models do not learn from this data. This means they can't automatically get better at the things you use them for."

## A Aposta da Engram

Em vez de spending compute massivo em dados públicos:
1. Partir de modelos pré-treinados fortes
2. Gastar training compute no contexto que importa para você
3. Cada modelo gasta equivalente a centenas de anos estudando seu contexto

**Resultados internos e com Notion:**
- Modelos aprenderam sobre a empresa e o trabalho deles de GitHub, Slack, Notion
- Sabem o que estão trabalhando e por quê
- Fazem conexões inesperadas, lembram things que esqueceram
- Para muitas tasks, não precisam re-gather context → **10x ou 100x mais token-efficient**
- "They just know things you'd expect your best teammate to know."

## North Star

Um único algoritmo de training que pode absorver quantidades arbitrárias de dados em um modelo que fica continuamente melhor.

- Atualmente: rodam o processo em todos os dados da empresa todo dia
- Movendo para: retraining a cada hora
- Eventualmente: a cada minuto

## A Dificuldade

Apesar do buzz sobre continual learning, memory, e "learning from you", construir um sistema que funciona (at scale, over many rounds of updates) ainda é um problema em aberto.

A equipe trabalhou no problema de todos os ângulos:
- Context compression
- Retrieval
- LoRA
- Synthetic data
- Long-context architectures
- Memory architectures
- Memorization and forgetting in humans and machines

> "Our findings convinced us that we've identified a concrete new axis of scaling. Scaling compute to study and internalize data offers a tractable path to models that understand you and what you do."

## Primeiro Produto e Parceiros

API para agents que aprendem em workspaces de conhecimento compartilhado muito grandes:

- **Notion** — Custom Agents que entendem grandes Notion workspaces
- **Harvey** — modelos que internalizam conhecimento de uma firma inteira e buscam precedentes across many client matters
- **Microsoft** — piloto de modelos Engram dentro M365 para deliver cost-efficient, customized agents para enterprise customers

## Funding

$98M de General Catalyst, Kleiner Perkins, Sequoia, Factory, Modern, Amplify Partners, Neo, SV Angel. Advisors incluem Andrej Karpathy, Pieter Abbeel, Assaf Rappaport.

> "Interactions with future models will feel completely different. They'll generate trillions of tokens of context a day against a background of a constantly changing world. Every day, you'll teach things to a model — and have it actually learn. Your model."

## Key Insights

- Modelos atuais são treinados na internet pública — não entendem seu trabalho específico
- Context crescente = mais caro E mais confuso (context rot)
- Models não aprendem dos dados que você usa — não ficam automaticamente melhores
- Engram: gastar training compute no CONTEXTO QUE IMPORTA, não em dados públicos
- Equivalente a centenas de anos de estudo do seu contexto
- 10x-100x mais token-efficient porque não precisam re-gather context
- "They just know things you'd expect your best teammate to know."
- North star: retraining a cada minuto eventualmente
- Continual learning at scale over many rounds é problema em aberto
- Novo eixo de scaling: compute para estudar e internalizar dados
- Parceiros: Notion, Harvey, Microsoft — contexts mais ricos e earliest adopters de AI

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/llm-ml-foundations/fine-tuning]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-patterns]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[03-RESOURCES/concepts/pkm-obsidian/personal-corpus]]

## Minha Síntese

**O que muda:** Engram propõe um novo eixo de scaling: em vez de "modelos mais inteligentes treinados em mais dados públicos," gastar compute treinando modelos no CONTEXTO de um usuário/empresa específica. A ideia de que um modelo gasta "centenas de anos estudando seu contexto" e fica 10-100x mais token-efficient é uma mudança de paradigma. O modelo deixa de ser um generalista que precisa re-gather context toda vez e vira um especialista que "just knows things you'd expect your best teammate to know."

**Conexão pessoal:** O vault-michel é exatamente o tipo de contexto que Engram propõe internalizar — meses de decisões, conexões, notas, Clippings, conceitos. Se um modelo pudesse ser treinado no vault e ficar 10x mais eficiente em tasks relacionadas ao vault, o workflow de ingest/consolidação mudaria fundamentalmente. A connection com Karpathy (advisor) conecta com os 4 Principles que governam o vault. A ideia de "retraining a cada minuto" aponta para um futuro onde o modelo aprende continuamente, não apenas no inference time.

**Próximo passo:** Acompanhar Engram (API ainda não pública — early partners only). Quando disponível, avaliar se treinar um modelo no vault-michel context produz ganhos mensuráveis. Por enquanto, o vault já faz uma versão manual disso: hot cache, manifest, concepts consolidados são "context internalizado" que um agent lê no início de cada sessão.