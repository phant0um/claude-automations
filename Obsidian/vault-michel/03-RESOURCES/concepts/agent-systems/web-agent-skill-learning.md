---
title: Web Agent Skill Learning
type: concept
status: developing
created: 2026-04-19
updated: 2026-05-19
tags: [web-agents, skill-learning, llm, grounding, reusable-knowledge]
---

# Web Agent Skill Learning

Linha de pesquisa focada em dotar agentes web autônomos de **conhecimento procedimental reutilizável** — eliminando a necessidade de re-planejar sequências de ações recorrentes do zero a cada execução.

## O Problema Central: Grounding Gap

Agentes web baseados em LLMs sofrem de dois extremos:

| Tipo | Vantagem | Problema |
|------|---------|---------|
| **Skills textuais** (ex: AWM) | Guiam o planejamento, legíveis pelo agente | Não executam diretamente; o agente ainda precisa traduzir cada instrução em ações concretas |
| **Skills em código** (ex: SkillWeaver, WALT) | Executáveis diretamente pelo runtime | Black-box — agente não entende o que acontece internamente; não consegue adaptar ou recuperar de falhas |

O **grounding gap** é o espaço entre "o que fazer" e "como executar" — textual skills ficam no primeiro lado, code skills ficam no segundo.

## Solução: Executable Skills (WebXSkill)

[[03-RESOURCES/sources/claude-code-skills/webxskill-skill-learning-autonomous-web-agents|WebXSkill]] propõe **executable skills** que combinam ambos os lados:

```
skill = action_program + step_level_guidance
```

- **Action program:** sequência parametrizada de ações (click, type, navigate) com parâmetros abstratos (ex: `{{query}}`)
- **Step-level guidance:** texto natural descrevendo cada passo — visível ao agente, permite planejamento e adaptação

## Aquisição de Skills

Estratégias de aquisição, com trade-offs:

| Estratégia | Exemplo | Custo | Risco |
|-----------|---------|-------|-------|
| **Autonomous exploration** | SkillWeaver, WALT | Alto (GPU) | Baixo |
| **Test-time trajectories** | ASI, AWM | Zero extra | **Data leakage** (usa dados do test set) |
| **Synthetic trajectories** | WebXSkill | Baixo | Baixo |

WebXSkill usa trajetórias sintéticas (SynthAgent) — cheaper que exploração, sem risco de leakage.

## Organização: Skill Graph

Em vez de flat libraries (problema: ruído alto no retrieval), skills são organizadas num grafo onde:
- **Nós** = URL patterns generalizados (ex: `gitlab/*/*/-/issues/*`)
- **Arestas** = aplicabilidade entre páginas

**Context-aware retrieval:** dado o URL atual, o agente só vê skills relevantes para aquela página. Filtro adicional: presença dos elementos DOM alvo. Resultado: até 20 skills surfaced por página, com alta relevância.

## Deployment: Dual Mode

### Grounded Mode
- Skill exposta como tool callable (`fg_search_product(query="laptop")`)
- Runtime executa a sequência de ações automaticamente
- Mais eficiente; requer modelo forte para recuperar de falhas
- Melhor para: GPT-5, modelos de alto capability

### Guided Mode
- Skill apresentada como instruções step-by-step
- Agente executa com suas próprias ações nativas
- Mais robusto a mudanças de página; preserva autonomia do agente
- Melhor para: modelos menores, ambientes heterogêneos, cross-environment transfer

**Regra prática:** stronger model → grounded; weaker model → guided.

## Benchmarks Principais

- **[[03-RESOURCES/entities/WebArena]]** — 5 sites self-hosted (Shopping, CMS, Reddit, GitLab, Map), 154 tasks controladas
- **[[03-RESOURCES/entities/WebVoyager]]** — sites reais (Amazon, Apple, ArXiv, BBC, Cambridge, GitHub, Google Maps, etc.)

## Métodos no Campo

| Método | Paper | Foco |
|--------|-------|------|
| **AWM** (Agent Workflow Memory) | Wang et al. 2024 | Skills textuais; workflow memory |
| **SkillWeaver** | Zheng et al. 2025 | Python APIs via exploração; auto-melhoria |
| **ASI** | Wang et al. 2025 | Programmatic skills de episódios de sucesso |
| **WALT** | Prabhu et al. 2026 | Reverse-engineering de funcionalidade interna do site |
| **WebXSkill** | Wang et al. 2026 | Executable skills; dual mode; skill graph |
| **[[03-RESOURCES/entities/Autobrowse]]** | Jeong / Browserbase 2026 | Iterative convergence in production; SKILL.md graduation; strategy.md compounding |
| **SkillMigrator** | He et al. 2026 | Cross-domain transfer via Transferable Interaction Patterns (layout-conditioned retrieval, não URL pattern) |

## Autobrowse (Producao vs Academia)

[[03-RESOURCES/entities/Autobrowse]] (Browserbase, 2026) representa uma variante de producao desta linha de pesquisa: em vez de explorar ambientes simulados (WebArena), o agente itera em sites reais com custo real, convergindo para um `SKILL.md` graduado. O custo da primeira run e intencional — e o investimento em todas as runs seguintes. Ver [[03-RESOURCES/concepts/agent-systems/browser-agent-amnesia]] e [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]].

## Conexões no vault

- [[03-RESOURCES/sources/claude-code-skills/webxskill-skill-learning-autonomous-web-agents]] — paper principal
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — analogia no ecossistema Claude (SKILL.md)
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — skills como memória procedimental (episódica → procedimental)
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — skills são building blocks para coordenação
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — skill graph = context-aware retrieval aplicado a ações
- [[03-RESOURCES/entities/WebArena]] — benchmark
- [[03-RESOURCES/entities/SkillWeaver]] — competidor
- [[03-RESOURCES/sources/beyond-domains-reusing-web-skills-via-transferable-interaction-patterns]] — SkillMigrator, retrieval por layout structure (TED) em vez de URL pattern
