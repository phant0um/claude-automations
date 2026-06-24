---
title: "Autonomous troubleshooting for Medallion Architecture with AWS DevOps Agent and Apache Spark Troubleshooting Agent"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://aws.amazon.com/pt/blogs/big-data/autonomous-troubleshooting-for-medallion-architecture-with-aws-devops-agent-and-apache-spark-troubleshooting-agent/"
author: "Mohammad Sabeel, Ishan Gaur"
published: 2026-06-23
grade: B
tags: [articles, aws, bedrock, devops, spark, medallion, troubleshooting, mcp, agent, source]
---

# Autonomous troubleshooting for Medallion Architecture with AWS DevOps Agent and Apache Spark Troubleshooting Agent

**Tese central**: Diagnóstico de falhas multi-layer em pipelines Medallion Architecture em minutos (3-5 min) usando AWS DevOps Agent com Apache Spark Troubleshooting Agent integrado como MCP server, substituindo o ciclo reativo de detect-investigate-fix por troubleshooting autônomo e proativo.

## O problema: troubleshooting reativo em pipelines multi-camada

Every minute of data processing pipeline downtime delays business decisions, stalls downstream analytics, drives revenue loss, and erodes stakeholder confidence. Teams que rodam pipelines Medallion Architecture (pattern lakehouse onde data flui por bronze, silver, gold layers com qualidade crescente) enfrentam falhas em cascata que impactam reporting e ML workloads críticos para receita.

À medida que pipelines multi-stage escalam com Amazon MWAA, AWS Glue, e Amazon Redshift, troubleshooting fica cada vez mais complexo. Quando um job crítico falha, um engineer precisa siftar por gigabytes de logs across interconnected systems — horas de investigação examinando execution timelines, resource metrics, cross-referencing com Amazon CloudWatch e recent deployment changes. Requer deep familiarity com tecnologias subjacentes, expertise que nem todo team member tem. Quando o engineer certo não está disponível em off-hours, downtime se estende. O ciclo detect → investigate → fix → repeat é custoso e inteiramente reativo.

## What is AWS DevOps Agent and Apache Spark Troubleshooting Agent?

**AWS DevOps Agent** é um autonomous investigation agent powered by AI que automaticamente diagnostica operational issues across AWS environment. Quando uma falha ocorre, o agent independentemente gathers evidence de logs, metrics, e configurations across interconnected services, identifica root cause, e entrega actionable remediation steps — sem intervenção humana. Integra com workflows existentes via webhooks e entrega findings diretamente a Slack. Substitui o ciclo reativo por autonomous, proactive troubleshooting. O agent atua como always-on, on-call engineer, iniciando investigação no momento da falha.

**Apache Spark Troubleshooting Agent** é um AI-powered, fully managed MCP (Model Context Protocol) server que data engineers usam para diagnosticar Spark application failures across Amazon EMR, AWS Glue, e Amazon SageMaker AI Notebooks via natural language. Automaticamente correlaciona Spark History Server data, distributed executor logs, e configuration patterns para identificar root causes e entregar recommendations. Remove horas de manual investigation across multiple consoles e log files.

## Use case: scenario Medallion Architecture

### Cenário
Um gold layer AWS Glue job falha com "Missing data for not-null field." Os logs não revelam o problema real. O root cause é uma subtle data quality issue introduzida upstream no silver layer — um job que succeeded sem errors. Sem autonomous troubleshooting, seria necessário manualmente trace data lineage across Amazon S3, Amazon Redshift, e múltiplos AWS Glue job logs.

### Solução
Quando integrado com Apache Spark Troubleshooting Agent, AWS DevOps Agent identifica a gold layer Amazon Redshift write failure, traces back to silver layer data corruption, e fornece detailed root causes e actionable recommendations. A investigação tipicamente completa em 3-5 minutos.

## Solution overview — arquitetura de 7 passos

