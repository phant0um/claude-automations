---
title: "Agents for Financial Services"
type: source
source_url: "https://www.anthropic.com/news/finance-agents"
author: Anthropic
published: 2026-05-05
created: 2026-05-09
tags: [financial-services, agents, anthropic, claude-cowork, managed-agents, microsoft-365, mcp, fintech, source]
triagem_score: 7
---

# Agents for Financial Services

**Source:** [Anthropic News](https://www.anthropic.com/news/finance-agents) — 5 May 2026
**Author:** [[03-RESOURCES/entities/anthropic]]

Anthropic releases ten ready-to-run agent templates for financial services, Microsoft 365 add-in integrations, and new data connectors/MCP apps targeting banks, asset managers, and insurers.

## Key Use Cases (10 Agent Templates)

### Research and Client Coverage
| Agent | Function |
|-------|----------|
| **Pitch Builder** | Target lists, comparables, pitchbook drafts |
| **Meeting Preparer** | Client/counterparty briefs ahead of calls |
| **Earnings Reviewer** | Reads transcripts/filings, updates models, flags thesis changes |
| **Model Builder** | Creates financial models from filings and data feeds |
| **Market Researcher** | Tracks sector/issuer news, synthesizes broker research |

### Finance and Operations
| Agent | Function |
|-------|----------|
| **Valuation Reviewer** | Checks valuations vs. comparables and firm standards |
| **General Ledger Reconciler** | GL reconciliation and NAV calculations |
| **Month-End Closer** | Close checklist, journal entries, close reports |
| **Statement Auditor** | Reviews financials for consistency and audit-readiness |
| **KYC Screener** | Assembles entity files, reviews source docs, packages compliance escalations |

## Technical Patterns

### Agent Template Architecture
Each template packages three components:
1. **Skills** — instructions and domain knowledge for the task
2. **Connectors** — governed, real-time access to required data
3. **Subagents** — specialist Claude models called for sub-tasks (e.g. comparables selection, methodology checks)

### Two Deployment Modes
- **Plugin (Cowork/Code):** runs alongside the analyst on their desktop; output lands directly in Excel/PowerPoint/Outlook
- **[[03-RESOURCES/entities/Claude-Managed-Agents|Claude Managed Agent]]:** runs autonomously on the Claude Platform for nightly schedules or whole-book-of-deals scope; includes long-running sessions, per-tool permissions, managed credential vaults, and full audit log in Claude Console

### Microsoft 365 Integration
Claude add-ins for Excel, PowerPoint, Word (GA), and Outlook (coming soon). Context persists across all four apps — a model started in Excel carries forward into a PowerPoint deck without re-explanation. Dispatch (voice or text task assignment) available in [[03-RESOURCES/entities/Claude-Cowork]].

### Data Ecosystem (Connectors + MCP)
- **Existing:** FactSet, S&P Capital IQ, MSCI, PitchBook, Morningstar, Chronograph, LSEG, Daloopa
- **New connectors:** Dun & Bradstreet, Fiscal AI, Financial Modeling Prep, Guidepoint, IBISWorld, SS&C IntraLinks, Third Bridge, Verisk
- **New MCP app:** Moody's — proprietary credit ratings + data on 600M+ public/private companies

### Model Recommendation
Claude Opus 4.7 recommended for financial tasks; leads Vals AI Finance Agent benchmark at **64.37%**.

## Regulatory Considerations

- Users remain in the loop — reviewing, iterating, and approving before work goes to clients, is filed, or acted on
- KYC and compliance escalation workflows built into agent templates
- Audit log in Claude Console for every tool call and decision (compliance + engineering visibility)
- Per-tool permissions and managed credential vaults isolate sensitive credentials from agent sandboxes
- Governed access controls on all data connectors

## Distribution

Available at [financial services marketplace](https://github.com/anthropics/financial-services) as plugins (all paid plans) or Managed Agents (Claude Platform public beta).

## Análise dos padrões técnicos

### Por que Skills + Connectors + Subagents?

A decomposição de cada template em três componentes reflete um princípio de separação de responsabilidades:

- **Skills** encapsulam o conhecimento do domínio (como um analista experiente pensa sobre uma valuation, quais perguntas fazer em due diligence) — são estáveis e reutilizáveis
- **Connectors** gerenciam acesso a dados em tempo real — são trocáveis sem mudar a lógica do agente
- **Subagents** especializam-se em sub-tarefas que requerem julgamento diferente do agente principal (ex: o Earnings Reviewer usa um subagente especializado em detecção de mudança de tese vs. o agente principal que lê o transcript)

Esse padrão reduz a complexidade de cada componente individualmente — cada um pode ser testado, auditado e melhorado de forma independente.

### Material Passport implícito

Embora não nomeado assim, o fato de que "contexto persiste entre Excel, PowerPoint e Word" descreve um handoff de contexto estruturado — o equivalente corporativo do Material Passport de pipelines acadêmicos. O modelo iniciado no Excel carrega o schema de dados, as suposições e o estado da análise para o PowerPoint sem requerer re-explicação. Isso é context engineering aplicado ao workflow de um analista de banco de investimento.

## Implicações regulatórias aprofundadas

O design "humano no loop" não é apenas marketing de compliance — é um requisito estrutural para uso em serviços financeiros regulados:

**MiFID II / SEC Rule 15c3-5 (Market Access Rule):** Recomendações de investimento geradas por AI devem ter revisão humana documentada antes de chegar ao cliente. O audit log do Claude Console cobre esse requisito.

**AML/KYC:** O KYC Screener não toma decisões de aprovação — "packages compliance escalations". A decisão final permanece com o compliance officer humano. O agente aumenta capacidade de throughput sem assumir responsabilidade legal.

**SOX (Sarbanes-Oxley):** O General Ledger Reconciler e Month-End Closer produzem entradas auditáveis. O log de cada tool call no Claude Console é o trail de auditoria.

**Risco de modelo:** Reguladores de serviços financeiros (DORA na Europa, OCC nos EUA) exigem gestão de risco de modelos AI. Os templates Anthropic com versionamento explícito e benchmarks (Vals AI Finance Agent) facilitam a documentação de model risk management.

## Comparação com alternativas de mercado

| Solução | Custo | Integração M365 | Audit Log | Customizável |
|---|---|---|---|---|
| Anthropic Finance Agents | Plano pago + Platform | Nativo (GA) | Sim (Claude Console) | Sim (via templates) |
| Bloomberg GPT | Licença Bloomberg | Não nativo | Limitado | Não |
| Microsoft Copilot for Finance | M365 licença | Nativo | Microsoft Purview | Limitado |
| Harvey (para legal/finance) | Enterprise custom | Limitado | Sim | Moderado |

A vantagem principal dos templates Anthropic é a combinação de customizabilidade + audit log nativo + qualidade do modelo subjacente (Opus 4.7 lidera Vals AI Finance benchmark).

## Limitações honestas

- Os templates são ponto de partida, não produto final. Uma firma real precisará customizar Skills para suas metodologias proprietárias, conectar Connectors aos seus sistemas internos (Bloomberg Terminal, sistemas de risco próprios), e treinar analistas para usar e supervisionar os agentes corretamente.
- O custo de ownership não é só licença Anthropic — inclui tempo de integração, treinamento de equipe, validação de outputs, e manutenção dos templates conforme regulações mudam.
- O benchmark Vals AI Finance Agent (64.37% Opus 4.7) mede capacidade de completar tarefas financeiras em contexto de teste. Performance em produção com dados reais e edge cases de mercado pode diferir.
- Mercados emergentes (Brasil, LATAM) têm regulações específicas (CVM, BACEN, SUSEP) não endereçadas nos templates padrão — requerem customização significativa.

## Related

- [[03-RESOURCES/entities/Claude-Cowork]]
- [[03-RESOURCES/entities/Claude-Managed-Agents]]
- [[03-RESOURCES/concepts/agent-systems/financial-services-agents]]
- [[03-RESOURCES/concepts/agent-systems/regulated-domain-agents]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — Material Passport implícito no cross-app context persistence
- [[03-RESOURCES/entities/anthropic]] — publisher
