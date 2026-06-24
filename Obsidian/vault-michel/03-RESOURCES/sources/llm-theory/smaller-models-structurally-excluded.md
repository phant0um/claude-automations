---
title: "Smaller Models Don't Just Underperform. They're Structurally Excluded."
type: source
source: "Clippings/Smaller Models Don't Just Underperform. They're Structurally Excluded..md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents, llm-ml-foundations, model-compression, scaling-laws]
---

## Tese central

Modelos pequenos não são versões "subtreinadas" de modelos grandes que eventualmente alcançariam o mesmo nível com mais dados. Existe uma porção da distribuição de treino que um modelo pequeno **nunca** vai aprender — não importa quanto tempo ou dado adicional receba. Não é um gap de eficiência amostral, é um tipo de falha estruturalmente diferente: exclusão por capacidade.

## Argumentos principais

### Scaling laws escondem uma descontinuidade

- Scaling laws tradicionais sugerem uma curva suave: perda decresce previsivelmente conforme o modelo cresce, e a leitura comum é "modelo pequeno = modelo grande subtreinado".
- O paper (Stanford, Harvard, MIT, Anthropic) mostra que isso é falso para uma porção relevante do que os modelos precisam aprender.
- Duas leis de escala diferentes:
  - Compute finito: `L_C(N) ∝ N^(-0.34)`
  - Dados infinitos: `L_inf(N) ∝ N^(-0.46)`
- Como o expoente de dados infinitos (0.46) é maior que o de compute finito (0.34), a **perda assintótica** de um modelo grande é melhor que a de um modelo pequeno — mesmo com dados infinitos para o pequeno.
- Conclusão: existe uma parte da distribuição de treino que o modelo pequeno falha em aprender mesmo sob treino infinito. No gráfico do paper, a região roxa é o que o modelo pequeno alcança com mais dados; a região laranja abaixo é acessível **apenas** a modelos maiores — o pequeno não está "atrás", está **excluído**.

### Mecanismo: neurônios como recurso disputado

- Durante o treino, cada tarefa na mistura de dados compete pelos neurônios do modelo.
- Tarefas frequentes geram sinais de gradiente fortes e consistentes; tarefas raras geram sinais fracos e esporádicos.
- Em modelos pequenos, tarefas frequentes vencem essa disputa de forma decisiva: o sinal de uma tarefa rara chega, ajusta levemente alguns pesos, e é sobrescrito pelo próximo lote de updates de tarefas frequentes antes de acumular algo durável.
- O paper chama isso de **"update-and-forget loop"**: "In a small model, the same parameters face more competition: updates from frequent tasks undo the rare-task update before the next rare batch arrives. Rare-task learning then becomes an update-and-forget loop."
- Base formal: **Theorem 4** — limita a norma do gradiente de um conjunto de tarefas pela quantidade de covariância não explicada pela representação atual (o "residual signal"). Quando o modelo já aprendeu bem as tarefas frequentes, o residual delas cai a zero, seus gradientes enfraquecem, e elas param de interferir com o resto.
- Modelo grande tem capacidade suficiente para chegar nesse ponto; modelo pequeno nunca chega — os gradientes das tarefas frequentes permanecem fortes durante todo o treino, sobrescrevendo perpetuamente os sinais raros.

### Theorem 3 — ranking de utilidade

- Um modelo de largura N aprende features na ordem do seu **utility score**: `utility(k, j) = task_frequency(k) × feature_complexity(k, j)`.
- Features de maior utilidade são aprendidas primeiro; features de menor utilidade exigem modelos maiores.
- Uma tarefa rara com features complexas tem utility score baixo em todas as dimensões — precisa de um modelo grande o suficiente para já ter satisfeito todas as features de alta utilidade, deixando capacidade residual disponível para as raras.
- Isso transforma o dimensionamento de modelo de uma questão empírica (rodar ablations até funcionar) em um **problema de raciocínio**: dado a frequência e complexidade aproximada de uma tarefa, dá para estimar o tamanho mínimo de modelo necessário.

## Key insights

