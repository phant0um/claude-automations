---
title: "Using Claude Code: Session Management & 1M Context"
type: source
source_file: ".raw/articles/Using Claude Code Session Management & 1M Context.md"
author: Thariq (@trq212)
ingested: 2026-04-17
tags: [claude-code, context-window, session-management, compaction, subagents, context-rot]
triagem_score: 8
---

# Using Claude Code: Session Management & 1M Context

**Autor:** Thariq — [@trq212](https://x.com/trq212)

Guia prático sobre gerenciamento de sessão no Claude Code com contexto de 1M tokens. Insight central: a janela de 1M tokens é uma faca de dois gumes — permite tarefas mais longas mas abre espaço para "context pollution" se não gerenciada.

## Conceitos fundamentais

### Context Rot
Degradação de performance à medida que o contexto cresce: atenção fica distribuída por mais tokens e conteúdo antigo/irrelevante começa a distrair.

> [!warning] Threshold prático
> Context rot começa a aparecer em ~300-400K tokens para o modelo de 1M. Não é uma regra fixa — depende muito da tarefa.

### Compaction
Quando o contexto está chegando ao limite, a conversa é sumarizada em uma descrição menor e o trabalho continua em uma nova janela. Pode ser acionada automaticamente ou manualmente.

## Os 5 pontos de decisão a cada turno

Após cada resposta do Claude, o usuário tem 5 opções:

| Opção | Quando usar |
|---|---|
| **Continue** | Tarefa em andamento, contexto saudável |
| **/rewind (Esc Esc)** | Abordagem errada; melhor que "tente de novo" |
| **/clear** | Nova tarefa; você escreve o brief manualmente |
| **Compact** | Sessão longa; deixa Claude sumarizar |
| **Subagents** | Trabalho que vai gerar muito output intermediário desnecessário |

## Quando iniciar nova sessão

**Regra geral:** nova tarefa = nova sessão.

**Área cinza:** tarefas relacionadas onde parte do contexto ainda é relevante. Exemplo: documentar uma feature que acabou de implementar — Claude já leu os arquivos, então o custo de eficiência de reler compensa manter o contexto.

## Rewind: o hábito mais importante

`/rewind` (ou `Esc Esc`) volta para uma mensagem anterior e descarta tudo depois daquele ponto.

> [!key-insight] Rewind > "tente de novo"
> Se Claude leu 5 arquivos, tentou uma abordagem e falhou, NÃO diga "that didn't work, try X". Em vez disso: `/rewind` para logo após a leitura dos arquivos e re-prompt com o que você aprendeu. Ex: "Don't use approach A, the foo module doesn't expose that — go straight to B."

Técnica avançada: pedir "summarize from here" — Claude gera uma mensagem de handoff da iteração anterior para a próxima.

## Compact vs. Clear

### /compact
- Claude sumariza a conversa e substitui o histórico pelo resumo
- Lossy — Claude decide o que importa
- Pode ser direcionado: `/compact focus on the auth refactor, drop the test debugging`
- Risco: "bad compact" quando o modelo não consegue prever a direção do trabalho

### /clear
- Você escreve o que importa e começa limpo
- Mais trabalhoso, mais preciso
- Recomendado: "we're refactoring the auth middleware, constraint is X, files A and B matter, ruled out approach Y"

**Quando ocorre bad compact:** sessão focada em debugging, autocompact dispara, a próxima mensagem referencia algo diferente que foi descartado. Problema exacerbado pelo context rot — o modelo está no ponto menos inteligente quando precisa resumir.

## Subagentes como gerenciamento de contexto

Quando Claude spawna um subagente via Agent tool, esse subagente recebe sua própria janela de contexto limpa. Apenas o resultado final volta para o contexto pai.

**Teste mental:** "vou precisar deste tool output de novo, ou só da conclusão?"

**Exemplos de uso explícito de subagentes:**
```
"Spin up a subagent to verify the result of this work based on the following spec file"
"Spin off a subagent to read through this codebase and summarize how it implemented auth flow"
"Spin off a subagent to write the docs on this feature based on my git changes"
```

## Conexões no vault

- [[03-RESOURCES/entities/Claude Code]] — objeto central do artigo
- [[03-RESOURCES/entities/Thariq]] — autor
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — conceito introduzido neste artigo
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — subagents e arquitetura multi-agent

## Por que context rot é um problema de atenção, não de memória

Context rot não acontece porque o Claude "esquece" o início da conversa — o conteúdo ainda está no contexto. O problema é de atenção distribuída: ao processar um token, o modelo atende a todos os tokens anteriores com pesos que variam com a posição. Conteúdo antigo e distante recebe atenção mais difusa. Quando o contexto tem 400K tokens e a instrução relevante estava nas primeiras 10K tokens, a instrução recebe uma fração tiny da atenção que receberia em uma janela de 20K.

A consequência prática é que o threshold de 300-400K tokens para context rot não é arbitrário — é o ponto onde a diluição de atenção começa a superar a capacidade do modelo de manter coerência sobre instruções de início de contexto. Tarefas que dependem de instruções dadas no início da sessão degradam mais rapidamente do que tarefas onde as instruções relevantes aparecem próximas ao ponto de execução.

## /rewind como ferramenta de aprendizado, não apenas de correção

A técnica de usar /rewind acompanhada de "summarize from here" antes de resubmitir é mais do que uma forma de corrigir abordagens erradas — é uma forma de aprender com erros sem pagar o custo de tokens de um loop completo. O processo força articular o que foi aprendido na iteração falha ("Don't use approach A, the foo module doesn't expose that") de forma compacta, que então serve como especificação mais rica para a próxima tentativa.

Comparado ao padrão ingênuo de "that didn't work, try X", o /rewind preserva os arquivos lidos e o contexto estabelecido enquanto descarta apenas a tentativa de abordagem que falhou. A sessão resultante é mais curta (menos tokens), mais focada (instrução mais clara), e parte de um estado mais limpo (sem acumulação de tentativas fracassadas no histórico).

## Subagentes como particionamento de contexto

A abstração de subagentes como gerenciamento de contexto é o insight mais operacionalmente importante do artigo. O teste mental — "vou precisar deste tool output de novo, ou só da conclusão?" — é um heurístico concreto para decidir quando spawnar um subagente.

O custo de um subagente é uma janela de contexto limpa separada. O benefício é que tudo que o subagente lê, processa, e descarta não polui o contexto pai. Para tarefas de exploração (ler um codebase para entender como auth foi implementado), quase nada do conteúdo intermediário precisa voltar ao pai — apenas a conclusão. Usar o contexto pai para essa exploração desperdiça tokens e acelera context rot sem benefício.