1. Amazon MWAA triggera o Medallion pipeline DAG, orquestrando três AWS Glue jobs sequencialmente: bronze → silver → gold.
2. Bronze layer job: gera 50,000 synthetic ecommerce order records, escreve raw Parquet files para Amazon S3.
3. Silver layer job: lê bronze data, aplica transformations, escreve para Amazon S3 e Amazon Redshift (`silver_ecommerce` table). Silenciosamente introduz data corruption em ~8% dos `total_amount` values.
4. Gold layer job: lê da Redshift `silver_ecommerce` table, faz aggregation, tenta escrever para `gold_ecommerce_summary`. Se upstream corruption introduz `NULL` values, falha com "Missing data for not-null field" (viola `NOT NULL` constraint).
5. Quando gold job entra FAILED state, Amazon EventBridge captura o Glue Job State Change event e invoca AWS Lambda. A Lambda recupera webhook credentials de AWS Secrets Manager, constrói HMAC-signed event payload, envia para AWS DevOps Agent.
6. AWS DevOps Agent recebe o HTTP POST, inicia investigação autônoma. Autentica com Amazon Cognito via OAuth 2.0 client credentials flow, envia MCP request através de Amazon Bedrock AgentCore Gateway. O Gateway invoca SigV4 Proxy Lambda que assina e encaminha para Apache Spark Troubleshooting Agent MCP Server. O MCP Server analisa Spark event logs, executor metrics, error stack traces.
7. AWS DevOps Agent entrega a investigação no Slack: root cause analysis, upstream data lineage back to silver layer corruption, step-by-step remediation.

## Walkthrough de deployment

### Pré-requisitos
- AWS account com IAM permissions (iam, lambda, glue, redshift, airflow, events, sqs, secretsmanager, kms, ec2, cloudformation) ou `AdministratorAccess` para dev/test
- AWS CLI v2.30.0+
- Slack workspace (opcional)

### Set up AWS DevOps Agent
1. Criar Agent Space (investigation workspace)
2. Conectar Slack integration (opcional)
3. Criar webhook endpoint com URL e Secret Key

### Deploy CloudFormation stack
Deploya VPC com private subnets, Redshift cluster (ra3.xlplus single-node), 3 Glue jobs, MWAA environment, EventBridge rules, Lambda functions, AgentCore Gateway com Cognito OAuth auth. ~30-40 min para CREATE_COMPLETE.

### Registrar Spark Troubleshooting MCP Server no DevOps Agent
- Name: `sparkagent`
- Endpoint: `AgentCoreGatewayUrl` dos stack outputs
- Authorization: OAuth Client Credentials (Cognito)
- Scope: `<stack-name>-mcp-proxy/invoke`
- Selecionar tool `spark___analyze_spark_workload` (root cause analysis tool)

### See DevOps Agent in action
Trigger manual do `medallion_architecture_pipeline` DAG no Airflow UI. O silver job injeta `$` prefix em ~8% de `total_amount` (hidden corruption). Gold job falha porque `NULL` values (do cast de `$`-prefixed strings) violam `NOT NULL` constraint em `revenue_total`.

AWS DevOps Agent inicia investigação em 1-2 min pós-falha. Resultados organizados em:
1. **Root cause identified**: gold layer write error traced back to silver layer data corruption
2. **Mitigation plan generated**: step-by-step remediation recommendations
3. **Slack notification**: root cause + upstream data lineage + actionable recommendation (3-5 min total)

## Enhanced investigations with AWS DevOps Agent Skills

Skills fornecem ao agent domain-specific guidance tailored ao environment. Para Medallion pipelines, Skills podem instruir o agent a:
- Check data type mismatches entre pipeline layers quando Amazon Redshift COPY errors ocorrem
- Cross-reference silver layer data quality metrics com gold layer aggregation failures
- Seguir runbook interno para escalar data quality issues ao upstream data engineering team

## Por que importa para o vault

- **MCP server pattern**: specialist agent como MCP server é exatamente o pattern do vault (agent registry, model-router) — decomposition of expertise via protocol
- **Medallion Architecture**: Bronze/Silver/Gold layers espelha a estrutura do vault (00-INBOX → Clippings → 03-RESOURCES)
- **Troubleshooting automatizado**: equivalente ao daily-scan + pipeline-semanal detecting issues sem intervenção humana
- **Webhook-driven investigation**: event-driven architecture onde falhas triggeram automaticamente investigação — modelo para o vault auto-diagnosticar drift
- **Agent-as-on-call-engineer**: pattern de agent sempre disponível, iniciando work no momento do evento — relevante para cron jobs e background agents do Hermes
- **Skills como domain guidance**: equivalente a Hermes skills que estendem capability do agent com contexto específico

## Links

- [[03-RESOURCES/sources/ai-agents/new-in-amazon-bedrock-agentcore]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[04-SYSTEM/agents/core/hill]]