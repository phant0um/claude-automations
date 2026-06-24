---
title: "How we built a Single Company Brain (and how you can too)"
type: source
source: "Clippings/How we built a Single Company Brain (and how you can too).md"
source_url: "https://x.com/ericosiu/status/2060415100603781497"
author: "@ericosiu (Eric Siu, Single Grain)"
published: 2026-05-29
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, memory, agent-architecture, company-brain, retrieval, single-grain]
---

# How we built a Single Company Brain (and how you can too)

**Autor:** [[03-RESOURCES/entities/Eric-Siu]] (@ericosiu) — CEO, [[03-RESOURCES/entities/Single-Grain]] / [[03-RESOURCES/entities/SingleBrain]]
**Fonte:** Twitter/X thread, 2026-05-29

---

## Tese central

Uma empresa já tem um cérebro — ele só está fragmentado em Slack, Gong, HubSpot e nas pessoas que estão ausentes hoje. O valor não é uma pasta gigante de conhecimento corporativo (toda empresa já tem isso). O valor real é a **camada de inteligência entre todo esse contexto e o trabalho que o time precisa executar.**

> "A company brain isn't useful because it remembers more. It's useful when it knows what to retrieve, what to trust, who can see it, and how to turn corrections into better work."

**Memória é matéria-prima. Retrieval é a camada operacional.**

---

## Argumentos principais

### O erro comum: memória como armazenamento

A primeira versão do sistema interno da Single Grain tratou memória como contexto máximo. Resultado após 3 semanas: arquivos de memória persistente consumindo 40% da context window. Agentes com mais informação, mas puxando as informações erradas no momento errado. **Tecnicamente mais inteligente, operacionalmente muito mais bagunçado.**

O loop quebrado:

```
Call transcript → Random notes → Human remembers → Agent starts cold → Human re-explains
```

O problema estrutural: o humano vira o router. Cada output depende de alguém ter lembrado a call certa, copiado a nota certa, colado o contexto certo.

### A solução: retrieval como camada operacional

```
Calls ─────┐
CRM ───────┼──► Retrieval ─► Agent ─► Work
SOPs ──────┤        ▲          │
Slack ─────┘        │          ▼
             Human correction ─► Rule
```

Na Single Grain em produção: 500K+ tokens de memória persistente, 90+ crons diários, múltiplos agentes especializados, milhares de calls de vendas alimentando o sistema. 2.862 transcrições Gong transformadas em playbooks operacionais. Um exemplo de ingestão diária: 15 calls → 390 insights + 470 fatos + 125 frameworks.

---

## Key insights

1. **Retrieval beats bigger context** — dar mais contexto ao agente sem retrieval inteligente é uma biblioteca sem catálogo. Sistemas de demo funcionam porque o contexto é alimentado manualmente; falham em produção porque ninguém construiu o retrieval layer.

2. **Memória como matéria-prima, não inteligência** — o agente não precisa de todo o histórico da empresa; precisa das 6 peças de contexto relevantes para a tarefa em frente a ele. Ex.: para redigir email outbound: ICP + oferta + objeções + performance de campanha anterior + voz da marca + meta atual.

3. **Source truth como problema de design operacional** — sem hierarquia de fontes explícita, agentes se tornam "confident liars with better formatting". Algumas fontes são verdade viva, outras contexto histórico, outras inspiração.

4. **Permissions são arquitetura, não add-on** — o agente de marketing não precisa de detalhes de RH; o agente de conteúdo não precisa de financials de clientes. Objetivo: não um cérebro único sem paredes, mas o cérebro certo para o workflow certo.

5. **Feedback loops fazem o sistema compor** — cada correção humana deve virar comportamento futuro. Sem loops de feedback, você está apenas babysitting software. Com eles, cada correção é um treino para todo o sistema operacional.

6. **Decision latency como vantagem real** — o ganho de tempo (ex.: reportes em 60s vs. 25min + horas de follow-up) importa menos do que a mudança em como a empresa opera: líderes não esperam alguém montar o dashboard; operadores não partem do zero.

---

## Arquitetura em 5 camadas

```
┌──────────────┐
│  Execution   │ agents, workflows
├──────────────┤
│  Feedback    │ corrections → rules
├──────────────┤
│  Permission  │ who can use what
├──────────────┤
│ Source Truth │ what to trust
├──────────────┤
│  Retrieval   │ right context now
├──────────────┤
│   Capture    │ calls, CRM, SOPs
└──────────────┘
```

