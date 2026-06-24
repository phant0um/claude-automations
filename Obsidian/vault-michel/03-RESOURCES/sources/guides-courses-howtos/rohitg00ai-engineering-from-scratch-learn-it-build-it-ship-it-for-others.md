---
title: "rohitg00/ai-engineering-from-scratch: Learn it. Build it. Ship it for others."
type: source
source: "Clippings/rohitg00ai-engineering-from-scratch Learn it. Build it. Ship it for others..md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-engineering, curriculum, open-source, agents, education, mcp]
---

## Tese central

Currículo open-source de 503 lições / 20 fases / ~320 horas que fecha o gap entre "usar AI" e "entender AI de verdade": cada algoritmo é construído do zero (da matemática ao código) antes de usar qualquer framework, e cada lição produz um artefato reutilizável (prompt, skill, agente, ou servidor MCP) — não apenas conhecimento.

## Argumentos principais

- 84% dos estudantes já usam ferramentas de AI; apenas 18% se sentem preparados para usá-las profissionalmente — esse currículo fecha esse gap.
- A metodologia "Build It / Use It" é o pilar: implementar o algoritmo raw primeiro (backprop, tokenizer, attention, agent loop), depois usar PyTorch/sklearn para entender o que o framework faz por baixo.
- Cada lição = 6 beats: MOTTO → PROBLEM → CONCEPT → BUILD IT → USE IT → SHIP IT (o artefato entregue).
- Estrutura: 20 fases lineares de Math Foundations → Agent Engineering → Autonomous Systems → Multi-Agent Swarms → Infrastructure → Ethics/Alignment → 17 Capstone Projects.
- MIT license, gratuito, roda no laptop local.

## Key insights

- Fases de maior relevância para o vault: Phase 13 (Tools & Protocols — MCP do zero), Phase 14 (Agent Engineering — 42 lições incluindo Agent Workbench, Scope Contracts, Verification Gates), Phase 15 (Autonomous Systems — safety stack 2026), Phase 16 (Multi-Agent & Swarms).
- Skills built-in: `/find-your-level` (placement quiz 10 questões → fase de entrada + path personalizado) e `/check-understanding <phase>` (quiz por fase com feedback).
- Phase 14 tem lições específicas de: Claude Agent SDK — Subagents and Session Store, Anthropic's Workflow Patterns, Agent Workbench (lições 31-42 com `mission.md` briefings), Scope Contracts and Task Boundaries, Verification Gates, Reviewer Agent (separar builder de marker).
- Phase 17 (Infrastructure): prompt caching economics, batch APIs (50% discount), model routing, FinOps para LLMs — todo o stack de token economy.
- Phase 18 (Ethics/Safety): 30 lições incluindo in-context scheming, alignment faking, Constitutional AI, EU/US regulatory frameworks — nível de profundidade academic.
- Capstone 01: Terminal-Native Coding Agent (combina P0+P5+P7+P10+P11+P13+P14+P15+P17+P18) — 20-40 horas.

## Exemplos e evidências

- Phase 14, Lesson 01: agent loop em ~120 linhas de Python puro, sem dependências — `run(query, tools)` com history, tool calls e step limit.
- Cada lesson tem: `code/` (implementações), `docs/en.md` (narrativa), `outputs/` (prompt/skill/agent/MCP server produzido).
- `python3 scripts/install_skills.py` instala todos os 503+ artefatos de uma vez.
- Disponível em `aiengineeringfromscratch.com` para leitura sem clone.

## Implicações para o vault

- Referência curricular para Michel no contexto de ADS@FIAP e preparação para mercado de AI engineering.
- Phase 14 workbench lessons (31-42) são especialmente relevantes para aprender a construir e avaliar agentes — parallelo direto com os agentes do vault.
- O conceito de "cada lição produz um artefato reutilizável" é exatamente o design de skills do vault.
- Skills `/find-your-level` e `/check-understanding` podem ser instaladas no Claude Code como referência de como implementar skills educacionais.
- Phase 13 (MCP do zero) é recurso de referência para entender profundamente o protocolo que o vault usa.

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-engineering]]
- [[03-RESOURCES/concepts/ai-agents/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/ai-agents/agentic-development]]
- [[02-AREAS/fiap/fiap-index]]
