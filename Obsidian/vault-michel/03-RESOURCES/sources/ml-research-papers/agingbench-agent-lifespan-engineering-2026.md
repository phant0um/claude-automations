---
title: "Your Agents Are Aging Too: Agent Lifespan Engineering for Deployed Systems"
type: source
source: "Clippings/Your Agents Are Aging Too Agent Lifespan Engineering for Deployed Systems.md"
arxiv: "2605.26302"
author: ["Jianing Zhu", "Yeonju Ro", "John T. Robertson", "Kevin Wang", "Junbo Li", "Haris Vikalo", "Aditya Akella", "Zhangyang Atlas Wang"]
affiliation: "University of Texas at Austin"
published: 2026-05-25
created: 2026-05-27
ingested: 2026-05-28
tags: [ai-agents, source, arxiv, agent-memory, agent-lifespan, benchmark, aging]
---

## Tese central

Agentes de longa duração degradam de forma silenciosa após o deploy, mesmo com pesos do modelo congelados. A confiabilidade é uma **propriedade de vida útil do harness completo**, não uma propriedade snapshot do modelo base. **AgingBench** introduz a prática de **Agent Lifespan Engineering (ALE)**: medir não apenas *se* os agentes degradam, mas *como* e *onde* a reparação deve ser direcionada.

## Argumentos principais

1. **Agent aging como nova classe de falha de deploy.** Um agente deployed é um harness (LLM + escrita de memória + armazenamento + retrieval + utilização + tools + prompts). Mesmo com pesos congelados, o estado efetivo muda: compressão de histórico, acumulação de memórias similares, revisão de fatos, manutenção de rotina. Degradação pode ser gradual e parcialmente oculta.

2. **Quatro mecanismos de aging:**
   - **Compression aging**: write-time summarization descarta detalhes relevantes futuros (valores em dólar, nomes próprios, valores de constraint são os primeiros a ir)
   - **Interference aging**: entradas similares acumuladas competem e obscurecem o fato alvo durante retrieval — mesmo sem perda de informação e sem mudança de fatos
   - **Revision aging**: fatos mudam mas o agente não propaga updates; forma especialmente difícil: *dynamic latent state* onde respostas derivadas de updates acumulados geram erros que se compõem
   - **Maintenance aging**: eventos de ciclo de vida rotineiros (recompactação, flush, migração de prompts) alteram silenciosamente o comportamento — regressão abrupta pós-evento

3. **Taxonomia acumulation-driven vs event-driven.** Compression e interference pioram com o crescimento do estado ao longo do tempo. Revision e maintenance são disparados por mudanças discretas no ambiente ou no agente.

4. **AgingBench: benchmark longitudinal.** Usa temporal dependency DAG que codifica: version chains (fact supersession), dependency edges (probes multi-sessão), interference pairs (entidades confundíveis). Geradores programáticos produzem streams de tarefas controláveis com seed reproduzível. Métricas: half-life t½, decay slope, hazard proxy.

5. **Decomposição do pipeline de memória.** Quatro componentes como attribution targets: W (write/compression policy), S (memory store), R (read/retrieval), U (utilization logic). Probes contrafactuais P1/P2/P3: baseline → oracle retrieval → oracle context. O laddering revela qual estágio é responsável pela falha.

6. **Resultados principais (14 modelos, 7 cenários, ~400 runs):**
   - **Finding I**: aging é multidimensional — nenhum modelo domina consistentemente em todos os mecanismos
   - **Finding II**: compliance comportamental e precisão factual degradam independentemente (CVR fica em 0 enquanto precisão cai → invisível para monitoramento comportamental)
   - **Finding III**: revision aging é representacional, não de capacidade — sem melhora consistente com modelos maiores
   - **Finding IV**: agentes autônomos (Tier 2): workspace fidelity > downstream recall — o write–read gap persiste
   - **Finding V**: Opus-4.7 tem lowest pytest/ws_fid mas métricas de retrieval competitivas — falha no estágio de escrita (artifacts), não no raciocínio

## Key insights

- **"Mesma resposta errada, reparações diferentes."** Taxa de erro agregada de ~0.60–0.82 mas composição U/W/R é heterogênea entre modelos e cenários. S1 precisa de operadores de estágio de utilização; S2 precisa de compaction prompt que preserva valores; S5 precisa de forçar re-reads. Score único de memória descarta o sinal de deploy que mais importa.
- **Surface-reliability gap**: agentes continuam respondendo fluentemente e com confiança enquanto o valor exato desapareceu, a entidade errada foi recuperada ou um fato obsoleto permanece ativo.
- A benchmark só avalia política de compaction básica — mais complexas podem ser plugadas como U alternativo.
- Claude Code Sonnet-4.6 teve os melhores resultados gerais em Tier 2 (ws_fid=0.83, interference=0.92, revision=1.00, recall=0.74).

## Exemplos e evidências

- Cenário S2 (Lifestyle Assistant): constraint violations ficam em 0 mas precision cai — monitores comportamentais não detectam.
- Scenario S7 (Self-Planning, autonomous): Claude Code Haiku-4.5 teve maior maintenance shock (−0.21); GPT-4o teve resultado positivo em shock (interpretado como floor effect).
- Memory policy contrast: "careful compression" melhora S1 half-life e S2 precision mas às vezes piora interference — trade-offs entre mecanismos.

## Implicações para o vault

- **Novo conceito crítico**: [[03-RESOURCES/concepts/agent-systems/agent-lifespan-engineering]] — ALE como disciplina distinta de avaliação de agentes.
- Enriquece [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] com os quatro mecanismos de aging e o pipeline W→S→R→U.
- Enriquece [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]] com a perspectiva longitudinal vs. snapshot.
- Implicação direta para o vault: o vault usa um agente (Michel) que acumula memória ao longo do tempo em `hot.md` e `MEMORY.md` — os mesmos mecanismos de compression aging e revision aging se aplicam.
- Contradiction potencial com [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]: esse conceito foca em **arquitetura** de memória; ALE foca em **degradação ao longo do tempo** — são complementares, não rivais.

## Links

- arxiv: https://arxiv.org/abs/2605.26302
- AgingBench: https://AgingBench.github.io/
- Conceito novo: [[03-RESOURCES/concepts/agent-systems/agent-lifespan-engineering]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
