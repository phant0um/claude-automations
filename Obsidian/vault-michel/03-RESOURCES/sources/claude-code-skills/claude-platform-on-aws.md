---
title: Claude Platform on AWS
type: source
source: "Clippings/Claude Platform on AWS.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, aws, infrastructure]
---

## Tese central
Documentação oficial sobre **Claude Platform on AWS** — uma via de acesso à plataforma completa da Anthropic (Messages API, Agent Skills, code execution, betas, e **Claude Managed Agents**) através da conta AWS do cliente, operada pela Anthropic (não pela AWS, ao contrário do Amazon Bedrock). É a peça que ancora toda a infraestrutura Managed Agents (sandboxes, environments, vaults, GitHub, Files API) num contexto enterprise/AWS, com autenticação IAM/SigV4, billing via AWS Marketplace e compliance diferenciada de Bedrock.

## Argumentos principais
- **Quem opera o quê:** ao contrário do Amazon Bedrock (onde a AWS opera o stack de inferência), na Claude Platform on AWS **a Anthropic opera tudo** — modelos rodam em infraestrutura gerenciada pela Anthropic; a AWS fornece apenas autenticação (SigV4/API key), controle de acesso IAM e integração de billing via AWS Marketplace.
- **Comparativo Claude Platform on AWS vs. Amazon Bedrock vs. Bedrock legacy** (tabela completa): difere em quem opera o stack, superfície de API (`/v1/{endpoint}` vs. `/anthropic/v1/messages` vs. Converse/InvokeModel), disponibilidade de Agent Skills (somente na Platform on AWS) e beta features via `anthropic-beta` (idem), autenticação, billing, base URL, classe de cliente SDK, console, rate limits e processador de dados de inferência.
- **Quando escolher Bedrock em vez disso:** organizações reguladas que exigem FedRAMP High, IL4, IL5, HIPAA-ready, ou que precisem da AWS como único processador de dados.
- **Residência de dados:** dados podem não residir nos EUA; a inferência pode rotear para a nuvem primária da Anthropic; subserviços podem mudar sem aviso. O parâmetro `inference_geo` (suportado apenas em Claude Opus 4.6, Sonnet 4.6 e modelos posteriores — versões anteriores retornam erro 400) permite fixar a inferência a uma geografia (`us` com multiplicador de preço 1.1x, ou `global` com preço padrão).
- **Setup da conta — 4 fases:** (1) inscrição via página de serviço no AWS Console, (2) configuração da organização Anthropic (e-mail do owner, formulário de detalhes), (3) criação de workspace e obtenção do `wrkspc_`-ID, (4) acesso federado ao Claude Console via IAM role com permissão `aws-external-anthropic:AssumeConsole`.
- **Pré-requisito crítico — outbound web identity federation:** capacidade STS desabilitada por padrão em toda conta AWS; deve ser habilitada uma vez via `aws iam enable-outbound-web-identity-federation`. Sem isso, toda requisição falha com `"Outbound web identity federation is disabled for your account"` — descrito como **o erro de setup mais comum**.
- **Autenticação — dois métodos:** SigV4 (caminho enterprise-nativo, integra com IAM existente) e API key. Ordem de precedência de credenciais: `apiKey` constructor → `awsAccessKey`+`awsSecretAccessKey` → `awsProfile` → `ANTHROPIC_AWS_API_KEY` env var → cadeia padrão de credenciais AWS.
- **API keys de curta duração:** geradas a partir de credenciais AWS via bibliotecas `token-generator-for-aws-external-anthropic` (JS/Python/Java); validade default 12h, capada no menor entre duração solicitada, expiração das credenciais AWS, e 12h. SDK não as renova automaticamente.
- **Resolução de região:** `AWS_REGION`/`AWS_DEFAULT_REGION` — região é **obrigatória, sem fallback** (diferente do `AnthropicBedrock`, que cai para `us-east-1`).
- **Modelos disponíveis:** Opus 4.8, 4.7, 4.6, Sonnet 4.6, Opus 4.5, Sonnet 4.5, Haiku 4.5 — IDs idênticos à API first-party (sem prefixos `anthropic.` nem ARNs estilo Bedrock). Novos modelos lançam simultaneamente com a API first-party.
- **Diferença operacional para Managed Agents — reautenticação de sessão autônoma:** sessões podem rodar autonomamente por **até 6 horas** sem eventos de usuário; após isso exigem reautenticação via envio de qualquer evento `user`-role. A API Managed Agents first-party **não tem esse limite**.
- **Workspaces:** vinculados a uma única região AWS; ID no formato `wrkspc_<alfanumérico>`; servem como recurso IAM primário (ARN `arn:aws:aws-external-anthropic:{region}:{account-id}:workspace/{workspace-id}`).
- **Recursos não suportados:** HIPAA-ready, maioria do Admin API, gestão de membros de workspace, spend limits, Claude Code workspace dedicado, OAuth, Fast mode, endpoints OpenAI-compatíveis, endpoint de work-list de self-hosted sandbox (`GET /v1/environments/{id}/work`), MCP tunnels (apenas servidores MCP públicos).
- **Billing:** via AWS Marketplace, em Claude Consumption Units (CCUs) — não são créditos pré-pagos, sem saldo/compromisso; faturado mensalmente em arrears.
- **Monitoramento:** AWS CloudTrail captura todas as requisições; operações de workspace/vault/webhook são "Management events" (logadas por padrão); inferência, batch, files, skills, modelos, perfis e operações Managed Agents (exceto vaults/webhooks) são "Data events" (requerem config explícita, custo extra). Cada resposta traz dois request IDs: `x-amzn-requestid` (AWS/CloudTrail) e `request-id` (suporte Anthropic).
- **Migração desde Bedrock:** delta inclui base URL, nome do serviço SigV4 (`aws-external-anthropic`), IDs de modelo, header `anthropic-workspace-id` obrigatório; ZDR é **opt-in** na Platform on AWS (diferente do Bedrock, onde a AWS é processadora de dados e a Anthropic não retém nada).
- **IAM:** namespace de ações `aws-external-anthropic:<Action>`; cinco managed policies AWS (`AnthropicFullAccess`, `AnthropicReadOnlyAccess`, `AnthropicInferenceAccess`, `AnthropicLimitedAccess`, `AnthropicSelfHostedEnvironmentAccess`).

