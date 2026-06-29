---
title: AGENTS
type: global-variable
updated: 2026-06-28
version: 1.7
---

# AGENTS.md — Global Variable do Vault

> Leia este arquivo antes de qualquer tarefa. É o firmware do vault.
> Atualizar semanalmente via `[[04-SYSTEM/agents/core/hill]]`.

> *"The fix is not a better model. It's a better setup."* — @0xCodez

---

## Identidade do Vault

**Dono:** Michel Csasznik  
**Propósito:** Second brain + SO pessoal — estudo (ADS @ FIAP, concurso público), pesquisa em AI agents, produtividade composta.  
**Princípio:** O vault melhora a cada ciclo. Drift é dívida.

---

## Princípios Comportamentais (aidd)

- **Anti-sycophancy:** nunca abrir com "você está certo". Não ceder sob pressão
  sem evidência. Desafiar raciocínio fraco, não validar. Em dúvida: "não sei" ou perguntar.
- **Dedupe antes de adicionar:** antes de criar regra/finding/instrução, checar se
  já existe ou contradiz uma. Se sim → merge na mais forte ou deletar, nunca criar
  paralela. (Guardrail obrigatório do `hill`/auto-evolução — previne bloat.)
- **Nomear por intenção, não mecanismo:** descrever objetivo/responsabilidade,
  não a ferramenta ou formato de arquivo.

---

## Sistema Operacional

```
Nexus (orquestrador)
├── Projetos fullstack → Scout · Forge · Shield · Pixel · Herald · Ledger
└── Vault / Sistema    → spec · hill · review · extend · verify · guard · ingest-report
```

---

## Inventário de Agentes

> **Fonte canônica de roteamento (V.1 — "AGENTS.md é o resolver").** `04-SYSTEM/wiki/agent-registry.md` e `_index/ai-agents-index.md` são mirrors históricos (deprecados como fonte). Roster = **94 agentes roteáveis, verificado 2026-06-21 via `check-resolvable`** (protocolo completo: scan filesystem filtrado + diff vs tabelas abaixo) — 94/94 disco↔resolver em todos os 12 sistemas, 0 agentes fantasma, 0 dead links, 0 sistemas sem roteamento. Skills: 36/36 idem (ver §Skills Disponíveis).

### Camada Vault SO — `04-SYSTEM/agents/core/`

| Agente | Modelo | Trigger | Função |
|--------|--------|---------|--------|
| `guard` | Opus | `@guard [alvo]` | Auditoria segurança (OWASP LLM Top 10) |
| `hill` | Haiku→Sonnet | `@hill [slug]` | Hill-climbing: melhoria contínua de agente |
| `review` | Haiku | `@review` | Drift review: docs vs comportamento real |
| `spec` | Sonnet | `@spec [feature]` | Spec-Driven Development (PRD→tasks) |
| `extend` | Sonnet | `@extend [slug]` | Extensão cirúrgica de agente existente |
| `verify` | Sonnet | `@verify [output]` | Quality gate independente |
| `ingest-report` | Sonnet | `@ingest-report` | Relatório semanal de artigos (Clippings/) |

### Edu System — `04-SYSTEM/agents/edu-system/`

| Agente | Modelo | Trigger | Função |
|--------|--------|---------|--------|
| `mestre` | Sonnet | `@mestre` | Orquestrador educacional — roteia para tutor/stack/trilha |
| `tutor` | Sonnet | `@tutor [tema]` | Ensino adaptativo com calibração de nível |
| `stack` | Sonnet | `@stack [carreira]` | Roadmap técnico por carreira |
| `trilha` | Sonnet | `@trilha [fase]` | Gestão de trilha de aprendizado |
| `sintese` | Sonnet | `@sintese [conteúdo]` | Síntese de material educacional |
| `babel` | Sonnet | `@babel [idioma]` | Aprendizado de idiomas |
| `banca` | Sonnet | `@banca [prova]` | Análise de padrão de banca examinadora |

→ README: `[[04-SYSTEM/agents/edu-system/README]]`

