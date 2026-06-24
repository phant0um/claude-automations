---
title: Ciência de Dados
type: concept
status: developing
updated: 2026-04-16
tags: [data-science, machine-learning, estatistica, python, scikit-learn]
---

# Ciência de Dados

Campo interdisciplinar que combina estatística, programação e domínio de negócio para extrair insights e construir modelos preditivos a partir de dados.

## Pipeline completo (CRISP-DM)

6 etapas não lineares (sempre possível voltar):

1. **Entendimento do negócio** — qual problema? qual meta? quais variáveis relevantes? qual custo?
2. **Entendimento dos dados** — quais bases? qual periodicidade? volumetria consistente?
3. **Preparação dos dados** — limpeza, transformação, feature engineering
4. **Modelagem** — teste de algoritmos; pode requerer re-preparação dos dados
5. **Avaliação** — métricas + otimização de hiperparâmetros
6. **Deploy** — implementação em produção

## Fundamentos estatísticos essenciais

### Tipos de variáveis
| Tipo | Característica | Encoding recomendado |
|---|---|---|
| Qualitativa Nominal | Sem ordem (cores, marcas) | One Hot Encoding |
| Qualitativa Ordinal | Com ordem (escolaridade) | Label Encoding |
| Quantitativa Contínua | Decimais (peso, altura) | Normalização/Padronização |
| Quantitativa Discreta | Inteiros (n° faturas) | — |

### Medidas de centralidade
- **Média** — sensível a outliers; usada como previsão padrão em árvores de regressão
- **Mediana** — robusta a outliers; preferir quando há outliers na árvore de regressão
- **Moda** — frequência; usada como previsão em árvores de classificação

### Correlação
- **Pearson** — linear; requer normalidade e ausência de outliers extremos
- **Spearman** — monotônica; mais robusta (usa rankings)
- Heatmap (`sns.heatmap(df.corr())`) para visualizar toda a matriz

### Métricas de distância (usadas em KNN, DBSCAN, clustering)
- **Euclidiana** — linha reta; amplifica outliers (quadrático)
- **Manhattan** — soma de módulos; mais robusta
- **Minkowski** — generalização; p=1→Manhattan, p=2→Euclidiana
- **Mahalanobis** — considera correlação entre variáveis; escala-invariante

## Preparação dos dados

### Stack Python
- **Pandas** — manipulação de DataFrames
- **Scikit-learn** — preprocessing (MinMaxScaler, StandardScaler, encoders) + modelos
- **Matplotlib/Seaborn** — visualização e detecção de outliers

### Sequência de limpeza
1. Descartar colunas irrelevantes
2. Remover duplicados
3. Imputar valores nulos (média/mediana/moda/KNN)
4. Detectar e tratar outliers (IQR, z-score, gráficos)
5. Normalizar/Padronizar features (nunca a target)
6. Tratar desbalanceamento (undersampling/oversampling/class_weight)
7. Codificar variáveis categóricas (OHE ou Label Encoding)
8. Redução de dimensionalidade (PCA, SelectKBest, Boruta)

### Normalização vs Padronização
| Técnica | Fórmula | Resultado | Quando usar |
|---|---|---|---|
| Min-Max Scaler | (x-min)/(max-min) | [0,1] | Quando distribuição não é normal |
| Standard Scaler | (x-μ)/σ | média=0, dp=1 | Quando distribuição aproximadamente normal |

### Desbalanceamento de classes
- Problema: modelo aprende padrão da maioria (ex: 98% não-fraude → sempre prevê não-fraude)
- **Undersampling** — remove majoritária (perde dados)
- **Oversampling/SMOTE** — cria exemplos artificiais da minoritária (pode criar viés)
- **class_weight='balanced'** — ajusta pesos internamente; mais simples e eficaz

## Separação e validação

| Método | Descrição | Quando usar |
|---|---|---|
| Holdout | 80/20 único | Prototipagem rápida |
| K-Fold | K divisões; avaliação rotativa | Padrão para datasets tabulares |
| Stratified K-Fold | K-Fold com proporção de classes mantida | Dados desbalanceados |
| LOOCV | K=n; uma observação por vez | Datasets muito pequenos |
| Out of Time | Treino passado, teste futuro | Séries temporais (obrigatório) |

## Funções de custo e métricas de avaliação

### Regressão
| Métrica | Fórmula | Característica |
|---|---|---|
| MAE | Σ\|yi-ŷi\|/n | Robusta a outliers |
| MSE | Σ(yi-ŷi)²/n | Penaliza erros grandes |
| RMSE | √MSE | Mesma escala dos dados |
| R² | 1 - SSR/SST | Proporção de variância explicada (0 a 1) |

### Classificação (principais)
- **Log-Loss** — para probabilidades (função de custo na Regressão Logística)
- **Acurácia, Precisão, Recall, F1, AUC-ROC** — ver métricas de classificação

## Algoritmos supervisionados — resumo

| Algoritmo | Tipo | Pontos fortes | Cuidados |
|---|---|---|---|
| Regressão Linear | Regressão | Interpretável; R² claro | Pressupostos rígidos; multicolinearidade |
| Regressão Logística | Classificação | Probabilidades; MLE | Assume relação log-linear |
| Naive Bayes | Classif. | Rápido; poucos dados | Assume independência entre features |
| KNN | Ambos | Sem fase de treino; intuitivo | Sensível à escala; lento em inferência |
| Árvore de Decisão | Ambos | Interpretável; sem normalização | Overfitting sem poda |
| SVM | Ambos | Eficaz em alta dimensão; Kernel Trick | Lento em datasets grandes |
| Random Forest | Ambos | Robusto; feature importance | Menos interpretável |
| XGBoost/LightGBM | Ambos | Estado da arte em tabular | Muitos hiperparâmetros |

## Algoritmos não supervisionados — resumo

| Algoritmo | Característica | Cuidado |
|---|---|---|
| K-means | Rápido; centróides | Precisa de K pré-definido; sensível à escala |
| DBSCAN | Detecta outliers; clusters arbitrários | Sensível a epsilon e min_samples |
| Agrupamento Hierárquico | Dendrograma ajuda a escolher K | Computacionalmente custoso |
| GMM | Soft clustering; probabilístico | Assume distribuições gaussianas |

## Overfitting e Underfitting

- **Underfitting (viés alto)** — modelo simples demais; não captura padrão
- **Overfitting (variância alta)** — modelo decorou treino; não generaliza
- **Soluções para overfitting:** regularização (L1/L2), poda (árvores), mais dados, K-Fold, Random Forest, dropout (redes neurais)

## Relevância para Michel/FIAP

Complementa e supera as apostilas das Fases 3 e 5 do curso ADS. Cobertura de algoritmos de ML é muito mais aprofundada que o conteúdo visto em sala.

## Fontes

- [[02-AREAS/fiap/sources/ciencia-de-dados-luiza-reixach-castro]] — fonte principal; guia de ~110 páginas

## Evidências
- [[03-RESOURCES/sources/how-the-university-of-s-o-paulo-is-transforming-how-researchers-access-greenhouse-gas-data-for-the-amazon-rainforest-with-aws]] — Digital Amazon: 17 AWS services, 7TB, FAIR-aligned data para pesquisa climática Amazônia
