---
title: "ActiveGraph A Continuity Layer for Long-Running Agents"
type: source
source: Clippings/ActiveGraph A Continuity Layer for Long-Running Agents.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 7
triagem_cat: ai-agents
tags: [ai-agents, clipping]
---

## Tese central

Yohei Nakajima (autor do BabyAGI) propõe o ActiveGraph como solução ao problema fundamental de agentes long-running: como um agente mantém coerência ao longo de horas ou dias de execução, quando o estado da tarefa é grande demais para caber no context window.

## Key insights

- O grafo captura **dependências**: what depends on what — quais subtarefas dependem de quais outras
- O grafo captura **evidências**: what evidence supports what — quais descobertas suportam quais conclusões
- O grafo captura **próximos passos**: what should happen next — estado de execução e próxima ação recomendada

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]

## Fonte

Arquivo original: `Clippings/ActiveGraph A Continuity Layer for Long-Running Agents.md`

---

## O problema que o ActiveGraph resolve

Agentes LLM têm um context window finito. Para tarefas curtas (minutos), isso não é problema — tudo cabe no contexto. Para tarefas long-running (horas a dias) como pesquisa profunda, desenvolvimento de software complexo, ou análise de dados extensiva, o estado da tarefa eventualmente excede o contexto disponível.

As soluções existentes são inadequadas:

**Summarization:** resumir o histórico para liberar contexto. Perde detalhes e raciocínio intermediário. O agente "esquece" por que tomou decisões importantes.

**Sliding window:** manter apenas as N mensagens mais recentes. Similar ao summarization — perde contexto histórico crítico.

**Armazenar tudo, recuperar por relevância:** RAG sobre o histórico completo. Funciona para recuperar fatos, mas não captura a estrutura de dependências e raciocínio — um fato isolado sem seu contexto de por que foi descoberto e como se relaciona com outros fatos tem valor limitado.

O ActiveGraph resolve ao representar o estado da tarefa como um **grafo explícito** que pode ser serializado, armazenado, e recuperado sem perda de estrutura.

## Estrutura do ActiveGraph

O grafo tem três tipos de nodes:

**Task nodes:** representam subtarefas. Têm status (pending/in-progress/completed/failed), outputs, e metadados de execução.

**Evidence nodes:** representam descobertas, dados, e informações coletadas. Conectados às tarefas que os geraram e às conclusões que suportam.

**Conclusion nodes:** representam inferências e decisões tomadas. Conectados às evidências que as fundamentam e às próximas tarefas que habilitam.

E três tipos de arestas:

**depends_on:** task A depende de task B — B deve completar antes de A poder começar. Permite scheduling correto e detecção de bloqueadores.

**supports:** evidence X suporta conclusion Y. Permite rastrear a cadeia de raciocínio de volta às fontes.

**enables:** conclusion Y habilita task Z — a decisão tomada abre novas linhas de investigação ou execução.

## Como o agente usa o grafo

Ao iniciar uma sessão de continuidade (retomando uma tarefa interrompida), o agente não recebe o histórico completo — recebe uma **vista do grafo** relevante para o estado atual:

1. **Subgrafo de contexto imediato:** a tarefa atual, suas dependências diretas, e as evidências mais relevantes
2. **Resumo estrutural:** quantas tarefas completadas/pendentes/falhadas, principais conclusões até agora
3. **Próximos passos recomendados:** tasks habilitadas que ainda não começaram, ordenadas por prioridade

Isso permite que o agente retome com contexto suficiente sem precisar do histórico completo — o grafo é um índice estruturado do estado da tarefa.

## Casos de uso

**Pesquisa de múltiplos dias:** um agente pesquisando um tópico complexo mantém o grafo de quais fontes explorou, o que encontrou, quais hipóteses foram confirmadas ou refutadas, e quais linhas de pesquisa ainda estão abertas.

**Desenvolvimento de software complexo:** o grafo captura dependências entre componentes, decisões arquiteturais e seus raciocínios, e o estado de implementação de cada módulo.

**Análise financeira ou jurídica:** grafo de claims, evidências suportando cada claim, e conclusões derivadas — com rastreabilidade completa de raciocínio.

**Debugging profundo:** o agente registra no grafo cada hipótese testada, o resultado do teste, e as conclusões derivadas — evitando re-testar hipóteses já descartadas.

## Comparação com abordagens alternativas

| Abordagem | Persistência | Estrutura | Rastreabilidade |
|---|---|---|---|
| Context window puro | Nenhuma | Sequencial | Nenhuma |
| Summarization | Parcial | Nenhuma | Baixa |
| RAG sobre histórico | Alta | Semântica | Baixa |
| Checklist/todo | Média | Hierárquica | Baixa |
| ActiveGraph | Alta | Grafo rico | Alta |

## Limitações

**Overhead de manutenção:** o agente precisa atualizar o grafo a cada ação. Isso adiciona latência e custo por step.

**Qualidade do grafo depende do agente:** se o agente categoriza mal uma evidência ou classifica uma dependência erroneamente, o grafo se torna incorreto — e erros se propagam em steps subsequentes.

**Complexidade de implementação:** construir e manter um grafo consistente é tecnicamente mais complexo que um simples log de ações.

**Tamanho do grafo:** tarefas muito longas com muitas ramificações podem produzir grafos enormes. Estratégias de compressão (colapsar subgrafos completados em summary nodes) são necessárias.

## Relevância para o vault

O vault executa tarefas que se beneficiariam do ActiveGraph: ingestões batch de múltiplos artigos, consolidação de conceitos relacionados, restructuring de seções do wiki. Atualmente, o estado dessas tarefas fica em `.claude/todo.md` como lista — sem captura de dependências, evidências, ou raciocínio intermediário. Usar um grafo explícito (mesmo que simplificado, como YAML de dependências) melhoraria a capacidade de retomar tarefas interrompidas sem perda de contexto.

## Links relacionados

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-masterclass]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-ruflo-multi-agent-platform]]
