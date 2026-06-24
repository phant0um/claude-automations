---
title: AI Agents para Negócios
type: concept
status: developing
tags: [ai-agents, negócios, automação, saas]
created: 2026-04-14
updated: 2026-05-19
---

# AI Agents para Negócios

Padrão de negócio onde agentes de IA são o produto — não apenas um assistente interno, mas a infraestrutura vendida para outros.

## O modelo

```
LLM (inteligência) + API de integração (execução) = produto escalável
```

Exemplos de stack:
- **[[03-RESOURCES/entities/Claude Code\|Claude]] + [[03-RESOURCES/entities/Composio\|Composio]]** → bots para Polymarket
- **LLM + ferramentas customizadas** → qualquer domínio vertical

## Por que a camada de infraestrutura ganha

| Abordagem | Dependência | Escala |
|---|---|---|
| Usar a ferramenta (trader) | Precisa acertar | Linear |
| Construir a ferramenta | Precisa ser útil | Exponencial |

Quem constrói infraestrutura lucra de **cada usuário** da ferramenta — independente do resultado deles.

## Analogia histórica

- Corrida do ouro → vendedores de pás
- Internet → CDNs e processadores de pagamento
- Crypto → exchanges e protocolos de infraestrutura
- **Prediction markets → quem construir as ferramentas agora**

## Modelo de monetização típico

1. **SaaS de bot** — assinatura mensal para ferramenta pronta
2. **Ferramenta customizada** — preço premium para clientes sérios
3. **Dashboard + execução** — setup fee + recorrente para times
4. **Solução institucional** — enterprise, alto ticket

## Casos de uso mapeados

- Bots para [[03-RESOURCES/concepts/finance-trading/prediction-markets\|Prediction Markets]] (Polymarket)
- Automação de trading e arbitragem
- Scanners de mercado e alertas
- Copy-trading dashboards

## Ver também

- [[03-RESOURCES/concepts/finance-trading/prediction-markets\|Prediction Markets]]
- [[03-RESOURCES/entities/Composio\|Composio]]
- [[03-RESOURCES/sources/financial-trading/polymarket-infrastructure-business|Fonte: Polymarket Infrastructure Business]]

## Evidências
- **[2026-06-19]** Time de GTM de 5 agentes (prospector, researcher, sequencer, recoverer, reporter) sobre memória compartilhada por conta roda go-to-market inteiro por ~$400/mês, operado por uma pessoa que só edita o standup diário — [[how-to-build-a-gtm-team-on-claude-code-you-can-run-alone]]
- **[2026-06-19]** Todo agente deve pertencer a um humano específico — sem isso ninguém responde pelo output e nada de fato é implantado; baseline de dois agentes por pessoa ativa para virar delegação real — [[gtm-engineering-chapter-two]]
- [[03-RESOURCES/sources/the-agent-is-not-the-product]] — Process reengineering makes AI 100x more effective; deployment IS the product, not the agent
- [[03-RESOURCES/sources/here-s-how-196-yc-p26-startups-sell-the-same-thing]] — YC P26: ninguém diz 'AI-powered', todos vendem headcount reduction; AI virou commodity
- [[03-RESOURCES/sources/how-to-build-a-100m-warm-lead-database-with-an-ai-coding-agent]] — Intent-signal prospecting com AI agent: 11.4% reply rate vs 1-2% bought lists