## Key insights
- O ponto mais importante para arquitetura enterprise: **Claude Platform on AWS dá acesso same-day a Managed Agents/Skills/code execution dentro do perímetro AWS do cliente**, algo que o Bedrock não oferece (Bedrock não suporta Agent Skills nem headers `anthropic-beta`). Isso faz da Platform on AWS a opção natural para clientes AWS que querem o full stack Managed Agents sem sair do ecossistema AWS — desde que não precisem de FedRAMP/HIPAA/IL4-5.
- O limite de **6 horas de autonomia de sessão sem reautenticação** é uma restrição operacional concreta e específica da Platform on AWS que não existe na API Managed Agents first-party — relevante para quem projeta agentes de longa duração ("long-running agents") nesse ambiente.
- A "Outbound web identity federation desabilitada por padrão" é um gotcha de onboarding tão comum que a doc o documenta como erro nº1 — útil registrar para qualquer playbook de setup.
- ZDR ser opt-in (e não automático como em Bedrock) é uma diferença de postura de privacidade que pode pesar na decisão entre as duas plataformas para workloads sensíveis.
- A separação entre "Through AWS gateway" (Sim/Não) nas páginas do Console é um detalhe sutil mas operacionalmente importante: define quais operações são governadas por IAM actions e quais batem direto nas APIs da Anthropic — molda o desenho de políticas de acesso.
- O fato de "Available models" listar Opus **4.8** (mais novo que o 4.7/4.6 mencionados em outras fontes do vault) sinaliza um lançamento recente capturado por esta doc — vale cross-checar com entidades de modelo existentes no vault.

