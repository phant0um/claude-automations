---
title: "Agent Lifespan Engineering (ALE)"
type: concept
status: developing
created: 2026-05-28
updated: 2026-05-28
tags: [concept, ai-agents, agent-memory, deployment, aging, benchmark, longitudinal]
aliases: [ALE, agent-aging, agingbench]
---

# Agent Lifespan Engineering (ALE)

## Definição

**Agent Lifespan Engineering (ALE)** é a disciplina de medir, diagnosticar e reparar degradação em sistemas de agentes de longa duração. A premissa central: **confiabilidade é uma propriedade de vida útil do harness completo**, não uma propriedade snapshot do modelo base.

> Um agente deployed não é apenas um modelo — é um harness (LLM + escrita de memória + armazenamento + retrieval + utilização + tools). Mesmo com pesos congelados, o estado efetivo do sistema continua mudando.

---

## As Três Perguntas de ALE

1. **Por quanto tempo** um agente deployed permanece confiável?
2. **Como** a confiabilidade decai: através de compression, interference, revision ou maintenance?
3. **Onde** a reparação deve ser direcionada: escrita, retrieval, utilização ou o ciclo de vida da memória?

---

## Os Quatro Mecanismos de Aging

### Accumulation-driven (piora com o crescimento do estado)

| Mecanismo | Causa | Sintoma |
|-----------|-------|---------|
| **Compression aging** | Write-time summarization descarta detalhes relevantes futuros (valores numéricos, nomes próprios, constraints específicos) | Respostas sumariadas imprecisas; omissão de detalhes de baixa frequência |
| **Interference aging** | Entradas similares acumuladas competem durante retrieval — mesmo sem perda de informação, sem mudança de fatos | Confusão de entidades; resposta de cliente errado |

### Event-driven (disparado por mudanças discretas)

| Mecanismo | Causa | Sintoma |
|-----------|-------|---------|
| **Revision aging** | Fatos mudam mas o agente não propaga updates; forma grave: *dynamic latent state* (respostas derivadas de somas/deltas acumulados) | Respostas obsoletas confiantes; erros compostos em acumuladores |
| **Maintenance aging** | Eventos rotineiros (recompactação, flush de histórico, rotação de modelo, limpeza de logs) | Regressão abrupta pós-evento; performance cliff |

---

## Pipeline de Memória e Attribution

O agente deployed é um ciclo de dataflow:

```
History → [W] → Store [S] → [R] → Context → [U] → Answer
```

- **W** (Write/Compression Policy): transforma histórico em formato persistente
- **S** (Memory Store): artefato persistente
- **R** (Read/Retrieval): extrai working context para tarefa atual
- **U** (Utilization Logic): raciocínio + síntese

### Diagnóstico Contrafactual (P1/P2/P3)

| Probe | Write | Retrieval | Utilize |
|-------|-------|-----------|---------|
| P1 baseline | Agent | Agent | Agent |
| P2 oracle retrieval | Agent | **Oracle** | Agent |
| P3 oracle context | **Oracle** | **Oracle** | Agent |

- `Acc_P3 − Acc_P2` = Write error (compression aging signature)
- `Acc_P2 − Acc_P1` = Read error (interference aging signature)
- `1 − Acc_P3` = Utilization error (revision aging signature)

**Insight chave**: a mesma taxa de erro agregada (~0.60–0.82) pode ter composições U/W/R completamente diferentes entre modelos e cenários. Score único de memória descarta o sinal de diagnóstico que mais importa.

---

## AgingBench

Benchmark longitudinal que implementa ALE. Usa **temporal dependency DAG** com:
- Version chains (supersessão de fatos com ground truth rastreado)
- Dependency edges (probes requerendo síntese multi-sessão)
- Interference pairs (entidades confundíveis com resposta correta conhecida)

Métricas: half-life t½ (sessões até 50% de perda de capability), decay slope, hazard proxy.

7 cenários × 14 modelos × múltiplas políticas de memória × ~400 runs.

---

## Findings Críticos (AgingBench 2026)

1. **Aging é multidimensional**: nenhum modelo domina em todos os mecanismos
2. **Compliance comportamental e precisão factual degradam independentemente**: CVR (constraint violation rate) fica em 0 enquanto precisão cai — monitoramento comportamental perde a degradação
3. **Revision aging é representacional**: modelos maiores não melhoram consistentemente acumulador de estado — precisa de state maintenance explícito ou recomputação periódica
4. **Claude Code Sonnet-4.6** teve melhores resultados gerais em Tier 2 autônomo
5. **Opus-4.7 paradox**: raciocínio forte mas ws_fid baixo — lida bem com o que recupera mas produz artefatos de write-time de fidelidade menor

---

## Implicações Práticas

- **Para agentes de produção**: monitorar apenas comportamento (respostas fluentes, sem erros explícitos) não detecta aging factual. Requer probes mecanismo-específicos.
- **Para design**: política de compaction que preserva valores numéricos e nomes próprios (careful compression) melhora compression aging mas pode piorar interference — trade-offs entre mecanismos.
- **Para reparação**: diagnóstico de pipeline antes de prescrever solução. "Dar mais memória" é a prescrição genérica que o paper refuta.
- **Relevância vault**: `hot.md` e `MEMORY.md` estão sujeitos aos mesmos mecanismos de compression e revision aging.

---

## Relação com Outros Conceitos

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — estrutura de memória; ALE estuda sua degradação ao longo do tempo
- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]] — ALE adiciona dimensão longitudinal vs. snapshot
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — confiabilidade como propriedade do harness
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] — feedback loops como mitigação de aging

---

## Fontes

- [[03-RESOURCES/sources/ml-research-papers/agingbench-agent-lifespan-engineering-2026]] — Zhu et al., arXiv 2605.26302 (UT Austin, 2026-05-25)