### Finance System — `04-SYSTEM/agents/finance-system/`

| Agente | Modelo | Trigger | Função |
|--------|--------|---------|--------|
| `nexo` | Sonnet 4.6 | `@nexo-fin` | Orquestrador financeiro — roteia para especialistas |
| `fluxo` | Sonnet 4.6 | `@fluxo` | Renda passiva: ETFs, FIIs, dividendos |
| `valor` | Opus 4.8 / Sonnet 4.6 | `@valor [ticker]` | Análise fundamentalista (Opus para DCF/tese complexa) |
| `macro` | Sonnet 4.6 | `@macro` | Cenário macroeconômico — layer 0, classifica regime |
| `quant` | Opus 4.8 / Sonnet 4.6 | `@quant` | Análise quantitativa (Opus para otimização de portfólio) |
| `cripto` | Sonnet 4.6 | `@cripto` | Mercado cripto e DeFi |
| `contador` | Sonnet 4.6 | `@irpf` | IRPF, ganho de capital, DARF, tributação cross-asset |
| `desafiante` | Opus 4.8 | `@desafiante` | Adversarial checker — ataca premissas de qualquer análise |
| `analista-de-investimentos-br-eua` | Sonnet | — | Análise fundamentalista BR+EUA (legado, precursor de `valor`) |
| `fatura` | Sonnet 4.6 | `@fatura` | Análise de fatura de cartão de crédito |

→ README: `[[04-SYSTEM/agents/finance-system/README]]`

### Marketing System — `04-SYSTEM/agents/marketing-system/`

| Agente | Modelo | Trigger | Função |
|--------|--------|---------|--------|
| `signal` | Sonnet | `@signal` | Orquestrador de marketing — roteia demandas |
| `frame` | Sonnet | `@frame` | YouTube: roteiro, SEO, thumbnail brief |
| `folio` | Sonnet | `@folio` | Documentos HTML standalone (on-demand) |
| `lens` | Sonnet | `@lens` | Prompts DALL-E 3 para marca pessoal |
| `vox` | Sonnet | `@vox` | Copywriting e voz de marca |
| `anchor` | Sonnet | `@anchor` | Estratégia de conteúdo e pilares |
| `canvas` | Sonnet | `@canvas` | Design visual e layout |
| `prism` | Sonnet | `@prism` | Análise de performance de conteúdo |

→ README: `[[04-SYSTEM/agents/marketing-system/README]]`

### Knowledge System — `04-SYSTEM/agents/knowledge-system/`

| Agente | Modelo | Trigger | Função |
|--------|--------|---------|--------|
| `kore` | Sonnet | `@kore` | Orquestrador de conhecimento |
| `sigma` | Sonnet | `@sigma` | Curadoria e síntese de fontes |
| `farol` | Sonnet | `@farol [tema]` | Research & síntese: pesquisa, ensino, simplificação com confiança |
| `pena` | Sonnet | `@pena` | Escrita e refinamento |
| `bussola` | Sonnet | `@bussola` | Orientação de pesquisa |
| `brainstorm` | Sonnet | `@brainstorm` | Ideação divergente / geração de ideias |

→ README: `[[04-SYSTEM/agents/knowledge-system/README]]`

### Productivity System — `04-SYSTEM/agents/productivity-system/`

| Agente | Modelo | Trigger | Função |
|--------|--------|---------|--------|
| `pulso` | Sonnet | `@pulso` | Orquestrador de produtividade |
| `eixo` | Sonnet | `@eixo` | GTD: captura, clarificação, next actions |
| `norte` | Sonnet | `@norte` | Metas, OKRs, planejamento horizonte |
| `eco` | Sonnet | `@eco` | Reflexão, journaling, análise de padrões |

→ README: `[[04-SYSTEM/agents/productivity-system/README]]`

### Travel System — `04-SYSTEM/agents/travel-system/`

