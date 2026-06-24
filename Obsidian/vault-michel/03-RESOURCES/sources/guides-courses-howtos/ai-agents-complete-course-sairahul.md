---
title: "AI Agents: The Complete Course"
type: source
source_file: "Clippings/AI Agents The Complete Course.md"
origin: "x.com/@sairahul1"
author: "@sairahul1"
ingested: 2026-05-28
tags: [ai-agents, course, react-loop, multi-agent, production, guardrails, observability, security]
triagem_score: 8
---
# AI Agents: The Complete Course

> [!key-insight] Tese central
> Roadmap completo de agentes IA em 3 níveis (Beginner/Intermediate/Production), desde o ReAct loop básico até observabilidade e segurança em escala. A maior lacuna entre quem protótipa e quem faz ship é o que está neste guia.

## Conteúdo

### Parte 1 — Beginner

**ReAct Loop:** Reason → Act → Observe → Repeat. Cada iteração adiciona profundidade, reduz alucinações.

**Matriz de uso:** Complexidade × Precisão necessária. Sweet spot: alta complexidade + baixa precisão (iniciar aqui). Alta complexidade + alta precisão = agentes com guardrails pesados.

**Espectro de autonomia:** Scripted → Semi-autônomo (maioria dos sistemas de produção) → Totalmente autônomo. Começar no meio.

**Context Engineering:** O que o agente sabe em cada momento (background, papel, memória, ferramentas, conhecimento). Isso separa agentes ótimos de quebrados — não o modelo.

**Task Decomposition:** Habilidade mais importante. Cada passo: pequeno, verificável, entrada/saída claros.

### Parte 2 — Intermediate

**Evals:** Avaliar desde o dia 1. LLM-as-judge para tarefas complexas. Dois níveis: component-level + end-to-end.

**Memória vs Conhecimento:** Memória = dinâmica, atualiza a cada run (short-term + long-term). Conhecimento = estático, carregado de início. Não se substituem.

**Guardrails — 3 tipos:**
1. Code checks — determinístico, sem custo
2. LLM judge — qualidade nuançada
3. Human in the loop — decisões de alto risco

**4 Design Patterns:** Reflection, Tool Use, Planning, Multi-Agent Collaboration.

**Coordenação multi-agente:** Sequential → Parallel → Manager Hierarchy → All-to-All. Começar em Sequential.

### Parte 3 — Production

**4 decomposição patterns:** Functional / Spatial / Temporal / Data-driven. Podem ser combinados.

**Melhorar qualidade:** Fix prompts → trocar modelo → decompor mais → fine-tune (último recurso).

**Custo típico por run de research agent:**
- LLM: ~$0.04 / Search API: ~$0.02 / Embeddings: ~$0.005 / Infra: ~$0.015
- Total: ~$0.08 → $2.400/mês a 1K runs/dia

**Observabilidade:** Zoom-in (trace único) + Zoom-out (health metrics agregados). Log "por que" o agente tomou cada decisão.

**Segurança:** Ameaças são do próprio sistema, não só externos — prompt injection, unsafe code gen, data leakage, resource exhaustion. Code execution requer Docker sandbox + resource limits + whitelist de libs.

## Key Insights

- "Context engineering is the real intelligence" — modelo é commodity; contexto é vantagem
- A maioria chega em qualidade suficiente no passo 2 (trocar modelo), não precisa de fine-tune
- Security para agentes: proteger o sistema contra si mesmo, não só contra atacantes externos
- Evals são o que separa profissionais de hobbyistas

## Implicações para o vault

- Complementa e sintetiza [[03-RESOURCES/concepts/agent-systems/agentic-patterns]]
- Adiciona framework concreto a [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- Referência de custos reais para [[03-RESOURCES/concepts/agent-systems/token-economy]]
- Segurança: amplia [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]

## Links

- Fonte: `Clippings/AI Agents The Complete Course.md`
- Conceito: [[03-RESOURCES/concepts/agent-systems/agentic-patterns]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]
