---
title: "Hermes Agent Docs: Providers & Cloud"
type: source
source: "Hermes Agent official docs — /docs/integrations/providers + AWS Bedrock + Microsoft Foundry + Register a Microsoft Graph Application (guides)"
created: 2026-06-14
ingested: 2026-06-14
tags: [ai-agents]
---

# Hermes Agent Docs: Providers & Cloud

## Tese central

Hermes suporta 28+ inference providers via um caminho recomendado unificado (Nous Portal) e caminhos nativos para clouds enterprise (AWS Bedrock, Microsoft Foundry/Azure), cada um com seu próprio modelo de auth, descoberta de modelos e config. Para integrações Microsoft (Teams Meeting Pipeline), é necessário registro de app Azure AD com app-only auth.

## Argumentos principais

- **Nous Portal** é o caminho recomendado: `hermes setup --portal` faz OAuth + provider + Tool Gateway em um comando. Subscrição única cobre 300+ modelos (Claude, GPT, Gemini, DeepSeek, Qwen, Kimi, GLM, MiniMax, Grok). Cada request carrega tag `client=hermes-client-v<version>` para telemetria.
- **JWT auth automático** para Portal: `inference:invoke` JWTs com fallback para opaque session-key; refresh tokens revogados são quarentenados.
- **`hermes model` vs `/model`**: `hermes model` (terminal, fora da sessão) = wizard completo de setup/OAuth/API keys; `/model` (dentro da sessão) = troca rápida entre providers já configurados. Para adicionar um provider novo, sempre `hermes model`.
- **Anthropic nativo**: três métodos de auth. OAuth via `hermes model` só funciona com Claude Max + extra usage credits (overage) — não consome o allowance base do Claude Code, e Pro não serve. Alternativa: `ANTHROPIC_API_KEY` (pay-per-token, billing separado).
- **Auxiliary models**: por padrão (`auxiliary.*.provider: "auto"`) tarefas como vision/web-summarization/MoA roteiam para o modelo principal; pode-se override individual para modelo mais barato (ex: Gemini Flash).
- **AWS Bedrock**: provider nativo via Converse API (não o endpoint OpenAI-compatible) — acesso completo ao ecossistema Bedrock: IAM auth, Guardrails, cross-region inference profiles.
- **Microsoft Foundry (azure-foundry)**: cobre Microsoft Foundry + Azure OpenAI, com auto-detecção de transporte (OpenAI-style vs Anthropic-style).
- **Microsoft Entra ID (keyless)**: role "Azure AI User" cobre ambas as superfícies de auth.
- **Microsoft Graph Application**: pré-requisito para o Teams Meeting Pipeline — app registration Azure AD com app-only (daemon) auth, sem login interativo por reunião.

## Key insights

