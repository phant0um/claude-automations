---
title: "SaaS"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, ai-strategy-org]
status: developing
---

# SaaS

Software entregue como serviço via cloud, com assinatura — o modelo dominante de distribuição de software em 2026.

## O que é

SaaS (Software as a Service) é o modelo no qual o software é hospedado pelo fornecedor e acessado pelo cliente via browser ou API, mediante pagamento por assinatura (mensal, anual, por usuário ou por uso). O cliente não instala, não mantém infraestrutura, não gerencia atualizações — tudo é responsabilidade do fornecedor.

O SaaS é um dos três modelos de serviço em cloud, junto com **PaaS** (Platform as a Service) e **IaaS** (Infrastructure as a Service). A diferença está no nível de abstração: IaaS fornece servidores virtuais (você gerencia SO, runtime, app); PaaS fornece o ambiente de execução (você gerencia apenas a aplicação); SaaS fornece a aplicação pronta (você só usa). Um desenvolvedor, dependendo da fase do projeto, pode ser cliente de SaaS (usa Slack, GitHub) e ao mesmo tempo construir em cima de PaaS (Railway, Heroku) usando IaaS por baixo (AWS EC2).

O modelo de negócio SaaS revolução a distribuição: em vez de vender licença única, o fornecedor cobra recorrentemente. Isso alinha incentivos — o fornecedor precisa que o produto seja bom continuamente para reter o cliente (churn).

## Como funciona

Exemplos por categoria:
| Categoria | Exemplos SaaS |
|---|---|
| Colaboração | Slack, Notion, Google Workspace |
| Dev tools | GitHub, Linear, Vercel, Datadog |
| CRM/Vendas | Salesforce, HubSpot |
| IA | Claude (Anthropic), OpenAI API, Midjourney |
| Finance | Stripe (pagamentos), QuickBooks |

Métricas SaaS essenciais: **MRR** (Monthly Recurring Revenue), **Churn Rate** (% de clientes que cancelam), **LTV** (Lifetime Value), **CAC** (Customer Acquisition Cost). A regra de ouro: LTV/CAC > 3.

Multi-tenancy: um único deployment do software serve múltiplos clientes (tenants), com isolamento de dados. Diferente de instâncias separadas por cliente.

## Por que importa

Como desenvolvedor em 2026, você provavelmente trabalhará em uma empresa SaaS ou construirá produtos SaaS. Entender o modelo de negócio (recorrência, churn, MRR) é essencial para tomar decisões técnicas alinhadas ao negócio — por que uptime 99,9% importa, por que tempo de resposta afeta conversão, por que feature flags existem. Para concursos com questões de TI e inovação, cloud computing (SaaS/PaaS/IaaS) é tópico frequente.

## Exemplo

GitHub: você acessa via browser, a Microsoft mantém a infraestrutura, você paga mensalmente, recebe atualizações automáticas. Você nunca instala um "GitHub.exe". Isso é SaaS.

## Related
- [[03-RESOURCES/concepts/ai-strategy-org/_index]]
- [[03-RESOURCES/concepts/roi]]
- [[03-RESOURCES/concepts/engenharia-de-software]]

## Evidências
- **[2026-06-19]** Service-as-a-software inverte o modelo SaaS: vende outcome com margem de software mas preço de agência, via 4 camadas (Company OS, client repos, skill library, MCP execution) — [[03-RESOURCES/sources/how-to-build-service-as-a-software-2026]]
