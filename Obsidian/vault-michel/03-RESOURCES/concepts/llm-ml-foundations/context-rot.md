---
title: Context Rot
type: concept
status: developing
tags: [claude-code, context-window, session-management, qualidade, performance]
created: 2026-04-17
updated: 2026-05-19
---

# Context Rot

Fenômeno de degradação progressiva da qualidade de output de um LLM à medida que o contexto da sessão cresce. A atenção do modelo fica distribuída por mais tokens, e conteúdo antigo ou irrelevante começa a competir com as instruções atuais.

> [!key-insight] Threshold prático (Claude Code 1M)
> Context rot começa a aparecer em **~300–400K tokens** no modelo de 1M de janela. Não é regra fixa — depende da tarefa. Uma sessão de debugging com muitos tool calls é mais suscetível que uma sessão de escrita linear.

## Por que acontece

1. Atenção do transformer é distribuída por todos os tokens no contexto
2. Conteúdo antigo e irrelevante "compete" com instruções novas
3. O modelo fica progressivamente menos inteligente conforme a janela enche
4. Problema é exacerbado por **tokens invisíveis** injetados server-side (ver [[03-RESOURCES/sources/token-economy-cost/fix-claude-code-rate-limits-quality]])

## Sintomas práticos

- Instruções do CLAUDE.md começam a ser ignoradas
- O modelo "esquece" decisões arquiteturais tomadas no início da sessão
- Respostas ficam mais genéricas e menos orientadas ao projeto específico
- Outputs de debugging se tornam circulares

## Estratégias de mitigação

| Estratégia | Como funciona |
|---|---|
| `/rewind` | Descarta tokens desnecessários retornando a ponto anterior |
| `/compact` | Sumariza o histórico; lossy mas automático |
| `/clear` | Contexto novo com brief escrito manualmente |
| **Subagents** | Trabalho isolado com contexto próprio; só o resultado volta ao pai |
| **CLAUDE.md curto** | Menos tokens consumidos por instruções de projeto |
| **Downgrade de versão** | Remove tokens invisíveis server-side (v2.1.98 vs 2.1.100+) |

## Bad Compact

O pior momento para compactar é quando o modelo está com context rot — justamente quando a compaction é mais necessária. O modelo compacta com menos inteligência e pode descartar informação que ainda era relevante.

Mitigação: usar `/compact` com instrução direcionada antes que o contexto fique cheio demais.
```
/compact focus on the auth refactor, drop the test debugging
```

## Relação com "Claude Code Tax"

Versões v2.1.100+ injetam ~20.000 tokens invisíveis server-side por request. Isso:
1. Consome a janela de contexto mais rápido (~40% mais rápido segundo testes)
2. Dilui instruções do CLAUDE.md
3. Acelera o onset do context rot

## Fontes

- [[03-RESOURCES/sources/skills-prompting-mcp/claude-code-session-management-1m-context]] — definição e estratégias de mitigação
- [[03-RESOURCES/sources/token-economy-cost/fix-claude-code-rate-limits-quality]] — "Claude Code Tax" e tokens invisíveis
- [[03-RESOURCES/sources/adacom-learning-agent-compatible-context-management]] — AdaCoM: manager externo treinado por RL gerencia contexto de agente frozen; Fidelity-Reliability Trade-off mostra que cada agente tem um "context length efetivo" próprio

## Evidências
- **[2026-06-19]** Estudo Chroma com 18 modelos de fronteira mostra degradação contínua (não cliff) bem antes do limite duro; usuários de Claude Code relatam degradação em 40-60% da capacidade — [[03-RESOURCES/sources/ai-agents-harness/context-engineering-complete-playbook]]
