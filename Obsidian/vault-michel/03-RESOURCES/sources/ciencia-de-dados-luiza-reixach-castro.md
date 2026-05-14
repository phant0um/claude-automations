---
title: Data Science — Um Guia Teórico de Ciência de Dados e Machine Learning
type: source
source_file: .raw/ebooks/PDF CIENCIA DE DADOS -  LUIZA REIXACH CASTRO.pdf
author: Luiza Reixach Castro
revisao: Matheus Borges
date_ingested: 2026-04-16
tags: [data-science, machine-learning, estatistica, python, scikit-learn]
---

# Data Science — Luiza Reixach Castro

Guia teórico abrangente de Ciência de Dados e Machine Learning (~110 páginas). Cobertura desde fundamentos estatísticos até algoritmos supervisionados e não supervisionados, com exemplos práticos em Python/Pandas/Scikit-learn.

## Estrutura do livro

4 grandes seções:
1. **Fundamentos da Estatística** — variáveis, medidas de posição/dispersão, outliers, testes de hipótese, distribuições, correlação, métricas de distância
2. **Preparação dos dados** — Pandas/Matplotlib/Seaborn/Scikit-learn, limpeza, imputação, normalização, desbalanceamento, encoding, PCA, feature selection
3. **Conceitos Fundamentais para ML** — CRISP-DM, treino/teste/validação, funções de custo, tipos de aprendizado, métricas de avaliação, hiperparâmetros, overfitting/underfitting
4. **Aprendizado Supervisionado** — Regressão Linear, Regressão Logística, Naive Bayes, KNN, Árvore de Decisão, SVM, Ensemble (Random Forest, Adaboost, Gradient Boosting, XGBoost, LightGBM)
5. **Aprendizado Não Supervisionado** — K-means, DBSCAN, Agrupamento Hierárquico, GMM
6. **Conteúdos extras** — Glossário, perguntas técnicas, tabela de hiperparâmetros

## Fundamentos Estatísticos

### Tipos de variáveis
- **Qualitativa Ordinal** — categórica com ordem natural (escolaridade, renda alta/média/baixa)
- **Qualitativa Nominal** — categórica sem ordem (cores, marcas)
- **Quantitativa Contínua** — valores decimais (peso, altura)
- **Quantitativa Discreta** — valores inteiros (número de faturas)

### Medidas de posição
- **Média** — sensível a outliers (x̄ = Σxi/n)
- **Mediana** — robusta a outliers; usada em árvores de regressão com muitos outliers
- **Moda** — frequência; usada em árvores de classificação (predição = moda da classe)

### Medidas de dispersão
- **Variância** — média dos quadrados dos desvios; amostral divide por (n-1) para estimativa não-tendenciosa
- **Desvio padrão** — raiz da variância; mesma escala dos dados

### Outliers — métodos de detecção
- **IQR** — `Q1 - 1.5*IQR` e `Q3 + 1.5*IQR` (boxplot)
- **Z-score** — pontos abaixo de -3 ou acima de +3 desvios-padrão
- Também via DBSCAN (não supervisionado) ou Árvore de Decisão (supervisionado)

### Testes de hipótese
- **H0** (nula) — o que se assume verdadeiro; objetivo é encontrar evidências para rejeitar
- **H1** (alternativa) — existência de efeito
- **p-valor** — probabilidade de obter resultado tão extremo se H0 verdadeira
- **Nível de significância α** — geralmente 0.05; rejeita H0 se p-valor < α
- **Erro tipo I** — rejeitar H0 sendo ela verdadeira (falso positivo)
- **Erro tipo II** — aceitar H0 sendo ela falsa (falso negativo)

### Distribuições importantes
| Distribuição | Tipo | Uso em ML |
|---|---|---|
| Normal | Contínua | Gaussiano Naive Bayes; pressuposto Regressão Linear |
| Bernoulli | Discreta | Regressão Logística, Bernoulli NB (variável binária) |
| Binomial | Discreta | n tentativas independentes |
| Poisson | Discreta | Contagem de eventos em intervalo fixo |
| Geométrica | Discreta | Tentativas até primeiro sucesso |

### Correlação
- **Pearson** — linear, paramétrica; requer distribuição normal e relação linear
- **Spearman** — não-linear, usa rankings; menos restritiva

### Métricas de distância
- **Euclidiana** — linha reta; sensível a outliers (termo quadrático amplifica)
- **Manhattan** — soma de módulos; mais robusta a outliers
- **Minkowski** — generalização (p=1 → Manhattan; p=2 → Euclidiana)
- **Mahalanobis** — considera correlação entre variáveis; escala-invariante

## Preparação dos dados

### Stack Python
- **Pandas** — manipulação de DataFrames; base para outras bibliotecas
- **Matplotlib** — visualização base; customizável
- **Seaborn** — visualização de alto nível (usa Matplotlib)
- **Scikit-learn** — modelos ML + preprocessing

### Pipeline de limpeza
1. Descartar colunas irrelevantes (`df.drop`)
2. Remover duplicados (`df.drop_duplicates()`)
3. Tratar valores nulos:
   - Excluir linhas (`dropna`) — só se poucos
   - Imputar com **média** (numéricas sem outliers), **mediana** (com outliers), **moda** (categóricas)
   - Imputar com **KNN** — usa outras features; requer normalização prévia
4. Detectar e tratar outliers (IQR, z-score, scatterplot, histograma)
5. Padronizar/Normalizar:
   - **Min-Max Scaler** → intervalo [0,1]; `x_norm = (x - x_min)/(x_max - x_min)`
   - **Standard Scaler (Z-score)** → média 0, desvio padrão 1; `z = (x - μ)/σ`
