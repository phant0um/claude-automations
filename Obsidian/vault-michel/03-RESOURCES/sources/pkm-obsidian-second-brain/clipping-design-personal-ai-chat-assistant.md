---
title: "Design a Personal AI Chat Assistant"
type: source
source_type: article
author: "Neo Kim / Louis-Francois Bouchard"
created: 2026-05-06
tags: [ai-assistant, architecture, tokenization, production]
triagem_score: 7
---

Architecture of a customer-facing chat assistant: tokenization/BPE, pretraining to SFT to RLHF pipeline, context engineering, prompt caching, model routing, LLM-as-Judge evaluation. 8-step build from API call to production.

## Source

Ingested from: `clippings/Design a personal AI chat assistant.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## O que diferencia um assistente pessoal de um chatbot genérico

Um chatbot genérico usa o modelo base sem customização — cada conversa começa do zero, sem conhecimento do usuário, sem personalização, sem memória. Um assistente pessoal tem três características adicionais:

1. **Conhecimento do usuário:** preferências, histórico, contexto de vida
2. **Persistência:** memória entre sessões
3. **Personalidade consistente:** tom e estilo adaptados ao usuário

O artigo apresenta um pipeline de 8 etapas para construir isso de forma robusta para produção.

## Etapas do pipeline

### Etapa 1: Tokenização e BPE
Entender como o modelo processa texto é fundamental para otimização de custo e qualidade. Byte Pair Encoding (BPE) é o algoritmo dominante: começa com bytes individuais e iterativamente merge os pares mais frequentes.

Implicação prática: tokens não correspondem a palavras. "unhappy" pode ser 1 token, mas "felicidade" pode ser 2-3 tokens dependendo da língua. Português é geralmente menos eficiente que inglês em tokens/palavra — assistentes em PT custam mais por palavra processada.

### Etapa 2: Pretraining → SFT → RLHF
O modelo base (pretraining) sabe completar texto mas não sabe ser um assistente. Fine-tuning supervisionado (SFT) em pares de conversa ensina o formato de assistente. RLHF (Reinforcement Learning from Human Feedback) alinha o comportamento com preferências humanas.

Para a maioria dos casos de uso, não faz sentido fazer esse pipeline completo. Você usa um modelo já alinhado (GPT-4, Claude, Gemini) e customiza via prompt engineering e RAG.

### Etapa 3: Context engineering
O contexto que você passa ao modelo determina mais a qualidade da resposta que o modelo em si. Context engineering é a arte de montar esse contexto de forma eficiente:

- System prompt com identidade e regras do assistente
- Histórico de conversa relevante (não todo o histórico — curated)
- Informações do usuário recuperadas da memória
- Documentos relevantes via RAG

### Etapa 4: Prompt caching
Anthropic e outros providers oferecem cache de prefixo: se o início do contexto for idêntico entre chamadas, os tokens em cache não são reprocessados. Para um assistente pessoal, o system prompt (identidade + regras + dados fixos do usuário) é perfeito para caching — é estático e longo.

Economia típica: 60-80% do custo de input tokens para sessões longas onde o system prompt domina o contexto.

### Etapa 5: Model routing
Nem toda mensagem precisa do modelo mais capaz (e caro). Implementar um roteador que classifica a complexidade da query e direciona para o modelo apropriado reduz custo significativamente:

- Query simples ("qual o dia de hoje?") → modelo pequeno/rápido
- Query complexa ("analise este documento e compare com nossa estratégia") → modelo grande
- Query de código → modelo especializado em código

### Etapa 6: Retrieval e memória
Para assistente pessoal, a memória tem duas dimensões:

**Memória de curto prazo:** histórico da conversa atual. Implementado via sliding window ou summarization quando o contexto fica longo.

**Memória de longo prazo:** fatos sobre o usuário, preferências, interações passadas. Armazenado em vector DB, recuperado por similaridade semântica quando relevante para a query atual.

### Etapa 7: LLM-as-Judge para avaliação
Em vez de métricas automáticas (BLEU, ROUGE) que não capturam qualidade de conversa, use um LLM para avaliar amostras das respostas do assistente contra critérios explícitos: utilidade, precisão, tom, concisão.

Implementação: amostra 5-10% das conversas, passe por juiz LLM com rubric, monitore tendências de qualidade ao longo do tempo.

### Etapa 8: Observability e feedback loops
Logging de: latência por etapa, custo por sessão, taxa de abandono, thumb down do usuário. Esses sinais alimentam melhoria contínua do system prompt, da estratégia de retrieval e do routing.

## Arquitetura de referência

```
Usuário → Interface
           ↓
         Roteador (classifica complexidade)
           ↓
         Context Assembler
           ├─ System prompt (cacheado)
           ├─ Histórico relevante (recuperado)
           └─ Memória do usuário (vector DB)
           ↓
         LLM (modelo selecionado pelo roteador)
           ↓
         Post-processing (formatting, safety filter)
           ↓
         Resposta → Usuário
           ↓
         Logger → Avaliação assíncrona
```

## Considerações de segurança e privacidade

**Dados do usuário em prompts:** informações pessoais (preferências, histórico, dados sensíveis) que passam pelo LLM precisam de tratamento especial. Anonimização ou pseudonimização antes de enviar ao provider externo.

**Prompt injection:** o assistente pode receber inputs que tentam modificar seu comportamento. System prompt deve ter instruções explícitas sobre o que nunca fazer, independente do que o usuário pedir.

**Retenção de dados:** quanto tempo guardar o histórico de conversa e memória do usuário? Defina política clara e implemente expiração.

## Comparação de abordagens de personalização

| Abordagem | Custo | Qualidade | Tempo |
|---|---|---|---|
| Prompt engineering apenas | Baixo | Média | Dias |
| RAG + prompt | Médio | Alta | Semanas |
| Fine-tuning | Alto | Muito alta | Meses |
| RLHF completo | Muito alto | Máxima | Anos |

Para um assistente pessoal individual, RAG + prompt engineering cobre 90% dos casos de uso com fração do custo.

## Relevância para o vault

O vault opera como um assistente pessoal para Michel: o Nexus tem system prompt (CLAUDE.md), memória externa (hot.md, wiki), e recuperação por relevância. Os princípios do artigo são aplicados implicitamente. A lacuna atual: falta de observability formal (logs de qualidade, métricas de latência) e model routing explícito — o vault usa sempre o modelo padrão independente da complexidade da task.

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/retrieval-augmented-generation]]
