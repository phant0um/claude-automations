---
title: "Context Engineering 101: How ChatGPT Stays on Track"
type: source
source_type: article
author: "Neo Kim"
created: 2026-05-06
tags: [context-engineering, chatgpt, architecture, llm]
triagem_score: 8
---

Deep dive into context engineering: how ChatGPT manages context windows, conversation state, and memory. System prompts, RAG integration, and production context management patterns.

## Source

Ingested from: `clippings/Context Engineering 101 How ChatGPT Stays on Track.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## O que é Context Engineering

Context engineering é a disciplina de gerenciar o que entra na janela de contexto de um LLM para maximizar qualidade de output, minimizar tokens desperdiçados, e manter coerência ao longo de conversas longas ou tarefas multi-step. É uma camada acima de prompt engineering: não se trata apenas de como você formula uma pergunta, mas de qual informação está presente, em qual ordem, com qual peso relativo.

A distinção central do artigo: enquanto **prompt engineering** otimiza o texto de uma única instrução, **context engineering** gerencia o estado completo que o modelo vê — incluindo histórico de conversa, documentos recuperados, memórias externas, e saídas de ferramentas.

## Anatomia do Contexto no ChatGPT

O artigo descreve as camadas que compõem o contexto em produção:

**1. System Prompt (instruções persistentes)**
Carregado no início de cada sessão, define comportamento base, persona, restrições, e formato de output. No ChatGPT, este é o "Custom Instructions" do usuário combinado com instruções internas da OpenAI. Em Claude Code, é o CLAUDE.md.

**2. Conversation History (estado conversacional)**
Cada turno anterior ocupa tokens. Conversas longas eventualmente excedem a janela — o sistema deve decidir o que comprimir, sumarizar, ou descartar. ChatGPT usa uma estratégia de truncação + sumarização automática em conversas muito longas.

**3. Retrieved Context (RAG)**
Quando o modelo precisa de conhecimento externo, documentos são recuperados por busca vetorial e injetados no contexto. A qualidade do RAG depende do chunking, do modelo de embedding, e da estratégia de re-ranking. Injetar chunks irrelevantes desperdiça tokens e degrada qualidade.

**4. Tool Outputs (resultados de ferramentas)**
Quando o modelo usa ferramentas (busca web, code execution, APIs), os resultados são inseridos no contexto como observações. Ferramentas com outputs muito verbosos podem saturar o contexto rapidamente.

**5. Memory Layer (memória externa)**
Fatos persistentes sobre o usuário ou tarefa que são recuperados e injetados seletivamente. Diferente do histórico de conversa, memória persiste entre sessões e é mais densa (menos redundância).

## Padrões de Gerenciamento de Contexto

**Progressive Summarization**: conforme a conversa avança, sumários compactos substituem trechos antigos. O risco é perda de detalhes que se tornam relevantes mais tarde — bons sistemas mantêm o contexto recente verboso e comprimem apenas o antigo.

**Selective Injection**: não injetar tudo que está disponível — injetar apenas o que é relevante para a query atual. Requer um ranker ou heurística de relevância. Sem isso, o contexto se torna ruidoso.

**Sliding Window**: manter apenas os N tokens mais recentes. Simples mas perde contexto antigo irreversivelmente. Adequado para tarefas onde recência domina (chat casual), ruim para tarefas que exigem referência a instruções antigas.

**Hot Cache**: manter um subconjunto de contexto "quente" — informações que aparecem frequentemente e devem estar sempre disponíveis sem recuperação. O hot.md do vault-michel é uma implementação desse padrão.

## RAG em Produção: Trade-offs

| Decisão | Opção A | Opção B | Trade-off |
|---|---|---|---|
| Chunk size | pequeno (128 tokens) | grande (512 tokens) | precisão vs cobertura |
| Retrieval | dense (embedding) | sparse (BM25) | semântica vs keywords |
| Re-ranking | cross-encoder | sem re-rank | qualidade vs latência |
| Injection | top-k fixed | threshold dinâmico | consistência vs relevância |

## Limites e Falhas Comuns

**Context Poisoning**: um documento irrelevante mas de alta similaridade semântica injeta informação incorreta que o modelo prioriza. Mitigação: re-ranking + filtros de metadados.

**Lost in the Middle**: estudos mostram que LLMs degradam performance para informações no meio do contexto. Informações críticas devem estar no início ou no final, não enterradas no meio de documentos longos.

**Token Pressure**: quando o contexto está quase cheio, o modelo começa a "esquecer" conteúdo do início. Isso causa respostas que contradizem instruções dadas no início da sessão.

**Hallucination na Ausência de Contexto**: se informação necessária não está no contexto e o modelo não foi treinado nela, ele inventa. Contexto suficiente é mais eficaz que instrução "não invente".

## Relevância para o Vault

Context engineering é a disciplina que fundamenta todo o design do vault-michel como segundo cérebro: hot.md, CLAUDE.md, a separação entre conceitos/entidades/fontes, e o padrão de ingestão estruturada são todas decisões de context engineering — como e o quê injetar no contexto de Claude para maximizar qualidade de resposta por token consumido.

## Relações

- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]] — fundamento técnico
- [[03-RESOURCES/concepts/rag-retrieval-augmented-generation]] — padrão central
- [[03-RESOURCES/concepts/pkm-obsidian/hot-cache]] — implementação do vault
- [[03-RESOURCES/concepts/prompt-engineering]] — disciplina adjacente
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — memory layer como componente de contexto
