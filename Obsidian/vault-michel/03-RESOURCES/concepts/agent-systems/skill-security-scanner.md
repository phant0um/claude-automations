---
title: skill-security-scanner
type: concept
domain: agent-systems
created: 2026-05-31
updated: 2026-05-31
tags: [security, ai-agents, skill-security, vulnerability, nvidia, skillspector]
---

# Skill Security Scanner

## Problema

AI agent skills (SKILL.md + scripts) executam com **confiança implícita e vetting mínimo**. Skills infectadas em marketplaces são um vetor de ataque real com prevalência empiricamente medida.

**Dados (Liu et al., 2026 — 42.447 skills analisadas):**
- **26,1%** contêm ao menos uma vulnerabilidade
- **5,2%** com provável intenção maliciosa
- Skills com scripts executáveis: **2,12× mais prováveis** de serem vulneráveis

## Pipeline de detecção em dois estágios

**Stage 1 — Análise estática**: regex + AST sobre arquivos da skill. Alto recall, precisão moderada. Rápido, sem API key.

**Stage 2 — Avaliação semântica LLM** (opcional): filtra falsos positivos, explica findings em linguagem natural. Precisão ~87%.

## 16 Categorias de vulnerabilidade

| Tier | Categorias |
|---|---|
| CRITICAL | Rogue Agent (auto-modificação), Behavioral AST (exec/eval), Taint Tracking (credenciais→rede), YARA (malware/webshell) |
| HIGH | Prompt Injection, Data Exfiltration, Privilege Escalation, Supply Chain, Memory Poisoning, MCP Tool Poisoning |
| MEDIUM/LOW | Excessive Agency, Output Handling, System Prompt Leakage, Tool Misuse, Trigger Abuse, MCP Least Privilege |

## Risk scoring

| Score | Recomendação |
|---|---|
| 0-20 | SAFE |
| 21-50 | CAUTION |
| 51-80 | DO NOT INSTALL |
| 81-100 | DO NOT INSTALL |

Scripts executáveis aplicam multiplicador 1.3×.

## Implementação de referência

[[03-RESOURCES/entities/SkillSpector]] — NVIDIA, open-source (Apache-2.0), suporta Git repo, URL, zip, diretório, arquivo único.

## Relação com o vault

- O vault usa skills Claude Code — scanning recomendado antes de instalar qualquer skill de fonte externa
- MCP Tool Poisoning e Memory Poisoning são categorias específicas ao ecossistema vault (usa MCP + claude-mem/MemPalace)
- [[03-RESOURCES/entities/AgentShield]] é abordagem complementar (red-team/blue-team com 102 regras)

## Relacionado

- [[03-RESOURCES/sources/claude-code-skills/skillspector-nvidia-security-scanner]] — spec completa
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-security]] — segurança Claude Code geral
