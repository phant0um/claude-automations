---
title: "How Paperclip With Hermes Agent Runs 10 Agents At Once"
type: source
source: Clippings/How Paperclip With Hermes Agent Runs 10 Agents At Once.md
created: 2026-05-17
ingested: 2026-05-17
tags: [ai-agents, hermes, paperclip, orchestration]
triagem_score: 8
---

## Tese central
Paperclip + Hermes orquestra 10 agentes em paralelo via control room — viabiliza throughput multi-stream sem perda de coerência por separação rigorosa de contexto entre agentes. Demonstração prática de arquitetura de plataforma multi-agente funcional em uso real.

## Key insights
- **Paperclip = scheduler; Hermes = executor:** separação de concerns clara. Paperclip decide QUANDO e O QUE cada agente faz. Hermes executa a tarefa, usa ferramentas, retorna resultado. Não misturar as funções
- **Control room UI para supervisão não-gargalo:** interface centralizada mostra estado de todos os 10 agentes simultaneamente — humano pode intervir em qualquer um sem parar o sistema. Supervisão passiva (olhar) vs ativa (intervir) são modos distintos
- **Isolamento de contexto é o enabler:** 10 agentes em paralelo funcionam porque cada um tem contexto completamente isolado. Sem isolamento, agentes interferem entre si, resultados se misturam, coerência colapsa
- **Limitação real: isolamento de contexto, não scheduler:** scheduler (Paperclip) pode orquestrar 1000 agentes teoricamente. Gargalo prático é custo de tokens × paralelismo — 10 agentes simultâneos × custo por agente é decisão econômica, não técnica

## Arquitetura Paperclip + Hermes

### Paperclip: camada de orquestração

Responsabilidades:
- **Task queue:** recebe tarefas, prioriza, distribui para agentes disponíveis
- **Agent pool management:** monitora quais agentes estão livres, ocupados, ou em erro
- **Rate limiting:** controla quantas chamadas de API paralelas para não exceder limits
- **Retry logic:** reagenda tarefas que falharam com backoff exponencial
- **Result aggregation:** coleta outputs de agentes paralelos e organiza para consumo humano

Paperclip não tem inteligência de tarefa — é infra pura de scheduling.

### Hermes: camada de execução

Responsabilidades:
- **Context management:** carrega contexto específico da tarefa (sem contaminar com estado de outros agentes)
- **Tool execution:** chama ferramentas, processa resultados, itera conforme necessário
- **Error handling:** detecta erros, decide se tenta recover ou escala para Paperclip
- **Output formatting:** formata resultado para ingestão pelo agregador do Paperclip

Hermes não sabe de outros agentes em execução — isolation total.

## Control Room UI

### O que mostra

Para cada um dos 10 agentes:
- Status atual (running, waiting, error, done)
- Tarefa sendo executada (título/descrição)
- Progress indicator (step atual / total estimado)
- Output parcial (stream de output conforme agente produz)
- Custo acumulado (tokens usados)

### Modos de interação humana

**Supervisão passiva:** humano apenas observa. Sistema roda de forma autônoma. Intervenção só se agente entra em estado de erro ou produz output claramente errado.

**Intervenção cirúrgica:** humano pode pausar agente específico, modificar instrução, e retomar — sem afetar outros 9. Control room viabiliza isso sem parar o sistema inteiro.

**Escalation:** quando Hermes encontra ambiguidade que não consegue resolver, escala para control room como notificação. Humano decide, sistema continua.

## Por que 10 agentes especificamente

10 é ponto empírico de equilíbrio observado em uso real:
- Abaixo de 5: paralelismo insuficiente para throughput significativo
- 10-15: zona de eficiência — humano consegue supervisionar sem overwhelm cognitivo
- Acima de 20: supervisão humana fica inviável, necessidade de meta-agente de supervisão

"10 agentes" não é limite técnico — é limite ergonômico de supervisão humana.

## Casos de uso demonstrados

1. **Research paralelo:** 10 agentes pesquisam 10 tópicos diferentes simultaneamente. Paperclip agrega resultados em relatório unificado
2. **Processamento de batch:** 10 agentes processam 10 documentos em paralelo (ingestão, análise, categorização)
3. **A/B de abordagem:** 5 agentes com estratégia A, 5 com estratégia B na mesma tarefa. Comparação de resultados revela melhor abordagem
4. **Pipeline com estágios:** Paperclip orquestra 10 agentes em pipeline, cada um pegando output do anterior

## Limitações

- **Custo:** 10 agentes simultâneos = 10× custo de tokens. Justificado apenas quando latência importa mais que custo
- **Debugging:** error em agente paralelo pode ser difícil de rastrear se logging não for granular o suficiente
- **State compartilhado:** tarefas que precisam de state compartilhado entre agentes requerem coordenação extra (shared memory ou mensageria) — arquitetura não resolve isso nativamente

## Comparação com orquestração sequencial

Custo vs latência: processar 10 tarefas sequencialmente = 10× latência, 1× custo. Em paralelo = 1× latência (mais overhead), 10× custo.

Quando paralelo vale:
- Tarefas independentes (sem dependência de resultado de umas nas outras)
- Latência crítica (usuário esperando resultado combinado)
- Batch de trabalho com deadline (processar 100 fontes em 1 hora vs 10 horas)

Quando sequencial vale:
- Tarefas dependentes (output de A é input de B)
- Custo é constraint primário
- Volume pequeno onde overhead de orquestração domina

## Padrão hermes-paperclip como referência arquitetural

Para quem vai construir sistema similar, Paperclip+Hermes demonstra que a separação scheduler/executor é o design correto — não misturar orquestração com execução no mesmo agente. Cada agente Hermes pode ser implementado com Claude, GPT-4, ou modelo especializado conforme task requirements, enquanto Paperclip permanece model-agnostic.

## Links
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-platform-architecture]]
