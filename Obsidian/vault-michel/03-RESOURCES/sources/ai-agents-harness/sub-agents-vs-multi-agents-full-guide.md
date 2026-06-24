---
title: "Sub-Agents vs. Multi-Agents: The Full Guide"
type: source
category: ai-agents
author: "@nyk_builderz"
source_url: "https://x.com/nyk_builderz/status/2056039028181664106"
published: 2026-05-17
ingested: 2026-05-18
tags: [source, ai-agents, sub-agents, multi-agent, architecture, anthropic-sdk]
triagem_score: 9
---

# Sub-Agents vs. Multi-Agents: The Full Guide

## Tese central

Sub-agentes vencem 7 de 10 tarefas que times habitualmente resolvem com multi-agent — não por serem mais simples, mas porque resolvem problemas diferentes: multi-agent é para **coordenação**, sub-agentes são para **compressão**.

## Key insights

**Decisão arquitetural (árvore):**
```
TASK
├── Fan-out paralelo? (múltiplas threads independentes: audits, scans)
│   └── YES → SUB-AGENTS (compressão)
└── Assembly line sequencial? (especialistas que constroem sobre output anterior)
    ├── YES → MULTI-AGENT TEAM (coordenação)
    └── NO  → ONE AGENT (default mínimo)
```

**Custo de erro:** usar multi-agent onde sub-agentes bastam = 2× custo de tokens + 3× overhead de debugging.

**Propriedades estruturais dos sub-agentes:**
1. Isolamento estrito — sem comunicação horizontal; tudo passa pelo parent controller
2. Sem propagação — não podem spawnar sub-processos downstream
3. Zero context leakage — fresh context por execução; sem dirty state vazando entre runs
4. Truncação intermediária — apenas o payload final volta; tokens de raciocínio interno são descartados

**O objetivo é compressão, não paralelismo:** sub-agentes colapsam 8.000 tokens de exploração em 200 tokens de sinal verificado. O paralelismo é efeito colateral eficiente, não o target.

**Dados de produção (8 teams, Anthropic Agent SDK):** tasks "complexas" de backend são 70% reads de telemetria paralelizados — executados 3× mais barato com sub-agentes.

**Multi-agent team:** cada agente tem identidade operacional explícita, comunicação horizontal nativa, e o coordination bus importa mais do que a capacidade isolada de qualquer nó.

**Regra de ouro de description:** escreva `description` de sub-agente como job posting preciso, não docstring de software — o roteador do framework usa literais de string para matching.

## Links

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — arquitetura multi-agent detalhada
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]] — princípios gerais de arquitetura
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — contexto do harness
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] — engineering patterns

---

## Mecanismo: por que sub-agentes comprimem e não apenas paralelizam

A confusão mais comum é tratar sub-agentes como "agentes que rodam em paralelo". O paralelismo é um efeito colateral — a propriedade definitória é **compressão de contexto**.

Um agente que processa 8.000 tokens de logs de telemetria para extrair 3 anomalias relevantes não está "ajudando" o agente pai — está descartando 7.800 tokens que o pai nunca precisa ver. O pai recebe 200 tokens de sinal verificado. Sem o sub-agente, esses 7.800 tokens polueríam o contexto do pai, aumentariam o risco de confusão e aumentariam custo de inferência.

Esta é a distinção arquitetural central: **sub-agentes são filtros de sinal**, não workers genéricos.

## Por que isolamento estrito importa

As quatro propriedades estruturais (isolamento, sem propagação, zero context leakage, truncação intermediária) não são limitações — são garantias de design deliberadas.

**Isolamento:** comunicação horizontal entre sub-agentes criaria acoplamento implícito. Se sub-agente A influencia sub-agente B diretamente, o pai perde visibilidade sobre o estado do sistema. Todo fluxo de informação passa pelo parent controller, que tem visão global.

