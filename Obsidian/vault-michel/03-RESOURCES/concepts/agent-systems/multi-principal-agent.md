---
title: Multi-Principal Agent
type: concept
status: developing
created: 2026-04-19
updated: 2026-04-19
tags: [ai-agents, multi-user, principal-agent, coordination, conflict-resolution, access-control]
---

# Multi-Principal Agent

## Definição

Em contraste com o **Single Principal–Agent** (LLM serve um único usuário com um único objetivo), o cenário **Multi-Principal** envolve um único agente LLM servindo múltiplos usuários que atuam como **principals independentes** — cada um com utilidades, roles, contextos privados e objetivos potencialmente conflitantes.

Formalização (de [[03-RESOURCES/sources/ai-agents-harness/multi-user-llm-agents]]):

Cada usuário `u_i` é caracterizado por:
- `p_i` — authority persona (nível 1–10)
- `C_i` — contexto privado (não visível a outros por padrão)
- `U_i(a; C_i, p_i)` — função de utilidade

O agente maximiza um **objetivo social ponderado**:
```
max_a Σ w_i * U_i(a; C_i, p_i)
```

## Por que LLMs Atuais Falham

LLMs treinados com:
- **SFT** — colapsa todos os inputs em single `user` role
- **RLHF** — aprende um único reward scalar que conflate preferências de usuários distintos

Resultado: modelos são incapazes de representar múltiplos principals, raciocinar sobre trade-offs cross-user, ou enforcar restrições específicas por usuário.

## Três Desafios Fundamentais

### 1. User Role & Preference Modeling
Identificar quem fala, inferir objetivos individuais, manter atribuição estável ao longo de conversas longas com muitos participantes.

### 2. Information Asymmetry & Selective Visibility
Cada usuário tem `C_i` privado. O agente media comunicação sem violar privacidade ou expor informação não autorizada. Análogo ao problema moral hazard em economia (Holmström, 1979).

### 3. Conflict Resolution
Quando usuários têm objetivos incompatíveis, o agente precisa de arbitragem principiada — não apenas seguir o usuário mais assertivo ou mais frequente. Modelos single-user não têm mecanismo explícito para isso.

## Protocolo Multi-User (Muses-Bench)

```
Sessões privadas por usuário
  ↓
Agente observa: (C_share, {I_i,t | u_i ∈ U})
  ↓
Produz ação A_t
  ↓
Update personalizado para cada usuário (somente seu escopo)
```

- `C_share` = estado público do ambiente (ex: calendário)
- `authority persona p_i` sempre visível ao agente
- `C_i` revelado só quando o usuário decide compartilhar

## Hierarquia de Autoridade (exemplo organizacional)

```
CEO (9-10) > Director > Manager (6) > Senior IC (4) > Junior IC (2) > Intern (1)
```

## Cenários de Stress-Test (Muses-Bench)

| Cenário | Desafio | Métrica |
|---|---|---|
| Multi-User Instruction Following | Conflitos de autoridade | F1 + Execution Acc |
| Cross-User Access Control | Privacy vs Utility | Privacy Score + Utility Score |
| Multi-User Meeting Coordination | Coordenação parcial | Success Rate + Turns |

## Achados Empíricos

- Melhor modelo (Gemini-3-Pro): **85.6% avg** — ainda longe de resolvido
- Privacy erode gradualmente em multi-round: de >0.95 para <0.75 em 4 rounds
- Meeting coordination com partial disclosure: queda drástica para N>10 usuários
- **Premature Commitment** = falha de rastreio de constraints (Llama-3-70B)
- **Refusal-Leak Paradox** = recusa acesso mas revela o dado sob pressão social

## Direções de Pesquisa

- Native multi-user message schemas (além de serialização)
- Social choice theory aplicada a conflict resolution
- Long-horizon safety benchmarks
- Policy enforcement + auditability

## Ligações

- [[03-RESOURCES/sources/ai-agents-harness/multi-user-llm-agents]] — paper que formaliza este conceito
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — múltiplos agentes (vs múltiplos usuários de 1 agente)
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — como agentes mantêm contexto por usuário
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — selective visibility e gestão de C_i
- [[03-RESOURCES/entities/Muses-Bench]] — benchmark para avaliar sistemas multi-principal
