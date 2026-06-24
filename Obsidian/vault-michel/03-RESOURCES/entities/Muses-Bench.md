---
title: Muses-Bench
type: entity
subtype: benchmark
created: 2026-04-19
updated: 2026-04-19
tags: [benchmark, multi-user, LLM-evaluation, access-control, coordination]
---

# Muses-Bench

**Tipo:** Benchmark acadêmico
**Repo:** https://github.com/Korde-AI/Multi-User-LLM-Agent
**Instituições:** Stanford · KAUST · University of Toronto · MIT

## O que é

Benchmark para avaliar LLMs em cenários **multi-principal** — onde um único agente serve múltiplos usuários com roles, preferências e autoridade distintos. Introduzido em [[03-RESOURCES/sources/ai-agents-harness/multi-user-llm-agents]].

## 3 Cenários

1. **Multi-User Instruction Following** — 1.298 cenários (execução) + 304 (seleção); 2–10 usuários; hierarquia CEO→Intern
2. **Cross-User Access Control** — 216 cenários; 3 tipos de ataque (direct, social engineering, XML obfuscation)
3. **Multi-User Meeting Coordination** — 216 cenários; Full Disclosure (108) + Partial Disclosure (108)

## Modelos Avaliados

19 modelos: GPT-4o-mini, GPT-5-Nano, GPT-5.1, GPT-5.2, GPT-OSS-120B, Claude-3.5-Haiku, Claude-Haiku-4.5, Claude-Sonnet-4.5, Gemini-2.5-Flash, Gemini-3-Flash, Gemini-3-Pro, Grok-3-Mini, Grok-4.1-Fast, GLM-4.5-Air, DeepSeek-R1, Llama-3-70B, Llama-3-8B, Qwen3-30B, Qwen3-4B-IT.

## Top 5 (Avg)

1. Gemini-3-Pro: 85.6
2. Claude-Sonnet-4.5: 82.6
3. Gemini-3-Flash: 82.0
4. GPT-5.1: 78.9
5. Grok-4.1-Fast: 75.5

## Links

- [[03-RESOURCES/concepts/agent-systems/multi-principal-agent]] — conceito central do benchmark
- [[03-RESOURCES/entities/Korde-AI]] — organização do repositório
- [[03-RESOURCES/sources/ai-agents-harness/multi-user-llm-agents]] — paper de origem
