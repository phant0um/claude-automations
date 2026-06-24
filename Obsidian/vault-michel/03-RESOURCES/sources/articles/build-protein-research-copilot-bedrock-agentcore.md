---
title: "Build a protein research copilot with Amazon Bedrock AgentCore"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://aws.amazon.com/pt/blogs/machine-learning/build-a-protein-research-copilot-with-amazon-bedrock-agentcore/"
author: "AWS Blog"
published: 2026-06-23
grade: B
tags: [articles, aws, bedrock, agentcore, strands, protein, embeddings, vector-search, sage-maker, agent, source]
---

# Build a protein research copilot with Amazon Bedrock AgentCore

**Tese central**: Construção de um conversational protein research assistant que combina parsing de natural language, vector similarity search sobre protein embeddings (ESM-C 300M), e AI-generated scientific summaries em uma única interface, usando Strands Agents SDK orquestrando 3 specialized tools dentro de um Bedrock AgentCore runtime.

## O problema: pesquisa manual de peptídeos é lenta

Protein researchers enfrentam um challenge time-consuming: manualmente searching through thousands of peptide sequences para encontrar structurally similar candidates é slow, error-prone, e requer deep domain expertise para interpretar resultados. Um protein research copilot transforma como researchers search por structurally similar peptides — natural language queries, automated embedding generation, e AI-powered result summarization em uma única conversational interface.

## Três capabilities combinadas

1. Natural language query parsing para extrair structured search parameters
2. Vector similarity search over protein embeddings usando specialized language model
3. AI-generated scientific summaries of search results

O sistema usa Strands Agents SDK para orquestrar 3 specialized tools dentro de 1 agent, deploya para Amazon Bedrock AgentCore para production serving, e armazena peptide embeddings em Amazon Aurora PostgreSQL com pgvector.

## Solution overview — 5 componentes arquiteturais

1. **Streamlit frontend** (AWS Fargate): interface conversacional, envia queries ao AgentCore runtime, displaya resultados em formato estruturado com downloadable tables
2. **Strands agent** (1 AgentCore runtime): orquestra workflow. Usa Anthropic Claude Sonnet 4.6 via Bedrock Converse API, acesso a 3 tools via `@tool` decorator
3. **Parser tool**: dedicated Strands agent (LLM-as-parser pattern) que extrai structured search parameters — sequence, species filter, result limit — de natural language queries
4. **Searcher tool**: gera protein embeddings via Amazon SageMaker AI serverless endpoint (ESM-C 300M), executa cosine similarity search contra Aurora PostgreSQL com pgvector
5. **Summarizer tool**: dedicated Strands agent que analisa search results e produz concise scientific summaries com suggestions para further investigation

Single-runtime, multi-tool design mantém deployment simples com clear separation of concerns. Cada tool encapsula uma capability distinta; o orchestrator agent decide quando e como invocá-las.

## Protein embeddings with ESM-C 300M

ESM-C 300M é um protein language model da EvolutionaryScale (Built with ESM) que produz 960-dimensional embeddings capturando structural e functional properties de amino acid sequences. Dois peptides com similar biological function produzem embeddings próximos em vector space — similarity search sem sequence alignment.

Deployado como Amazon SageMaker AI serverless endpoint: scales to zero quando idle, sem cost entre invocations. Model weights bundled no deployment artifact para evitar download de HuggingFace em inference time — critical para serverless cold start latency.

Inference handler constrói a model architecture diretamente e loads pre-packaged weights:
- `model_fn`: loads ESMC with d_model=960, n_heads=15, n_layers=30
- `predict_fn`: encodes protein sequence, returns mean-pooled embedding

Serverless config: 6144 MB memory, max concurrency 5, PyTorch 2.6.0 CPU inference container.

## Vector search with Aurora PostgreSQL and pgvector

Schema:
```sql
CREATE TABLE peptides (
    id SERIAL PRIMARY KEY,
    sequence TEXT NOT NULL,
    embedding vector(960),
    properties JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX peptides_embedding_idx
ON peptides USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
```

`properties` JSONB column stores biological metadata — species, source organism, source molecule, epitope positions — enabling combined vector + metadata filtering. Query "Find peptides similar to LPAIVREAI from dengue virus" triggers cosine similarity search on `embedding` + filter on `properties->>'species'`.

Data loading: IEDB virus epitope dataset, embeddings gerados via SageMaker AI endpoint, inserts via Amazon RDS Data API. Initial load: 1,000 linear peptides. Database access via RDS Data API significa que agent runtime não precisa direct network connectivity ao DB — comunica over HTTPS.

## Building the agent with Strands Agents SDK

Strands Agents SDK fornece clean abstraction para building tool-using agents. Cada tool é uma Python function decorated com `@tool`; o agent automaticamente gera tool descriptions para o LLM da function docstring e type hints.

