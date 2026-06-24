---
title: "Harness-1: Reinforcement Learning for Search Agents with State-Externalizing Harnesses"
type: source
source: Clippings/2606.02373v1.md
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, rl, search-agents, harness, paper, arxiv, state-externalization]
---

## Tese central

Search agents devem externalizar o gerenciamento de estado rotineiro (working memory, candidate pools, verification records) para o harness, e não embuti-lo na policy. O RL então otimiza apenas decisões semânticas sobre estado explícito — não bookkeeping recuperável. Um modelo 20B treinado com RL dentro de um harness stateful supera agentes open-source maiores e permanece competitivo com frontier models.

## Argumentos principais

**1. O problema do estado embutido na policy**
A formulação clássica de search agents treina o modelo como policy sobre transcripts crescentes. A policy precisa, ao mesmo tempo: decidir o que buscar E lembrar o que viu, quais documentos são relevantes, quais constraints permanecem abertas, quais claims foram verificados. Isso é ineficiente: o RL é forçado a otimizar bookkeeping recuperável junto com raciocínio semântico.

**2. Separação semântica vs. bookkeeping**
- **Policy retém:** o que buscar, quais documentos manter/descartar, o que verificar, quando parar
- **Harness mantém:** candidate pool, curated set com importance tags, evidence graph, verification records, compressão/dedup de observações, budget-aware context rendering

**3. Três requisitos de treinabilidade para harnesses stateful**
- **Warm-started curation:** auto-seed do curated set com top-8 documentos do primeiro search — muda a task de "construção do zero" para "refinamento"
- **Compact derived-state rendering:** importance tags, evidence graph, verification records — o contexto carrega estado de busca acionável, não transcrição bruta
- **Diversity-preserving incentives:** sem reward de diversidade de tools, a policy colapsa para search-only e ignora curation/verification

## Key insights

**Transferência > performance no domínio de treino**
Harness-1 ganha +17.0 pts médios nos 4 benchmarks *held-out* (fora de SFT e RL) vs. +7.9 pts nos 4 benchmarks source-family — uma razão de **2.2×**. O mecanismo: a policy aprende operações sobre estado de busca domain-general (refinar curated set, ler bridge entities do evidence graph, verificar antes de promover). Essas operações transferem naturalmente porque não dependem de padrões domain-specific nos pesos.

**Menos dados, melhor transferência**
Harness-1 usa apenas 4.352 itens de treino únicos (899 SFT + 3.453 RL). Context-1 usa 9.159, Search-R1 usa 221.328. O harness move o prior comportamental para a interface stateful, permitindo SFT pequeno e RL focado.

**Ablação de componentes**
- Remover importance tags: −7.9% FA recall
- Remover evidence graph: −5.4% FA recall
- Remover verify: −3.9% FA recall
- Desabilitar todos harness mechanisms: −12.2% Recall — maior que qualquer ablação individual (composição de mecanismos)
- Dedup de conteúdo é o único mecanismo que *nominalmente* ajuda no recall bruto (+4.6%), pois o qrel do BC+ inclui near-duplicates; dedup é mecanismo de token budget, não de recall

**Context-1 harness contribui +4 pts sozinho**
Frontier models rodando dentro do Context-1 harness ganham ~4 pontos de recall apenas pela interface — confirmando que o harness é parte do método, não detalhe de implementação.

## Exemplos e evidências

| Model | Avg Curated Recall | Params |
|---|---|---|
| Harness-1 | **0.730** | 20B |
| Context-1 | 0.616 | 20B |
| Tongyi DeepResearch | 0.619 | 30B |
| Search-R1 | 0.296 | 32B |
| GPT-5.4 | 0.627 | frontier |
| Sonnet-4.6 | 0.640 | frontier |
| Opus-4.6 | **0.764** | frontier |

Harness-1 supera todos os open-source small models por +11.4 pts sobre o próximo melhor, e supera GPT-5.4, Sonnet-4.6, Kimi-K2.5 e GPT-OSS-120B. Apenas Opus-4.6 fica à frente.

**Ações do agente (5 classes):**
- `fanout_search` — até 5 queries paralelas diversas
- `search_corpus` / `grep_corpus` — busca híbrida e exata
- `curate` — adiciona/remove/taga documentos (very_high / high / fair / low)
- `verify` — policy escreve claim, harness verifica contra Dt
- `review_docs` — re-renderiza docs já vistos sem nova chamada ao corpus

**WORKINGMEMORY (dois tiers):**
- Inner tier (prompt-facing): Pt (candidate pool), Ct (curated set), It (importance tags), Gt (evidence graph), Vt (verification records), Ht (search history), Bt (budget marker)
- Outer tier: Dt (full-text store) — acessível via `review_docs` / `read_document`

## Implicações para o vault

Este paper é evidência empírica direta para o princípio de [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — a maioria das falhas de agentes vem do harness, não do modelo. Especificamente:

1. **State externalization como design pattern:** O vault SO já usa harnesses stateful (skills como arquivos markdown, manifest.json como estado externo). Harness-1 formaliza isso com a divisão policy/harness e prova que funciona com RL.

2. **RL sobre estado explícito generaliza melhor que RL sobre transcripts:** Implicação para design de agentes treinados: externalizar estado reduz o burden do RL, melhora sample efficiency, e produz comportamentos que transferem.

3. **Diversity-preserving incentives são obrigatórios:** Sem reward de diversidade, qualquer agente RL com tool-use colapsa para a ação de menor custo. Design de reward deve incluir incentivos explícitos para o ritmo search → curate → verify.

4. **Warm-starting evita sparse rewards:** O problema de curated set vazio em early rollouts é análogo ao problema de sparse reward em exploração. Auto-seed é uma forma de curriculum implícito.

## Links

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/concepts/agent-systems/managed-agents-harness]]
- [[03-RESOURCES/concepts/agent-systems/orchestration-mode-pattern]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- Code: https://github.com/pat-jj/harness-1
