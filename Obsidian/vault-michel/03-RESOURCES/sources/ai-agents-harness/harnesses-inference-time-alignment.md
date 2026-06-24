---
title: "Harnesses for Inference-Time Alignment over Execution Trajectories"
type: source
source: "Clippings/Harnesses for Inference-Time Alignment over Execution Trajectories.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, harness, inference-time, agent-theory]
---

## Tese central

Harness design é um problema de alinhamento de trajetórias: estrutura imposta precisa corresponder à capacidade do agente e às evidências disponíveis. Harnesses mais elaborados não são uniformemente melhores — over-decomposição e over-pruning degradam performance — e harnesses parciais (especificando apenas os passos iniciais) frequentemente superam workflows totalmente estruturados.

## Argumentos principais

- **Dois mecanismos separáveis no harness**: (1) task decomposition — estrutura o que o agente deve alcançar a cada etapa; (2) guided execution — restringe como o agente age dentro de cada etapa
- **Granularidade ótima não é máxima** — decomposição deve alinhar a escala dos sub-objetivos com o "progresso controlável" do agente dado o tolerance e retry budget
- **Guidance só ajuda quando alinhada** — guidance que favorece ações que seguem a instrução em vez das evidências da tarefa causa "hallucinated execution" (agente faz o que foi dito, não o que a situação requer)
- **Over-pruning** — guidance muito restritiva elimina ações válidas do espaço de busca do agente
- **Harnesses parciais superam completos** — especificar apenas os primeiros passos e deixar o restante para o agente produz maior pass rate que workflows totalmente estruturados

## Key insights

- O "bitter lesson" de AI aparece no design de harness: estrutura humana ajuda no curto prazo mas limita adaptação e escala
- Partial harness = bootstrapping que não engessa: dá direção inicial sem comprometer flexibilidade posterior
- Stage-level gaps: medir o gap de performance por etapa revela onde o harness ajuda e onde atrapalha
- Failure modes nomeados: over-decomposition (muitos sub-goais), over-pruning (guidance elimina ações válidas), hallucinated execution (segue instrução não evidência)

## Exemplos e evidências

- Validação: experimentos sintéticos controlados + real terminal agent benchmarks
- Southern University of Science and Technology
- Framework teórico formal com predições validadas empiricamente

## Implicações para o vault

- Pipeline diário é um harness — este paper justifica por que o pipeline não especifica cada micro-step do ingest: deixa espaço para o agente adaptar
- O `@nexus` como gate/guide parcial (não micromanagement) está teoricamente correto
- Confirma design de skills como "primeiros passos" + agente decide o restante

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]]
- [[03-RESOURCES/sources/life-harness-runtime-adaptation]]
