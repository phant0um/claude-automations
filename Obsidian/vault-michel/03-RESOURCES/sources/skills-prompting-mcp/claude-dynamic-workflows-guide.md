---
title: "Claude Dynamic Workflows: The Ultimate Guide"
type: source
source: "Clippings/Claude Dynamic Workflows (not only) for PMs The Ultimate Guide.md"
author: "@PawelHuryn"
published: 2026-06-08
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, claude-code, dynamic-workflows, orchestration, anthropic]
---

## Tese central

O orchestrator saiu do modelo e entrou no código. Dynamic Workflows é um short JavaScript que Claude escreve on-the-fly para coordenar subagentes — o código de coordenação gasta zero tokens de modelo; só os agentes que raciocinam pagam. Resultado real: 113 agentes, 1.95M tokens, 3 protótipos clicáveis, 12 minutos.

## Argumentos principais

- **Zero tokens no glue:** loops, filtros e roteamento são código determinístico — não existência de modelo na coordenação. Agentes custam tokens; a cola entre eles não.
- **O orchestrator no modelo falha de três formas previsíveis:** laziness (para no item 35 de 50), self-preferential bias (se auto-avalia generosamente), goal drift ("não toque em auth" evapora na virada 80). Mover o plano para o script elimina os três.
- **n8n vs. dynamic workflows:** n8n conecta ferramentas conhecidas; dynamic workflow deixa o agente construir o procedimento para este run específico — nível acima na abstração.
- **Workspace agents vs. embedded agents:** o SDK é para os agentes que você embarca no produto; dynamic workflows são para os agentes que fazem seu trabalho dentro do Claude Code.
- **Trigger:** palavra "ultracode" no prompt, ou pedir explicitamente "use a workflow".

## Key insights

- **Seis padrões que recorrem** (nomes de Thariq Shihipar e Sid Bidasaria, Anthropic):
  1. **Classify-and-act** — um agente decide o tipo, o script roteia. Uso: triagem de bug vs. feature vs. ruído.
  2. **Fan-out-and-synthesize** — um agente por peça, merged em código. Uso: mapa de mercado, competitor teardown.
  3. **Adversarial verification** — agente separado checa o output contra rubrica. Uso: fact-check de PRD contra fontes.
  4. **Generate-and-filter** — muitos candidatos, deduplicados, os sobreviventes ficam. Uso: naming, positioning lines.
  5. **Tournament (compare)** — agentes tentam a tarefa de formas diferentes, juízes comparam até um vencer. Uso: strategy memo sem resposta única correta.
  6. **Loop-until-done** — spawn até stop condition. Uso: auditoria onde não se sabe a priori quanto trabalho há.
- **Regra prática de quando usar subagent vs. workflow:** subagent para uma rodada de julgamento paralelo; workflow quando o output da etapa N decide a etapa N+1.
- **Modelo por estágio:** extração barata → Haiku ou Sonnet; canonicalização/julgamento → Sonnet ou Opus. Custo explícito, não grátis.
- **Score fórmula para oportunidades:** `frequência × importância × (5 − satisfação)` — cálculo em código, sem modelo no loop.

## Exemplos e evidências

**Run real de PawelHuryn (2026-06-08):**
- Keyword: "ultracode". Job: product discovery.
- Claude escreveu um JavaScript, depois o usou para spinnar 113 agentes.
- Leu 100 customer interviews sintéticas em 1.95M tokens.
- 622 oportunidades brutas → clustering → 11 needs canônicos → score → top 3 → 3 protótipos HTML clicáveis.
- Tempo total: 12.5 minutos. Tokens no JS de coordenação: 0.

**Pipeline de 6 estágios (100 entrevistas → 3 protótipos):**
1. Extract — agente barato por entrevista → oportunidades estruturadas + persona + verbatims
2. Canonicalize — um agente clusteriza as oportunidades brutas em conjunto canônico (merging sinônimos = julgamento, então é modelo)
3. Score — código puro (freq × imp × (5 − sat)), zero modelo
4. Generate and triage — agente propõe soluções; juiz separado ranqueia por ROI, guarda top 3
5. Build — agente usa frontend-design skill → protótipo HTML clicável
6. Inspect and rerun — smoke check; qualquer falha relança só o estágio que falhou (loop real)

**Fix de canonicalização:** primeira versão retornou 30+ fragmentos em vez de 11 needs; adicionou uma linha ("cluster synonyms before counting") → Claude reescreveu o harness com clustering agent na frente do scorer. O fix também ficou no código, não no modelo.

## Implicações para o vault

- O padrão **loop-until-done** é aplicável ao pipeline de ingestão batch do vault — não travar no limite de sessão, spawnar até a lista estar vazia.
- **Fan-out-and-synthesize** é o que o vault já usa implicitamente nos 9 agentes paralelos de ingest; nomear o padrão facilita comunicação e reuso.
- **Score de oportunidades** (freq × imp × (5 − sat)) é reutilizável para priorização de backlog de conceitos ou action items do vault.
- O framing "goal drift via contexto longo" é evidência adicional para a política de rotation do hot.md (ceiling 300 linhas, sessions ao final).
- Trigger "ultracode" é o atalho operacional imediato — testar no próximo pipeline de ingestão longo.
- Containment playbook (agentes escrevem arquivos e rodam shell sem parar para perguntar) é risco real: aplicar ao vault (ver [[03-RESOURCES/concepts/agent-security]]).

## Links

- [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]]
- [[03-RESOURCES/concepts/agent-systems/orchestration-mode-pattern]]
- [[03-RESOURCES/concepts/agent-systems/compound-engineering]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/sources/a-harness-for-every-task-dynamic-workflows-in-claude-code]]
- [[03-RESOURCES/sources/claude-dynamic-workflows-ultimate-guide]]
- [[03-RESOURCES/entities/Thariq]]
