---
title: "New Skills: /handoff, /prototype, /review, writing"
type: source
source_file: "Clippings/New Skills! _handoff, _prototype, _review and _writing-_.pdf"
source_type: social-media
ingested: 2026-05-15
tags: [claude-code, skills, sub-agents, prototyping, writing]
triagem_score: 8
---

## Tese central

4 novas skills resolvem problemas concretos de workflow: context overflow mid-session, unknowns que só se revelam construindo, code review contra spec original, e escrita estruturada em 3 fases.

## /handoff

**Problema:** deep em sessão, context window enchendo, precisa fazer pivot (prototipar algo, corrigir bug). Apertar tudo nos tokens restantes = cramped e errado.

**Solução:** entrega toda a conversa (context + vibe) para um agente fresco em workspace separado → resolve → retorna com o que aprendeu.

Padrão: sub-agente genuinamente autônomo, mas operador mantém controle total. Handoff ida + handoff volta.

## /prototype

**Problema:** unknown unknown — só descobre o que precisa construindo.

**Para UI:** gera variações radicalmente diferentes → operador mistura os melhores pedaços ("mix and match").

**Para state machines / business logic:** constrói app terminal interativo em vez de UI.

**Key insight:** "AI often can't see what it's building" → human-in-the-loop obrigatório para aplicar taste. Prototyping = técnica de descoberta, não de entrega.

## /review (preview)

Verifica código contra:
1. Padrões do repositório
2. Spec original do feature

Resolve drift entre implementação e intenção.

## Writing skill (preview — 3 partes)

Pipeline: **fragments → beats → shape**

Trata prototyping como técnica de escrita. Fragmentos brutos → estrutura narrativa (beats) → forma final (shape). Mesmo princípio do /prototype: iterar com human taste no loop.

## Relação com vault

`/handoff` = pattern de sub-agent com context handoff → [[03-RESOURCES/concepts/agent-systems/agent-harness]] (sub-agent isolation), [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]

`/prototype` + writing = exploração antes de commitment → [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]] (Think Before Coding, tensão: prototype EXIGE build-first)

`/review` = verification loop → [[03-RESOURCES/concepts/claude-code-tooling/goal-command]] (VERIFY section), [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]

## Como cada skill resolve o problema que o prompt simples não resolve

### /handoff: o problema dos tokens restantes

Sem `/handoff`, quando a janela de contexto está enchendo em uma sessão de trabalho, as opções são:
1. Continuar na mesma sessão com qualidade degradada
2. Abandonar a sessão e recomeçar do zero, perdendo o contexto construído
3. Tentar comprimir manualmente o contexto — demorado e impreciso

`/handoff` oferece uma quarta opção: um agente fresco recebe o contexto necessário (não todo o histórico, mas o contexto relevante destilado) e resolve a subtarefa em seu próprio espaço de contexto limpo. O resultado retorna ao agente original com o que foi aprendido — mas sem os tokens gastos durante a exploração.

O padrão "handoff ida + handoff volta" é a chave: não é apenas delegação (ida), é delegação com retorno de aprendizado (volta). O agente principal fica mais rico sem ter gasto os tokens da exploração.

### /prototype: "AI often can't see what it's building"

O problema do unknown unknown é fundamental ao design: você não sabe o que não sabe até construir algo e descobrir que era o que precisava. Pedir ao agente para especificar completamente antes de construir quebra no problema de que a especificação só pode ser completa depois de ver o que foi construído.

Para UI, variações radicalmente diferentes forçam decisões de design que um spec abstrato não força. Quando você vê três layouts concretos, você pode dizer "quero a hierarquia visual do primeiro, a densidade do segundo, e a navegação do terceiro" — algo que seria impossível de especificar em texto antes de ver qualquer alternativa.

Para lógica de negócio (state machines), o app terminal interativo permite exploração de edge cases que emergem durante o uso — não durante a especificação. Você descobre que precisa de tratamento especial para o estado X quando tenta fazer a transição X→Y no terminal e percebe que não existe.

### /review vs. lint e type check

Lint e type check verificam contra regras formais. `/review` verifica contra dois critérios mais ricos:
1. Padrões do repositório específico — convenções que não estão em nenhum linter, porque são específicas do time ou do projeto
2. Spec original do feature — "o que foi pedido" vs. "o que foi implementado"

O drift spec→implementação é uma das fontes mais comuns de bugs que passam em todos os testes formais mas quebram a expectativa do usuário. `/review` fecha essa lacuna.

### Writing skill: por que fragments → beats → shape

O pipeline em 3 fases mapeia para um insight sobre escrita criativa: o processo de escrever bem é separar três atividades que normalmente se interferem — coletar material, estruturar narrativa, e polir forma.

- **Fragments:** coletar sem julgamento — ideias brutas, observações, citações, exemplos. O filtro estético desligado.
- **Beats:** estruturar a sequência narrativa — qual ideia leva a qual, qual é a tensão central, onde fica o clímax. Sem preocupação com linguagem.
- **Shape:** polir a forma com a estrutura já fixada — escolha de palavras, ritmo, transições. O conteúdo não muda mais.

O valor do pipeline é que cada fase tem um critério de qualidade diferente. Na fase de fragments, "mais é melhor". Na fase de beats, "fluxo narrativo é tudo". Na fase de shape, "cada palavra importa". Misturar as fases — escrever a prosa final enquanto ainda está descobrindo o que dizer — é o que produz escrita genérica e sem foco.

## A tensão com Karpathy Princípio 1

O princípio "Pense antes de agir" de Karpathy parece contradizer `/prototype` (que diz "só descobre construindo"). A tensão é real e produtiva:

- Karpathy se aplica quando os requisitos são suficientemente conhecidos para que o plano seja válido
- `/prototype` se aplica quando os requisitos são fundamentalmente desconhecidos até que algo seja construído

A resolução: planejamento antecipado é valioso quando reduz o custo de descoberta. Prototipagem é válida quando o custo de planejamento sem informação suficiente excede o custo de construir para descobrir. O julgamento de qual situação você está é a habilidade meta.

## Padrões de uso combinado

Os 4 skills não são mutuamente exclusivos:
- `/prototype` para descobrir o que construir → `/handoff` para delegar a implementação a um agente fresco
- `/prototype` para UI → `/review` para verificar que a implementação corresponde à intenção do prototype
- Writing skill para spec do feature → `/goal` estruturado → `/review` final contra a spec

## Limitações

- `/handoff` depende de destilação de contexto — se o contexto relevante não for bem destilado, o agente fresco não tem o necessário para continuar
- `/prototype` com variações de UI só é útil se o humano tem taste suficiente para avaliar o que é "mix and match" válido — garbage in, garbage out no lado humano
- `/review` contra spec original pressupõe que a spec original é boa o suficiente para ser o critério de verdade
- Writing skill (ainda em preview) não tem histórico de uso suficiente para avaliar onde funciona bem e onde falha

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
