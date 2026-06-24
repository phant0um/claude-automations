---
title: "Agentic Harness Engineering (AHE)"
type: concept
status: developing
created: 2026-05-01
updated: 2026-05-01
tags: [concept, ai-agents, harness-engineering, self-evolution, auto-optimization]
---

# Agentic Harness Engineering (AHE)

**Definição:** Framework de auto-evolução que mantém o modelo base frozen e otimiza os 7 componentes do harness de um coding agent (system prompt, tool descriptions, tool implementations, middleware, skills, sub-agent config, long-term memory) de forma combinatorial, usando observabilidade estruturada e contratos de edição verificáveis.

Publicado: arXiv 2604.25850 (Fudan/Peking/Shanghai Qiji Zhifeng, abr 2026). Ver [[03-RESOURCES/sources/ai-agents-harness/clipping-agentic-harness-engineering-ahe]].

## O Insight Central

> O system prompt sozinho **regride** performance (−2.3pp). Memory, tools e middleware — componentes que equipes nunca tocam — são onde o ganho vive.

Esta é a inversão mais importante em relação à sabedoria convencional de "melhor o prompt".

## Os 7 Componentes do Harness (NexAU)

1. **System prompt** — instruções base (regredi quando único foco de otimização)
2. **Tool descriptions** — como o modelo entende as ferramentas disponíveis
3. **Tool implementations** — código real das ferramentas (maior superfície de fix)
4. **Middleware** — interceptors e guards entre model turns
5. **Skills** — SKILL.md plugáveis para tarefas recorrentes
6. **Sub-agent configuration** — como sub-agentes são instanciados e delegados
7. **Long-term memory** — artefatos persistentes entre sessões (+5.6pp solo)

## Observabilidade em 3 Camadas

```
Component observability  →  arquivos em mount points fixos, 1 componente por tipo
Experience observability →  Agent Debugger: traces → root-cause reports por tarefa
Decision observability   →  change_manifest.json por edição com predições verificáveis
```

## Padrão de Falha → Fix (dos 4 Case Studies)

| Falha | Tipo | Fix |
|-------|------|-----|
| Inventar valores, self-check errado | Prompt | 8 regras genéricas no system prompt |
| `rm -rf` após check correto | Tool impl | publish-state guard (hard block) |
| Proxy posterior + mata MCMC | Middleware | ExecutionRiskHintsMiddleware |
| Override token que wipa estado | Tool impl + hook | Hard block + before_model hook |

**Regra:** prompts dizem o que evitar. Tool-implementation e middleware **forçam** o comportamento.

## Relation com Outros Padrões

| Padrão | Diferença do AHE |
|--------|-----------------|
| [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] (Autogenesis) | Autogenesis evolui protocolos/estratégias; AHE evolui o harness de engenharia |
| [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] | Prompt-only otimização cobre 1/7 componentes (e o menos efetivo) |
| [[03-RESOURCES/concepts/agent-systems/agent-harness]] | agent-harness é o design estático; AHE é a auto-evolução desse design |
| [[03-RESOURCES/concepts/pkm-obsidian/file-as-bus]] | AHE usa exatamente o princípio file-as-bus para coordenação entre iterações |

## Quando Usar

**Beneficia:**
- Agents de coding de longo horizonte com traces e verifier binário
- Times hand-tuning prompts além de um primeiro rascunho
- Pesquisadores de test-time adaptation sem gradient updates

**Não beneficia:**
- Agents de chamadas API curtas sem rollout traces
- Times sem verifier com sinal pass/fail binário
- Frameworks prompt-only (ACE, DSPy) que não abrem os outros componentes

## Status (mai/2026)

Protótipo de pesquisa com receipts sólidos (change manifests + auto-rollback). Faltam: segundo benchmark de evolução (não-Terminal-Bench-2) e solução para regression blindness (precision 11.6%). Substrate [[03-RESOURCES/entities/NexAU]] é a entidade a monitorar para adoção em produção.

## Evidências
- **[2026-06-19]** Harness engineering é a camada "sem glamour" que decide se loop/workflow funcionam — 14 passos práticos cobrindo CLAUDE.md, settings.json, subagentes, skills, hooks, memória — [[03-RESOURCES/sources/ai-agents-harness/agent-harness-engineering-14-step-roadmap]]
- **[2026-06-22]** Cloudflare Agents SDK como camada de runtime/platform que qualquer harness/framework pode plugar (Flue sobre Pi); três camadas: framework → harness → platform. — [[03-RESOURCES/sources/bringing-more-agent-harnesses-to-cloudflare-starting-with-flue]]
