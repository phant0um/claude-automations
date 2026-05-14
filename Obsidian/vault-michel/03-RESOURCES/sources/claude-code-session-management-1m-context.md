---
title: "Using Claude Code: Session Management & 1M Context"
type: source
source_file: ".raw/articles/Using Claude Code Session Management & 1M Context.md"
author: Thariq (@trq212)
ingested: 2026-04-17
tags: [claude-code, context-window, session-management, compaction, subagents, context-rot]
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
- [[03-RESOURCES/concepts/context-rot]] — conceito introduzido neste artigo
- [[03-RESOURCES/concepts/claude-agent-harness-architecture]] — subagents e arquitetura multi-agent
