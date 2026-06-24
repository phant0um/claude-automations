---
title: "mukul975/Anthropic-Cybersecurity-Skills: 754 Skills for AI Agents"
type: source
source: "Clippings/mukul975Anthropic-Cybersecurity-Skills 754 structured cybersecurity skills for AI agents · Mapped to 5 frameworks MITRE ATT&CK, NIST CSF 2.0, MITRE ATLAS, D3FEND & NIST AI RMF · agentskills.io standard · Works with Claude Code, GitHub Copilot, C.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, cybersecurity, skills, mitre, agent-security]
---

## Tese central

754 skills de cybersegurança estruturadas para AI agents, mapeadas a 5 frameworks (MITRE ATT&CK, NIST CSF 2.0, MITRE ATLAS, D3FEND, NIST AI RMF), seguindo o agentskills.io standard — a única biblioteca open-source com cobertura cross-framework unificada.

## Argumentos principais

- **Gap no mercado** — um analista júnior sabe qual plugin Volatility3 usar em um memory dump suspeito; seu AI agent não sabe, a não ser que você forneça skills
- **754 skills em 26 domínios** de segurança (threat intelligence, incident response, network security, cloud security, etc.)
- **5 frameworks mapeados** — MITRE ATT&CK (ofensivo), NIST CSF 2.0 (defensive framework), MITRE ATLAS (AI threats), MITRE D3FEND (defensive countermeasures), NIST AI RMF (AI risk)
- **Cross-platform** — funciona em Claude Code, GitHub Copilot, Codex CLI, Cursor, Gemini CLI, 20+ plataformas
- **Projeto comunitário independente** — não afiliado à Anthropic apesar do nome

## Key insights

- MITRE ATLAS + NIST AI RMF = frameworks específicos para ameaças e riscos de AI (não só cybersec tradicional)
- Mapeamento cross-framework = uma skill endereça múltiplos frameworks simultaneamente
- Open source (Apache 2.0) = reutilizável e extensível

## Implicações para o vault

- Referência para o `guard` agent do vault — pode incorporar skills de security scanning
- MITRE ATLAS especificamente relevante: ataques em AI systems (prompt injection, model extraction, etc.)
- Vocabulário de frameworks de segurança útil para entender ameaças ao vault pipeline

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]
- [[03-RESOURCES/sources/anthropics-skills-repo]]
- [[04-SYSTEM/agents/core/cluster-agent.md]]
