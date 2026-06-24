---
title: "The Memory Curse: How Expanded Recall Erodes Cooperative Intent in LLM Agents"
type: source
source: Clippings/The Memory Curse How Expanded Recall Erodes Cooperative Intent in LLM Agents.md
created: 2026-05-17
ingested: 2026-05-17
tags: [ai-agents, research, memory, multi-agent, alignment]
triagem_score: 10
---

## Tese central
Aumentar capacidade de memória em agentes LLM degrada cooperação em settings multi-agente — paradoxo: mais memória = mais defecção, não mais coordenação. Paper de CMU + Harvard + Michigan revela mecanismo: memória longa permite agentes lembrarem traições passadas e adotarem estratégias de retaliação dominantes sobre cooperação.

## Key insights
- **Paradoxo de memória:** intuição humana é que mais memória = melhor coordenação (lembrar acordos passados). Realidade empírica: mais memória = retaliação dominante, cooperação colapsa em sistemas com histórico longo
- **Mecanismo: retaliação supera cooperação no equilíbrio de longo prazo:** agente com memória longa aprende que agente B traiu N vezes → adota defecção como política default → agente B retalia → loop de defecção mútua estável
- **CMU + Harvard + Michigan:** paper com rigor metodológico alto — replicado em múltiplos jogos (Prisoner's Dilemma, Stag Hunt, Public Goods) com múltiplos modelos LLM
- **Implicação para design:** memória em MAS precisa de gestão ativa — não só recall, mas also forgetting controlado e decay de rancor para preservar espaço para cooperação

## Background: Teoria dos Jogos em MAS

### Por que cooperação é frágil

Em teoria dos jogos, cooperação é estável quando:
1. Interações são repetidas (não one-shot)
2. Agentes se reconhecem (identidade persistente)
3. Reputação importa (defecção é punida)

Memória torna 2 e 3 possíveis — deveria ajudar cooperação. O paper mostra que memória longa demais inverte o efeito.

### Tit-for-Tat com memória longa

Tit-for-Tat (coopera na primeira vez, depois copia a última ação do oponente) é estratégia famosa de cooperação estável. Com memória longa, degrada para:

- Agente lembra 100 interações passadas onde houve 3 defecções e 97 cooperações
- Peso maior nas defecções (negativity bias aprendido ou inerente ao LLM)
- Decisão: defectar "por precaução"
- Oponente, que cooperava, retalia
- Ciclo de defecção se instala

## Experimentos do paper

### Setup

- Jogos clássicos de teoria dos jogos (Prisoner's Dilemma, Stag Hunt, Public Goods)
- LLMs como agentes (GPT-4, Claude, Llama) com diferentes tamanhos de memória
- Condições: sem memória, memória curta (5 turnos), memória média (20 turnos), memória longa (100+ turnos)
- Múltiplas rodadas por par de agentes

### Resultados

| Memória | Taxa de cooperação |
|---------|-------------------|
| Sem memória | 71% |
| 5 turnos | 78% (pico) |
| 20 turnos | 64% |
| 100+ turnos | 31% |

Pico de cooperação em memória curta — confirma que alguma memória ajuda (lembrar acordos recentes), mas memória longa degrada.

### Mecanismo confirmado

Com análise de raciocínio dos agentes (chain-of-thought logs), paper confirma:
- Com memória longa, agentes explicitamente citam traições antigas como justificativa para defecção atual
- Agentes com memória curta focam em tendência recente — mais adaptável a mudança de comportamento do parceiro

## Implicações para design de MAS

### Forgetting controlado é feature, não bug

Sistema de memória que força decay — interações antigas têm peso menor que recentes — mantém agentes adaptáveis sem acúmulo de rancor. Analogia: humanos bem funcionais não guardam rancor infinitamente.

### Reset de reputação periódico

Em sistemas de longa duração, mecanismo de "slate clean" periódico onde histórico é parcialmente esquecido preserva espaço para reestabelecimento de cooperação após período de defecção.

### Arquitetura prática

```python
memory_entry = {
    "partner_id": "agent_B",
    "action": "defect",
    "weight": 1.0 * decay_factor(age_in_turns=50)  # decay exponencial
}
# decay_factor(50) ≈ 0.05 com meia-vida de 10 turnos
# Traição de 50 turnos atrás = peso 5% vs traição recente
```

## Implicação crítica para agent-memory-architecture

Separar memória de fatos (quem sou eu, o que sei, como o mundo funciona) de memória episódica de interações com outros agentes. Esta segunda categoria precisa de política de decay explícita para preservar cooperação em MAS.

## Generalização além de MAS

O paradoxo de memória pode afetar agentes single em interações com humanos:

Agente com memória longa de interações negativas com usuário (sessões frustrantes, instruções confusas, erros frequentes) pode desenvolver "viés de desconfiança" ao usuário — interpretar ambiguidades negativamente, pedir mais confirmações que necessário, ser mais conservador.

Paradoxalmente, usuário com erros frequentes no passado pode ser novo usuário que melhorou — mas agente com memória longa "lembra" o histórico ruim.

Solução: decay de memória episódica de interações. Manter memória de preferências estáveis (o usuário prefere código em Python) mas decair memória de padrões de interação (o usuário costumava fazer perguntas confusas).

## Conexão com privacy e GDPR

"Direito ao esquecimento" do GDPR tem análogo técnico aqui: permitir que usuários solicitem que o agente "esqueça" histórico de interações específicas. Além de compliance legal, tem benefício funcional — reset de memória episódica negativa pode restaurar cooperação em relacionamento humano-agente deteriorado.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
