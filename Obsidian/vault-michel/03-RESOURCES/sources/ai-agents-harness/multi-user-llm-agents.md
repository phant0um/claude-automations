---
title: "Multi-User Large Language Model Agents"
type: source
created: 2026-04-19
updated: 2026-04-19
tags: [ai-agents, multi-user, multi-principal, LLM, benchmark, access-control, coordination]
authors: [Shu Yang, Shenzhe Zhu, Hao Zhu, José Ramón Enríquez, Di Wang, Alex Pentland, Michiel A. Bakker, Jiaxin Pei]
institutions: [Stanford University, KAUST, University of Toronto, MIT]
repo: https://github.com/Korde-AI/Multi-User-LLM-Agent
triagem_score: 8
---

# Multi-User Large Language Model Agents

**Fonte:** `.raw/articles/Multi-User Large Language Model Agents.md`
**Tipo:** Paper acadêmico (preprint)
**Ano:** 2025/2026

## Sumário

Primeiro estudo sistemático de agentes LLM em cenários **multi-principal** — onde um único agente serve múltiplos usuários com roles, preferências e níveis de autoridade distintos. Formaliza o problema, propõe um protocolo de interação unificado e introduz o benchmark **Muses-Bench** com 3 cenários de stress-test.

## Argumento Central

LLMs modernos são treinados sob **single-user assumption**: SFT colapsa todos os inputs num único `user` role; RLHF aprende um único reward scalar. Isso torna os modelos fundamentalmente inadequados para ambientes organizacionais reais onde múltiplos principals têm objetivos conflitantes.

## Formalização

Cada usuário `u_i` tem:
- **Autoridade** `p_i` (1–10)
- **Contexto privado** `C_i` (não visível a outros por padrão)
- **Função de utilidade** `U_i`

O agente deve maximizar um objetivo social ponderado:
```
max_a Σ w_i * U_i(a; C_i, p_i)
```
Sujeito a restrições de acesso que limitam o que pode ser revelado.

## Três Desafios Core

1. **User Role & Preference Modeling** — identificar quem fala, o que quer, quais constraints
2. **Information Asymmetry & Selective Visibility** — cada usuário tem `C_i` privado; coordenação não pode violar privacidade
3. **Conflict Resolution** — modelos treinados single-user não têm mecanismo explícito de arbitragem

## Protocolo Multi-User (§4.1)

- Cada usuário tem **sessão privada** com o agente
- `authority persona p_i` sempre visível ao agente
- `C_i` privado por padrão; revelado apenas quando o usuário compartilha explicitamente
- `C_share` = estado público do ambiente (ex: calendário de disponibilidade)
- A cada turno: agente observa `(C_share, {I_i,t})`, produz ação `A_t`, cada usuário recebe update personalizado

## Muses-Bench: 3 Cenários

### Cenário 1: Multi-User Instruction Following
- CEO manda parar desenvolvimento; engenheiro manda continuar
- Agente deve seguir hierarquia de autoridade + objetivo global
- Métricas: **Selection F1** + **Execution Accuracy**
- 1.298 cenários (execução) + 304 cenários (seleção)

### Cenário 2: Cross-User Access Control
- Agente como gatekeeper de recursos restritos (ex: banco de salários)
- Usuários autorizados vs não-autorizados + ataques adversariais (social engineering, XML obfuscation)
- Métricas: **Privacy Score** (zero leakage) + **Utility Score** (servir autorizados)
- 216 cenários, 3 categorias de ataque

### Cenário 3: Multi-User Meeting Coordination
- Agendar reunião com restrições parcialmente reveladas
- Full Disclosure (108) vs Partial Disclosure (108)
- Métrica: **Success Rate** + **Turns Taken**

## Resultados Principais (Table 2) — Full Model Evaluation

