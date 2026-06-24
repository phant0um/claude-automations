---
title: "Company Brain, Part 2: Factual Memory"
type: source
source_url: "https://x.com/ashwingop/status/2049885545288077720"
author: "[[03-RESOURCES/entities/Ashwin-Gopinath]]"
published: 2026-04-30
created: 2026-05-05
tags:
  - ai-agents
  - company-brain
  - factual-memory
  - knowledge-graph
  - enterprise-ai
category: article
triagem_score: 8
---

# Company Brain, Part 2: Factual Memory

Author [[03-RESOURCES/entities/Ashwin-Gopinath]] (@ashwingop), building [[03-RESOURCES/entities/Sentra-AI]] (enterprise general intelligence).

## Core Argument

Factual memory is the first layer of a Company Brain — the ability to answer "what is this, what happened, where is the source, who owns it, when did it change, how does this thing work?" across all places where work leaves a trace.

## The Three-Layer Framework (referenced)

1. **Factual memory** — what exists, what happened, provenance, ownership, freshness (this piece)
2. **Interaction memory** — why decisions were made (meetings, messages, tradeoffs) — Part 3
3. **Action memory** — (Part 1 introduced)

See companion pages:
- [[03-RESOURCES/sources/clipping-company-brain-part-1]] (if processed)
- [[03-RESOURCES/sources/clipping-company-brain-part-3]] (if processed)

## Why Central Repositories Fail

> "The mistake is to think this can be built as a central repository. That is how knowledge bases die."

People work in docs, Slack, meetings, tickets, Notion, GitHub, email — not in repositories. A Company Brain that asks people to stop working naturally and start feeding a central archive will fail. Memory must emerge from the **individual outward**.

## Individual Brain → Company Brain Emergence

- Individual has: drafts, private notes, local context, working memory
- Company has: official docs, shared decisions, customer commitments, policies
- Good Company Brain respects the **boundary** while letting useful memory emerge

Progression of artifacts:
```
personal note → team doc → roadmap decision → customer commitment
```

Each transition is a moment where individual memory becomes institutional memory.

## Why RAG Alone Is Not Enough

RAG retrieves fragments. Plausible snippets are not durable structure. A company needs:

- **Provenance** — who created it, who modified it, who owns it now
- **Permissions** — can this person see the underlying source?
- **Ownership** — which person/team made it official?
- **Freshness** — is this still current or contradicted by something newer?
- **Source-of-truth boundaries** — can this answer be trusted for a customer conversation?
- **Relationships between artifacts** — not just blobs of text

→ This points to a [[03-RESOURCES/concepts/pkm-obsidian/semantic-file-system]] rather than a retrieval layer.

## Semantic File System

A memory layer where **relationships around the artifact matter as much as the artifact itself**:

```
customer call → account → open issues → tickets → product areas → owners → decisions
```

More than a knowledge graph pasted on top of documents. More than markdown with metadata. The quality of relationships determines the quality of memory.

## Personalization Is Not Decoration

The same question should produce different answers for different roles:
- **IC** → implementation details, owners
- **Manager** → blockers, risk, scope
- **CEO** → shape of the issue across customers and strategy

The system must understand the person asking, what they are allowed to know, and what they are trying to do.

## Proactive vs. Reactive Memory

> "A knowledge base waits. Memory participates."

Proactive triggers:
- Before a customer call → surface open commitments, recent issues, prior conversations
- When someone edits a roadmap doc → surface related customer asks and duplicate work
- When a ticket is assigned → show prior incidents and owners
- When a pricing exception is requested → surface precedent
- When a new employee joins → build a personalized map of what they need to know

## Distinction from Enterprise Search

[[03-RESOURCES/entities/Glean]] showed that finding knowledge across company tools is a real wedge. But a Company Brain must go further: synthesize, personalize, respect permissions, show provenance, notice stale info, admit uncertainty, and **bring the right fact before you ask**.

## Connection to This Wiki's Concepts

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — individual agent memory layers (episodic/semantic/procedural); factual memory is the org-scale analog
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]] — four-layer separation; Company Brain's factual memory adds provenance and permission layers absent from coding-agent memory models
- [[03-RESOURCES/concepts/pkm-obsidian/company-brain]] — parent concept page
- [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]] — concept deep-dive
- [[03-RESOURCES/concepts/pkm-obsidian/semantic-file-system]] — the storage model required
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — why connected memory compounds in value

## Por que a memória individual como ponto de partida é a decisão arquitetural mais importante

A observação de que "memória deve emergir do indivíduo para fora" tem consequências práticas de adoção que repositórios centrais ignoram. Um repositório central tem um problema de bootstrap: para ser útil, precisa ser populado; para ser populado, as pessoas precisam mudar seus workflows; mas as pessoas mudam seus workflows apenas se o repositório já for útil. O Company Brain que emerge do indivíduo não tem esse problema porque começa onde as pessoas já trabalham.

O mapeamento de artefatos — nota pessoal → documento de equipe → decisão de roadmap → compromisso com cliente — também é um modelo de permissões natural. A transição entre níveis é um evento explícito que indica que a informação mudou de escopo. Um sistema que detecta e rastreia essas transições automaticamente não precisa que as pessoas se lembrem de "submeter para o repositório central" — a transição já aconteceu no workflow normal.

## A distinção entre busca empresarial e memória empresarial

Glean (busca empresarial) resolve o problema de encontrar documentos que existem. O Company Brain resolve o problema de saber o que esses documentos implicam no contexto do que o usuário está tentando fazer agora. A diferença é entre "onde está o documento sobre o contrato X?" e "antes de entrar nessa call, o que você precisa saber sobre o cliente X dado que você está negociando renovação?".

A segunda questão requer síntese, personalização por papel e contexto, consciência de staleness, e iniciativa proativa — nenhuma dessas capacidades está no design de um sistema de busca. Enterprise search é um prerequisite do Company Brain, não uma implementação dele.

## Implicações para o vault-michel como Company Brain pessoal

O vault-michel implementa a versão pessoal do Company Brain: a progressão nota → source → concept → entity segue exatamente o modelo de artefato → memória institucional. As propriedades de proveniência (source_file, author, ingested) e staleness (updated, triagem_score) estão presentes nos frontmatters. O que falta é a proatividade — o vault responde a queries mas não antecipa o que o usuário precisa saber antes de uma tarefa específica. Isso é exatamente o que o morning brief do Second Brain de Ryan Wiggins adiciona.
