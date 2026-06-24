---
title: "AtomMem: Building Simple and Effective Memory System for LLM Agents via Atomic Facts"
type: source
source: "Clippings/AtomMem Building Simple and Effective Memory System for LLM Agents via Atomic Facts.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
AtomMem é um sistema de memória de longo prazo para agentes LLM centrado em "fatos atômicos" — unidades semânticas mínimas, auto-contidas (com resolução de correferência e ancoragem temporal já feita), organizadas em estruturas hierárquicas de eventos e perfis temporais, com recall associativo via grafo de memória. A tese é que sistemas de memória existentes enfrentam um dilema fundamental — guardar conversas brutas maximiza retenção mas sobrecarrega RAG com ruído redundante, enquanto representações condensadas via rewrite LLM-driven introduzem instabilidade (alucinações que corrompem entradas repetidamente) — e que fatos atômicos bem estruturados resolvem esse dilema, alcançando estado da arte no benchmark LoCoMo com custo computacional competitivo.

## Argumentos principais
- **O dilema da representação de memória**: armazenar conversa bruta = alta retenção, mas ruído que sobrecarrega RAG; representações condensadas (rewrite contínuo via LLM) = compactas, mas updates não-restringidos acumulam instabilidade — alucinações podem corromper repetidamente a mesma entrada, levando a expansão incontrolável e destruição de fatos originais.
- **Atomic Fact Extractor**: módulo treinado via SFT (não heurística/zero-shot, que dão resultados subótimos) que extrai fatos atômicos auto-contidos do diálogo bruto, fazendo denoising e raciocínio leve (resolução de correferência, ancoragem temporal). Cada fato é estruturado como `F = {id, c, v, P, K, T, E}` — texto, embedding denso, participantes, keywords, timestamp/intervalo temporal, e lista de IDs de eventos associados.
- **Fact Verification**: antes de armazenar, AtomMem verifica se o novo fato duplica ou conflita com registros existentes. Filtragem simbólica (participantes/contexto temporal compartilhado) reduz o espaço de busca antes de computação vetorial cara; ranking via métrica híbrida combinando similaridade de embedding semântico e similaridade Jaccard de keywords. Um LLM analisa a relação entre input novo e contexto recuperado, gerando conteúdo residual (não-redundante) para armazenar como novo fato, e um conjunto de updates apenas quando conflitos lógicos são detectados — prevenindo redundância e mantendo consistência global.
- **Event Memory**: fatos são agregados em "Eventos" (blocos narrativos coerentes) — `E = {id, S, F_ids, P_e, K_e, T_e}` (sumário, IDs de fatos constituintes, participantes/keywords/intervalo temporal do evento). Novos fatos logicamente alinhados são absorvidos em eventos existentes ou disparam criação de novo evento.
- **Temporal Profile Modeling**: camada separada para atributos estáveis de longo prazo (preferências, hábitos, background). Diferente do update em tempo real de fatos/eventos, perfis usam mecanismo batch por sessão — a LLM identifica fatos com potencial de atributo de longo prazo durante extração, e ao fim da sessão processa esses candidatos em batch. Um updater LLM decide se o candidato é redundante, atualiza o perfil atual, modifica uma versão histórica, ou cria entrada nova — preservando histórico via campo `H`.
- **Memory Graph com 3 tipos de aresta**: Entity Edge (fatos conectados por keywords compartilhadas, com peso IDF-weighted para penalizar termos frequentes não-informativos), Event Edge (fatos do mesmo evento, com penalidade por tamanho de evento para reduzir ruído de eventos muito amplos), Temporal Edge (fatos em turnos adjacentes da mesma sessão, com decaimento exponencial por distância de turno).
- **Retrieval hierárquico em 3 estágios**: (1) Primary Recall — filtra por participantes/tempo, rankeia por similaridade híbrida; (2) Compensatory Recall — busca na camada de eventos (recall implícito que keyword matching direto perderia), extrai fatos constituintes dos top eventos, exclui duplicatas do Primary; (3) Associative Recall — usa os sets combinados como seeds para ativar o grafo de memória via Random Walk with Restart (RWR), propagando ativação através das 3 arestas, selecionando os top-k fatos com maior score de ativação.

## Key insights
- O insight estrutural central é separar memória em 3 camadas com semânticas de update distintas: fatos (real-time, granular), eventos (consolidação narrativa), perfis (batch, estável, versionado com histórico) — em vez de tratar toda memória como uma única representação plana ou um único grafo de conhecimento genérico.
- O uso de RWR (Random Walk with Restart) sobre um grafo heterogêneo de 3 tipos de aresta para recall associativo é uma técnica emprestada de graph mining clássico, aplicada de forma elegante ao problema de "memórias relacionadas que keyword/vetor isolado não capturam".
- AtomMem-Flat (variante simplificada, só fact-level, sem grafo/eventos/perfis) já é competitiva com baselines fortes a custo computacional mínimo (722K tokens vs. 21.3M do AtomMem completo) — confirma que boa parte do ganho vem da qualidade da extração de fatos atômicos, e o resto (grafo+eventos+perfis) é ganho incremental mas caro em tokens.
- O mecanismo de "fact verification" com merge/update apenas em conflito lógico detectado (não rewrite livre) é uma resposta direta e cuidadosa ao problema de instabilidade de memórias dinâmicas citado como motivação central do paper.

## Exemplos e evidências
- Benchmark LoCoMo (interações de longo prazo, média 600+ turnos em 35 sessões): AtomMem atinge F1=56.66/BLEU-1=49.56/J=78.48 em single-hop, superando MEM0 (54.95/44.71/78.00), MemoryOS (49.72/43.58/66.47) e LightMem (49.30/42.45/68.97).
- Em Temporal (categoria mais difícil para a maioria dos baselines): AtomMem atinge F1=62.78/BLEU-1=57.64/J=66.98 — muito acima de MEM0 (30.36/29.69/30.53) e MemoryOS (41.99/36.32/34.58), sugerindo que a ancoragem temporal explícita nos fatos atômicos é especialmente vantajosa para perguntas dependentes de tempo.
- Custo: AtomMem-Flat usa só 722.75K tokens (mais barato que todos os baselines exceto LoCoMo raw), enquanto AtomMem completo usa 21.357,06K tokens — ainda bem abaixo de MEM0 (55.300,30K) e MemoryOS (19.207,67K), apesar de ter performance superior a ambos.
- Avaliado também em LongMemEval (500 perguntas curadas) com resultados detalhados no apêndice.

## Implicações para o vault
Atualiza diretamente [[03-RESOURCES/concepts/agent-systems/llm-memory-systems]] e [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] com uma arquitetura concreta e competitiva (SOTA no LoCoMo) que formaliza a separação fato-atômico/evento/perfil — útil como contraponto a Mem0 (grafo) e MemGPT/MemoryOS (hierárquico explícito) já mapeados na nota existente. A técnica de RWR sobre grafo heterogêneo de memória é candidata a virar referência técnica para qualquer sistema de memória pessoal/SO do vault.

## Links
- [[03-RESOURCES/concepts/agent-systems/llm-memory-systems]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