**Sem propagação downstream:** sub-agentes não spawnando seus próprios sub-processos previne explosão combinatória de contextos. Em produção, uma tarefa de auditoria que gera 10 sub-agentes, cada um gerando 5 sub-sub-agentes, resulta em 50 contextos impossíveis de depurar.

**Zero context leakage:** fresh context por execução elimina dirty state. Um sub-agente que processou dados sensíveis numa execução não carrega vestígios para a próxima. Relevante para sistemas com dados de múltiplos clientes.

**Truncação intermediária:** apenas o payload final retorna ao pai. Os tokens de chain-of-thought interno do sub-agente são descartados. Isso é eficiência, não limitação — o raciocínio interno não tem valor para o pai; o resultado verificado sim.

## Quando multi-agent teams são a escolha certa

Multi-agent teams resolvem um problema diferente: **coordenação de especialistas que precisam de contexto compartilhado**.

Use multi-agent quando:
- O output de um agente é *input direto e dependente* do próximo (assembly line, não fan-out)
- Agentes precisam negociar ou revisar outputs uns dos outros (QA agent precisa ver o que o feature agent produziu)
- A tarefa requer identidade operacional persistente por agente (um "Security Agent" que mantém estado de ameaças ao longo de múltiplas sessões)
- O coordination bus (como os agentes se comunicam) é parte do design do produto

A regra de ouro: se você pode descrever a tarefa como "N coisas independentes que precisam ser feitas", use sub-agentes. Se você precisa descrever "N especialistas que constroem sobre o trabalho um do outro", use multi-agent.

## Exemplo prático: auditoria de codebase

**Com sub-agentes (correto para este caso):**
```
Parent: "Audite estes 12 serviços para vulnerabilidades SQL injection"
├── sub-agent-1: analisa serviço-A → retorna: [vuln encontrada: linha 47]
├── sub-agent-2: analisa serviço-B → retorna: [clean]
├── sub-agent-3: analisa serviço-C → retorna: [vuln encontrada: linha 203]
...
Parent: agrega 12 resultados comprimidos → gera relatório
```

**Com multi-agent (errado para este caso):**
```
Coordinator: distribui para 12 feature-agents que dependem do trabalho de outros?
→ Não há dependência entre serviços, então o overhead de coordenação é puro desperdício
```

**Com multi-agent (correto para outro caso):**
```
Spec Agent: escreve SPEC.md → Feature Agent: implementa → QA Agent: valida contra SPEC.md
→ Cada estágio depende do anterior; coordenação é necessária
```

## Custo de erro: por que a escolha errada é cara

Usar multi-agent onde sub-agentes bastam custa 2× em tokens + 3× em debugging overhead (dado de produção da fonte). O 3× em debugging é o mais caro:

- Multi-agent teams têm estado distribuído — quando algo falha, o debugging requer reconstruir o estado de múltiplos agentes
- Sub-agentes têm falha isolada — se sub-agente-3 falha, o pai vê exatamente qual input causou a falha; os outros 11 sub-agentes não são afetados

## Implementação com Anthropic Agent SDK

A `description` do sub-agente é o campo mais crítico do SDK. O framework usa literais de string para roteamento — não há inferência semântica avançada. Escrever `description` como job posting preciso:

```python
# Ruim — vago, será roteado incorretamente
description="Analisa código"

# Bom — preciso, cobrindo variações de caso de uso
description="Analisa um único serviço Python para vulnerabilidades SQL injection. Use quando: auditar um endpoint específico, verificar queries de banco de dados, revisar ORM usage. Retorna: lista de vulnerabilidades encontradas com arquivo e linha, ou confirmação de que está clean."
```

## Relevância no vault

O vault usa sub-agentes na skill `batch-ingest`: cada fonte é processada por um sub-agente independente que ingere, cria o arquivo wiki, atualiza o manifest e retorna confirmação. O orquestrador (agente principal) não vê o processamento interno de cada fonte — apenas os resultados comprimidos. Este é o padrão exato descrito na fonte.
