---
title: "Mathematics for Machine Learning (MML Book) — Deisenroth, Faisal, Ong"
type: source
source: "Clippings/mml-book.md"
origin: "https://mml-book.com"
author: "Marc Peter Deisenroth, A. Aldo Faisal, Cheng Soon Ong"
published: 2020
created: 2026-05-31
ingested: 2026-05-31
tags: [math-ml, linear-algebra, probability, statistics, machine-learning, textbook, cambridge, pca, svd, regression]
---

## Tese central

MML Book (Cambridge University Press, 2020, atualizado 2024) preenche o gap entre matemática do ensino médio e o nível necessário para ler textbooks de ML modernos — coletando fundamentos matemáticos de ML em um único lugar, motivando cada conceito diretamente por sua utilidade em problemas concretos de ML. O livro é gratuito para uso pessoal em `mml-book.com`.

## Argumentos principais

- **Gap identificado**: cursos introdutórios de ML em CS assumem proficiência em programação mas não em matemática/estatística. Este livro fecha esse gap.
- **Estrutura em duas partes**:
  - **Part I — Mathematical Foundations** (Caps. 2–7): Linear Algebra, Analytic Geometry, Matrix Decompositions, Vector Calculus, Probability and Distributions, Continuous Optimization.
  - **Part II — Central Machine Learning Problems** (Caps. 8–12): When Models Meet Data, Linear Regression, PCA (Dimensionality Reduction), Gaussian Mixture Models (Density Estimation), SVMs (Classification).
- **Abordagem**: não é um ML textbook clássico — foca nos fundamentos matemáticos aplicados a 4 problemas representativos de ML, como primer para outros livros.
- **Público-alvo**: undergrad, evening learners, participantes de cursos online de ML com base matemática de ensino médio.
- **Três perfis de leitor**: Astute Listener (usa ML sem detalhes técnicos), Experienced Artist (data scientist/engineer), Informed Expert (pesquisador que entende teoria e prática).

## Key insights

1. **Motivação matemática via ML**: o livro usa ML como motivação explícita para matemática — contra a dissociação comum entre disciplinas abstratas e aplicações práticas.
2. **Quatro exemplos representativos**: Linear Regression, PCA, GMM, SVM — cobrem os padrões arquetípicos (supervisionado, não-supervisionado, probabilístico, discriminativo).
3. **Vector Calculus cap. 5**: inclui backpropagation e automatic differentiation como tópico matemático fundamental — conecta diretamente ao training de redes neurais.
4. **SVD e Matrix Approximation** (cap. 4.5–4.6): fundamento matemático para embeddings, compressão, PCA — relevante para entender representações em LLMs.
5. **Bayesian Linear Regression** (cap. 9.3): fundamento para entender incerteza em modelos — base para calibração de LLMs e probabilistic modeling.

## Exemplos e evidências

- Cap. 2 Linear Algebra: sistemas de equações lineares → matrizes → espaços vetoriais → mapeamentos lineares (progressão pedagógica completa)
- Cap. 4 Matrix Decompositions: Cholesky, Eigendecomposition, SVD, Matrix Approximation — cobrindo todas as decomposições-chave
- Cap. 6 Probability: Gaussian Distribution, Conjugacy, Exponential Family, Change of Variables — fundamentos probabilísticos completos
- Cap. 7 Continuous Optimization: Gradient Descent, Lagrange Multipliers, Convex Optimization — base matemática para training
- Cap. 10 PCA: 8 perspectivas diferentes (maximum variance, projection, eigenvector, latent variable, high dimensions) — profundidade pedagógica exemplar

## Implicações para o vault

- **Referência fundamental para ADS @ FIAP**: cobre Linear Algebra e Probability que são pré-requisitos para os cursos de IA/ML da FIAP.
- **Base para entender LLMs matematicamente**: SVD → embeddings; backpropagation → training; Bayesian inference → incerteza em LLMs.
- **Companion para concurso**: tópicos de probabilidade, álgebra linear e otimização aparecem em concursos de TI e análise de dados.
- **Gratuito e autorizado**: disponível em `mml-book.com` para uso pessoal — recurso direto sem paywall.

## Links

- [[02-AREAS/fiap/fiap-index]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[03-RESOURCES/sources/ml-research-papers/clipping-how-ml-systems-work-38-concepts]]
- [[03-RESOURCES/sources/ml-research-papers/math-behind-llm-series-amitiitbhu]]
