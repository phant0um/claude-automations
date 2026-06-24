---
title: Everything Claude Code (ECC)
type: entity
entity_type: Tool
created: 2026-04-25
updated: 2026-05-18
tags: [entity, tool, ai-agents, agent-harness, claude-code]
---

# Everything Claude Code (ECC)

**Repo:** `affaan-m/everything-claude-code` · 182K+ stars · 28K+ forks · 170+ contributors  
**Versão atual:** v2.0.0-rc.1 (Abril 2026) — Anthropic Hackathon Winner  
**Site:** [ecc.tools](https://ecc.tools/)

Performance optimization system para AI agent harnesses — não apenas config-pack, mas sistema completo: skills, instincts, memória, aprendizado contínuo, segurança ([[03-RESOURCES/entities/AgentShield]]) e development research-first. 10+ meses de uso diário em produção. Funciona em Claude Code, Codex, Cursor, OpenCode, Gemini, Zed, GitHub Copilot.

## Componentes (v2.0.0-rc.1)

- **60 agentes** especializados (planner, architect, security-reviewer, code-reviewer, debugger, language-specific reviewers para 12 linguagens)
- **232 skills** on-demand — zero desperdício de contexto; incluem /plan, /tdd, /security-scan, /quality-gate, /simplify, nextjs-turbopack, bun-runtime, pytorch-patterns, mcp-server-patterns
- **75 legacy command shims**
- **ECC 2.0 alpha** — Rust control-plane (`ecc2/`): commands `dashboard`, `start`, `sessions`, `status`, `stop`, `resume`, `daemon`
- **Dashboard GUI** Tkinter/npm com dark/light theme
- **Operator story pública** via [[03-RESOURCES/entities/hermes]] (Hermes setup guide + cross-harness architecture)

## AgentShield

Pipeline red-team com 3 agentes Claude Opus: Atacante (exploit chains) → Defensor (defensive eval) → Auditor (risk report). Escaneia CLAUDE.md, settings.json, MCP configs, hooks, agentes, skills — detecta segredos hardcoded, injection vectors, supply chain risks.

## Aprendizado Contínuo

Observa sessões e extrai padrões com confidence incremental (0.3 → 0.6 → ...). Stock Claude Code começa zerado; ECC accumula padrões específicos ao operador ao longo do tempo.

## Related Sources

- [[03-RESOURCES/sources/open-source-ecosystems/everything-claude-code-ecc]] — source técnico detalhado (v1.10)
- [[03-RESOURCES/sources/open-source-ecosystems/affaan-m-ecc-github-readme-v2]] — README v2.0.0-rc.1
- [[03-RESOURCES/sources/misc-low-confidence/post-codewithimanshu-ecc-anthropic-hackathon]] — overview público do ECC

## Hub — Conceitos Relacionados

ECC é o hub de referência para harness engineering. Conecta:

- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — arquitetura que ECC implementa
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — 232 skills do ECC
- [[03-RESOURCES/concepts/agent-systems/subagent-pattern-empirical]] — padrão sub-agent (7/10 produção)
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — memória persistente cross-session
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — token economy que ECC otimiza
- [[03-RESOURCES/entities/AgentShield]] — componente segurança integrado
- [[03-RESOURCES/entities/affaan-m]] — autor/maintainer
- [[03-RESOURCES/entities/hermes]] — harness alternativo (referenciado como "operator story" por ECC)
