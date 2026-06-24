---
title: "Skill: grill-me"
type: source
source_type: clipping
source_path: clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 1.md
created: 2026-05-09
ingested: 2026-05-09
tags: [ai-agents, clipping]
triagem_score: 7
---

## Resumo

| name | grill-me |
| --- | --- |
| description | Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me". |

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exp

## Origem

- Path: `clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 1.md`
- Categoria: ai-agents
- Ingerido: 2026-05-09

## Cross-links

_Pendente — autoresearch/lint cycle._

---

## Mecânica da skill

O `grill-me` é uma skill de entrevista socrática estruturada. O modelo assume o papel de um interviewer rigoroso e percorre o espaço de decisões de um plano ou design de forma sistemática, ramo a ramo, sem deixar dependências não resolvidas. A instrução central é:

> "Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer. Ask the questions one at a time."

A cláusula "provide your recommended answer" é o que diferencia esta skill de uma simples entrevista: o modelo não faz perguntas no vácuo, mas entrega sua própria recomendação junto com cada questão. O usuário pode aceitar, rejeitar ou refinar — o que gera um loop de convergência rápida.

## Por que funciona

A maioria dos planos falha porque o autor não sabe o que não sabe. O `grill-me` força exposição sistemática de gaps: ao percorrer o decision tree ramo a ramo, o modelo identifica onde as dependências estão implícitas e onde suposições não declaradas sustentam decisões downstream.

Isso é equivalente a um **pre-mortem estruturado** combinado com **revisão por pares simulada** — sem precisar de outro humano.

## Casos de uso práticos

- **Design de sistema**: grilliar a arquitetura de um agente antes de construir — quais ferramentas, qual modelo, como lidar com falhas, como escalar
- **Plano de negócios**: stress-test de suposições de mercado, pricing, GTM, risco operacional
- **Decisão de carreira**: mapear tradeoffs antes de aceitar oferta ou mudar de área
- **Estratégia de projeto**: escopo, dependências, riscos técnicos, critérios de sucesso
- **Spec de produto**: requisitos funcionais vs não-funcionais, edge cases, stakeholders

## Diferença de uma conversa comum

Em uma conversa normal com Claude, o usuário dirige. No `grill-me`, o modelo dirige. O usuário responde. Essa inversão de controle remove o viés de confirmação: o usuário não pode ignorar perguntas difíceis porque o modelo vai fazê-las de qualquer forma.

A instrução "ask one at a time" preserva o foco — evita sobrecarga cognitiva de múltiplas perguntas simultâneas e força resposta completa antes de avançar.

## Estrutura do decision tree

O modelo trata o plano como uma árvore:

1. **Raiz**: objetivo central — clareza e critério de sucesso
2. **Ramos de primeiro nível**: decisões principais (arquitetura, recursos, cronograma, stakeholders)
3. **Ramos de segundo nível**: dependências de cada decisão principal
4. **Folhas**: escolhas concretas e suas justificativas

A resolução é bottom-up: resolve as dependências antes de fechar os ramos de cima. Isso evita a situação comum de decidir estratégia antes de resolver restrições técnicas.

## Integração no vault

Esta skill mapeia diretamente para o princípio **"Think before acting"** do CLAUDE.md: antes de qualquer operação não-trivial com 3+ passos, entrar em modo de planejamento e listar os passos. O `grill-me` é a versão interativa desse princípio — o modelo como co-planejador rigoroso.

Uso recomendado no vault: antes de iniciar ingestão em lote, reestruturação de agentes, ou qualquer tarefa que afete mais de 10 arquivos, rodar `/grill-me` para mapear dependências e riscos antes de executar.

## Limitações

- Não é ideal para planos simples: o overhead da entrevista não compensa para tarefas de 1-2 passos
- O modelo pode superestimar riscos em domínios onde não tem expertise específica
- Requer que o usuário tenha uma ideia inicial razoável — o `grill-me` refina, não inventa

## A cláusula "se a pergunta pode ser respondida pela experiência do usuário"

A instrução completa que aparece cortada no clipping é provavelmente:

> "If a question can be answered by experience or judgment without research, answer it yourself and ask the user to confirm, rather than waiting for input."

Essa cláusula é importante porque sem ela, o `grill-me` pode virar uma sequência de perguntas óbvias que o usuário já decidiu — o overhead da entrevista excede o valor. A cláusula instrui o modelo a exercer julgamento: se a resposta "padrão" é óbvia e o risco de errar é baixo, assuma e confirme, não questione.

Isso calibra o ritmo da entrevista: perguntas de alta incerteza → o modelo pergunta. Perguntas de baixa incerteza com resposta default clara → o modelo propõe e pede confirmação. O usuário avança mais rápido e ainda tem controle.

## Protocolo de sessão completo

Uma sessão `grill-me` bem conduzida segue:

1. **Enunciado inicial:** usuário apresenta o plano em 1-3 parágrafos — suficiente para o modelo mapear a estrutura
2. **Identificação da raiz:** modelo restate o objetivo central e critério de sucesso para alinhamento
3. **Ramos de primeiro nível:** modelo identifica as 3-5 decisões principais do plano
4. **Drill-down sequencial:** para cada ramo, percorre dependências uma por vez, com recomendação junto de cada pergunta
5. **Resolução de cross-dependencies:** quando duas decisões são interdependentes, o modelo as trata juntas, não separadamente
6. **Síntese:** ao final, modelo produz a versão atualizada do plano incorporando as respostas
7. **Open issues:** lista de itens que ficaram em aberto para decisão futura

Esse protocolo produz em 45-90 minutos o equivalente a uma sessão de design review com um engenheiro sênior experiente no domínio.

## Comparação com outras técnicas de stress-test

**Red teaming tradicional:** focado em encontrar falhas de segurança. `grill-me` cobre todo o design, não apenas vulnerabilidades.

**Pre-mortem (Klein, 1989):** técnica onde o grupo imagina que o projeto falhou e pergunta "por quê". Focado em risk identification. `grill-me` cobre tanto riscos quanto decisões de design ainda abertas.

**Architecture Decision Records (ADRs):** documentam decisões tomadas. `grill-me` é um processo de tomar as decisões — os ADRs são o output natural de uma sessão.

**FMEA (Failure Mode and Effects Analysis):** análise sistemática de modos de falha com severidade e probabilidade. Mais estruturado que `grill-me`, mas requer mais setup e domínio técnico específico.

`grill-me` é o meio-termo: mais sistemático que uma conversa informal, menos burocrático que FMEA, e disponível sem coordenação de equipe.

## Padrão de output recomendado

Para maximizar o valor da sessão, instruir o modelo a produzir ao final:

```
## Decisões Tomadas
[lista das escolhas confirmadas durante a entrevista]

## Suposições Declaradas
[premissas que sustentam o plano e que deveriam ser validadas]

## Questões em Aberto
[itens que não foram resolvidos e precisam de mais informação ou decisão futura]

## Riscos Identificados
[riscos que emergiram durante a entrevista, com mitigações propostas]

## Próximos Passos
[ações concretas com owners e prazos, derivadas da entrevista]
```

Esse output pode ser salvo como ADR, compartilhado com a equipe, ou usado como base para o plano de execução.

## Referências internas

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — skills como extensão de comportamento do modelo
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — padrões de inversão de controle em prompts
- [[04-SYSTEM/skills/]] — diretório de skills instaladas no vault
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — a sessão grill-me é context engineering do plano antes da execução
