---
title: "What Makes an AI Agent Different From ChatGPT?"
type: source
source_type: article
author: "Sairam Sundaresan"
created: 2026-05-06
tags: [ai-agents, react, agent-architecture, chatbot]
triagem_score: 7
---

Agent anatomy: PEAS framework, ReAct loop, Plan-and-Execute, hybrid approach, RAG memory. Core distinction: chatbot talks, agent does. Covers tool use, observation loops, and practical deployment patterns.

## Source

Ingested from: `clippings/What Makes an AI Agent Different From ChatGPT?.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## A distinção fundamental

Um chatbot como o ChatGPT em modo padrão é um sistema de **pergunta-resposta**: recebe texto, produz texto. Não tem estado persistente além do contexto da conversa, não executa ações no mundo, não observa resultados de suas ações.

Um agente AI adiciona três capacidades:
1. **Ferramentas:** capacidade de executar ações no mundo (buscar web, escrever arquivo, chamar API)
2. **Observação:** capacidade de ver o resultado dessas ações e incorporar no raciocínio
3. **Loop:** capacidade de iterar até completar uma tarefa, não apenas responder uma vez

A consequência prática: ChatGPT diz "você poderia criar um arquivo com esse conteúdo"; um agente cria o arquivo.

## O framework PEAS

PEAS é um framework de IA clássico para especificar agentes, aplicado a agentes LLM modernos:

- **Performance measure:** o que define sucesso? (tarefa completa, usuário satisfeito, sem erros)
- **Environment:** em qual ambiente o agente opera? (filesystem, web, APIs, banco de dados)
- **Actuators:** quais ações o agente pode executar? (write, search, call API, send message)
- **Sensors:** o que o agente pode perceber? (arquivos, output de ferramentas, mensagens do usuário)

PEAS força clareza sobre o escopo do agente antes de implementação. Um agente mal especificado tem PEAS implícito e inconsistente — daí a maioria dos problemas de produção.

## O loop ReAct

ReAct (Reasoning + Acting) é o padrão dominante para agentes LLM:

```
Thought: Preciso encontrar o preço atual do produto X.
Action: search("preço produto X site oficial")
Observation: O preço é R$199,90 com desconto de 10% para pagamento à vista.
Thought: Tenho a informação. Agora posso calcular o valor à vista.
Action: calculate(199.90 * 0.9)
Observation: 179.91
Thought: Tenho o resultado. Posso responder ao usuário.
Answer: O preço à vista é R$179,91.
```

O ponto crítico: **o agente decide a próxima ação baseado na observação anterior**, não em um plano fixo. Isso permite adaptação a resultados inesperados.

## Plan-and-Execute vs. ReAct

**ReAct:** raciocínio e ação são intercalados. Cada observação pode mudar o próximo passo. Mais adaptativo, mas o contexto cresce a cada iteração — pode exceder o context window em tarefas longas.

**Plan-and-Execute:** o agente primeiro cria um plano completo, depois executa cada passo. Mais eficiente em tokens (o plano é compacto), mas menos adaptativo. Se o passo 2 falha inesperadamente, o plano precisa ser refeito.

**Abordagem híbrida:** plano de alto nível + ReAct dentro de cada passo. Captura o melhor dos dois: eficiência do planejamento + adaptabilidade local.

## Memória de agente: as 4 camadas

**In-context (curto prazo):** o conteúdo atual do context window. Volátil — some quando a sessão termina.

**External (longo prazo):** vector database, key-value store, arquivos. Persistente entre sessões. Requer retrieval explícito.

**Episodic:** memória de interações passadas ("na última semana você me pediu X"). Análogo à memória episódica humana.

**Semantic:** conhecimento factual geral sobre o domínio. Equivalente ao que o modelo aprendeu no treinamento + knowledge base curada.

## RAG como memória de agente

Retrieval-Augmented Generation integrado em agentes funciona como memória externa consultável: quando o agente precisa de informação, busca na vector DB antes de responder ou agir.

Diferença crítica em relação a RAG passivo: em RAG para chatbot, o retrieval acontece sempre, antes de cada resposta. Em agentes com RAG como ferramenta, o agente decide **quando** buscar — o que reduz latência e custo mas exige que o agente saiba quando não sabe algo (calibração de incerteza).

## Deployment patterns práticos

**Agente single-turn:** executa uma tarefa e retorna. Sem estado entre chamadas. Mais simples de operar, menos poderoso.

**Agente multi-turn com memória:** mantém contexto entre chamadas. Requer gerenciamento de estado explícito — onde fica, como expira, como é recuperado.

**Multi-agente:** múltiplos agentes especializados, coordenados por um orquestrador. Permite paralelização e especialização, aumenta complexidade de debugging.

**Human-in-the-loop:** agente executa até um ponto de decisão crítico, pausa para aprovação humana, continua. Padrão obrigatório para ações com side effects irreversíveis.

## Comparação: chatbot vs. agente

| Dimensão | Chatbot | Agente |
|---|---|---|
| Estado | Apenas in-context | Persistente + in-context |
| Ações | Nenhuma | Ferramentas externas |
| Loop | Uma resposta | Múltiplos passos |
| Falha | Resposta incorreta | Ação incorreta no mundo |
| Debug | Revisar resposta | Revisar cada step |
| Custo | Previsível | Variável (N chamadas) |

## Limitações e riscos

**Loops infinitos:** sem limite de iterações, um agente pode ficar preso em um ciclo. Sempre defina `max_iterations`.

**Cascata de erros:** erro no passo 2 contamina todos os passos seguintes. Checkpoints e validação por etapa são essenciais.

**Tool misuse:** o agente pode chamar ferramentas de forma inesperada. Sandboxing rigoroso e minimal permissions são necessários.

**Latência não previsível:** N chamadas de LLM + N chamadas de tool = latência variável. Para UX responsivo, use streaming e feedback de progresso.

## Relevância para o vault

O Nexus e os agentes do vault são exatamente essa arquitetura: ReAct implícito via CLAUDE.md (think → act → verify), ferramentas via MCP (filesystem, search), e memória em múltiplas camadas (hot.md como in-context, wiki como external, errors.md como episodic). Entender o PEAS de cada agente do vault (guard, hill, ingest-report) tornaria mais claro quando cada um deve ser invocado.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]]
- [[03-RESOURCES/sources/claude-code-skills/clipping-9-agentic-patterns-explained]]
- [[03-RESOURCES/sources/ml-research-papers/clipping-post-burkov-llm-rationality-gap]]
