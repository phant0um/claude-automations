---
title: SkillSpector
type: entity
category: tool / security scanner
created: 2026-05-31
updated: 2026-05-31
tags: [security, ai-agents, skill-security, nvidia, open-source, vulnerability-scanner]
---

# SkillSpector

Repositório: [github.com/NVIDIA/SkillSpector](https://github.com/NVIDIA/SkillSpector)
Licença: Apache-2.0
Mantenedor: [[03-RESOURCES/entities/NVIDIA]]

Scanner de segurança open-source para AI agent skills. Detecta vulnerabilidades, padrões maliciosos e riscos antes da instalação de skills para Claude Code, Codex CLI, Gemini CLI etc.

## Contexto

Baseado na pesquisa "Agent Skills in the Wild" (Liu et al., 2026):
- **26,1%** dos skills analisados (42.447 de marketplaces) contêm ao menos uma vulnerabilidade
- **5,2%** com provável intenção maliciosa
- Skills com scripts executáveis são **2,12×** mais prováveis de serem vulneráveis

## Pipeline de detecção

**Stage 1 — Análise estática**: regex + AST sobre 11 analisadores. Alto recall, precisão moderada.

**Stage 2 — Avaliação semântica LLM** (opcional): filtra falsos positivos, explica findings. Precisão ~87%. O prompt inclui proteções anti-jailbreak.

## 64 padrões em 16 categorias

| Categoria | Padrões | Severity máximo |
|---|---|---|
| Prompt Injection | 5 | CRITICAL |
| Data Exfiltration | 4 | HIGH |
| Privilege Escalation | 3 | HIGH |
| Supply Chain | 6 | HIGH |
| Excessive Agency | 4 | HIGH |
| Memory Poisoning | 3 | HIGH |
| Rogue Agent | 2 | CRITICAL |
| Behavioral AST | 8 | CRITICAL |
| Taint Tracking | 5 | CRITICAL |
| YARA Signatures | 4 | CRITICAL |
| MCP Tool Poisoning | 4 | HIGH |
| MCP Least Privilege | 4 | HIGH |
| + 4 outras | | |

## Uso básico

```bash
skillspector scan ./my-skill/
skillspector scan ./SKILL.md
skillspector scan https://github.com/user/my-skill
skillspector scan ./skill.zip --format sarif --output report.sarif
skillspector scan ./my-skill/ --no-llm   # apenas análise estática
```

## Risk scoring

| Score | Severity | Recomendação |
|---|---|---|
| 0-20 | LOW | SAFE |
| 21-50 | MEDIUM | CAUTION |
| 51-80 | HIGH | DO NOT INSTALL |
| 81-100 | CRITICAL | DO NOT INSTALL |

## Providers LLM suportados

| Provider | Modelo padrão |
|---|---|
| `nv_build` (default) | deepseek-ai/deepseek-v4-flash |
| `openai` | gpt-5.4 |
| `anthropic` | claude-opus-4-6 |
| Local (Ollama/vLLM) | configurável via OPENAI_BASE_URL |

## Relação com o vault

- [[03-RESOURCES/entities/AgentShield]] — ferramenta similar (ECC red-team/blue-team, 102 regras)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-security]] — contexto de segurança Claude Code
- [[03-RESOURCES/sources/claude-code-skills/skillspector-nvidia-security-scanner]] — fonte completa
