---
title: Everything Claude Code (ECC)
type: source
created: 2026-04-24
updated: 2026-04-24
tags: [claude-code, agent-harness, skills, hooks, plugins, security]
triagem_score: 9
source_file: Downloads/Arquivar2/Everything Claude Code.md
---

# Everything Claude Code (ECC)

**Repo:** `affaan-m/everything-claude-code` · 140K+ stars · 21K+ forks · 170+ contributors  
**Plugin ID:** `everything-claude-code@everything-claude-code`  
**npm:** `ecc-universal`  
**Site:** [ecc.tools](https://ecc.tools/)  
**Versão atual:** v1.10.0 (Abril 2026)

## O que é

Performance optimization system para AI agent harnesses. Não é apenas config — é um sistema completo: skills, instincts, memória, aprendizado contínuo, security scanning, e development research-first. Produzido ao longo de 10+ meses de uso diário construindo produtos reais.

Funciona em **Claude Code**, Codex, Cursor, OpenCode, Gemini e outros harnesses.

## Componentes Principais

### Agents (38 especializados)
Subagentes para delegação. Exemplos: `planner.md`, `architect.md`, `tdd-guide.md`, `code-reviewer.md`, `security-reviewer.md`, `loop-operator.md`, `harness-optimizer.md`. Reviewers para 12 linguagens: TypeScript, Python, Go, Java, Kotlin, Rust, C++, Swift, PHP, Perl, Django, Laravel.

### Skills (156 domínios)
Workflow definitions e domain knowledge. Incluem:
- **Operacionais:** `continuous-learning-v2/`, `iterative-retrieval/`, `strategic-compact/`
- **Dev patterns:** `backend-patterns/`, `frontend-patterns/`, `golang-patterns/`, `springboot-patterns/`
- **Security:** `security-review/`, `security-scan/` (AgentShield)
- **Negócios:** `article-writing/`, `content-engine/`, `market-research/`, `investor-materials/`
- **Infra:** `deployment-patterns/`, `docker-patterns/`, `database-migrations/`
- **Apple:** `foundation-models-on-device/`, `swift-concurrency-6-2/`, `liquid-glass-design/`
- **Avançados:** `autonomous-loops/`, `cost-aware-llm-pipeline/`, `regex-vs-llm-structured-text/`

### Commands (72 legacy shims)
Entry points slash-style; ECC está migrando para Skills. Comandos principais: `/plan`, `/tdd`, `/code-review`, `/build-fix`, `/learn`, `/checkpoint`, `/verify`, `/orchestrate`, `/sessions`, `/instinct-*`, `/evolve`, `/prune`, `/multi-*`, `/pm2`.

### Rules
Diretrizes always-follow (copiar para `~/.claude/rules/`). Estrutura: `common/` + linguagens específicas (`typescript/`, `python/`, `golang/`, `swift/`, `php/`). Cada regra cobre: coding-style, git-workflow, testing (80% coverage), performance, patterns, hooks, agents, security.

### Hooks (`hooks/hooks.json`)
Automações trigger-based. Runtime controls via:
- `ECC_HOOK_PROFILE=minimal|standard|strict`
- `ECC_DISABLED_HOOKS="pre:bash:tmux-reminder,post:edit:typecheck"`

Hooks de memória: `session-start.js`, `session-end.js`, `pre-compact.js`, `suggest-compact.js`, `evaluate-session.js`.

### Contexts
System prompt injection dinâmico: `dev.md`, `review.md`, `research.md`.

## Ferramentas do Ecossistema

### Skill Creator
Gera SKILL.md a partir do histórico git do projeto.
- **Local:** `/skill-create` (sem serviços externos)
- **GitHub App:** [github.com/apps/skill-creator](https://github.com/apps/skill-creator) — para 10k+ commits, auto-PRs, team sharing

### AgentShield
Security auditor — 1.282 testes, 98% cobertura, 102 regras estáticas. Construído no Claude Code Hackathon (Cerebral Valley x Anthropic, Fev 2026).
- Detecta: secrets (14 padrões), permissões, hook injection, MCP risk profiling, agent config review
- Flag `--opus`: pipeline red-team/blue-team/auditor com 3 agentes Claude Opus
- Output: Terminal (A-F), JSON, Markdown, HTML; exit code 2 em achados críticos

```bash
npx ecc-agentshield scan
npx ecc-agentshield scan --fix
npx ecc-agentshield scan --opus --stream
```

### Continuous Learning v2
Sistema de instincts com confidence scoring:
```
/instinct-status   → mostra instincts aprendidos com confiança
/instinct-import   → importar instincts de outros
/instinct-export   → exportar seus instincts
/evolve            → clusterizar instincts em skills
```

### Dashboard GUI
`npm run dashboard` ou `python3 ./ecc_dashboard.py` — Tkinter desktop app com dark/light theme, font customization, busca por componente.

## Instalação

```bash
# Plugin (marketplace)
/plugin marketplace add https://github.com/affaan-m/everything-claude-code
/plugin install everything-claude-code@everything-claude-code

# Rules (necessário copiar manualmente)
cp -R rules/common ~/.claude/rules/
cp -R rules/typescript ~/.claude/rules/

# Multi-* commands requerem ccg-workflow adicional
npx ccg-workflow
```

**Atenção:** Não rodar `./install.sh --profile full` após plugin install — duplica surfaces.

## Versões Recentes

| Versão | Data | Highlights |
|--------|------|-----------|
| v1.10.0 | Abr 2026 | Dashboard GUI; ECC 2.0 alpha (Rust); 38 agents, 156 skills, 72 shims |
| v1.9.0 | Mar 2026 | Selective install; 6 novos agents; SQLite state store; session adapters |
| v1.8.0 | Mar 2026 | Harness-first; hook reliability; NanoClaw v2; /harness-audit; 997 testes |
| v1.7.0 | Fev 2026 | Codex app/CLI; frontend-slides skill; 992 testes |
| v1.6.0 | Fev 2026 | AgentShield; GitHub Marketplace; 978 testes |
| v1.4.0 | Fev 2026 | PM2; multi-agent orchestration; rules multi-linguagem |
| v1.3.0 | Fev 2026 | OpenCode plugin support nativo |
| v1.2.0 | Fev 2026 | Django; Java Spring Boot; instinct-based learning v2 |

## ECC 2.0 Alpha
Prototype em Rust (`ecc2/`). Comandos: `dashboard`, `start`, `sessions`, `status`, `stop`, `resume`, `daemon`. Usável como alpha, não release geral.

## Como o ECC difere de uma coleção de prompts

A maioria dos "packs" de prompts para Claude é uma lista plana de instruções. ECC é fundamentalmente diferente em três dimensões:

**1. Sistema de aprendizado contínuo com state.** Os instincts do ECC têm confidence scoring: cada vez que uma heurística funciona, a confiança sobe; quando falha, desce. Com `/evolve`, o agente clusteriza instincts similares em skills formais — o conhecimento acumula em vez de resetar a cada sessão.

**2. Instrumentação de segurança first-class.** O AgentShield não é uma feature opcional — é parte do pipeline de release. Os 1.282 testes cobrem vetores que desenvolvedores não pensariam manualmente: hook injection (um hook malicioso que dispara a partir de output de outro agente), MCP risk profiling (quais MCPs têm acesso a filesystem e podem exfiltrar dados), e agent config review (configurações que criam superfícies de ataque implícitas).

**3. Cross-harness por design.** Quando uma skill funciona no Claude Code, ela não fica locked-in. O mesmo SKILL.md funciona no Codex CLI, no Cursor, no Gemini CLI. Isso muda a equação de ROI: cada skill criada multiplica seu valor por N harnesses em vez de ser descartada quando a equipe muda de ferramenta.

## Selective install e footprint de contexto

O problema de harnesses monolíticos é counter-intuitivo: mais capabilities no contexto base significa pior performance em tasks específicas, porque o modelo "vê" ferramentas e padrões irrelevantes que introduzem ruído. A arquitetura `install-plan.js → install-apply.js` do ECC v1.9 resolve isso: cada projeto declara quais agentes e skills instalar no manifesto, mantendo o footprint mínimo.

O SQLite state store complementa isso — habilita auditoria de sessões passadas via SQL direto, correlacionando quais skills foram invocadas com quais resultados de qualidade. Em um harness que evolui, ter esse histórico é o que torna a evolução baseada em dados em vez de intuição.

## Relevância para o vault-michel

O vault-michel usa uma versão informal do que o ECC formaliza: CLAUDE.md como configuração de harness, `04-SYSTEM/agents/` como biblioteca de skills especializados, hooks em `settings.json` como guardrails. A diferença é que o ECC tem instrumentação, métricas e feedback loops explícitos — o vault opera de forma mais manual. Os padrões do ECC (especialmente Continuous Learning v2 e AgentShield) são referências diretas para evolução do sistema Nexus.

## Conexões no Vault
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — SKILL.md é o padrão que ECC amplifica massivamente
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — hooks de sessão são a espinha dorsal do ECC
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — ECC vive em `.claude/` e `~/.claude/`
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — ECC é o harness performance system
- [[03-RESOURCES/concepts/agent-systems/autonomous-learning]] — Continuous Learning v2 via instincts
- [[03-RESOURCES/entities/Claude Code]] — harness primário do ECC
- [[03-RESOURCES/entities/AgentShield]] — security auditor integrado
- [[03-RESOURCES/entities/affaan-m]] — autor principal do ECC
