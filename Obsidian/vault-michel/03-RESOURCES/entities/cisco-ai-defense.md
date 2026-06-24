---
title: Cisco AI Defense
type: entity
category: tools
created: 2026-06-02
updated: 2026-06-02
tags: [entity, tool, security, ai-agents, skill-scanner]
---

# Cisco AI Defense

Divisão de segurança IA da Cisco. Foco em defesa de agentes e skills contra ataques — prompt injection, exfiltração de dados, código malicioso.

## skill-scanner

Scanner de segurança best-effort para skills de agentes IA.

**Stack de detecção:**
- Static analysis (YAML + YARA rules)
- LLM-as-judge (análise semântica)
- Behavioral dataflow analysis
- Meta-analyzer (false positive filtering)
- Cloud-based scanning (opcional)

**Formatos suportados:**
- OpenAI Codex Skills
- Cursor Agent Skills
- Claude Code `.claude/commands/*.md` (via `--lenient`)

**Integração CI/CD:**
- SARIF output para GitHub Code Scanning
- Reusable GitHub Actions workflow
- Pre-commit hook (standard pre-commit framework)

**Instalação:**
```bash
uv pip install cisco-ai-skill-scanner
```

**Limitação central:** "No findings ≠ no risk" — scanner best-effort, não certifica segurança. Human review permanece essencial.

## AITech Threat Taxonomy

Taxonomia completa de ameaças para skills de agentes IA. Referência para design de [[04-SYSTEM/agents/core/guard]].

## Relacionado

- [[03-RESOURCES/sources/cisco-skill-scanner-agent-security]]
- [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]
- [[04-SYSTEM/agents/core/guard]]
