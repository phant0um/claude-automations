---
title: "The Stanford EDGAR Filings Dataset: Reconstructing U.S. Corporate and Financial Disclosures into Layout-Faithful and Token-Efficient Pretraining Data"
type: source
source: Clippings/The Stanford EDGAR Filings Dataset Reconstructing U.S. Corporate and Financial Disclosures into Layout-Faithful and Token-Efficient Pretraining Data.md
created: 2026-06-22
ingested: 2026-06-22
tags: [articles]
---

## Tese central
Conforme corpora web de alta qualidade se esgotam, documentos longos e limpos se tornam fonte escassa e cara de treino para LLMs. O Stanford EDGAR Filings Dataset (SEFD) reconstrói o arquivo público da SEC (18.5M filings, 1994–presente) em MultiMarkdown fiel ao layout — preservando estrutura que carrega significado financeiro (indentação de hierarquia contábil, headers mesclados, sinais/moeda/percentuais reanexados aos valores) — produzindo um corpus token-eficiente, quase sem overlap com Common Crawl, pronto para pretraining de longo contexto e para tarefas de raciocínio/forecasting financeiro.

## Argumentos principais
- **Motivação "quality over quantity"**: a era de "bigger is better" mostra retornos decrescentes (GPT-4.5, Llama 4 Behemoth) mesmo com pretraining escalando a 30T+ tokens; curadoria de dados (linha Phi da Microsoft) se torna o diferenciador primário de performance conforme arquiteturas convergem.
- **EDGAR é vasto mas inexplorado como pretraining**: ~4.700 filings/dia, ~40.000 novos filers/ano, mas os 18.5M filings apresentam desafios amplos de parsing por como disclosures são criadas, renderizadas e arquivadas — extrações anteriores (ex.: BeanCounter) descartam tabelas numéricas em vez de preservá-las.
- **Por que layout carrega significado**: indentação desambigua hierarquias de demonstrações financeiras; headers mesclados conectam períodos/segmentos sem repetir texto; reconstrução de células numéricas reanexa sinais, símbolos de moeda e percentuais aos valores que modificam. Achatar tabelas EDGAR (abordagem comum) cria ambiguidade — desconecta valores de labels, duplica headers, ou inverte sinais contábeis.
- **Escala e qualidade do release**: SEFD-v1 libera 152B tokens (snapshot jan/2022–jun/2025) de um corpus total estimado em 550B tokens (arquivo completo de 18.5M filings); avaliação humana mostra acurácia estrutural/semântica >99% da metodologia rule-based; overlap com corpora derivados de Common Crawl (C4) é <0.1%.
- **Dois benchmarks derivados**: EDGAR-Forecast testa raciocínio financeiro agêntico em sandbox sem acesso à internet — modelo recebe só os 5 anos anteriores de filings de uma empresa e prevê valores numéricos em filings 10-Q de 2026 publicados após o cutoff de conhecimento dos modelos avaliados. EDGAR-OCR mede LLMs pequenos/alto-throughput transcrevendo tabelas financeiras complexas para HTML, com 300 tabelas sinteticamente transformadas (entidades/datas/labels/valores substituídos, layout e relações aritméticas preservadas) para reduzir contaminação por memorização.

## Key insights
- O melhor modelo testado (GPT-5.5) atinge só 51.8% no EDGAR-Forecast (250 perguntas, 50 empresas) — sinaliza que forecasting financeiro grounded em filings reais permanece capability gap real, não resolvido por escala bruta.
- Qwen3.6-35B-A3B lidera EDGAR-OCR com 75.78% — mostra que transcrição de tabela complexa também não está saturada mesmo em modelos menores especializados.
- O dataset suporta não só pretraining, mas aplicações downstream: forecasting, compliance review, accounting QA, table extraction, document OCR evaluation, análise financeira agêntica, e construção de datasets estilo RLVR.

## Exemplos e evidências
- Comparação com corpora prévios: FinPile (BloombergGPT) é fechado e só parcialmente derivado de EDGAR; BeanCounter é a comparação aberta mais próxima (159B tokens) mas remove tabelas numéricas em vez de preservá-las; EdgarTools fornece acesso a metadados/XBRL mas não produz corpus de pretraining.
- SEFD-v1: 152B tokens, snapshot jan/2022–jun/2025; corpus completo estimado: 550B tokens, 18.5M filings.
- Overlap com Common Crawl-derived corpora (C4 etc.): <0.1%.
- Acurácia estrutural/semântica da reconstrução rule-based: >99% (avaliação humana).

## Implicações para o vault
Relevante para o interesse declarado em investimentos/finanças do vault: é uma fonte primária de dados estruturados de disclosure financeiro (10-K, 10-Q, 8-K) que pode alimentar pipelines de análise/backtesting ou servir como referência de qualidade de dado ao avaliar LLMs financeiros. Conecta com o tema de "quality over quantity" em pretraining já presente no domínio LLM & ML Foundations.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-pretraining]]
- [[03-RESOURCES/concepts/llm-ml-foundations/synthetic-training-data]]
- [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]]
