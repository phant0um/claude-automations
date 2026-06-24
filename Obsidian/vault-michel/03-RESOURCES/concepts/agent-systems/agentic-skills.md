---
title: Agentic Skills & Reusable Patterns
type: concept
status: developing
created: 2026-04-25
updated: 2026-05-23
tags: [agents, skills, patterns, reusability, skillsmp, marketplace]
---

# Agentic Skills & Reusable Patterns

Skills are encapsulated agent behaviors that can be composed and reused.

## What is a Skill?

A skill is a self-contained SKILL.md file that describes:
1. **When to use it** — triggers, use cases
2. **What it does** — behavior, transformation
3. **How to use it** — invocation, parameters
4. **What it returns** — output format, side effects

## Types of Skills

### Domain Skills
- Language-specific (Python patterns, TypeScript patterns)
- Framework-specific (Django, Spring Boot, Next.js)
- Tool-specific (Docker, CI/CD, testing)

### Operational Skills
- Orchestration (multi-agent workflows)
- Monitoring and observability
- Deployment and rollback
- Cost tracking and optimization

### Creative Skills
- Content generation (articles, social media)
- Design (UI/UX, design systems)
- Research and synthesis

## Skill Lifecycle

1. **Discovery** — Manual creation or auto-extraction from git history
2. **Definition** — SKILL.md with frontmatter, examples, constraints
3. **Usage** — Invoked during Claude Code sessions
4. **Evolution** — Improved via continuous-learning-v2 (Instincts)
5. **Consolidation** — Cluster related instincts into evolved skills

## Autogeneration

Tools like `/skill-create` extract patterns from:
- Git commit messages
- Code reviews
- Test patterns
- Architectural decisions

Result: Skills that match YOUR team's actual practice, not generic templates.

## Anatomia de um SKILL.md Efetivo

Formato mínimo que funciona em produção:

```markdown
---
name: systematic-debugging
description: Debug a failing test, error, or unexpected behavior. Use when: test fails, error appears, behavior is wrong.
---

## Process
1. **Reproduce** — run failing scenario exactly as reported. Change nothing yet.
2. **Narrow** — find smallest change that makes behavior appear/disappear.
3. **Hypothesize** — list 3 possible root causes, ordered by probability.
4. **Fix** — implement fix for most likely cause only. Never fix multiple issues simultaneously.
5. **Verify** — run original failing scenario + adjacent tests.

## Rules
- Never fix what isn't broken.
- Never guess-and-check more than 3 times. If 3 hypotheses fail, re-read the error.
- Document root cause after fixing: "Root cause: [explanation]"
```

**Por que funciona:** `description` com "when to use" habilita auto-delegação precisa. Rules que proíbem anti-patterns específicos (não "tente não adivinhar" mas "não mais de 3 vezes").

## Ordem de Instalação (importa)

1. **Meta skills** (Write a Skill, Skill Creator) — primeiro, para não criar skills ruins
2. **Planning** (Grill Me, PRD suite) — planning ruim cria retrabalho em tudo
3. **Safety** (Git Guardrails, TDD, Systematic Debugging) — antes de automatizar mais
4. **Superpowers** — pressupõe base de safety operando
5. **Business + SkillsMP** — skills de domínio só fazem sentido sobre base sólida

## SkillsMP — Marketplace como Estratégia

`skillsmp.com` (66k+ skills) = modelo análogo ao npm/PyPI, mas para **comportamento de agente** em vez de código.

Implicações:
- Skill testada por uma empresa → reutilizável por outra sem recriar o trabalho
- Skills de domínio (healthcare, legal, finance) criadas por especialistas, não só engenheiros
- Ratings criam mercado de qualidade — skills ruins ficam no fundo

Para vault-michel: descobrir skills que cobrem casos de uso não considerados antes de criar do zero.

## Limitações do Sistema de Skills

**Portabilidade imperfeita:** skills com `gh issue create` ou Bash não funcionam em ambientes sem GitHub/Unix.

**Manutenção necessária:** skills não se auto-atualizam. API deprecated em junho invalida skill de março.

**Overlap e conflito:** dois skills com escopos sobrepostos podem competir pelo mesmo trigger. "Systematic Debugging" e "Triage Issue" podem ambos responder a "debug this failing test" — problema de design ainda sem solução padronizada.

**Sem evals:** skills raramente têm testes. Qualidade medida por uso — skills ruins só identificadas quando produzem output ruim em produção.

## Relacionado
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — anatomia completa oficial Anthropic
- [[03-RESOURCES/concepts/learning-cognition/skill-development]] — ciclo de vida detalhado
- [[03-RESOURCES/concepts/claude-code-tooling/skill-trust-schema]] — governança e confiança
- [[everything-claude-code-ecc]]
- [[continuous-learning-v2]]

## Segurança: SKILL.md como Superfície de Ataque

SKILL.md não é documentação passiva — é texto operacional que um adversário pode manipular para:
- **Discovery:** Triggers de ~20 tokens melhoram ranking no registry (86% win rate)
- **Selection:** Framing da `description` desvia escolha do agente em 77.6% dos trials
- **Governance:** Context-window overflow (> 10K chars) bypassa 100% dos LLM reviewers

Ver [[03-RESOURCES/sources/ml-research-papers/skill-md-semantic-supply-chain-attacks]] — Saha, Faghih, Feizi (UMD, 2026).

## SkillOpt — Otimização Formal de Skills (Microsoft, 2026)

SkillOpt trata skills como pesos de rede neural, mas no espaço de texto.

**Mecanismo:** Loop de otimização com epochs, mini-batch, validation gate — sem alterar pesos do modelo.

```
Skill inicial → Execução em trajetórias → Score → Edit (texto) → Validation gate → best_skill.md
```

**Resultados empíricos:**
- +59.7pp no SpreadsheetBench vs skill base
- Comprimento ótimo: ~920 tokens por skill
- Validation gate elimina regressões — skills só substituídas quando novas superam a anterior

**Para vault-michel:** aplicável a `wiki-ingest`, `pipeline-diario`, `relatorio-artigos` — as 3 skills com mais execuções. Método: registrar trajetórias de falha, iterar skill texto, validar contra casos regressão.

**Limitação:** requer trajetórias de execução para treinar — skills sem histórico de uso não têm sinal de otimização.

→ [[03-RESOURCES/sources/claude-code-skills/microsoft-skillopt-github-repo]]

## Fontes
- [[03-RESOURCES/sources/claude-code-skills/67-claude-skills-full-dev-team]]
- [[03-RESOURCES/sources/claude-code-skills/autoskills-auto-ai-skill-installer]]
- [[03-RESOURCES/sources/ml-research-papers/skill-md-semantic-supply-chain-attacks]]
- [[03-RESOURCES/concepts/agent-systems/interpreter-skills]] — extensão: skills com TypeScript modules embutidos