- **Tamanho de modelo é pré-requisito, não dial de performance.** Se a tarefa que importa é rara na distribuição de treino, existe um tamanho mínimo de modelo abaixo do qual ela simplesmente não será aprendida — mais tempo de treino não muda isso.
- **Mais dados em casos raros é necessário, mas não suficiente.** Aumentar a frequência de tarefas raras no fine-tuning eleva o utility score, mas abaixo de certo tamanho de modelo os gradientes de tarefas frequentes ainda dominam e sobrescrevem. Os dois alavancas (tamanho + frequência) são necessárias.
- **Design de mistura de dados é um problema de alocação de capacidade.** O framework de utilidade permite raciocinar explicitamente: quais tarefas são raras? quão complexas? que tamanho de modelo isso implica?
- **Post-training pode às vezes corrigir o que o pré-treino perdeu** — funciona quando a distribuição de fine-tuning é concentrada o suficiente na tarefa rara para vencer a interferência. Mas não é garantido e não resolve o problema de capacidade subjacente.
- **O ganho de escala é em degraus, não suave.** Um modelo logo abaixo do limiar de capacidade para tarefas frequentes e um logo acima podem parecer quase idênticos em benchmarks médios — mas seu comportamento em inputs raros é completamente diferente.
- A pergunta certa ao avaliar um modelo não é só "qual a performance média?", mas **"quais partes da distribuição esse modelo efetivamente cruzou o limiar de capacidade para aprender?"**. A maioria dos setups de avaliação só responde à primeira pergunta.

## Exemplos e evidências

### Experimento 1 — Diagrama de fases
- Modelos de larguras variadas treinados em 32 tarefas de regressão com frequências controladas.
- Resultado: diagrama de fases nítido — laranja = tarefa aprendida, roxo = não aprendida.
- Padrão de "escada": tarefas mais raras só entram na região laranja em larguras de modelo maiores.
- As linhas tracejadas (predições analíticas via Theorem 3, baseadas em utility score) batem quase exatamente com as fronteiras empíricas — as fronteiras foram **previstas pela teoria antes dos experimentos rodarem**.

### Experimento 2 — Interferência em tempo real
- Injetam uma tarefa rara no meio do treino e acompanham se o sinal acumula ou decai entre injeções.
- Modelo pequeno (N=32): sinal sobe quando exemplos raros chegam, decai a zero antes da próxima injeção — tendência geral plana ("aprende e esquece" em loop).
- Modelo grande (N=256): sinal sobe e a baseline tende para cima — cada exposição constrói sobre a anterior, compondo aprendizado da tarefa rara ao longo de milhares de updates de tarefas frequentes.

### Experimento 3 — Pré-treino de LLM real
- Modelos OLMo de 4M a 4B parâmetros, treinados no corpus Dolma, com tarefas novas injetadas (aritmética modular, operações de comparação com tokens aleatórios) em frequências controladas.
- Mesmo resultado: só modelos maiores aprendem as tarefas infrequentes. Modelos maiores também embutem mais features de Fourier específicas de tarefa em suas representações e mostram menos interferência de gradiente entre tarefas — exatamente como previsto pela teoria.

## Implicacoes para o vault

- Reforça e formaliza o tradeoff custo-qualidade já documentado em [[03-RESOURCES/concepts/model-routing]]: roteamento para modelo pequeno não é só "mais lento/mais barato e um pouco pior" — para tarefas raras na distribuição de treino do modelo pequeno, pode ser **estruturalmente impossível** de acertar, independente de prompt ou retries.
- Acrescenta nuance a [[03-RESOURCES/concepts/model-compression]]: compressão (quantização, pruning, distillation) reduz capacidade — e por esse paper, reduzir capacidade abaixo de um limiar pode eliminar completamente a habilidade do modelo de lidar com casos de cauda longa, não apenas degradar gradualmente.
- Para sistemas de agentes (roteamento, fallback): "será que o modelo menor consegue resolver isso com mais contexto/exemplos?" pode ter resposta "não, nunca" se o caso for raro o suficiente na distribuição de pré-treino — argumento a favor de manter modelos maiores como fallback para a cauda longa, não apenas para tarefas "complexas" em média.

## Links

- [[03-RESOURCES/concepts/model-routing]]
- [[03-RESOURCES/concepts/model-compression]]
- [[03-RESOURCES/concepts/model-selection-patterns]]
