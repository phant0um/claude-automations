---
title: "How to Build a Claude Agent You Can Actually Trust in Production — Full Course"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://x.com/s4yonnara/status/2069345769954349251"
author: "@s4yonnara"
published: 2026-06-23
grade: A
tags: [ai-agents, production, claude, agent-design, course, source]
---

# How to Build a Claude Agent You Can Actually Trust in Production

**Tese central**: Um agent que funciona no mundo real não é um prompt melhor. É um job narrow, tools certas, state file, verifier separado, hard stop, e budget — wrapped em um loop que você pode abandonar.

## 14 passos em 4 partes

### Part 1 — What an agent actually is
1. **Agent = goal + tools + loop**, não clever prompt. "You are designing a loop, not writing a prompt."
2. **3 things that kill agents**: Laziness (declares done at step 8/12), Goal drift (forget rules by turn 40), No real verification (says done without proof)

### Part 2 — Build the core
3. **ONE narrow job**: "Build five agents that each do one thing well before you build one that does five things badly"
4. **Right tools (MCP)**: Knowledge → Skill, Context → MCP connector, Capability → MCP tool. Only add what the job needs.
5. **System prompt like operating manual**: Role, exact steps, hard rules (negative/specific), what done looks like. "Never touch billing" beats "be careful."
6. **State file**: Markdown file read at start, written at end. What's done, what's next, what learned. Without it, every run starts from zero.
7. **Separate verifier**: Single biggest reliability upgrade. Checker knows only rubric + result, not who produced it. Author ≠ Reviewer, never same Claude.
8. **Real harness**: Claude Code for technical agents, managed setup for knowledge work. Subagents keep main loop clean.

### Part 3 — Make it reliable
9. **Goal + hard stop**: Checkable end state verified by separate grader, not agent's opinion
10. **Token budget**: Cap loops and tokens. "A budget turns an agent from scary to leave alone into a tool I run unattended."
11. **Quarantine untrusted input**: Reader agent ≠ Actor agent. 30-line read-only reader removes prompt injection risk.
12. **Cost per accepted result**: The only metric that matters. If accepting <50%, agent is losing.

### Part 4 — Ship and maintain
13. **Schedule it**: Runs without you — every morning, on CI failure, when ticket lands
14. **Save as Skill**: Package prompt, rules, workflow, known failure modes. Every real failure folded back makes next run sharper.

## Por que importa para o vault

- **State file = hot.md**: O vault já implementa este padrão — hot.md é o state file do pipeline-semanal
- **Separate verifier = F2.8/F3.5 Nexus spot-check**: Validado como "single biggest reliability upgrade"
- **Save as Skill = skills graduation**: O vault já faz isso com skills/agents
- **Quarantine untrusted input**: Clippings são untrusted input — ingest-agent é o reader, Nexus é o actor
- **Narrow job**: Cada agente vault tem um job narrow (triagem, ingest, report) — confirma o design

## Minha Síntese

Este é o curso que mapeia 1:1 para a arquitetura do vault. Cada um dos 14 passos tem um correspondente: state file (hot.md), separate verifier (Nexus gates), hard stop (PIPELINE OK/FAIL), token budget (cost budget table), save as skill (agents/). O único gap identificado: "cost per accepted result" não é tracked explicitamente no pipeline — sabemos quantos arquivos são aprovados mas não quanto custou produzir cada source page aceita. Adicionar esse metric seria valioso.

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-loop-pattern]]
- [[03-RESOURCES/concepts/ai-agents/agent-production-patterns]]
- [[03-RESOURCES/sources/ai-agents/missing-piece-every-agent-loop]]
- [[03-RESOURCES/sources/ai-agents/i-tested-agentic-loops-real-code]]
- [[04-SYSTEM/agents/nexus-agent-system/ingest-agent]]
- [[04-SYSTEM/skills/foundational/pre-ingest-dedup]]