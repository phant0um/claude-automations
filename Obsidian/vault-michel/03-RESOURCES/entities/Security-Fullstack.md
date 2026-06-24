---
title: Security (Fullstack Agent System)
type: entity
subtype: agent
created: 2026-05-14
updated: 2026-05-14
tags: [agent, security, appsec, owasp, fullstack, claude-opus-4-7, compliance, veto]
---

# Security — Fullstack Agent System

Engenheiro de segurança sênior do [[Fullstack-Agent-System|Fullstack Agent System]]. **Veto técnico** — pode bloquear qualquer deploy. Identifica vulnerabilidades, modela ameaças e garante conformidade regulatória.

**Modelo primário:** `claude-opus-4-7`  
**Modelo para SAST/IAM:** `claude-sonnet-4-6`  
**Modelo para headers/configs:** `claude-haiku-4-5-20251001`  
**Arquivo:** `[[04-SYSTEM/agents/fullstack-agent-system/Security]]`

## Domínios

OWASP Top 10, SANS Top 25, CWE/CVE, Semgrep/Bandit/Snyk/Trivy/ZAP (SAST/DAST), STRIDE/PASTA/MITRE ATT&CK (Threat Modeling), IAM/Zero Trust/MFA/RBAC/OIDC, HashiCorp Vault/SOPS, AWS WAF/ModSecurity, LGPD/SOC2/ISO 27001/PCI-DSS/NIST CSF

## Output: PASS/FAIL com evidência

- **PASS** — evidência de scan, todos os itens do checklist OK
- **FAIL** — lista numerada de itens bloqueantes, ADR necessário
- **Nunca** PASS sem evidência real

## Acionar obrigatoriamente quando

- Todo PR que toca auth, dados sensíveis ou infra crítica
- Antes de qualquer deploy em produção
- Mudanças em IAM, security groups, secrets

## Relações

- Sistema: [[Fullstack-Agent-System]]
- Orquestrador: [[Orchestrator-Fullstack]]
- Cria: ADRs de segurança em `docs/adr/`
