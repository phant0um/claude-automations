---
title: Garry Tan
type: entity
category: person
tags: [yc, agent-systems, gbrain, gstack, open-source]
created: 2026-04-17
updated: 2026-05-19
---

# Garry Tan

Partner da Y Combinator. Autor da série "Thin Harness, Fat Skills" e criador dos projetos open-source GBrain, GStack e OpenClaw/Hermes Agent.

## Contribuições para Agent Systems

- Cunhou o conceito de "Thin Harness, Fat Skills"
- Desenvolveu o [[resolver-pattern]] a partir de um CLAUDE.md de 20.000 linhas que foi reduzido para 200
- Criou o meta-skill `check-resolvable` para auditar reachability de skills
- Propôs o conceito de RLM para auto-healing de resolvers

## Projetos

- **GBrain** — sistema de memória pessoal; `gbrain init` cria RESOLVER.md e decision tree; open-source
- **GStack** — 72.000+ stars no GitHub; fat skills em markdown; layer de coding
- **OpenClaw / Hermes Agent** — harness thin que conduz o agent loop; gerencia sessões e crons

## Citas de destaque

> "O problema não é que modelos não são inteligentes o suficiente. O problema é que construímos organizações sem camada de gestão."

### Insight chave sobre Agent Architecture (2026-04-13)

> **EN:** "If your memory dies when your harness dies, you built the harness too thick."
> "Memory is markdown. Skills are markdown. The brain is a git repository. The harness is a thin conductor — it reads the files, it doesn't own them."

> **PT:** "Se sua memória morre quando seu arnês morre, você construiu o arnês grosso demais."
> "A memória é markdown. As habilidades são markdown. O cérebro é um repositório git. O arnês é um condutor fino — ele lê os arquivos, não os possui."

**Impacto:** cristalizou o princípio core do AI Agent Stack do [[03-RESOURCES/entities/Avid-Builder]]. Separação harness ↔ brain → portabilidade total: trocar harness/modelo amanhã, não perder nada.

## Skillify

Prática de conversão de falhas em skills permanentes com testes. Detalhada em [[03-RESOURCES/concepts/claude-code-tooling/skillify]].
- **LangChain critique:** $160M em ferramentas de teste mas sem workflow opinionado; "gym membership without a workout plan"
- **GBrain doctor:** 10-step checklist automatizado; `--fix` auto-repara DRY violations
- Encontrou 6/40 skills "dark" (15% das capacidades inalcançáveis) na primeira auditoria

## GBrain — Atualização Mai/2026

v0.31.2 → v0.32.4 em 72h: 14 PRs, +28.746 linhas. Principais mudanças:
- Sistema de junção de fatos ao system-of-record (memória quente, +5.682 linhas)
- Takes v2 reescrito com aprendizados de 100K takes em produção (+5.306)
- Extração de fatos durante sincronização (memória hot em real-time)
- Resolvers de área funcional para compressão da tabela de roteamento
- 5 novas receitas de embedding

## Complexity Ratchet (Mai/2026)

Conceito cunhado na série "Building with AI" (#7): cada sessão de coding com AI agent adiciona testes + docs + evals ao codebase, criando um chão de qualidade que só sobe. O unlock: AI agents escrevem os últimos 20% de cobertura que humanos sempre evitavam por custo de esforço.

**90% coverage**: baseado em Capers Jones (10k+ projetos) e DO-178C (FAA). A curva de defeitos escapados é não-linear — 70%→90% é uma ordem de magnitude, não 30%.

"Getting to 90% used to be a heroic effort. Now it's a Tuesday."

Ver: [[03-RESOURCES/concepts/ai-strategy-org/complexity-ratchet]]

## Onde aparece no vault

- [[03-RESOURCES/sources/ai-agents-harness/resolvers-routing-table-intelligence]]
- [[03-RESOURCES/sources/ai-agents-harness/ai-agent-stack-2026]] (referenciado)
- [[03-RESOURCES/sources/guides-courses-howtos/how-to-stop-agents-making-same-mistakes-garry-tan]]
- [[03-RESOURCES/sources/post-garrytan-gbrain-update-29k-lines]]
- [[03-RESOURCES/sources/ai-agents-harness/agent-complexity-ratchet-garrytan]] — série Building with AI #7 (2026-05-12)

## GBrain v0.36–v0.38 (Mai/2026) — Principais Updates

- **ZeroEntropy padrão** (`zembed-1` 1280d via Matryoshka + `zerank-2`): 2.2× mais rápido, 2.6× mais barato que OpenAI; vence 11/20 queries head-to-head
- **`gbrain doctor --remediate`**: loop autônomo (sync→extract→embed→consolidate), respeita `--max-usd` cap
- **Temporal trajectory + founder scorecard**: métricas tipadas (`mrr=50000`, `arr=2000000`) em `## Facts` fence, `gbrain eval trajectory` imprime histórico com regressões marcadas
- **43 skills via skillpack**: routing automático via `skills/RESOLVER.md`, 3 fases PROTECTED (synthesize, patterns, consolidate) contra burn de créditos
- **Webhook ingest** (`POST /ingest`): compatível com Zapier/IFTTT/Apple Shortcuts → mobile capture via Shortcuts

**Em produção (2026-05-22):** 146.646 pages, 24.585 pessoas, 5.339 empresas, 66 cron jobs autônomos.

## Fontes da triagem 2026-05-23 (aprovadas, pendentes ingest)

- `Clippings/garrytangbrain...` — README GBrain completo (stack técnico)
- `Clippings/garrytangstack...` — 23 tools setup opinionated (CEO, Designer, Eng Mgr, Release Mgr, Doc Eng, QA)

**Relacionado (novos 2026-05-23):**
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]] — "Thin Harness, Fat Skills"
- [[03-RESOURCES/concepts/agent-systems/agent-memory-layers]] — GBrain como implementação 6 camadas
- [[03-RESOURCES/entities/Hermes-Agent]] — runtime principal do GBrain

## Links externos

- X: @garrytan
- GitHub: garrytan/gbrain, garrytan/gstack, garrytan/openclaw