| Agente | Modelo | Trigger | Função |
|--------|--------|---------|--------|
| `caca` | Sonnet | `@caca` | Busca de ofertas e oportunidades |
| `rota` | Sonnet | `@rota` | Planejamento de roteiro |
| `rumo` | Sonnet | `@rumo` | Logística e orçamento de viagem |
| `ajuste` | Sonnet | `@ajuste` | Refinamento de itinerário |

→ README: `[[04-SYSTEM/agents/travel-system/README]]`

### Nexus Agent System — `04-SYSTEM/agents/nexus-agent-system/`

| Agente | Modelo | Função |
|--------|--------|--------|
| `nexus` | Sonnet | Orquestrador — ponto de entrada de toda sessão |
| `scout` | Haiku | Pesquisa e descoberta |
| `forge` | Sonnet | Implementação e código |
| `shield` | Opus | Validação, segurança, arquitetura crítica |
| `pixel` | Sonnet | UI/UX e apresentação visual |
| `herald` | Haiku | Comunicação e síntese |
| `ledger` | Haiku | Memória e auditoria |
| `ingest-agent` | Sonnet | Construção do vault — ingest de fontes |
| `triagem-agent` | Haiku | Triagem/scoring de candidatos a ingest |
| `report-agent` | Sonnet | Geração de relatórios do vault |
| `model-router` | — | Roteamento de modelo (Ollama local/cloud por tarefa) |
| `vault-reconcile` | nemotron-3-ultra:cloud | Reconciliação 08-ARCHIVE vs fontes |

### TJAM Institutional System — `04-SYSTEM/agents/tjam-institutional-system/`

| Agente | Função |
|--------|--------|
| `assistente-de-chefia` | Suporte à chefia — despachos, comunicações internas |
| `analista-de-dados` | Análise de dados institucionais, Google Sheets ETL |
| `assessor-juridico-administrativo` | Direito administrativo, minutas, pareceres |
| `assessor-pca` | Plano de Contratações Anuais, normativas |
| `assessor-pls` | Plano de Logística Sustentável, CNJ 400/2021 |

### Concurso Coach System — `04-SYSTEM/agents/concurso-coach-system/`

18 agentes especializados para preparação fiscal (Receita Federal / SEFAZ estaduais / ISS municipais). Bancas: **CESPE/CEBRASPE, FGV, FCC**.

**Orquestradores:**

| Agente | Modelo | Trigger | Função |
|--------|--------|---------|--------|
| `tutor-mor` | Sonnet | `@tutor-mor` | Orquestrador — plano de estudos, ciclo, roteamento |
| `simulador` | Sonnet | `@simulador` | Gera simulados, corrige, diagnóstico de pontos fracos |
| `corretor-redacao` | Sonnet | `@corretor-redacao` | Espelho de correção banca + nota + diagnóstico |

**Coaches por disciplina:**

| Agente | Disciplina |
|--------|------------|
| `coach-portugues` | Gramática, interpretação, ortografia, sintaxe |
| `coach-ingles` | Leitura, vocabulário fiscal EN |
| `coach-logica` | RLM, lógica proposicional, matemática financeira |
| `coach-estatistica` | Descritiva, inferencial, probabilidade, amostragem |
| `coach-redacao` | Dissertativa, argumentação, repertório fiscal |
| `coach-direito` | Direito constitucional + administrativo |
| `coach-tributario` | CTN + tributos federais (IR/IPI/contribuições) |
| `coach-legislacao-estadual-municipal` | ICMS/ISS/IPVA/ITBI/IPTU |
| `coach-previdenciario` | RGPS/RPPS, benefícios, custeio, EC 103/2019 |
| `coach-aduaneiro` | Regulamento Aduaneiro, II/IE, regimes, NCM |
| `coach-contabilidade` | Geral (CPC) + pública (MCASP/Lei 4.320/LRF) |
| `coach-auditoria` | NBC TA, COSO, controles internos, governamental |
| `coach-economia-financas-publicas` | Micro/macro, finanças públicas, orçamento |
| `coach-administracao` | Adm geral (teorias/BSC) + adm pública (NGP/PDRAE) |
| `coach-informatica-dados` | HW/SO/redes/segurança + SQL/BI/fluência de dados |

