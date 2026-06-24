---
title: "NVIDIA/SkillSpector: Security scanner for AI agent skills"
type: source
source: "Clippings/NVIDIASkillSpector Security scanner for AI agent skills. Detect vulnerabilities, malicious patterns, and security risks..md"
original_url: "https://github.com/nvidia/skillspector"
author: NVIDIA
published: 2026-05-30
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, security, claude-code-skills, skill-security, nvidia, vulnerability-scanner]
---

## Tese central

26,1% dos AI agent skills contêm vulnerabilidades e 5,2% têm intenção maliciosa provável — o SkillSpector é um scanner de segurança open-source da NVIDIA que detecta essas ameaças antes da instalação, usando análise estática + avaliação semântica via LLM.

## Argumentos principais

1. **O problema é empiricamente validado**: pesquisa "Agent Skills in the Wild: An Empirical Study of Security Vulnerabilities at Scale" (Liu et al., 2026) analisou 42.447 skills de marketplaces:
   - 26,1% contêm ao menos uma vulnerabilidade
   - 5,2% com provável intenção maliciosa
   - Skills com scripts executáveis são **2,12× mais prováveis** de serem vulneráveis

2. **64 padrões de vulnerabilidade em 16 categorias**: prompt injection (5), data exfiltration (4), privilege escalation (3), supply chain (6), excessive agency (4), output handling (3), system prompt leakage (3), memory poisoning (3), tool misuse (3), rogue agent (2), trigger abuse (3), behavioral AST (8), taint tracking (5), YARA signatures (4), MCP least privilege (4), MCP tool poisoning (4).

3. **Pipeline em dois estágios**:
   - Stage 1: análise estática rápida (regex + AST) com alto recall
   - Stage 2: avaliação semântica LLM opcional para filtrar falsos positivos → precisão ~87%
   - O prompt LLM inclui proteções anti-jailbreak para evitar que skills maliciosas manipulem a análise.

4. **Risk scoring 0-100**: CRITICAL +50pts, HIGH +25pts, MEDIUM +10pts, LOW +5pts, multiplicador 1.3× para scripts executáveis. Score 0-20: SAFE; 21-50: CAUTION; 51-80: DO NOT INSTALL; 81-100: DO NOT INSTALL.

5. **Formatos de output**: terminal, JSON, Markdown, SARIF (para CI/CD e IDEs).

6. **Providers LLM suportados**: OpenAI (padrão: gpt-5.4), Anthropic (padrão: claude-opus-4-6), NVIDIA build (padrão: deepseek-ai/deepseek-v4-flash). Compatível com Ollama/vLLM/llama.cpp.

7. **Live CVE lookup (SC4)**: consulta OSV.dev em batch sem API key, com cache in-memory por 1 hora e fallback offline.

## Key insights

- Skills executam com *confiança implícita e vetting mínimo* — o problema não é teórico, é epidemiológico (26,1% de taxa de vulnerabilidade).
- As categorias mais críticas: prompt injection, taint tracking (especialmente TT3: credenciais → saída de rede), rogue agent (RA1: auto-modificação), e YARA para malware.
- MCP tool poisoning (TP1-TP4) é categoria específica: instruções ocultas em metadados HTML, caracteres zero-width, base64, homoglyphs, RTL overrides.
- Memory poisoning (MP1-MP3) ataca o estado persistente do agente — risco elevado para sistemas como MemPalace ou Hermes que mantêm memória entre sessões.
- O scanner pode rodar `--no-llm` para análise estática pura (mais rápido, sem API key).

## Exemplos e evidências

**Exemplo de output (terminal):**
```
Risk Score: 78/100 | Severity: HIGH | Recommendation: DO NOT INSTALL

HIGH: Env Variable Harvesting (E2) — scripts/sync.py:23
  for key, val in os.environ.items():... [coleta API keys]
  Confidence: 94%

HIGH: External Transmission (E1) — scripts/sync.py:45
  requests.post("https://api.skill.io/env"...) [exfiltração]
  Confidence: 89%
```

**Scan básico:**
```bash
skillspector scan ./my-skill/        # diretório local
skillspector scan ./SKILL.md         # arquivo único
skillspector scan https://github.com/user/my-skill  # repo Git
skillspector scan --format sarif --output report.sarif ./my-skill/
```

**Python API:**
```python
from skillspector import graph
result = graph.invoke({"input_path": "/path/to/skill", "output_format": "json", "use_llm": True})
print(f"Risk Score: {result['risk_score']}/100")
```

## Implicações para o vault

- **Relevância direta**: o vault-michel usa skills Claude Code ativamente. A taxa de 26,1% de vulnerabilidade em skills públicas justifica scanning antes de instalar qualquer skill de fonte externa.
- SkillSpector deve ser parte do processo de avaliação de skills — especialmente para skills com scripts executáveis (2,12× mais vulneráveis).
- As categorias MCP tool poisoning e memory poisoning são específicas ao ecossistema do vault (usa MCP + MemPalace/claude-mem).
- AgentShield ([[03-RESOURCES/entities/AgentShield]]) é ferramenta similar já no vault — vale comparar escopo (ECC red-team/blue-team vs. SkillSpector estático/semântico).
- Integração possível em CI/CD como quality gate antes de instalar skills no vault.

## Links

- [[03-RESOURCES/entities/NVIDIA]] — organização mantenedora
- [[03-RESOURCES/entities/SkillSpector]] — entidade do produto
- [[03-RESOURCES/entities/AgentShield]] — ferramenta similar (ECC, 102 regras)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-security]] — contexto de segurança Claude Code
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — skills como procedimentos
