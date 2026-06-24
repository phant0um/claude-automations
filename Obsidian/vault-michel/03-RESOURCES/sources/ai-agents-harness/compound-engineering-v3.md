---
title: "Compound Engineering v3 — Release Notes"
type: source
created: 2026-04-24
updated: 2026-04-24
tags: [compound-engineering, claude-code, ai-agents, plugin, harness]
triagem_score: 8
author: Trevin Chow (@trevin)
url: https://github.com/everyinc/compound-engineering-plugin
---

# Compound Engineering v3

**Autor:** Trevin Chow ([@trevin](https://x.com/trevin))
**Repo:** [everyinc/compound-engineering-plugin](https://github.com/everyinc/compound-engineering-plugin)

Compound Engineering (CE) é um plugin/framework de skills e agentes para harnesses de AI coding (Claude Code, Codex, Pi, Copilot). A v3.0.0 é uma atualização de breaking change focada em 4 eixos: namespace, rastreabilidade de requisitos, suporte cross-harness e review por finding.

---

## 1. Namespace unificado (breaking change)

Todos os skills e agentes movidos para prefixo `ce-`:

| Antes | Depois |
|-------|--------|
| `ce:work` | `ce-work` |
| `git-commit` | `ce-commit` |
| `setup` | `ce-setup` |
| `ce-review` | `ce-code-review` |
| `ce-document-review` | `ce-doc-review` |

Motivação: colisão com skills de outros plugins; sanitização de filesystem no Windows (colon proibido).

---

## 2. Paper trail de requisitos (brainstorm → commit)

`ce-brainstorm` e `ce-plan` agora produzem documentos estruturados com IDs estáveis:

- **ce-brainstorm:** seções para Actors, Key Flows, Acceptance Examples, Requirements (cada um com ID)
- **ce-plan:** Requirements Trace section + IDs de unidade de implementação que sobrevivem a deepening e reordenação
- **ce-work:** reconhece unit IDs em blockers, verification e task labels

**Payoff duplo:** rastreabilidade humana (failing test → acceptance example → brainstorm entry) + rastreabilidade dos agentes (reviewer verifica se implementação satisfaz acceptance example; debugger vê qual flow o test cobria).

Suporte melhorado para **greenfield product-tier brainstorms** — o template anterior era otimizado para mudanças incrementais.

---

## 3. Cross-harness de primeira classe

| Harness | Mudança |
|---------|---------|
| **Codex** | Install nativo via marketplace + `/plugins` TUI. Converter TOML escreve CE agents em `~/.codex/agents/` |
| **Pi** | Delegação para comunidade: `pi-subagents` (@nicopreme) para paralelismo real + `pi-ask-user` (@edlzsh) para blocking questions |
| **Copilot** | Suporte nativo no CLI e VSCode |

Fixes cross-harness:
- `question-tool` parava de fazer perguntas blocking no Codex (request_user_input só em Plan mode) e no Claude Code (tool deferred, schema não carregado no start) — corrigido via instrução unificada em 37 SKILL.md files
- Skill descriptions agora capped no limite do harness com frontmatter test

---

## 4. Reviews que forçam decisão (não rubber-stamp)

Antes: perguntas em nível de bucket → um approve cobre N findings → rubber-stamping.

Depois: engajamento per-finding:

- **ce-code-review:** modo interativo one-finding-at-a-time com Apply/Defer/Skip/"LFG the rest"; defer agora rota para issue tracker real (não todo store interno deprecated)
- **ce-doc-review:** three-tier autofix classification + premise-dependency chain grouping — de 14+ findings/run para 4-6 decisões reais
- **ce-resolve-pr-feedback:** clustering mais restrito (cross-round evidence obrigatória antes de ativar holistic refactors); bot-wrapper noise filtrado
- **ce-swift-ios-reviewer:** novo persona para Swift/iOS — SwiftUI state-wrapper misuse, Combine retain cycles, Core Data context threading (contrib: @jcjvm)

---

## 5. Debug melhorado

**ce-debug** v3:
- Environment sanity check antes de tracing (branch, deps, runtime, env vars, stale artifacts)
- Assumption audit no momento de hipótese
- Parallel read-only subagent dispatch para broad searches
- Nova técnica de referência: boundary instrumentation, test-order pollution, repro minimization, stepping vs instrumentation, heisenbugs, bug-class checklist (timezone, encoding, float, overflow, cache, auth)

---

## 6. QoL e correções

- **ce-proof:** aceita pedidos diretos do usuário ("Share this to Proof so we can iterate") sem precisar de upstream caller
- **ce-demo-reel:** local save como alternativa ao catbox upload (contrib: Lucas Henn)
- **ce-setup:** verifica ast-grep e o agent skill correspondente; nova seção Skills no health-check
- **ce-plan:** não mais misclassifica pesquisa não-software; funciona para problemas pessoais (plano de aula, roadtrip, home improvement)
- **ce-work:** parou de inventar estimativas de tempo humano e breakdowns multi-day
- **ce-update:** deriva cache directory do plugin root parent com shape check — evita `rm -rf` destrutivo em caso de env value malformado (contrib: @andrewlook)
- **ce-compound:** YAML frontmatter sobrevive a strict parsers e Cowork plugin validator

---

## Conexões no vault

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — CE usa SKILL.md como estrutura base
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — CE implementa o padrão cross-harness
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — ce-brainstorm/plan/work é análogo ao EPCC workflow
- [[03-RESOURCES/entities/Compound-Engineering]] — página de entidade do projeto
- [[03-RESOURCES/entities/Trevin-Chow]] — autor

## Por que o paper trail de requisitos é a mudança mais substancial da v3

A capacidade de rastrear de um teste falhando até o acceptance example no brainstorm até o requisito original é o que diferencia código produzido por AI de código produzido por AI com qualidade de engenharia. Sem IDs estáveis de requisitos, cada mudança de código é um evento isolado sem proveniência. Com IDs estáveis que sobrevivem a deepening e reordenação, é possível responder "por que esse código existe?" percorrendo a cadeia: código → unit de implementação → acceptance example → brainstorm entry.

Isso resolve um problema latente em workflows de AI coding: o agente pode implementar algo que atende ao teste mas não à intenção original. O ce-review que verifica contra acceptance examples (não apenas padrões do repositório) detecta exatamente esse tipo de drift. Um test que passa mas não satisfaz o acceptance example é um falso positivo de qualidade.

## A solução cross-harness do question-tool é um exemplo de complexidade acidental

O fato de que o `question-tool` precisou de instrução unificada em 37 SKILL.md files para funcionar corretamente em Codex (request_user_input só em Plan mode) e Claude Code (tool deferred, schema não carregado no start) ilustra como diferenças de implementação entre harnesses criam superfície de manutenção. Cada harness tem seu modelo de interação com o usuário, e skills que precisam de input humano bloqueante precisam ser implementadas diferentemente em cada um.

A solução de CE (instrução unificada nos 37 arquivos, com lógica condicional baseada no harness detectado) é pragmática mas aumenta o tamanho de cada skill. Uma alternativa mais limpa seria um abstraction layer de harness-agnostic user interaction — mas isso requer coordenação entre os desenvolvedores dos harnesses, não apenas dos skills.

## ce-debug como referência de metodologia de debugging com AI

A v3 do ce-debug codifica uma metodologia de debugging que vai além de "peça ao AI para encontrar o bug". O environment sanity check antes de qualquer tracing evita a classe de bugs onde o problema é no ambiente (variáveis de env erradas, artefatos stale, branch errado) mas o esforço de debugging é direcionado para o código. O assumption audit no momento de hipótese força articulação explícita antes de investigar — evitando o viés de confirmação de ir atrás de evidência para uma hipótese não-articulada. O checklist de classes de bug (timezone, encoding, float, overflow, cache, auth) garante que bugs comuns mas pouco óbvios são considerados sistematicamente.
