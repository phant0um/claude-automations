---
title: "Agentic Systems as Boosting Weak Reasoning Models"
type: source
source: "Clippings/Agentic Systems as Boosting Weak Reasoning Models.md"
arxiv: "2605.14163"
author: ["Varun Sunkaraneni", "Pierfrancesco Beneventano", "Riccardo Neumarker", "Tomaso Poggio", "Tomer Galanti"]
affiliation: "Texas A&M University / MIT"
created: 2026-05-24
ingested: 2026-05-28
tags: [ai-agents, source, arxiv, inference-time-compute, boosting, swe-bench, orchestration]
---

## Tese central

Sistemas agênticos podem ser formalizados como **inference-time boosting** de modelos de raciocínio fracos: amostras repetidas aumentam a chance de produzir um próximo passo útil, critics/comparators identificam esse passo, e progresso verificado por verifier permite que passos úteis sejam encadeados em uma solução terminal. Um comitê de chamadas de modelo nano pode alcançar a performance de modelos muito mais fortes — mas apenas quando duas condições são atendidas: **proposal coverage** (boas ações aparecem no pool) e **local identifiability** (o sistema consegue reconhecê-las).

## Argumentos principais

1. **Quatro quantidades de amplificação.** Coverage (boa ação aparece), identifiability (sistema reconhece), progress (escolhas locais se compõem), diversity (mais chamadas escapam de modos de falha diferentes).

2. **Coverage não implica identifiability.** Proposição 1 (black-box separation): probabilidade não-trivial de gerar ações progressing-sound não yield, por si só, um critic ou comparator útil. Amplificação confiável requer um sinal adicional de local identifiability — execução, proof checking, type checking, testes, ou constraint solving.

3. **Protocolo de comitê Π_{k,m,r}.** Por estado não-terminal: (1) amostrar k ações candidatas; (2) aplicar m critic calls independentes, descartar candidatos rejeitados; (3) falhar localmente se nenhum sobrevive; (4) selecionar Copeland winner entre sobreviventes com r comparator votes por par.

4. **Decomposição de erro global.** `err_x(k,m,r) ≤ L_x [B + R_k + k²·exp(−βm−2rσ²)]`
   - B = blind-spot mass (irredutível para portfolio fixo)
   - R_k = finite-sampling residual (decresce com k)
   - k²·exp(−...) = identifiability error (decresce com m e r)
   
5. **Blind-spot ceiling.** Oracle best-of-k converge para 1−B. B é irredutível: não importa quantas amostras, se todos os proposers atribuem probabilidade zero a ações úteis para certas instâncias, um critic ideal não pode recuperá-las. Reduzir B requer mudar o sistema de proposal: modelo, prompts, tools, retrieval, decomposição, ou diversidade de proposers.

6. **Resultados empíricos (SWE-bench Verified, 500 tasks).** GPT-5.4 nano single-call: 67.0%. Orchestration critic-comparator com k=8: **76.4%** — matching Gemini 3 Pro e Claude Opus 4.5 Thinking (ambos single-model). Oracle best-of-8: 79.0%. Recovery rate: ~76% do oracle gap recuperado. Falhas restantes são majoritariamente coverage failures (blind spots compartilhados), não selection failures.

## Key insights

- **Pass@1 vs oracle best-of-k vs system**: esses três números contam histórias diferentes. Pass@1 = capability one-shot. Oracle best-of-k = latent boostable capability. Gap oracle→sistema = identifiability bottleneck. Gap oracle→modelo mais forte = coverage limitation.
- **Diversity expõe capability latente.** Patches corretos já estão frequentemente no pool de propostas de nano — o problema é selecioná-los.
- **"Muitos agentes ajudam" não é o mecanismo correto.** O mecanismo correto é: coverage + identifiability + progress + diversity como recursos separáveis.
- Verifiers one-sided (tipo testes de software) são suficientes para fornecer local identifiability — e isso é o que torna código/provas/programas especialmente amenáveis ao boosting.

## Exemplos e evidências

- SWE-bench: nano 67% → orquestração 76.4% vs oracle 79% — pequeno gap de selection (2.6pp), grande gap que é blind-spot (não recuperável com melhor selection).
- Ablações: critics-only < comparators-only < critics+comparators. Complementaridade entre filtering e ranking.
- Categorias onde oracle-reachable-but-missed é pequeno: a maioria das falhas restantes são coverage failures.

## Implicações para o vault

- **Novo conceito**: [[03-RESOURCES/concepts/agent-systems/inference-time-boosting]] — formalização rigorosa de orquestração de múltiplos agentes.
- Enriquece [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] com a separação formal coverage/identifiability e o conceito de blind-spot ceiling.
- Enriquece [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]: o blind-spot ceiling é uma propriedade do proposer (model-bound); o gap oracle→sistema é harness-bound. Fornece fundamentação teórica para essa distinção.
- Importante para design de sistemas no vault: quando orquestração com múltiplos agentes ajuda (blind spots compartilhados baixos + verifier disponível) e quando não ajuda (blind spots altos → precisa de proposal diferente).
- Complementa [[03-RESOURCES/sources/ml-research-papers/agingbench-agent-lifespan-engineering-2026]] — ambos estudam propriedades do harness como sistema, não do modelo isolado.

## Links

- arxiv: https://arxiv.org/abs/2605.14163
- Conceito novo: [[03-RESOURCES/concepts/agent-systems/inference-time-boosting]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