→ README completo: `[[04-SYSTEM/agents/concurso-coach-system/README]]`

---

## Padrões de Orquestração

### Sub-agents vs. Multi-agents

**Sub-agents = compressão, não paralelismo.** Dado empírico: sub-agents vencem multi-agents em **7/10 casos de produção**.

| Usar sub-agent quando | Usar multi-agent quando |
|-----------------------|------------------------|
| Contexto principal precisa ser comprimido (8K → 200 tokens) | Tarefa exige escrita paralela genuína |
| Isolamento de falha crítico | Coordenação cross-task com estado compartilhado (Kanban) |
| Tarefa de leitura/análise paralela | Orquestração tipo pipeline com dependências complexas |

**Regra prática:** dúvida → use sub-agent. Multi-agent só quando coordenação cross-session é incontornável.

→ [[03-RESOURCES/concepts/agent-systems/subagent-pattern-empirical]] | [[03-RESOURCES/sources/ai-agents-harness/sub-agents-vs-multi-agents-full-guide]]

---

## Regras de Roteamento

| Situação | Agente |
|----------|--------|
| Nova feature ou agente | `spec` → `forge` → `verify` |
| Agente com comportamento degradado | `hill` |
| Mudança em agente existente | `extend` |
| Pré-deploy ou mudança crítica | `guard` + `shield` |
| Drift entre docs e código | `review` |
| Pesquisa/descoberta | `scout` |
| Síntese semanal de artigos | `ingest-report` |
| Tudo começa por | `nexus` |
| Demanda institucional TJAM | agente TJAM específico por função |
| Prep concurso fiscal (plano/ciclo) | `@tutor-mor` |
| Dúvida pontual de disciplina concurso | `@coach-[disciplina]` direto |
| Simulado/questões de prova | `@simulador` |
| Correção de redação concurso | `@corretor-redacao` |
| Investimento / renda passiva / ETF / FII | `@fluxo` ou `@nexo-fin` |
| Análise de empresa individual | `@valor` |
| Roteiro YouTube / SEO / thumbnail | `@frame` |
| Documento HTML (one-pager, newsletter) | `@folio` |
| Prompt DALL-E / imagem de marca | `@lens` |
| GTD / captura / next actions / weekly review | `@eixo` |
| Metas / OKRs / planejamento | `@norte` |
| Reflexão / journaling / padrões | `@eco` |
| Aprendizado / ensino adaptativo | `@tutor` ou `@mestre` |
| Viagem / roteiro / ofertas | `@caca` ou `@rota` |
| Conhecimento / curadoria / síntese de fontes | `@kore` ou `@farol` |
| MTG Arena / deck / coach Magic | `@mtg-arena-coach` |
| Decisão de alto risco / pre-mortem | `pre-mortem` skill |

---

## Memória Cross-Session — `04-SYSTEM/agents/memory/`

Cada agente tem arquivo de memória persistente. Padrão: [[03-RESOURCES/sources/ai-agents-harness/clipping-mem0-agent-self-provision]].

| Arquivo | Agente | Conteúdo |
|---------|--------|----------|
| `memory/nexus-memory.md` | Nexus | Decisões arquiteturais, padrões, falhas, contexto ativo |
| `memory/hill-memory.md` | Hill | Estado de sweeps e melhorias contínuas |
| `memory/maestro.md` | Orchestrator (fullstack) | Codenome `Maestro` — ver `[[04-SYSTEM/agents/fullstack-agent-system/README]]` |
| `memory/stratum.md` | Backend-Dev (fullstack) | Codenome `Stratum` |
| `memory/facet.md` | Frontend-Dev (fullstack) | Codenome `Facet` |
| `memory/bastion.md` | Infra-Cloud (fullstack) | Codenome `Bastion` |
| `memory/neuron.md` | Data-AI (fullstack) | Codenome `Neuron` |
| `memory/sentinel.md` | Security (fullstack) | Codenome `Sentinel` |
| `memory/_template.md` | todos | Template para novo agente |

