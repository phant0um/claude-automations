---
title: "cisco-ai-defense/skill-scanner — Security Scanner for Agent Skills"
type: source
source: "Clippings/cisco-ai-defenseskill-scanner Security Scanner for Agent Skills.md"
created: 2026-06-02
ingested: 2026-06-02
tags: [ai-agents, security, prompt-injection, skill-security, ci-cd, agent-defense]
---

## Tese central
skill-scanner é um scanner de segurança best-effort para skills de agentes IA que detecta prompt injection, exfiltração de dados e código malicioso, combinando análise estática (YAML+YARA), LLM-as-judge e análise comportamental de dataflow — com integração CI/CD nativa.

## Argumentos principais
- Skills são superfície de ataque: prompt injection, exfiltração e código malicioso são ameaças reais em repositórios de skills
- Multi-engine detection: static analysis + behavioral dataflow + LLM semantic analysis + cloud-based scanning para cobertura em camadas
- False positive filtering: meta-analyzer reduz ruído preservando capacidade de detecção
- CI/CD ready: SARIF output para GitHub Code Scanning, reusable GitHub Actions workflow, exit codes para build failures
- Pre-commit hook: integração com standard pre-commit framework — scan antes de cada commit
- Suporta múltiplos formatos: OpenAI Codex Skills, Cursor Agent Skills, com --lenient também Claude Code .claude/commands/*.md

## Limitações importantes (explicitadas na documentação)
- Best-effort, não garantia: "No findings ≠ no risk"
- Cobertura incompleta por design: ataques novel/zero-day não detectados por ferramentas automatizadas
- False positives e negatives existem — tunar scan policy ao risk tolerance
- Human review permanece essencial — parte de estratégia defense-in-depth, não substituto

## Key insights
- Skills como superfície de ataque é risco pouco discutido — ferramenta endereça gap real
- LLM-as-judge para análise semântica + pattern-based (YARA) = abordagem complementar que cobre classes diferentes de ataques
- CI/CD integration + pre-commit: defesa em dois pontos — no dev workflow e no pipeline
- Arquitetura plugin: extensível com analyzers customizados
- Transparência sobre limitações é sinal de maturidade — ferramenta de apoio, não solução definitiva

## Exemplos e evidências
- Ameaças alvo: prompt injection, data exfiltration, malicious code patterns
- Instalação: `uv pip install cisco-ai-skill-scanner` ou `pip install cisco-ai-skill-scanner`
- SARIF output: padrão da indústria para integração com GitHub Code Scanning

## Implicações para o vault
- vault-michel tem 100+ skills no 04-SYSTEM/skills/ — potencial candidato para scan
- guard agent cobre parte deste papel, mas sem análise estática/YARA
- Pre-commit hook poderia ser adicionado ao vault para verificar skills antes de commit
- Threat taxonomy (AITech) documentada é referência útil para o guard agent do vault
- Formato --lenient suporta Claude Code .claude/commands/*.md — diretamente aplicável ao vault

## Links
- [[04-SYSTEM/agents/core/guard]]
- [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]