### Layer 1: Capture
Onde times geralmente começam e param. Gravar reuniões, transcrever calls, salvar Slack — e chamar isso de cérebro. É uma unidade de armazenamento, não um cérebro. Captura fornece matéria-prima, mas matéria-prima não toma decisões.

### Layer 2: Retrieval
Onde o sistema começa a ser útil. Retrieval inteligente = contexto correto para a tarefa em frente, não o histórico inteiro. Falhando aqui → sistema parece inteligente em demo, colapsa em produção.

### Layer 3: Source Truth
Uma vez que agentes conseguem recuperar contexto, o problema é confiança. Qual fonte ganha? A call de vendas? O campo do CRM? A correção no Slack? O SOP antigo? Sem hierarquia de fontes, agentes inventam com formatação impecável.

### Layer 4: Permissions
Inteligência corporativa fica perigosa quando todo agente vê tudo. Especialmente crítico em agências e empresas de serviço com contextos de cliente, interno, prospect, financeiro e estratégico co-residindo. Permissões por workflow antes de qualquer geração.

### Layer 5: Feedback Loops
A camada que faz o sistema compor. Cada correção humana → atualização de regra futura: frase engessada → rule de voz; exemplo inseguro → rule de fonte; sinal de risco de CRM perdido → rule de pipeline scan. Empresa que aprende vs. empresa que babysits software.

---

## Audit rápido para implementação

Para qualquer workflow recorrente que já perde tempo (report semanal, revisão de pipeline, geração de conteúdo, follow-up de call):

1. De quais fontes este workflow depende?
2. Qual fonte é a verdade quando conflitam?
3. Que contexto o agente precisa sempre?
4. Que contexto o agente nunca deve ver?
5. Que correções humanas acontecem repetidamente?
6. Como uma correção vira uma regra futura?

> "If you can't answer those, you're not ready to automate the workflow yet. You'll just make the mess faster."

---

## Exemplos e evidências

- **2.862 transcrições Gong** → playbooks operacionais. Uma call deixa de ser só uma call e se torna: biblioteca de objeções + input de treinamento de vendas + sinal de positioning + fonte de ideias de conteúdo + flag de risco no CRM + instrução de agente futuro.
- **Weekly reporting**: de 25min de coleta de dados + horas de follow-up → resposta em menos de 60 segundos.
- **Single Grain atual**: 500K+ tokens memória persistente, 90+ crons diários, múltiplos agentes especializados.

---

## Implicações para o vault

- **Retrieval over context size** complementa e fortalece o padrão [[03-RESOURCES/concepts/memory-context-rag/contextual-agentic-memory-is-a-memo]] — memória como C-engineering requer retrieval inteligente, não só mais tokens.
- **5-layer system** é uma implementação prática do que [[03-RESOURCES/concepts/pkm-obsidian/company-brain]] descreve teoricamente. Ericosiu traz evidências de produção (Single Grain) onde a teoria anterior (Ashwin Gopinath / Sentra AI) era mais conceitual.
- **Permissions layer** alinha com [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]] — permissões como arquitetura de harness, não configuração.
- **Feedback → Rule** é a mesma mecânica de [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] mas aplicada a escala corporativa, não por agente individual.
- **Vault como Company Brain**: o vault-michel já segue partes desta arquitetura (hot.md = retrieval layer; manifest = source truth; CLAUDE.md = permissões implícitas). Gap: feedback loops sistemáticos (correções → rules) não estão formalizados.

---

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/company-brain]] — conceito base; este source adiciona evidências de produção + arquitetura 5 camadas de Ericosiu/Single Grain
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — fundamentos de memória de agente; este source adiciona a perspectiva de escala organizacional
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] — feedback loop em agentes individuais; este source expande para escala de empresa
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]] — permissions como camada arquitetural
- [[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-1-data-vs-memory]] — série Company Brain por Ashwin Gopinath (perspectiva diferente, mesmo problema)
- [[03-RESOURCES/sources/ai-agents-harness/stop-babysitting-agents-definition-of-done-ericosiu]] — post anterior do mesmo autor; Definition of Done framework
