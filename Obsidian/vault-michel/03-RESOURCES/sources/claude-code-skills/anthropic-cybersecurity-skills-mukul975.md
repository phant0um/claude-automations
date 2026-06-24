---
title: "Anthropic Cybersecurity Skills — 754 Structured Skills for AI Agents (mukul975)"
type: source
source: "Clippings/mukul975Anthropic-Cybersecurity-Skills 754 structured cybersecurity skills for AI agents · Mapped to 5 frameworks MITRE ATT&CK, NIST CSF 2.0, MITRE ATLAS, D3FEND & NIST AI RMF · agentskills.io standard · Works with Claude Code, GitHub Copilot, C.md"
origin: "https://github.com/mukul975/Anthropic-Cybersecurity-Skills"
author: "Mahipal Jangra (mukul975)"
published: 2026-03-11
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, cybersecurity, agent-skills, agentskills-io, mitre-attack, nist-csf, mitre-atlas, d3fend, nist-ai-rmf, claude-code, security]
---

## Tese central

Anthropic Cybersecurity Skills é a maior biblioteca open-source de cybersecurity skills para agentes de IA: 754 skills estruturadas cobrindo 26 domínios de segurança, cada uma mapeada para 5 frameworks (MITRE ATT&CK v18, NIST CSF 2.0, MITRE ATLAS v5.4, MITRE D3FEND v1.3, NIST AI RMF 1.0), seguindo o padrão agentskills.io — instalável em 26+ plataformas de IA com `npx skills add mukul975/Anthropic-Cybersecurity-Skills`. Projeto comunitário independente, não afiliado à Anthropic PBC.

## Argumentos principais

- **Escala**: 754 skills × 26 domínios × 5 framework mappings — nenhuma outra biblioteca open-source mapeia todos os 5 frameworks simultaneamente.
- **26 domínios**: Cloud Security (60), Threat Hunting (55), Threat Intelligence (50), Web Application Security (42), Network Security (40), Malware Analysis (39), Digital Forensics (37), Security Operations (36), IAM (35), SOC Operations (33), Container Security (30), OT/ICS (28), API Security (28), Vulnerability Management (25), Incident Response (25), Red Teaming (24), Penetration Testing (23), Endpoint Security (17), DevSecOps (17), Phishing Defense (16), Cryptography (14), Zero Trust (13), Mobile Security (12), Ransomware Defense (7), Compliance & Governance (5), Deception Technology (2).
- **Progressive disclosure architecture**: frontmatter ~30 tokens para scan; full skill 500–2,000 tokens para execução — agente faz 2 passes: scan de 754 skills → load dos top 3 matches.
- **Anatomia de skill**: `SKILL.md` (YAML frontmatter + Markdown body com When to Use / Prerequisites / Workflow / Verification) + `references/` (standards.md, workflows.md) + `scripts/` + `assets/`.
- **YAML frontmatter fields**: `name`, `description`, `domain`, `subdomain`, `tags`, `atlas_techniques`, `d3fend_techniques`, `nist_ai_rmf`, `nist_csf`, `version`, `license`.
- **Compatibilidade de plataformas**: Claude Code, GitHub Copilot, Cursor, Windsurf, Cline, Aider, Codex CLI, Gemini CLI, Devin, Replit Agent, SWE-agent, LangChain, CrewAI, AutoGen, Semantic Kernel, Vercel AI SDK + qualquer agentskills.io-compatible.
- **MITRE ATT&CK Navigator layer**: incluída no release v1.0.0 para visualização de cobertura.

## Key insights

1. **Gap da força de trabalho de segurança**: 4.8 milhões de vagas não preenchidas globalmente em 2024 (ISC2) — skills de IA como veículo de amplificação de analistas.
2. **AI-native vs. security scripts**: não é coleção de wordlists/payloads/exploits. É uma base de conhecimento de decision-making workflow de analista sênior — quando usar, pré-requisitos, execução passo a passo, verificação.
3. **MITRE ATLAS v5.4 coberto**: inclui vetores de ataque agentic AI adicionados em late 2025 — AI agent context poisoning, tool invocation abuse, MCP server compromises, malicious agent deployment.
4. **Colorado AI Act safe harbor**: compliance com NIST AI RMF oferece proteção legal no Colorado (vigente fevereiro 2026) — mapeamentos directamente relevantes para compliance regulatório.
5. **ATT&CK v19 breaking change**: versão v19 (lançada 28 abril 2026) divide Defense Evasion (TA0005) em duas novas táticas: *Stealth* e *Impair Defenses* — atualizações de mapeamento pendentes.
6. **Casky.ai playground**: plataforma no-setup para testar skills ao vivo contra alvos reais com visualização interativa de ATT&CK.

## Exemplos e evidências

- Skill `analyzing-network-traffic-of-malware`: mapeada para ATT&CK T1071 + NIST CSF DE.CM + ATLAS AML.T0047 + D3FEND D3-NTA + NIST AI RMF MEASURE-2.6 — 5 frameworks em um único skill.
- Skill `performing-memory-forensics-with-volatility3`: executa plugins Volatility3, checa padrões de acesso ao LSASS, correlaciona com event logs, mapeia para T1003 (Credential Dumping).
- MITRE ATT&CK cobertura de 14 táticas: Reconnaissance, Resource Development, Initial Access, Execution, Persistence, Privilege Escalation, Defense Evasion, Credential Access, Discovery, Lateral Movement, Collection, C&C, Exfiltration, Impact.
- NIST CSF 2.0: Govern (30+), Identify (120+), Protect (150+), Detect (200+), Respond (160+), Recover (40+).

## Implicações para o vault

- **Integração com Probe agent** (`04-SYSTEM/agents/security-scanner→Probe`): as 754 skills são input direto para o Probe executar análises de segurança estruturadas.
- **agentskills.io standard**: o vault pode adotar o mesmo padrão de YAML frontmatter para skills de segurança internas.
- **MCP server compromises em ATLAS**: risco relevante para o vault que usa MCP extensivamente — skills de detecção de tool invocation abuse são prioritárias.
- **Claude Code security skills específicas**: `claude-security-scan-3-skills-sabakan.md` já no vault — expandir com skills desta biblioteca.

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[04-SYSTEM/agents/core/guard]]
- [[03-RESOURCES/sources/claude-code-skills/claude-security-scan-3-skills-sabakan]]
- [[03-RESOURCES/sources/claude-code-skills/academic-research-skills-integrity-gates-146k-citations]]
