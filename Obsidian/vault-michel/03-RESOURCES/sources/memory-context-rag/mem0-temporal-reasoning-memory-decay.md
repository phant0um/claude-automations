---
title: Mem0: Token-Efficient Memory + Temporal Reasoning + Decay
type: source
source: Clippings/The Token-Efficient Memory Algorithm Now Has Temporal Reasoning.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 8
---

## Tese central
Mem0 atualizou algoritmo token-efficient (<7k retrieval budget): +3.8 pts temporal reasoning, +1.5 multi-session. LoCoMo 92.5%, LongMemEval 94.4%.

## Key insights
- Temporal Reasoning: cada memória extrai metadata temporal (quando, ongoing/completed, precisão, tipo) — distingue current vs historical facts.
- Memory Decay: recentes recebem boost até 1.5x; stales até 0.3x. Nada é deletado; ranqueamento só ajustado por idade.
- Search-time only — embeddings/categories/metadata existentes intactos; latência mediana inalterada.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]

## Relações
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/clipping-why-karpathys-second-brain-breaks-at-agent-scale-how-mercury]] — diagnóstico do problema que temporal reasoning resolve
- [[03-RESOURCES/sources/memory-context-rag/agentmemory-persistent-coding-agent]] — resposta complementar (persistência multi-sessão)

---

## O Problema que Mem0 Resolve

Sistemas de memória de agentes tratam todas as memórias como igualmente válidas independente de quando foram criadas. Isso causa erros de raciocínio temporal:

- **Current vs. historical confusion:** O agente sabe que "o usuário mora em São Paulo" (info de 2 anos atrás) e "o usuário mencionou que vai se mudar" (info de ontem). Sem temporal reasoning, o agente não sabe qual fact é atual.
- **Ongoing vs. completed:** "O usuário está aprendendo Python" (ongoing há 6 meses) vs. "O usuário terminou o curso de Python" (completed 1 mês atrás). A memória ongoing pode nunca ter sido atualizada.
- **Precision drift:** "O usuário tem reunião às 15h" (precise, hoje) vs. "O usuário normalmente tem reuniões à tarde" (imprecise, padrão geral). Ambas são verdadeiras mas têm precisão diferente.

---

## O Mecanismo de Temporal Reasoning

Quando uma nova memória é adicionada, o Mem0 extrai automaticamente metadata temporal estruturada:

```json
{
  "memory": "User is learning Python",
  "temporal": {
    "when": "2024-01",
    "status": "ongoing",
    "precision": "month",
    "type": "state"
  }
}
```

**Campos de metadata:**
- `when`: timestamp ou período quando o evento ocorreu/informação foi registrada.
- `status`: `ongoing` (ainda acontecendo), `completed` (terminou), `unknown` (não especificado).
- `precision`: granularidade — `exact`, `day`, `week`, `month`, `year`, `approximate`.
- `type`: categoria — `event` (aconteceu uma vez), `state` (condição contínua), `preference` (preferência pessoal), `fact` (fato fixo).

Esta metadata é usada na fase de retrieval para resolver conflitos temporais.

---

## O Mecanismo de Memory Decay

Mem0 implementa decay baseado em idade sem deletar memórias:

**Score de relevância ajustado:**
```
adjusted_score = semantic_similarity * time_decay_factor
```

**time_decay_factor:**
- Memórias criadas <24h atrás: fator 1.5x (boost de recência)
- Memórias criadas <7 dias: fator 1.2x
- Memórias criadas <30 dias: fator 1.0x (neutro)
- Memórias criadas <1 ano: fator 0.7x (penalidade leve)
- Memórias criadas >1 ano: fator 0.3x (penalidade forte)

**Importante:** O fator varia por `type`:
- `fact` tem decay mais lento (fatos tendem a ser estáveis)
- `state` tem decay mais rápido (estados mudam)
- `event` decai mais rápido ainda (eventos são pontuais e ficam desatualizados)

---

## Benchmarks

| Benchmark | Domínio | Score |
|---|---|---|
| LoCoMo | Long-context conversation memory | 92.5% |
| LongMemEval | Multi-session evaluation | 94.4% |
| Temporal reasoning (custom) | Distinguir current vs. historical | +3.8 pts vs. Mem0 baseline |
| Multi-session continuity | Consistência entre sessões | +1.5 pts vs. Mem0 baseline |

Budget de retrieval: <7k tokens — o sistema funciona dentro de limites restritos de contexto.

---

## Search-Time Only — Zero Breaking Changes

A atualização mais importante do ponto de vista de deployment: temporal reasoning e decay são aplicados apenas no momento do retrieval (query time), não no momento da escrita (ingest time).

Isso significa:
- Embeddings existentes não precisam ser recalculados.
- Schema do banco de dados não muda.
- Memórias antigas não precisam ser migradas.
- Latência mediana de retrieval inalterada (apenas cálculo de fator temporal adicional, que é O(1)).

Para sistemas em produção com milhões de memórias, esta decisão de design evita migration nightmares.

---

## Comparação com Abordagens Alternativas

| Abordagem | Como resolve temporal | Custo |
|---|---|---|
| Sem temporal reasoning | Não resolve — usa memória mais similar semanticamente | Zero |
| Mem0 (antes) | Sem distinção current/historical | Zero |
| Mem0 (atualizado) | Metadata temporal + decay no retrieval | Muito baixo (O(1)) |
| agentmemory | Confidence scoring + lifecycle (stale/archived) | Baixo |
| Manual (hot.md) | Humano decide o que é atual | Alto (esforço humano) |

---

## Implicações para Design de Memória em Agentes

O padrão de temporal metadata + decay é aplicável a qualquer sistema de memória:

1. **Sempre registre quando uma memória foi criada** — sem timestamp, impossível calcular decay.
2. **Registre o status** — `ongoing` vs `completed` resolve grande parte dos conflitos temporais.
3. **Decay por tipo, não uniforme** — fatos decaem mais devagar que estados, que decaem mais devagar que eventos.
4. **Nunca delete** — decay de ranqueamento é suficiente; memórias antigas podem ser valiosas como contexto histórico.

---

## Aplicação no Vault-Michel

`hot.md` implicitamente implementa um subset deste padrão: seções são atualizadas conforme o vault evolui, com conteúdo mais recente refletindo o estado atual. A diferença: hot.md é manual e binário (presente/ausente), enquanto Mem0 é automático e gradual (0.3x – 1.5x).

Melhoria futura: adicionar `updated` timestamp ao frontmatter de todas as notas e usar isso para priorizar retrieval por recência.

---

## Conexões

- [[03-RESOURCES/sources/memory-context-rag/rohitg00-agentmemory-persistent-llm-wiki]] — abordagem complementar (confidence scoring)
- [[03-RESOURCES/sources/memory-context-rag/clipping-memory-is-state-not-a-service]] — debate filosófico sobre onde vive a memória
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
