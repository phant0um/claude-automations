---
title: "9 Agentic Patterns, Simply Explained"
type: source
source_type: article
author: "Neo Kim"
created: 2026-05-06
tags: [ai-agents, agentic-patterns, multi-agent, orchestration]
triagem_score: 7
---

9-pattern taxonomy with escalation ladder: 4 workflow patterns (chaining, routing, parallelization, orchestrator-workers) + 5 agent patterns (reflection, tool use, ReAct, planning, evaluator-optimizer). Each pattern maps to specific complexity levels and use cases.

## Source

Ingested from: `clippings/9 Agentic Patterns, Simply Explained.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## A escalada de complexidade

O artigo de Neo Kim apresenta uma taxonomia progressiva — cada padrão resolve um problema que o anterior não consegue. A distinção entre **workflow patterns** e **agent patterns** é fundamental: workflows têm fluxo determinístico; agentes têm autonomia de decisão sobre o próximo passo.

## Os 4 padrões de workflow

### 1. Chaining (encadeamento)
O output de um LLM vira o input do próximo. Simples, previsível, facilmente debugável.

**Quando usar:** tarefas que naturalmente têm etapas sequenciais — extrair informação de um texto, depois formatar, depois traduzir.

**Limitação:** sem feedback. Se a etapa 1 falha, a etapa 2 processa lixo. Não há retry automático.

### 2. Routing (roteamento)
Um classificador decide qual branch do pipeline processa a query. Permite especialização sem crescer um prompt único para cobrir tudo.

**Quando usar:** sistema que atende múltiplos tipos de request (suporte técnico vs. billing vs. informação geral). Cada branch tem seu próprio prompt especializado.

**Implementação típica:** LLM leve (ou regra simples) classifica a intent, depois passa para o handler especializado. Custo: uma chamada extra de classificação.

### 3. Parallelization
Múltiplas chamadas LLM simultâneas, com agregação dos resultados. Reduz latência para tarefas independentes.

**Variante sectioning:** divide um documento longo em seções, processa cada seção em paralelo, agrega os outputs.

**Variante voting:** gera múltiplas respostas independentes, seleciona por consenso. Aumenta robustez em tarefas de alta variância (ex: geração de código).

### 4. Orchestrator-Workers
Um LLM "orquestrador" divide a tarefa em subtarefas e delega para "workers" especializados. Os workers retornam resultados; o orquestrador sintetiza.

**Quando usar:** tarefas complexas que exigem coordenação — pesquisa multi-fonte, análise multi-perspectiva, geração multi-modal.

**Risco:** o orquestrador pode dar instruções ambíguas. A qualidade do sistema depende da qualidade das instruções geradas dinamicamente.

## Os 5 padrões de agente

### 5. Reflection (auto-crítica)
O agente gera uma resposta e depois critica sua própria resposta, iterando até satisfazer critérios de qualidade.

**Implementação:** dois prompts (gerador + crítico) ou um único prompt com duas fases. O loop continua até que o crítico aprove ou um limite de iterações seja atingido.

**Limitação prática:** o agente pode aprovar outputs incorretos se o crítico usar os mesmos pressupostos do gerador. "Echo chamber" entre gerador e crítico.

### 6. Tool Use
O agente decide quando chamar ferramentas externas (APIs, calculadoras, busca web, banco de dados) e incorpora os resultados na resposta.

**Padrão fundamental:** `thought → action → observation → thought`. O LLM decide a ferramenta, executa, observa o resultado, decide próximo passo.

**Segurança:** ferramentas com side effects (write, delete, send email) requerem confirmação humana ou sandbox rigoroso.

### 7. ReAct (Reasoning + Acting)
Formalização do ciclo thought-action-observation com raciocínio explícito a cada passo. O agente externaliza seu processo de pensamento antes de cada ação.

**Por que funciona:** raciocínio explícito reduz erros de salto lógico. O agente não pode "intuir" a próxima ação — deve justificá-la, o que força coerência.

**Implementação:** few-shot examples mostrando o formato `Thought: ... Action: ... Observation: ...`

### 8. Planning
Antes de executar, o agente cria um plano explícito de etapas. Executa o plano. Revisa se necessário.

**Variantes:** Plan-and-Execute (plano fixo, executado sequencialmente) vs. ReWOO (raciocínio e ação desacoplados para eficiência) vs. LLMCompiler (paralelização do plano).

**Quando preferir sobre ReAct:** tarefas longas onde o contexto do loop ReAct ficaria grande demais. O plano é um sumário compacto do estado.

### 9. Evaluator-Optimizer
Um agente gera, outro avalia e retorna feedback, o gerador refina com base no feedback. Loop até convergência.

**Diferença de Reflection:** no Reflection, o mesmo agente auto-avalia. Aqui, são agentes separados com perspectivas independentes — reduz o echo chamber.

**Caso de uso:** geração de código (gerador escreve, evaluator roda testes, gerador corrige baseado nos erros).

## Escalada: quando usar cada padrão

```
Complexidade crescente →
Chaining → Routing → Parallelization → Orchestrator-Workers
→ Reflection → Tool Use → ReAct → Planning → Evaluator-Optimizer
```

Regra prática: comece com o padrão mais simples que resolve o problema. Adicione complexidade apenas quando o padrão atual falha em casos reais, não hipotéticos.

## Composição de padrões

Na prática, sistemas reais combinam padrões. Exemplo: um sistema de pesquisa pode usar Routing (classifica tipo de query) + Parallelization (busca múltiplas fontes) + ReAct (agente pesquisa com tool use) + Evaluator-Optimizer (avalia qualidade da resposta final).

A composição aumenta capacidade e aumenta complexidade de debugging. Cada padrão adicionado é mais um ponto de falha potencial.

## Relevância para o vault

O vault-michel usa explicitamente: Orchestrator-Workers (Nexus orquestra subagentes), Tool Use (agentes usam MCP tools), Planning (CLAUDE.md instrui pensar antes de agir). Reflection e Evaluator-Optimizer são aplicados informalmente mas não estão sistematizados. Uma oportunidade: implementar um avaliador explícito para ingestões — outro agente que verifica se o wikilink resolve, se hot.md foi atualizado, se o conteúdo é substantivo.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]]
- [[03-RESOURCES/sources/hermes-agent/clipping-what-makes-ai-agent-different]]
