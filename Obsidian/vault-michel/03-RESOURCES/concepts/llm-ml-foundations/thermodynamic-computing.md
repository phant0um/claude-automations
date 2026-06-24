---
title: "Thermodynamic Computing"
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, llm-ml-foundations, hardware, energy-efficiency, thermodynamic]
---

# Thermodynamic Computing

## Definição

Computação que harnessa flutuações térmicas como recurso computacional ao invés de suprimi-las. Diferente de computação digital (que elimina ruído), computação termodinâmica usa o ruído como source de aleatoriedade para sampling probabilístico. Oferece ordens de magnitude de economia de energia para tarefas probabilísticas e combinatórias.

## Como funciona

- **Thermodynamic Sampling Unit (TSU)**: chip com grid de p-bits (probabilistic bits) que realizam Gibbs sampling via flutuações térmicas físicas
- **Potts model**: variáveis categóricas diretamente (mais eficiente)
- **Ising model**: variáveis binárias via domain-wall encoding (mais simples de fabricar)
- **Energy**: ~1.3 fJ per spin per Gibbs step — 5 a 9 ordens de magnitude menos que GPU

## Aplicação

[[energy-efficient-codon-optimization-on-thermodynamic-hardware]] — codon optimization para SARS-CoV-2 spike protein:
- Potts model: 1.273 variáveis categóricas, 10 sweeps
- Ising model: 3.147 binary spins, 20.000 sweeps
- GPU: ordens de magnitude mais energia para mesma qualidade de solução

## Insight

Termodynamic computing não substitui GPUs para inference de LLMs. Mas para problemas de otimização combinatória, sampling, e probabilistic inference, oferece ganho energético de 10^5 a 10^9. É uma nova categoria de hardware — não von Neumann, não GPU, não quantum. Relevante para vault porque agent loops que fazem sampling/optimization podem um dia rodar em TSUs.

## Evidências

- **[2026-06-23]** Energy-efficient codon optimization on thermodynamic hardware — 10^5 to 10^9 energy savings vs GPU — [[energy-efficient-codon-optimization-on-thermodynamic-hardware]]

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/gpu]]
- [[03-RESOURCES/concepts/llm-ml-foundations/optimization]]
- [[03-RESOURCES/concepts/llm-ml-foundations/stochastic]]