> **Nota codename:** os 6 arquivos do fullstack-agent-system usam o codenome interno do README (`Maestro`/`Stratum`/`Facet`/`Bastion`/`Neuron`/`Sentinel`), não o slug do arquivo do agente (`orchestrator`/`backend-dev`/...). Não são órfãos — verificado contra `[[04-SYSTEM/agents/fullstack-agent-system/README]]` 2026-06-21.

**Protocolo:**
- Ao iniciar sessão complexa: leia `memory/[agente].md` se relevante
- Ao encerrar com decisão notável: append à seção correta
- Tipos: `DECISION` · `PATTERN` · `CONSTRAINT` · `FAILURE` · `PREFERENCE`

---

## Skills Disponíveis — `04-SYSTEM/skills/`

| Skill | Uso |
|-------|-----|
| `complexity-ratchet` | Por que 90% test coverage é obrigatório em agentes |
| `diagnose` | Loop debugging disciplinado: reproduce→minimise→hypothesise→instrument→fix→regression |
| `drift-review` | Auditoria de drift entre docs e implementação |
| `grill-me` | Desafio pré-implementação: perguntas duras para expor pressupostos falsos |
| `heavy-think` | Raciocínio paralelo + deliberação sequencial |
| `hill-climb` | Loop de eval→diagnóstico→fix→iterate |
| `meta-meta-prompt` | Transformar qualquer texto em skill reutilizável |
| `ralph-loop` | Loop autônomo multi-sessão (longa duração) |
| `spec-lifecycle` | Ciclo completo PRD→spec→tasks→verify |
| `subagent-team` | Orquestração de equipe de sub-agentes |
| `pre-mortem` | Análise de risco: "plano já falhou — como morreu?" (Gary Klein) |
| `pre-ingest-dedup` | Dedup de fontes antes do ingest |
| `check-resolvable` | Auditoria: agentes/skills registrados vs existentes |
| `ingest-verify` | Quality gate pós-ingest: frontmatter, wikilinks, tese central, manifest, seções |
| `12-factor-check` | Checklist 12-factor: confiabilidade de agentes em produção |
| `governance-audit` | Auditoria de governança: intent-boundary, policy, audit-layer |
| `score-drift` | Monitora drift quantitativo de score de agentes |
| `spec-verify` | Quality gate pré-implementação: acceptance criteria vs spec |
| `code-optimize` | Refactor 5E + deep modules (Ousterhout) |
| `codex-retrospective` | Retrospectiva de sessão: self-improvement de comportamento |
| `meta-learn` | Aprende com correções: princípios e feedback |
| `evolve` | Auto-evolução de agente/skill |
| `decisions` | Registro de decisões arquiteturais (ADR / audit-trail) |
| `connection-finder` | Encontra conexões cross-link entre notas (compounding) |
| `contradiction-sweep` | Varre contradições entre notas e reconcilia |
| `daily-brief` | Brief diário de contexto |
| `triagem-scoring` | Scoring determinístico de candidatos a ingest (0 AI calls) |
| `managed-agents-quickref` | Cheat-sheet de managed-agents (Claude API) |
| `fat-skill-thin-harness` | Arquitetura: skill gorda, harness fino |
| `modelo-mental-von-neumann` | Modelo mental von Neumann p/ arquitetura de agentes |
| `adversarial-gate` | Quality gate adversarial in-flight (planos/subagentes) |
| `adversarial-gate-v2` | Quality gate adversarial pós-batch (pipeline ingest >20 files) |
| `tdd` | Test-driven development: vertical slices, tracer bullets, red-green-refactor |
| `implement` | Implementar PRD/issues com TDD, typecheck, review, commit |
| `prototype` | Protótipo throwaway: TUI para lógica, variant switcher para UI |
| `resolving-merge-conflicts` | Resolver conflitos git merge/rebase preservando ambas intents |
| `to-issues` | Quebrar PRD em issues vertical-slice (tracer bullets) |
| `triage` | State machine para triage de issues/PRs: categorize, verify, brief |
| `brief` | Compressão de contexto p/ delegação (Nexus→subagente) |
| `council` | Decisão multi-perspectiva: peer-review deliberativo |
| `debate` | Deliberação two-perspective p/ decisões de arquitetura |
| `probe` | Teste comportamental adversarial de agentes |
| `trace` | Debug de root-cause de comportamento de agente |
| `writing/fragments` | Explore: minera fragmentos crus, sem estrutura (caça leading word) |
| `writing/shape` | Exploit: molda pile em artigo parágrafo-a-parágrafo (grounding) |
| `writing/beats` | Exploit: jornada de beats choose-your-own-adventure (grounding) |
| `lint-wiki` | Checagem manual de órfãos/links quebrados (até adotar iwe — ver tooling-iwe.md) |
| `security/*` | Skills cyber (IoC/phishing/forense) p/ shield/guard/sentinel/probe — import seletivo de Cybersecurity-Skills |
| `diagram/archify` | Diagramas de arquitetura export PNG/SVG (Explainer/pixel) — alt ao mermaid cru |
| `cite-or-flag` | core | anti-fabricação cross-system (concurso/edu/finance/tjam) |
| `repo-radar` | core | /repo-radar — triagem de repo novo (semanal) |
| `tooling-eval` | core | nota tooling-eval ao avaliar ferramenta externa |
| `prd-grade` | core | /prd-grade — nota PRD antes de orchestrator |
| `office-hours` | reasoning | /office-hours — interroga ideia de produto |
| `evaporation-reconcile` | core | detecta evaporação conceitual temporal (concept stale >30d) |
| `design-cluster` | skills | UI/UX patterns de referência (pixel/canvas) |

