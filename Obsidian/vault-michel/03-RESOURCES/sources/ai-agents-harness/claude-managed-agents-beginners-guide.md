---
title: Ultimate Beginners Guide to Claude Managed Agents
type: source
created: 2026-04-27
updated: 2026-04-27
tags: [managed-agents, business, api, anthropic]
source_file: .raw/articles/Ultimate Beginners Guide to Claude Managed Agents.md
triagem_score: 7
---

# Claude Managed Agents — Beginners Guide

Non-technical intro to [[Claude-Managed-Agents]]. Lowers AI services barrier: "describe what you want, we handle infrastructure."

## Core Concepts

**4 Building Blocks:**
- **Agent** — Job description. Model choice, instructions, tool access
- **Environment** — Workspace with pre-loaded tools (like onboarding a new employee)
- **Session** — Running conversation, agent memory persists, multi-hour capable
- **Events** — Message loop. Tasks in → status updates + results out

## Permission System

Two modes:
- **Auto-run** — Agent handles everything (internal tools)
- **Approval-required** — Agent pauses before sensitive actions (client-facing)

Mix both: auto-read/search, but approval before send/update.

## Business Opportunity

Target firms that won't self-serve (law, accounting, real estate, medical):

1. Run $999 AI audit → identify top time waster
2. Build managed agent solving that problem
3. Deploy on Anthropic infrastructure
4. Charge $500/month recurring

Economics: 4 clients = $2K/mo, 10 = $5K/mo. Low maintenance vs. meetings.

## Use Cases (Real)

**For own business:**
- Client email → draft responses in your voice
- Competitive monitoring + weekly briefings
- Content agent: rough notes → finished blog/social/newsletter

**As service ($1,500–5K setup + $500/mo):**
- Client onboarding agents
- Report generators (multi-source aggregation)
- Customer support + escalation
- Document processors (extract → organize)
- Project management agents (Asana/Linear)

## Pricing

Usage-based:
- Standard Claude API rates
- $0.08/session-hour (active runtime)
- $10 per 1,000 web searches (optional)

Typical 10-min session: a few cents.

## Getting Started

Path 1: Claude Code → `"start onboarding for managed agents in Claude API"`

Path 2: Non-technical → Join Build With AI community, live office hours.

---

**Author:** Unknown (builder-focused guide)  
**Key Insight:** Barrier dropped from "hire dev team" to "describe the job."

---

## Managed Agents vs Claude Code vs Claude.ai

A confusão comum: qual produto usar para qual caso de uso?

| Produto | Para quem | Como funciona | Persistência |
|---|---|---|---|
| Claude.ai | Usuário individual, tarefas ad-hoc | Chat na web | Nenhuma entre sessões |
| Claude Code | Desenvolvedor, codebase | CLI local + ferramentas de sistema | Por projeto (CLAUDE.md) |
| Managed Agents API | Builder que quer vender agentes | API com ambiente gerenciado | Por session (até multi-horas) |

Managed Agents é a oferta **para builders**, não para usuários finais. O builder constrói e hospeda o agente; o cliente final interage sem saber que está usando Claude.

## Arquitetura técnica dos 4 blocos

### Agent (Descrição de Job)

O agente é configurado via API com:
- **Model**: qual versão do Claude (Sonnet, Opus, Haiku)
- **System prompt**: as instruções de comportamento — o "job description"
- **Tool access**: quais ferramentas o agente pode usar (web search, code execution, custom tools)
- **Memory config**: o que persistir entre turns dentro da session

Um agente bem definido tem escopo estreito e instruções específicas. Um agente de "suporte ao cliente para plano de saúde" sabe: linguagem da empresa, políticas de cobertura, processo de autorização, tom de comunicação. Não é um agente genérico com system prompt curto.

### Environment (Workspace pré-configurado)

O ambiente define as ferramentas disponíveis e as condições de inicialização. Analogia do guia: "onboardar um novo funcionário" — você não explica tudo do zero na primeira conversa; o ambiente já vem configurado com o contexto necessário.

Inclui: bases de conhecimento carregadas, conexões de API pré-autenticadas, templates de output, contexto de empresa/cliente.

### Session (Conversa persistente)

A session é uma instância em execução do agente — pode durar horas, processar múltiplas tarefas, manter estado ao longo do tempo. Durante uma session, o agente pode:
- Completar tarefas em sequência
- Pausar para aprovação humana em etapas críticas
- Retornar status updates antes do resultado final
- Manter contexto de decisões anteriores dentro da session

### Events (Loop de mensagens)

