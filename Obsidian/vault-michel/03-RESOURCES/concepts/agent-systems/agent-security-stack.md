---
title: "Agent Security Stack"
type: concept
status: developing
created: 2026-05-23
updated: 2026-05-23
tags: [concept, ai-agents, security, credentials, harness-engineering, hermes-agent]
---

# Agent Security Stack

**Definição:** Infraestrutura de segurança para agentes autônomos em produção. Dois problemas distintos com soluções distintas que quase nenhum framework separa claramente.

> "Security as infrastructure, not policy." — Hermes / Nous Research

---

## Duas Camadas Distintas

### Layer 1 — Credential Management

*Onde vivem os secrets, como rotacionar, como revogar*

**Problema padrão:** credentials em `.env` plaintext no disco. Copiadas manualmente entre máquinas. Zero rotation. Zero revocation. Se rodando em múltiplas máquinas (VPS + dev + gateway) = copiar-colar manual.

**Solução (Bitwarden Secrets Manager):**
```
.env: BWS_ACCESS_TOKEN=0.x  →  Bitwarden Vault
                                ├─ BINANCE_API_KEY
                                ├─ WALLET_PRIVATE_KEY
                                ├─ OPENROUTER_API_KEY
                                └─ TELEGRAM_BOT_TOKEN
```
- 1 bootstrap token em `.env`
- Startup: `bws secret list` → injeta em `os.environ`
- Rotation: via Bitwarden dashboard, propaga automaticamente para toda a fleet
- Revocation: uma ação, propagação instantânea

### Layer 2 — Credential Protection

*O que acontece quando o agente é a superfície de ataque*

**Ameaças:** prompt injection via output de tool, malicious skill, jailbreak em webpage fetched. Se agente comprometido e credentials em `os.environ` → credentials expostas.

**Solução (iron-proxy):**
- Credentials **nunca entram no sandbox**
- Network boundary como enforcement point
- Proxy intercepta chamadas externas; injeta credentials na borda, não no contexto do agente

---

## Roadmap Hermes (Fase 4)
- Ephemeral secrets com TTL configurável — credentials só existem durante operação específica, purgadas automaticamente
- HashiCorp Vault + AWS Secrets Manager support
- Enhanced audit logging (compliance: SOC2, ISO 27001)
- Modal, Daytona, SSH backends para iron-proxy

---

## Threat Model para Agentes Autônomos

```
Sem iron-proxy:
  Agent → calls tool → gets malicious output
       → output contains jailbreak
       → model exfiltrates BINANCE_API_KEY via tool call
       
Com iron-proxy:
  Agent → calls tool → gets malicious output
       → tries to exfiltrate key
       → proxy blocks; key never in agent context
```

---

## Princípio

Frameworks que tratam credential security como responsabilidade do developer assumem implicitamente que o agente sempre se comportará como esperado. Essa suposição não escala para agentes autônomos. **Segurança = infraestrutura, não política.**

---

## Layer 3 — Skill-Layer Security

*O que acontece quando o vetor de ataque é o próprio conteúdo da skill*

**Problema:** skills instaladas de marketplaces/repos públicos podem conter vulnerabilidades ou intenção maliciosa **antes mesmo de executar**. Análise empírica (Liu et al., 2026 — pesquisa NVIDIA):
- 42.447 skills analisadas de marketplaces reais
- **26,1%** contêm ao menos 1 vulnerabilidade
- **5,2%** com provável intenção maliciosa
- Skills com scripts executáveis: **2,12× mais prováveis** de serem vulneráveis

**64 padrões de vulnerabilidade em 16 categorias:**
prompt injection, data exfiltration, privilege escalation, supply chain, excessive agency, output handling, system prompt leakage, memory poisoning, tool misuse, rogue agent, trigger abuse, behavioral AST, taint tracking, YARA signatures, MCP least privilege, MCP tool poisoning.

**Solução (NVIDIA SkillSpector):**
```python
from skillspector import graph
results = graph.invoke({"skill_path": "path/to/skill"})
# Output: vulnerabilities, malicious_intent_score, recommendations
```
Scanner open-source: análise estática + avaliação semântica via LLM. Detecta antes da instalação.

**Complementar (Anthropic Cybersecurity Skills — mukul975):**
754 skills estruturadas para 26 domínios de segurança × 5 frameworks (MITRE ATT&CK v18, NIST CSF 2.0, MITRE ATLAS v5.4, D3FEND v1.3, NIST AI RMF 1.0). Progressive disclosure architecture: frontmatter ~30 tokens para scan; full skill 500–2k tokens para execução.

---

## Stack Completo (3 Camadas)

```
Layer 3 — Skill Security (pre-install)
  SkillSpector scanner → rejeita skills vulneráveis antes de instalar
  
Layer 2 — Credential Protection (runtime)
  iron-proxy → credentials nunca entram no sandbox do agente
  
Layer 1 — Credential Management (lifecycle)
  Bitwarden Secrets Manager → rotation, revocation, fleet propagation
```

**Princípio unificado:** segurança = infraestrutura em cada camada, não política. A ameaça cresce junto com a autonomia do agente.

---

## Ameaças Emergentes (2026-06-22/23) — Vetores Não Cobertos pelo Stack Atual

Connection Finder (revisão-semanal 2026-06-28) achou convergência de 2 sources na mesma semana, cada uma cobrindo ameaça distinta do stack 3-camadas acima:

- **Mosaic leakage** (vazamento por agregação): deep research agents combinando docs privados + web retrieval podem vazar segredo via múltiplas queries externas inocentes — nenhuma revela individualmente, mas observador de outbound traffic reassembla. Não é exfiltração de credential (Layer 2) — é vazamento de **conteúdo do contexto**, vetor que iron-proxy não cobre.
- **OS-level enforcement** (em vez de network-boundary proxy): AgenticOS propõe interface intent-oriented substituindo syscalls POSIX genéricos — abordagem arquiteturalmente diferente do iron-proxy (proxy na borda vs. kernel redesenhado).

→ Candidato a **Layer 4** (Context/Output Leakage) no roadmap Hermes — gap real: stack atual protege credentials, não conteúdo de contexto agregado.

## Ver Também

- [[03-RESOURCES/entities/Hermes-Agent]] — implementação de referência (Layer 1+2)
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — security stack é componente do harness
- [[03-RESOURCES/sources/ai-agents-harness/clipping-hermes-bitwarden-security]] — fonte primária Layer 1+2
- [[03-RESOURCES/sources/ml-research-papers/skill-md-semantic-supply-chain-attacks]] — ataques semânticos a registries de skills (Saha et al., UMD 2026); SKILL.md como superfície de ataque pré-execução
- [[03-RESOURCES/sources/claude-code-skills/skillspector-nvidia-security-scanner]] — NVIDIA SkillSpector (Layer 3)
- [[03-RESOURCES/sources/claude-code-skills/anthropic-cybersecurity-skills-mukul975]] — 754 security skills mapeadas para 5 frameworks
- [[03-RESOURCES/sources/ai-agents/mosaicleaks-can-your-research-agent-keep-a-secret]] — mosaic effect, vazamento por agregação de queries (gap: Layer 4 candidato)
- [[03-RESOURCES/sources/agenticos-an-intent-oriented-secure-operating-system-architecture-for-autonomous]] — enforcement no nível OS vs. proxy de borda