## Exemplos e evidências
- Habilitar federação (passo crítico): `aws iam enable-outbound-web-identity-federation` / verificar com `aws iam get-outbound-web-identity-federation-info`.
- Variáveis de ambiente: `export ANTHROPIC_AWS_WORKSPACE_ID='wrkspc_01AbCdEf23GhIj'` / `export AWS_REGION='us-west-2'`.
- Geração de token de curta duração:
```python
from token_generator_for_aws_external_anthropic import TokenGenerator
from anthropic import AnthropicAWS
token = TokenGenerator(region="us-west-2").get_token()
client = AnthropicAWS(api_key=token, aws_region="us-west-2")
```
- Chamada básica com `inference_geo`:
```python
message = client.messages.create(
    model="claude-sonnet-4-6", max_tokens=1024,
    inference_geo="us",
    messages=[{"role": "user", "content": "Hello!"}],
)
```
- Política IAM exemplo (permitir inferência real-time, negar batch) — bloco completo com `Allow`/`Deny` por `aws-external-anthropic:<Action>` e ARN `arn:aws:aws-external-anthropic:*:*:workspace/*`.
- ARN de workspace: `arn:aws:aws-external-anthropic:us-west-2:123456789012:workspace/wrkspc_01AbCdEf23GhIj`.
- Tabela "What changes" na migração de Bedrock: base URL `bedrock-mantle.{region}.api.aws` → `aws-external-anthropic.{region}.api.aws`; model IDs `anthropic.claude-opus-4-6` → `claude-opus-4-6`; SigV4 service `bedrock-mantle`/`bedrock` → `aws-external-anthropic`.
- Limite de 12h em short-term keys; 6h de autonomia de sessão sem reautenticação; multiplicador 1.1x para `inference_geo: us`.

## Implicações para o vault
Esta página é a **âncora de infraestrutura enterprise** do lote: confirma que toda a stack Managed Agents — [[03-RESOURCES/sources/cloud-environment-setup]], [[03-RESOURCES/sources/cloud-sandbox-reference]], [[03-RESOURCES/sources/authenticate-with-vaults]], [[03-RESOURCES/sources/accessing-github]], [[03-RESOURCES/sources/adding-files]] e [[03-RESOURCES/sources/files-api]] — está disponível dentro do perímetro AWS, com a única diferença documentada sendo o limite de 6h de autonomia de sessão. Conecta-se diretamente a sources existentes sobre Managed Agents ([[03-RESOURCES/sources/ai-agents-harness/claude-managed-agents-beginners-guide]], [[03-RESOURCES/sources/ai-agents-harness/anthropic-dreaming-claude-managed-agents-setup]]) e amplia o conceito [[03-RESOURCES/concepts/agent-systems/harness-adaptation]] (deployment "harness" muda conforme a plataforma — AWS introduz reautenticação, billing, IAM, vaults regionais). Também alimenta [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] (workspace como camada de isolamento IAM/billing acima de agent/session/environment) e [[03-RESOURCES/concepts/agent-systems/agent-observability]] (CloudTrail + dois request-IDs como par de trilhas de auditoria). Pode ser fonte adicional do conceito sugerido `managed-agents-harness`.

## Links
- [[03-RESOURCES/sources/cloud-environment-setup]]
- [[03-RESOURCES/sources/cloud-sandbox-reference]]
- [[03-RESOURCES/sources/authenticate-with-vaults]]
- [[03-RESOURCES/sources/accessing-github]]
- [[03-RESOURCES/sources/adding-files]]
- [[03-RESOURCES/sources/files-api]]
- [[03-RESOURCES/sources/ai-agents-harness/claude-managed-agents-beginners-guide]]
- [[03-RESOURCES/sources/ai-agents-harness/anthropic-dreaming-claude-managed-agents-setup]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