---

## Catálogo Completo

Ver `[[04-SYSTEM/agents/_index/ai-agents-index]]` para todos os agentes categorizados com wikilinks.

---

## Fullstack Agent System — `04-SYSTEM/agents/fullstack-agent-system/`

| Agente | Modelo | Função |
|--------|--------|--------|
| `orchestrator` | Opus | Orquestrador do sistema fullstack |
| `frontend-dev` | Sonnet | Frontend — React, UI, acessibilidade |
| `backend-dev` | Sonnet | Backend — APIs, DB, lógica de negócio |
| `infra-cloud` | Sonnet | Infra, cloud, CI/CD, containers |
| `data-ai` | Opus | Dados, ML, pipelines de IA |
| `security` | Opus | Segurança de aplicação |
| `probe` | Sonnet | Security scanning |
| `forge` | Sonnet | Implementação + refactor (5E rubric) |

## Hobby System — `04-SYSTEM/agents/hobby-system/`

| Agente | Modelo | Função |
|--------|--------|--------|
| `mtg-arena-coach` | Sonnet | Coach Magic: The Gathering Arena |

## Infraestrutura — `04-SYSTEM/agents/core/`

| Agente | Modelo | Trigger | Função |
|--------|--------|---------|--------|
| `claude-hermes-proxy` | — | — | HTTP proxy OpenAI-compat p/ Claude Code · 127.0.0.1:8080 |
| `vault-audit` | Haiku | — | Auditoria estrutural do vault (saúde, links, staleness) |
| `audit-agentes-mensal` | Haiku | `@scheduled agent-audit-monthly` | Auditoria mensal agendada de agentes |
| `cluster-agent` | Haiku | `@cluster-agent [report]` | Detecta clusters temáticos + sugere páginas-conceito |

---

## Atualização

Atualizar este arquivo toda sexta-feira via `@hill` ou após qualquer mudança no inventário de agentes.

---

### Regras universais (todo agente herda)
- **What & Why:** toda saída relevante diz o quê + por quê (1 frase de raciocínio). Sem caixa-preta.
- **No-fabrication (cite-or-flag):** fato verificável SEM fonte → marcar `[não-verificado]`.
  Nunca inventar número, lei, norma, citação, data. Na dúvida, flag. Ver skill `cite-or-flag`.