O modelo de comunicação é orientado a eventos:
- **Input event**: tarefa ou mensagem entregue ao agente
- **Status event**: agente reporta progresso ou pede aprovação
- **Output event**: resultado entregue de volta ao caller

Isso permite integração com sistemas existentes (webhooks, Slack, email) sem bloquear o caller esperando a resposta.

## O sistema de permissões em detalhes

### Auto-run vs Approval-required

O design correto mistura os dois modos baseado em reversibilidade:

**Auto-run (sem confirmação):**
- Leitura de dados (busca, consulta, análise)
- Operações reversíveis (rascunhos, staging)
- Ações de baixo risco (classificação, extração)

**Approval-required (pausa antes de executar):**
- Envio de emails ou mensagens
- Atualizações de banco de dados
- Transferências financeiras
- Publicação de conteúdo

A regra prática: se a ação é irreversível ou tem impacto externo, requer aprovação. Se é leitura ou rascunho, auto-run.

## O modelo de negócio para builders

### Por que profissionais liberais são o target certo

Firmas de advocacia, contabilidade, medicina e imobiliário têm características ideais:
1. **Processos repetitivos de alto valor**: triagem de documentos, revisão de contratos, geração de relatórios
2. **Não vão self-serve**: não têm equipe técnica para construir e manter soluções próprias
3. **Dispostos a pagar por resultado**: já pagam consultores a $200-500/hora por trabalho manual
4. **Dados sensíveis**: valorizam privacidade e controle — preferem uma solução configurada especificamente para eles

### Estrutura de projeto

O guia propõe um fluxo de vendas:

1. **AI Audit ($999)**: sessão de 2h para mapear onde a firma perde mais tempo em tarefas repetitivas. Entregável: relatório com top 3 oportunidades de automação com ROI estimado.

2. **Build e Deploy ($1.500-5K setup)**: construir o agente resolvendo o problema #1 do audit. Deploy na infraestrutura Anthropic — o cliente não precisa gerenciar servidor.

3. **Manutenção ($500/mês)**: atualização de base de conhecimento, ajuste de instruções, adição de novos workflows, suporte.

**Matemática do negócio:**
- 4 clientes: $2K/mês de MRR ($24K/ano)
- 10 clientes: $5K/mês de MRR ($60K/ano)
- 20 clientes: $10K/mês de MRR ($120K/ano)

Com agentes bem construídos, manutenção por cliente é <2h/mês.

## Pricing da API em contexto real

O modelo de precificação `$0.08/session-hour` parece caro até calcular em cases reais:

- Agente de triagem de emails (10 min/dia): ~$0.013/dia → $0.40/mês
- Agente de geração de relatório semanal (30 min): ~$0.04/semana → $0.16/mês
- Agente de suporte ao cliente (8h/dia ativo): ~$19.20/mês em runtime

O runtime é custoso apenas para agentes sempre-ativos. Para workflows pontuais, o custo é marginal comparado ao tempo economizado.

## Comparação com alternativas de deploy

| Opção | Setup | Manutenção | Custo | Escalabilidade |
|---|---|---|---|---|
| Managed Agents API | Baixo (só API) | Baixo | Usage-based | Alta |
| Self-hosted (VPS + Claude API) | Médio (servidor + código) | Médio | Fixo + usage | Média |
| n8n + Claude | Baixo | Baixo | Fixo + usage | Baixa |
| Equipe humana | Zero | Alto | Alto (salários) | Manual |

Para builders que querem vender como serviço, Managed Agents elimina a necessidade de gerenciar infraestrutura — reduz a barreira de "quantos clientes posso servir com minha capacidade técnica".

## Aplicação no vault

O vault pode ser o "workspace" de um Managed Agent. Exemplo: um agente de ingestão de fontes para o vault, construído sobre Managed Agents:
- **Environment**: pasta `.raw/` como workspace + vault como base de conhecimento
- **Tools**: `wiki-ingest` skill, `hot.md` updater, wikilink resolver
- **Session**: multi-turn — processa uma fila de fontes em sequência
- **Events**: retorna confirmação de cada ingestão + summary final

Isso transformaria a ingestão batch de um processo manual em um agente managed que roda autonomamente.

## Referências adicionais

- [[03-RESOURCES/entities/Claude-Managed-Agents]] — entidade com detalhes técnicos da API
- [[03-RESOURCES/sources/claude-code-cowork/how-to-build-a-claude-cowork-plugin-create-your-own-ai-employee-full-course]] — alternativa via Cowork para usuário não-técnico
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]] — blocos construtivos de agentes