### Tool definitions
- **parse_peptide_query**: delega para dedicated Strands agent (structured output extractor). System prompt: "You are a peptide query parser. Extract structured search parameters from natural language queries. Return ONLY a valid JSON object."
- **search_similar_peptides**: combina SageMaker AI embedding generation com pgvector similarity search. Args: sequence, species (optional), limit. Retorna JSON com results e count.
- **summarize_results**: dedicated Strands agent para scientific analysis. System prompt: "You are a peptide research expert providing concise, high-level summaries."

### Orchestrator agent
System prompt define workflow de 3 steps: parse → search → summarize. Sempre complete os 3 steps.

**"Agents-as-tools" pattern**: parser e summarizer são themselves Strands agents, mas wrapped em `@tool` decorators e expostos ao orchestrator como callable tools. O orchestrator não sabe que essas tools internamente usam LLMs — chama-as como functions. Mantém orchestration logic clean enquanto cada tool leverage LLM capabilities.

## Deploying to Amazon Bedrock AgentCore

AgentCore fornece managed runtime para hosting AI agents. Agent code roda em containerized environment built e deployed via AWS CodeBuild — no local Docker installation required.

### Agent entrypoint
`BedrockAgentCoreApp` com `@app.entrypoint` decorator. Recebe payload com `query`/`prompt`, invokes strands_agent, retorna structured response (parsed_query, search_results, summary, session_id). Captura tool outputs em shared dict para response incluir structured data.

### Infrastructure as code
AWS CloudFormation. VPC stack cria private subnets com NAT gateways e VPC endpoints para Bedrock, RDS Data API, Secrets Manager — agent runtime reacha serviços sem traversing public internet. Aurora PostgreSQL Serverless v2 com auto scaling 0.5-4 ACUs, `EnableHttpEndpoint: true` para RDS Data API. Lambda-backed custom resource inicializa pgvector extension e peptides table.

### Deploy steps (em ordem)
1. VPC e networking
2. Aurora PostgreSQL database com pgvector
3. SageMaker AI endpoint (ESM-C 300M, serverless)
4. Peptide data (IEDB dataset, embeddings via SageMaker, inserts via RDS Data API)
5. AgentCore runtime + Streamlit UI (CodeBuild, Fargate)

## Streamlit frontend

Lightweight Streamlit app comunicando com AgentCore runtime via `bedrock-agentcore` boto3 client. Roda em AWS Fargate com minimal container (streamlit, pandas, boto3 — no ML libraries). UI displaya 3 sections: parsed query parameters (expandable), sortable table de similar peptides com cosine distances e metadata, AI-generated scientific summary. Download CSV para further analysis.

## Considerations de produção

- **Cold start latency**: SageMaker serverless endpoint 2-3 min na primeira invocation após idle. Subsequent invocations within keep-alive em seconds. Para latency-sensitive: provisioned endpoint ou higher provisioned concurrency.
- **Embedding model choice**: ESM-C 300M balanceia quality e speed em CPU. ESM-C 600M ou ESM2 offer larger dimensions a custo de memory e latency. 960-dim do ESM-C 300M performa bem para peptide similarity.
- **Scaling dataset**: initial load 1,000 peptides. Para production: batch-loading embeddings, aumentar IVFFlat index lists proporcionalmente, escalar Aurora ACUs. RDS Data API tem 1 MB response size limit — pagination para large result sets.
- **Cost**: serverless components scale to near-zero quando idle. Cost-effective para research workloads com intermittent usage. Custo ongoing: Bedrock LLM inference (3 calls/query: parser, orchestrator, summarizer) + SageMaker invocations.

## Por que importa para o vault

- **Agents-as-tools pattern**: nested LLM agents wrapped como tools — padrão de composição relevante para o Hermes agent system onde subagents podem ser expostos como tools ao orchestrator
- **Single-runtime multi-tool**: design de 1 runtime com N tools mantém deployment simples — modelo para agentes do vault que precisam orquestrar múltiplas capabilities
- **Vector search + metadata filtering**: pattern de combined semantic + structured query aplicável ao vault (encontrar notes por semantic similarity + tag filter)
- **Strands SDK + AgentCore**: stack AWS nativa para agent deployment — referência arquitetural para agentes em produção
- **Domain-specific embedding models**: uso de ESM-C 300M (não LLM genérico) para embeddings de proteína — princípio de escolher modelo especializado por domínio
- **Bundled weights**: evitar cold-start downloads bundlando model weights — prática relevante para deploys de agentes com modelos custom

## Links

- [[03-RESOURCES/sources/ai-agents/new-in-amazon-bedrock-agentcore]]
- [[03-RESOURCES/sources/articles/pool-model-multi-tenancy-bedrock-agentcore]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]