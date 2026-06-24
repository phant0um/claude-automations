---
title: "ToRL: Scaling Tool-Integrated Reinforcement Learning"
type: source
source: Clippings/ToRL Scaling Tool-Integrated RL.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, agentic-rl, tool-use]
---

## Tese central

ToRL treina LLMs para usar computational tools via RL diretamente de base models (sem SFT prévio). ToRL-7B alcança 43.3% em AIME24 (+14% vs RL sem tools, +17% vs melhor TIR model). Cognitive behaviors emergem sem instruction: strategic tool invocation, self-regulation de código inefetivo, dynamic adaptation entre computational e analytical reasoning.

## Argumentos principais

- **RL from base models** (não SFT then RL) permite unrestricted exploration de estratégias de tool use
- **Emergent cognitive behaviors**: cross-validation de tool output com reasoning, self-regulation de código inefetivo, adaptation dinâmica
- **Tool call frequency trade-off**: mais tool calls = melhor performance mas severe computational overhead
- **Code usage evolution**: proporção de problemas resolvidos com code aumenta steady, código syntactically correct cresce

## Key insights

- Tool-integrated reasoning emerge via reward-driven learning, não imitation
- Self-regulation (identificar e reduzir código inefetivo) é metacognition emergente
- Eficiency-effectiveness trade-off em tool calls é crítico

## Links

- [[03-RESOURCES/concepts/agent-systems/tool-use-agents]]
- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]