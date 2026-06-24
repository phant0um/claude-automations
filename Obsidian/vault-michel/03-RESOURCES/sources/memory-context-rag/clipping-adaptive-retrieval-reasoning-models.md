---
title: "When to Retrieve During Reasoning: Adaptive Retrieval for Large Reasoning Models"
type: source
source_type: paper
author: "Dongxin Guo et al. (HKU)"
created: 2026-05-06
tags: [rag, reasoning, adaptive-retrieval, multi-hop]
triagem_score: 8
---

ReaLM-Retrieve: reasoning-aware retrieval with step-level uncertainty detection, learned intervention policy, and 3.2x efficiency optimization. +10.1% F1 over standard RAG, 47% fewer retrieval calls vs fixed-interval. MuSiQue 71.2% F1 with 1.8 avg retrieval calls. arXiv:2604.26649v1.

## Source

Ingested from: `clippings/When to Retrieve During Reasoning Adaptive Retrieval for Large Reasoning Models.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## O Problema: Quando Recuperar?

RAG padrão recupera contexto uma vez antes de iniciar o raciocínio — "retrieve-then-read". Em tarefas multi-hop (questões que requerem múltiplos passos de inferência), isso falha porque: (1) a query inicial não captura o que será necessário nos steps futuros, (2) documentos recuperados no início ficam obsoletos conforme o raciocínio evolui.

A alternativa oposta — recuperar a cada step — desperdiça recursos: a maioria dos steps de raciocínio usa apenas o que já está no contexto, sem precisar de nova informação externa.

**ReaLM-Retrieve** resolve o dilema aprendendo QUANDO intervir, não como recuperar.

---

## Mecanismo: Step-Level Uncertainty Detection

O sistema monitora o raciocínio step a step. Em cada step de geração de tokens, calcula uma proxy de incerteza:

1. **Confidence scoring:** Entropia da distribuição de probabilidade sobre os próximos tokens. Alta entropia = modelo incerto sobre o que vem.
2. **Uncertainty threshold:** Se a incerteza excede o threshold θ, o step é marcado como candidato a retrieval.
3. **Learned intervention policy:** Uma política treinada (pequena rede neural) decide se deve ou não fazer retrieval dado o estado atual — evita falsos positivos onde alta entropia não implica falta de informação.

O threshold θ é calibrado por domínio durante o treinamento — questões factuais têm threshold menor que questões de raciocínio lógico (onde alta entropia pode ser intrínseca ao problema, não falta de dados).

---

## Resultados em Benchmarks

| Benchmark | Métrica | Standard RAG | Fixed-Interval | ReaLM-Retrieve |
|---|---|---|---|---|
| MuSiQue | F1 | 61.1% | 67.3% | 71.2% |
| HotpotQA | F1 | 58.4% | 63.1% | 68.5% |
| 2WikiMultiHop | F1 | 64.2% | 68.9% | 72.0% |

**Eficiência:** 1.8 chamadas de retrieval em média (vs. retrieval a cada step = 8-12 chamadas). Redução de 47% em retrieval calls comparado ao fixed-interval (retrieve a cada N steps).

**F1 global:** +10.1% sobre standard RAG, 3.2x mais eficiente que fixed-interval.

---

## Comparação de Estratégias de RAG

| Estratégia | Quando recupera | Precision | Recall | Eficiência |
|---|---|---|---|---|
| Pre-retrieval (padrão) | Uma vez, antes de raciocinar | Baixa | Baixa | Alta |
| Fixed-interval | A cada N steps | Média | Média | Baixa |
| ReaLM-Retrieve | Quando incerto | Alta | Alta | Alta |
| Always-on | A cada step | Alta | Alta | Muito baixa |

---

## Implicações para Design de Agentes RAG

**Para vault-michel:** A ideia de detectar incerteza antes de fazer retrieval é aplicável ao design de agentes de pesquisa. Em vez de sempre consultar o vault ao começar uma tarefa, um agente poderia checar sua confiança no contexto atual e só fazer retrieval se necessário.

**Para sistemas de produção:** 47% menos chamadas de retrieval traduz diretamente em latência e custo. Em sistemas onde cada retrieval é uma chamada de API (vector DB, search engine), isso é economicamente significativo.

**Limitação principal:** O threshold de incerteza precisa ser calibrado por domínio — um threshold genérico degrada performance. Isso adiciona complexidade de deployment.

---

## Conexão com Outros Trabalhos de Retrieval

- Complementa [[03-RESOURCES/sources/memory-context-rag/grep-vs-embeddings-coding-agents]] — grep/BM25 pode ser mais eficiente que embeddings em coding tasks; ReaLM-Retrieve sugere que frequência de retrieval importa tanto quanto o mecanismo.
- Contrasta com [[03-RESOURCES/sources/memory-context-rag/clipping-ocr-memory-optical-context-retrieval-full]] — OCR-Memory faz retrieval por similaridade visual de estado; ReaLM-Retrieve faz retrieval por incerteza de raciocínio. Abordagens complementares.

---

## Links

- [[03-RESOURCES/concepts/rag-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/reasoning-models]]
- [[03-RESOURCES/sources/memory-context-rag/grep-vs-embeddings-coding-agents]]

---

## Análise do Mecanismo de Detecção de Incerteza

### O Problema de Usar Entropia como Proxy de Incerteza

A escolha de entropia da distribuição de probabilidade sobre tokens como proxy de incerteza tem limitações conhecidas:

**Problema 1 — Overconfidence de modelos calibrated-poorly:** LLMs frequentemente têm entropia baixa mesmo quando factualmente errados. O modelo gera "Paris" com alta confiança como capital da França — correto. Mas também pode gerar "Napoleon foi o primeiro presidente da França" com alta confiança — incorreto. A entropia não distingue confiança calibrada de overconfidence.

**Problema 2 — Alta entropia intrínseca ao raciocínio:** Em etapas de raciocínio genuíno sobre problemas difíceis, a distribuição de probabilidade sobre tokens naturalmente tem alta entropia (o modelo considera múltiplos próximos passos válidos). Isso pode disparar retrieval desnecessariamente em exatamente o tipo de raciocínio que não precisa de informação externa — simplesmente é ambíguo por natureza.

A learned intervention policy é a solução para o Problema 2: ela aprende a distinguir "alta entropia porque genuinamente incerto sobre fato" de "alta entropia porque raciocínio complexo mas sem necessidade de informação externa." Mas isso requer dados de treinamento suficientes por domínio, o que explica a necessidade de calibração específica.

### Por Que a Arquitetura Tem Componentes Separados

A separação entre confidence scoring (entropia) e learned intervention policy não é redundância — é refinamento em cascata:

1. **Confidence scoring** é barato e sem parâmetros — apenas calcula entropia sobre tokens gerados. Filtra os steps claramente confiantes.

2. **Learned intervention policy** opera apenas sobre os steps que passaram pelo filtro de entropia. É mais cara (inferência de rede neural adicional) mas precisa de processar muito menos steps porque a maioria é filtrada na etapa anterior.

Essa cascata de filtros é padrão em sistemas de retrieval de alta performance: filtros baratos eliminam candidatos óbvios, filtros caros refinam o conjunto reduzido.

### Calibração por Domínio: O Custo Oculto

A limitação mais significativa para deployment é a calibração por domínio do threshold θ. Na prática:

- Um threshold calibrado para MuSiQue (multi-hop factual questions) vai recuperar errado no domínio de raciocínio matemático (onde alta entropia é intrínseca ao processo de prova)
- Um threshold calibrado para código vai recuperar errado em questões de conhecimento científico (onde domínios técnicos têm vocabulário de alta confiança mas fatos que o modelo não sabe)

Para sistemas que operam em múltiplos domínios (ex: um assistente de pesquisa que responde tanto sobre código quanto sobre ciência), a calibração requer múltiplos thresholds ou um classificador de domínio para selecionar o threshold correto.

Isso adiciona duas dependências ao sistema: dados de calibração por domínio e, potencialmente, um classificador de domínio. Em sistemas de produção, essas dependências têm custo de manutenção não trivial.

### Comparação de Estratégias RAG no Contexto de Agentes

A tabela de estratégias RAG do paper (pre-retrieval, fixed-interval, ReaLM-Retrieve, always-on) omite uma estratégia importante que é comum em agentes de produção: **agente-controlled retrieval**, onde o agente decide explicitamente via chamada de ferramenta quando buscar.

| Estratégia | Quem decide o retrieval | Custo de decisão | Qualidade de decisão |
|-----------|------------------------|-----------------|---------------------|
| Pre-retrieval | Sistema (fixo antes de raciocinar) | Zero | Baixa (sem informação do raciocínio) |
| Fixed-interval | Sistema (fixo a cada N steps) | Zero | Baixa (sem informação do raciocínio) |
| ReaLM-Retrieve | Sistema (baseado em entropia + política) | Baixo-médio | Alta (usa estado do raciocínio) |
| Agente-controlled | Agente (ferramenta explícita) | Alto (usa tokens de raciocínio) | Potencialmente mais alta |
| Always-on | Sistema | Zero | N/A (sempre recupera) |

Agente-controlled retrieval tem custo de tokens mais alto (o agente raciocina sobre quando buscar, depois busca) mas pode ter qualidade de decisão superior se o agente tem bom julgamento sobre quando sua incerteza é real. Claude Code usa exatamente esse modelo — o agente decide quando fazer grep/read file como parte natural do raciocínio.

### Implicação para o Vault-Michel

O princípio de detecção de incerteza antes de retrieval tem aplicação direta no design de sessões de pesquisa no vault. Um agente de pesquisa que automaticamente consulta todas as notas relevantes no início de cada tarefa está fazendo pre-retrieval — potencialmente carregando contexto que não será necessário.

A alternativa: o agente começa com apenas o hot.md e o índice da área relevante, raciocina até identificar especificamente quais notas precisa, então faz retrieval seletivo. Isso implementa o princípio de ReaLM-Retrieve em escala de vault: retrieval guiado por necessidade específica identificada durante raciocínio, não retrieval preventivo de tudo potencialmente relevante.
