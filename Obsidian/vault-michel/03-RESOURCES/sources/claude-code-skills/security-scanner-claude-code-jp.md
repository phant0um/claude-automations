---
title: "Security Scanner — Claude Code Skill (security audit)"
type: source
source_type: repo-skill
created: 2026-05-31
updated: 2026-06-10
tags: [claude-code-skills, security, guard]
status: seed
---

# Security Scanner — Claude Code Skill

> "Jp" (autor/origem JP) não confirmado — conteúdo geral sobre skills de security-scan pra Claude Code.

## Resumo

Skills de security-scanner pra Claude Code: varrem código em busca de vulnerabilidades comuns (injection, secrets hardcoded, deps vulneráveis), rodam como Agent Skill ativada por trigger ("audit security", "scan vulnerabilities"). Padrão geral: skill chama linters/SAST tools (semgrep, bandit, etc.) + LLM review.

## Por que importa (vault)

Relevante pro agente [[04-SYSTEM/agents/core/guard]] deste vault — comparar abordagem com guard atual.

## Notes
WebSearch (2026-06-10) — apenas match genérico (tema "security scanner skill"), origem "jp" não localizada.