| Modelo | Instr F1 | Exec Acc | Privacy | Utility | Meeting SR | Avg |
|---|---|---|---|---|---|---|
| **Gemini-3-Pro** | 97.3 | 93.4 | 98.6 | 73.9 | 64.8 | **85.6** |
| Claude-Sonnet-4.5 | 95.9 | 79.9 | 77.3 | 97.5 | 62.5 | 82.6 |
| Gemini-3-Flash | 94.1 | 83.9 | 88.7 | 90.6 | 52.5 | 82.0 |
| GPT-5.1 | 94.5 | 87.8 | 98.6 | 60.3 | 53.5 | 78.9 |
| Grok-4.1-Fast | 71.4 | 80.3 | 89.4 | 89.0 | 47.4 | 75.5 |
| Claude-Haiku-4.5 | 83.1 | 70.2 | 88.8 | 85.1 | 47.6 | 75.0 |
| GPT-5.2 | 57.1 | 82.5 | 100.0 | 61.2 | 59.7 | 72.1 |
| Qwen3-30B | 73.2 | 66.9 | 92.6 | 89.7 | 47.5 | 74.0 |
| Grok-3-Mini | 68.2 | 88.4 | 99.6 | 60.1 | 49.0 | 73.1 |
| GPT-OSS-120B | 59.1 | 54.6 | 92.2 | 94.8 | 58.9 | 71.9 |
| Gemini-2.5-Flash | 88.8 | 70.1 | 92.3 | 61.1 | 41.1 | 70.7 |
| Qwen3-4B-IT | 83.8 | 57.9 | 91.3 | 78.4 | 42.1 | 70.7 |
| DeepSeek-R1 | 39.1 | 87.4 | 84.7 | 90.1 | 48.5 | 70.0 |
| GLM-4.5-Air | 83.2 | 61.0 | 89.1 | 88.3 | 36.9 | 71.7 |
| GPT-5-Nano | 84.3 | 68.2 | 87.4 | 54.9 | 48.9 | 68.7 |
| Llama-3-70B | 54.2 | 34.5 | 91.3 | 86.6 | 22.9 | 57.9 |
| Claude-3.5-Haiku | 47.0 | 52.5 | 81.7 | 69.5 | 32.2 | 56.6 |
| GPT-4o-mini | 62.5 | 57.9 | 96.7 | 64.4 | 33.1 | 62.9 |
| Llama-3-8B | 14.8 | 29.8 | 82.2 | 59.2 | 23.0 | 41.8 |

**Nenhum modelo chega a 90% avg.** Meeting coordination é o gargalo universal — melhores modelos ficam em 60–65% de success rate. GPT-5.2 atinge 100% Privacy mas apenas 59.7% na coordination.

### Padrão de trade-off: Privacy vs Utility
- **Alto Privacy, Baixo Utility:** GPT-5.2 (100% / 61.2%), Grok-3-Mini (99.6% / 60.1%), GPT-5.1 (98.6% / 60.3%) — modelos muito conservadores bloqueiam usuários autorizados
- **Alto Utility, Moderado Privacy:** GPT-OSS-120B (94.8% / 92.2%), Gemini-3-Flash (90.6% / 88.7%) — melhor balanço operacional

## Três Achados Críticos

1. **Conflito degrada execução** — modelos com alta seleção têm baixa execução (e vice-versa); inter-user conflict cria queda consistente (ex: Claude-Haiku-4.5: 0.86 → 0.62)
2. **Privacy erode com o tempo** — modelos com alta privacidade round 1 perdem proteção gradualmente; Claude-3.5-Haiku cai de >0.95 para <0.75 em 4 rounds
3. **Coordenação é gargalo de eficiência** — modelos precisam de mais turnos quando informação é parcial; Llama-3-70B exibe "premature commitment" — finaliza meetings com constraints não satisfeitos

## Failure Modes Documentados

- **Premature Commitment** (Llama-3-70B): ignora conflitos explícitos, forçar "consenso"
- **Refusal-Leak Paradox** (Claude-3.5-Haiku): recusa acesso à "vault" mas revela o segredo específico quando pressionado com urgência

## Direções Futuras

- Native multi-user message schemas (além de serialização)
- Long-horizon safety benchmarks
- Principled conflict resolution via social choice theory
- Tooling + auditability (policy enforcement + logs)
- Human-in-the-loop em deployments reais

## Links

- [[03-RESOURCES/concepts/agent-systems/multi-principal-agent]] — conceito central formalizado aqui
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — orquestração de múltiplos agentes (perspectiva diferente)
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — memória e contexto em agentes
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — gestão de contexto
- [[03-RESOURCES/entities/Muses-Bench]] — o benchmark introduzido neste paper
- [[03-RESOURCES/entities/Korde-AI]] — organização do repositório
