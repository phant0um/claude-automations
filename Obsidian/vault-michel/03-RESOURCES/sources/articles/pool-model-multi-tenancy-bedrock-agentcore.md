---
title: "Shared infrastructure, isolated tenants: Pool model multi-tenancy with Amazon Bedrock AgentCore"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://aws.amazon.com/pt/blogs/machine-learning/shared-infrastructure-isolated-tenants-pool-model-multi-tenancy-with-amazon-bedrock-agentcore/"
author: "Ashley Chen, Sushanth Mangalore"
published: 2026-06-23
grade: B
tags: [articles, aws, bedrock, agentcore, multi-tenancy, architecture, isolation, cognito, cedar, healthcare, source]
---

# Shared infrastructure, isolated tenants: Pool model multi-tenancy with Amazon Bedrock AgentCore

**Tese central**: Patterns para implementar production-ready multi-tenant systems usando Amazon Bedrock AgentCore, demonstrados através de healthcare AI agents que servem múltiplas clínicas e hospitais. Multi-tenancy não requiere complex application-level isolation logic — combina native AWS capabilities (Cognito, S3 prefixes, API Gateway, Bedrock Projects, AgentCore) para isolation, tier differentiation, cost attribution, e scalability com minimal custom code.

## O challenge do multi-tenant AI

Building multi-tenant AI applications apresenta novos architectural challenges: complete tenant isolation entre customers, different service tiers com different capabilities, granular cost tracking, e observability per tenant. Sem esses, risco de expor customer data, não prover QoS apropriado, ou incorrer em unforeseen costs.

### What you'll learn
- Como implementar complete tenant isolation em agentic applications usando native AWS capabilities
- Patterns para service tier differentiation com minimal custom code
- Técnicas para granular cost attribution per tenant
- Best practices para scalable multi-tenant AI architectures

Parte 2 da série "Building multi-tenant agents with Amazon Bedrock AgentCore". GitHub: https://github.com/aws-samples/sample-agentcore-and-multitenancy-blog

## Solution overview — hierarquia Tier → Tenant → User

A solução implementa uma three-level hierarchy: Tier → Tenant → User, onde isolation é enforced em every layer through documents in knowledge base, memory, model access, e cost tracking.

### Healthcare AI assistant example — 2 service tiers
- **Basic Tier**: small clinics/practices, straightforward document search e retrieval. Usa Mistral Ministral 3 8B Instruct (cost-effective), accurate para simple queries.
- **Premium Tier**: hospitals/specialty centers, complex clinical analysis. Usa OpenAI GPT OSS 120B com advanced reasoning, accurate tool selection, incluindo web search tool (premium only).

**Pool isolation model**: tenants compartilham mesma underlying infrastructure e compute resources ao invés de dedicated siloed resources. Pool model maximiza resource utilization e simplifica operations; tenant isolation enforced through logical separation (scoped identifiers, access policies, data partitioning). Combinar tiering com pool model balanceia cost efficiency com differentiated service levels.

## Architecture — 7 key components

1. **Amazon Cognito**: user authentication, stores tenant metadata (tier, clinic_id, role) em JWT claims. Claims extraídos e propagados como tenant context through request payload.
2. **Amazon API Gateway**: routea requests, enforcea tier-based rate limiting via usage plans
3. **AWS Lambda**: extrai tenant context, invoca correspondente AgentCore agent
4. **AgentCore components**: Runtime (agent execution), Memory (conversation state), Identity (agent identity management), Gateway (tool server), Policy (agent action boundary)
5. **Amazon S3**: clinical documents em tier-separated buckets com hierarchical prefix structure para tenant isolation
6. **Amazon Bedrock Knowledge Bases**: semantic search com metadata filtering para scope queries ao requesting tenant's documents
7. **Amazon Bedrock project**: per-tier cost tracking via cost allocation tags

## Solution walkthrough — 6 core AgentCore capabilities

### AgentCore Runtime
Compute para agents, cada agent session execution em isolated micro-VM para tenant-level compute isolation. Hosta separate agent instances per tier, cada uma configured com tier-appropriate models e capabilities. Project ID fetched de SSM, passed para OpenAIModel (premium tier) targeting inference endpoint.