- Providers notáveis adicionados recentemente: NovitaAI, z.ai/GLM, Kimi/Moonshot (+ variante China), Arcee AI, GMI Cloud, MiniMax (+ China + OAuth), xAI Grok (API + SuperGrok OAuth), Qwen Cloud/OAuth, Alibaba Coding Plan, Kilo Code, Xiaomi MiMo, Tencent TokenHub, OpenCode Zen/Go, Hugging Face, Azure AI Foundry, AWS Bedrock, NVIDIA Build, Ollama Cloud, StepFun, LM Studio.
- **Bedrock — Prereqs**: credenciais via boto3 chain (IAM role em EC2/ECS/Lambda = zero config), `pip install hermes-agent[bedrock]`, permissões `bedrock:InvokeModel*` e `bedrock:ListFoundationModels`/`ListInferenceProfiles`.
- **Bedrock — Region**: prioridade `bedrock.region` > `AWS_REGION` > `AWS_DEFAULT_REGION` > default `us-east-1`.
- **Bedrock — Modelos disponíveis** usam inference profile IDs: `us.anthropic.claude-sonnet-4-6` (recomendado), `us.anthropic.claude-opus-4-6-v1`, `us.anthropic.claude-haiku-4-5-20251001-v1:0`, Amazon Nova Pro/Micro, DeepSeek V3.2, Llama 4 Scout 17B. Prefixo `us.` = cross-region profile; `global.` = roteamento mundial.
- Troca mid-session via `/model <id>`. Diagnóstico via `hermes doctor`.
- **Foundry — transporte OpenAI-style**: `POST /v1/chat/completions` em `https://<resource>.openai.azure.com/openai/v1` (GPT-4.x/5.x, Llama, Mistral).
- **Foundry — transporte Anthropic-style**: `POST /v1/messages` em `https://<resource>.services.ai.azure.com/anthropic` (Claude via Anthropic Messages API).
- Setup wizard Foundry: sniffa o path da URL, probe `GET <base>/models`, probe Anthropic Messages shape, fallback manual. Resolve context length via cadeia padrão (models.dev → metadata do provider → fallback hardcoded).
- **Entra ID — detalhe interno**: OpenAI-style usa `api_key=` callable do SDK (JWT por request automático); Anthropic-style usa `httpx.Client` com hook que reescreve `Authorization: Bearer <jwt>` por request, via `agent.azure_identity_adapter.build_bearer_http_client` (Anthropic SDK não aceita `auth_token` callable nativamente).
- Setup Azure: IAM → Add role assignment → "Azure AI User" → atribuir a user/managed identity/service principal → propagação ~5min. CLI: `az role assignment create --assignee <id> --role "Azure AI User" --scope <foundry-resource-id>`. `azure-identity` instalado via lazy-install (ou `pip install azure-identity`). Wizard tem preflight de 10s com opção "save anyway, validate later" para configs em máquinas sem credenciais ainda.
- **Graph App — passos de registro**:
  1. App registration em entra.microsoft.com → Identity → App registrations → New registration (single tenant, sem redirect URI). Copiar `Application (client) ID` → `MSGRAPH_CLIENT_ID` e `Directory (tenant) ID` → `MSGRAPH_TENANT_ID`.
  2. Client secret: Certificates & secrets → New client secret → copiar o campo **Value** (não o Secret ID) → `MSGRAPH_CLIENT_SECRET`.
  3. Graph API permissions (application permissions, admin consent obrigatório):
     - Transcript-first: `OnlineMeetings.Read.All`, `OnlineMeetingTranscript.Read.All`
     - Recording fallback: `OnlineMeetingRecording.Read.All`, `CallRecords.Read.All`
     - Delivery via Graph (se `delivery_mode: graph`): `ChannelMessage.Send`, `Chat.ReadWrite.All`
     - Evitar: `OnlineMeetings.ReadWrite.All` / `Chat.ReadWrite` sem `.All` (muito amplo); delegated permissions (não funcionam com app-only).
  4. Application Access Policy (opcional, recomendado p/ produção): restringe quais usuários o app pode ler — surface PowerShell-only (`New-CsApplicationAccessPolicy` + `Grant-CsApplicationAccessPolicy`), sem UI no portal.
- Valores finais vão para `~/.hermes/.env`.

## Exemplos e evidências

Config YAML completa do Bedrock (`~/.hermes/config.yaml`):

```yaml
model:
  default: us.anthropic.claude-sonnet-4-6
  provider: bedrock
  base_url: https://bedrock-runtime.us-east-2.amazonaws.com
bedrock:
  region: us-east-2
  guardrail:
    guardrail_identifier: "abc123def456"
    guardrail_version: "1"
    stream_processing_mode: "async"
    trace: "disabled"
  discovery:
    enabled: true
    provider_filter: ["anthropic", "amazon"]
    refresh_interval: 3600
```

## Implicações para o vault

Nenhuma ação direta necessária — conteúdo de referência para futura integração de providers caso o vault venha a operar um harness próprio com múltiplos backends de inferência.

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-persistent-memory]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-features-2]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-automation-cron]]
