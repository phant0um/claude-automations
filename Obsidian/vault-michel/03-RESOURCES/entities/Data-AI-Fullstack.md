---
title: Data & AI (Fullstack Agent System)
type: entity
subtype: agent
created: 2026-05-14
updated: 2026-05-14
tags: [agent, data, ml, llm, rag, fullstack, claude-opus-4-7, etl, mlops]
---

# Data & AI — Fullstack Agent System

Engenheiro de dados e IA sênior do [[Fullstack-Agent-System|Fullstack Agent System]]. Projeta e implementa pipelines de dados confiáveis, modelos de ML em produção e sistemas baseados em LLMs. **Modelo Opus** porque decisões de arquitetura de dados e design de RAG têm alto impacto.

**Modelo primário:** `claude-opus-4-7`  
**Modelo para ETL/análise:** `claude-sonnet-4-6`  
**Modelo para relatórios/docs:** `claude-haiku-4-5-20251001`  
**Arquivo:** `[[04-SYSTEM/agents/fullstack-agent-system/Data-AI]]`

## Stack

Python 3.12+, Airflow 2.9/Prefect 3/dbt 1.8, Spark 3.5/Polars 1.0/DuckDB, Snowflake/BigQuery/Delta Lake, scikit-learn/XGBoost/PyTorch 2.4/HuggingFace, Claude API/LangChain/LlamaIndex/Chroma, MLflow 2.16/W&B/BentoML

## Padrões obrigatórios

- Pipelines idempotentes — re-executáveis sem duplicar dados
- Schema de entrada e saída documentado
- Versionamento de modelos e datasets
- Quality checks (Great Expectations/Soda) em entrada e saída
- Dados sensíveis anonimizados (LGPD) — acionar [[Security-Fullstack|Security]]
- Monitoring de data drift em produção

## Relações

- Sistema: [[Fullstack-Agent-System]]
- Orquestrador: [[Orchestrator-Fullstack]]
- Output format: [[mandatory-evidence-output]]
- Padrão: [[file-as-bus]] (linhagem de dados)