### AgentCore Identity
Unified JWT-based authentication. Cognito ID token valida user em both Runtime e Gateway boundaries; tool Lambdas mint scoped credentials para downstream data access.

JWT claims propagadas:
| Claim | Example | Purpose |
|-------|---------|---------|
| sub | a4589458-... | Unique user ID (Cognito UUID) |
| cognito:username | dr.foster@hospital-a.com | Login, used as user_id for memory isolation |
| custom:tier | premium | Routes to correct model, KB, gateway |
| custom:clinic_id | hospital-a | Tenant ID, enforces data isolation |
| custom:role | physician | Role-based access control |

Authorizer configured durante agent deployment com `customJWTAuthorizer` + Cognito discovery URL + allowedAudience. Gateway também configurado com JWT authorization. Agent forwarda user's JWT como Bearer token + tenant context headers (X-Tier, X-Clinic-ID, X-S3-Prefix). Target Lambda nunca recebe JWT diretamente — lê trusted tenant headers (trusted porque só authenticated requests passam gateway's CUSTOM_JWT authorizer) e assume TVM role com session tags derivados dos headers. TVM role's ABAC policy restricts DynamoDB via `dynamodb:LeadingKeys` — cada tenant só query sua clinic's data ao IAM level.

### AgentCore Memory
Conversation history não pode leakar entre tenants ou users. Isolation em 2 layers: application-level scoping e IAM-backed ABAC.

Application layer: hierarchical namespace com composite actor_id:
```python
actor_id = f"{tier}-{clinic_id}-{user_id}"
# "basic-clinic-a-dr.smith@clinic-a.com"
```
Namespaces: `clinic/{actor_id}/facts/{session_id}` (SEMANTIC), `clinic/{actor_id}/preferences` (PREFERENCES)

Infrastructure level: Token Vending Machine (TVM) pattern com ABAC. Agent assume TVM role com Tier, ClinicId, UserId como session tags, recebe temporary credentials scoped ao tenant's namespace. TVM role trust policy: só agent execution role pode assumir, e todas 3 session tags devem estar presentes.

### AgentCore Gateway
Transforma static Lambda functions em dynamic, context-aware agent tools usando Model Context Protocol (MCP). Elimina need de custom tool orchestration logic. Lambda expõe 2 tools via Gateway:
- `patient_context`: patient demographics e medical history de DynamoDB
- `clinic_config`: clinic configuration e provider info de DynamoDB

Tenant identity propagada: agent inicializa MCP Gateway client com tenant-scoped headers, toda tool call automaticamente carrega tenant context — isolation enforced no gateway layer sem per-tool filtering logic. Gateway suporta 3 auth mechanisms: IAM role (AWS services), Custom JWT (tenant-aware tools), OAuth (third-party APIs).

### AgentCore Policy
Tier-specific action boundaries no gateway tools usando Cedar authorization policies. Shared policy engine attached a basic e premium gateways em ENFORCE mode:
- **Basic tier**: Cedar policy restricts `patient_context` a business hours (8 AM–6 PM). Agent deve chamar `current_time` primeiro e passar hour; policy engine deniega se fora da window.
- **Premium tier**: `patient_context` permitido unconditional, 24/7 access.
- Ambos tiers: explicit permits para `clinic_config` (non-sensitive config data).

Access control movido de application code para declarative Cedar policies avaliadas no gateway layer — tier differentiation enforced antes da Lambda executar.

### AgentCore Observability
OpenTelemetry baggage para propagar tenant metadata through request lifecycle. Tenant identifiers set como baggage no Runtime entrypoint, todo downstream span e log entry carrega tenant attribution:
```python
ctx = baggage.set_baggage("tier", tier)
ctx = baggage.set_baggage("clinic_id", clinic_id, context=ctx)
ctx = baggage.set_baggage("actor_id", actor_id, context=ctx)
context.attach(ctx)
```

CloudWatch Logs Insights para track volume de requests per clinic. Combinado com Bedrock Projects (per-tier cost) e structured usage logging (per-clinic tokens): tenant-level visibility across model usage, agent execution, memory operations.