6. Tratar desbalanceamento:
   - **Undersampling** — remove maioria (perde dados relevantes)
   - **Oversampling (SMOTE)** — cria exemplos artificiais da minoria
   - **class_weight='balanced'** — hiperparâmetro que ajusta pesos automaticamente
7. Codificar variáveis categóricas:
   - **One Hot Encoding** — nominal sem ordem (cria coluna binária por categoria)
   - **Label Encoding** — ordinal com ordem natural (atribui inteiro)
8. Redução de dimensionalidade:
   - **PCA** — combina variáveis correlacionadas em componentes não correlacionados
   - **SelectKBest**, **baixa variância**, **regularização L1**, **Boruta**, **Permutation Importance**

## Conceitos Fundamentais de ML

### CRISP-DM (6 etapas não lineares)
1. Entendimento do negócio
2. Entendimento dos dados
3. Preparação dos dados
4. Modelagem
5. Avaliação
6. Implementação (Deploy)

### Separação treino/teste/validação
- **Holdout** — divisão única 80/20; simples mas enviesável
- **K-Fold Cross Validation** — divide em K folds; avalia em cada; métrica = média das K performances
- **Stratified K-Fold** — mantém proporção das classes em cada fold (datasets desbalanceados)
- **LOOCV** — K = n; preciso mas computacionalmente custoso
- **Out of Time** — treino no passado, teste no futuro; obrigatório para séries temporais

### Funções de custo
| Função | Problema | Característica |
|---|---|---|
| MAE | Regressão | Robusto a outliers (valor absoluto) |
| MSE | Regressão | Penaliza erros grandes (quadrático); sensível a outliers |
| RMSE | Regressão | Raiz da MSE; mesma escala dos dados |
| Log-Loss | Classificação | Máxima verossimilhança; penaliza probabilidades erradas |

### Métricas de avaliação — Regressão
- **MAE**, **MSE**, **RMSE**, **MAPE** (%), **R²** (proporção de variância explicada; quanto mais variáveis, maior R² → usar R² ajustado)

### Tipos de aprendizado
- **Supervisionado** — dados rotulados; aprende padrões feature→target
  - **Regressão** — target numérico (previsão de renda, limite)
  - **Classificação** — target categórico (inadimplente ou não, sexo)
- **Não supervisionado** — sem rótulos; descobre estrutura nos dados (clustering)

## Algoritmos supervisionados

### Regressão Linear
Encontra a reta que minimiza o erro entre previsão e valor real. Pressupostos: linearidade, normalidade dos resíduos, ausência de multicolinearidade, homocedasticidade.
- **Funções de custo:** MAE, MSE
- **Otimização:** Gradiente Descendente ou Mínimos Quadrados
- **Regularização L1 (Lasso)** — força coeficientes irrelevantes a zero (feature selection embutida)
- **Regularização L2 (Ridge)** — penaliza coeficientes grandes sem zerá-los

### Regressão Logística
Classifica usando sigmoid (output entre 0 e 1). Função de custo: Log-Loss (MLE).

### Naive Bayes
Baseia-se no Teorema de Bayes; assume independência entre features. Tipos: Gaussiano, Bernoulli, Multinomial.

### KNN
Classifica/regride por maioria entre os K vizinhos mais próximos. Lazy learner (sem fase de treino). Sensível à escala → normalizar. K ótimo via elbow method.

### Árvore de Decisão
Estrutura hierárquica de perguntas. Impureza: Gini e Entropia. Previsão: média (regressão) ou moda (classificação). Sujeita a overfitting → poda (pruning).

### SVM
Encontra o hiperplano de máxima margem. Kernel Trick transforma features para espaço dimensional maior onde dados são linearmente separáveis.

### Modelos de Ensemble (Bagging e Boosting)
- **Random Forest** — múltiplas árvores independentes (Bagging); vota/média; mais robusto ao overfitting
- **Adaboost** — árvores sequenciais; cada uma foca nos erros da anterior (Boosting)
- **Gradient Boosting** — minimiza função de custo sequencialmente via gradiente
- **XGBoost** — crescimento level-wise; regularização embutida; eficiente
- **LightGBM** — crescimento leaf-wise; mais rápido que XGBoost em datasets grandes

## Algoritmos não supervisionados

### K-means
Agrupa em K clusters por centróide. Algoritmo iterativo: atribui pontos ao centróide mais próximo → recalcula centróides → repete até convergência.

### DBSCAN
Baseado em densidade. Não precisa de K pré-definido; detecta clusters de formato arbitrário e identifica outliers. Parâmetros: `epsilon` (raio) e `min_samples`.

### Agrupamento Hierárquico
Aglomerativo (bottom-up): cada ponto começa como cluster; une os mais próximos iterativamente. Dendrograma ajuda a definir número de clusters.

### GMM (Gaussian Mixture Models)
Soft clustering — cada ponto tem probabilidade de pertencer a cada cluster. Algoritmo EM (Expectation-Maximization).

## Relevância para o vault

- **Michel/FIAP** — complementa conteúdo de ML do curso ADS; detalhamento muito superior às apostilas
- **SEI Agent** — conceitos de preparação de dados e modelos relevantes para análise de documentos
- Conexão com [[03-RESOURCES/entities/Python]] e [[03-RESOURCES/concepts/orientacao-a-objetos]] (FIAP Fases 1-3)

## Links internos

- [[03-RESOURCES/concepts/ciencia-de-dados]] — conceito central expandido desta fonte
- [[03-RESOURCES/entities/Luiza-Reixach-Castro]] — autora
- [[03-RESOURCES/entities/Python]] — linguagem usada nos exemplos
