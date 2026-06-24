---
title: AgentShield
type: entity
subtype: tool
created: 2026-04-24
updated: 2026-04-24
tags: [security, claude-code, static-analysis, agent-security]
---

# AgentShield

Security auditor para Claude Code configurations. Construído no Claude Code Hackathon (Cerebral Valley x Anthropic, Fev 2026).

**npm:** `ecc-agentshield`  
**GitHub:** [github.com/affaan-m/agentshield](https://github.com/affaan-m/agentshield)

## Especificações

- 1.282 testes · 98% cobertura · 102 regras estáticas
- Integrado ao [[03-RESOURCES/sources/open-source-ecosystems/everything-claude-code-ecc|ECC]] via `/security-scan`
- GitHub Action disponível para CI/CD gates

## O que escaneia

Cobre CLAUDE.md, settings.json, MCP configs, hooks, agent definitions, skills em 5 categorias:
1. **Secrets detection** — 14 padrões
2. **Permission auditing**
3. **Hook injection analysis**
4. **MCP server risk profiling**
5. **Agent config review**

## Uso

```bash
npx ecc-agentshield scan              # quick scan
npx ecc-agentshield scan --fix        # auto-fix issues seguros
npx ecc-agentshield scan --opus --stream  # deep analysis (3 Opus agents)
npx ecc-agentshield init              # gera config segura do zero
```

## Flag --opus

Roda pipeline de 3 agentes Claude Opus:
- **Attacker** — encontra exploit chains
- **Defender** — avalia proteções existentes
- **Auditor** — sintetiza risk assessment priorizado

Adversarial reasoning, não apenas pattern matching.

## Output

Terminal (A-F color-graded) · JSON (CI pipelines) · Markdown · HTML  
Exit code 2 em critical findings para build gates.

## Conexões
- [[03-RESOURCES/sources/open-source-ecosystems/everything-claude-code-ecc]] — integrado ao ECC
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — analisa hooks como vetor de ataque
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — profila risco de MCP servers