## Key multi-tenancy implementation patterns

### 1. Data isolation via per-tier S3 buckets
Separate S3 bucket per service tier, tenant-specific prefixes dentro de cada bucket. Cada tier's KB tem dedicated bucket (bucket-level isolation). Within bucket, hierarchical prefixes organizam tenant data (path-based access control + KB metadata filtering):
```
s3://healthcare-basic-kb-{suffix}/basic-tier/clinic-a/{appointment-notes,lab-results,...}
s3://healthcare-premium-kb-{suffix}/premium-tier/hospital-a/{surgical-notes,pathology-reports,...}
```
S3 prefix construído de Cognito JWT claims. Prefix usado em 2 ways: X-S3-Prefix header em toda MCP Gateway tool call (gateway-level enforcement), e KB metadata filter em clinic_id:
```python
response = client.retrieve(
    knowledgeBaseId=kb_id,
    retrievalQuery={"text": query},
    retrievalConfiguration={"vectorSearchConfiguration": {
        "filter": {"equals": {"key": "clinic_id", "value": clinic_id}}
    }}
)
```

### 2. Cost attribution via Bedrock Projects + structured usage logging
Two levels: per-tier (Bedrock Projects) e per-clinic (structured usage logging).

**Per-tier**: cada tier tem dedicated Bedrock Project tagged com cost allocation metadata (CostCenter, Tier, Application). Project ID passed em toda inference request via Bedrock Mantle endpoint — todos model invocation costs automaticamente segmented por tier em AWS Cost Explorer.

**Per-clinic**: Bedrock Projects limit de 1,000 per account (application-level boundaries). Para per-clinic granularity, log token usage após cada agent invocation como structured JSON com tenant context:
```python
def _log_usage(self, result):
    usage = result.metrics.accumulated_usage
    logger.info(json.dumps({
        "event": "inference_usage", "tier": self.tier,
        "clinic_id": self.clinic_id, "user_id": self.user_id,
        "model_id": self.model_id,
        "input_tokens": usage.get("inputTokens", 0),
        "output_tokens": usage.get("outputTokens", 0),
    }))
```
Strands SDK automaticamente tracks token consumption. Logs em CloudWatch, queryable via Logs Insights para per-clinic usage. Cost estimate: multiply token counts por published per-token pricing.

### 3. Rate limiting via API Gateway
Usage plans per tier:
```yaml
basic-tier-plan: {throttle: {rate_limit: 2, burst_limit: 5}, quota: {limit: 50, period: DAY}}
premium-tier-plan: {throttle: {rate_limit: 10, burst_limit: 20}, quota: {limit: 500, period: DAY}}
```

## Por que importa para o vault

- **Multi-tenancy pattern**: relevante para arquitetura de agentes que servem múltiplas areas (FIAP, concurso, finance, AI agents) — pool model poderia otimizar shared infrastructure vs silo atual
- **Tier → Tenant → User hierarchy**: modelo de 3 níveis de isolation aplicável ao vault (area → project → note/user)
- **TVM pattern com ABAC**: Token Vending Machine com session tags para scoped credentials — pattern de infra-level isolation sem application-level filtering
- **Cedar policies para tier differentiation**: declarative access control avaliado fora do agent code — modelo para guardrails do vault
- **OpenTelemetry baggage**: propagar tenant metadata through request lifecycle — relevante para observability de agentes com múltiplas scopes
- **Per-tier + per-clinic cost attribution**: two-level cost tracking (Bedrock Projects + structured logging) — modelo para cost tracking do pipeline-semanal
- **Pool vs silo**: vault atualmente é "silo" (cada area tem seu espaço) — pool model é alternativa arquitetural
- **AgentCore Gateway + MCP**: tenant context propagado automaticamente via headers em toda tool call — pattern para multi-scope agent tools

## Links

- [[03-RESOURCES/sources/ai-agents/new-in-amazon-bedrock-agentcore]]
- [[03-RESOURCES/sources/articles/build-protein-research-copilot-bedrock-agentcore]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[04-SYSTEM/agents/core/guard]]