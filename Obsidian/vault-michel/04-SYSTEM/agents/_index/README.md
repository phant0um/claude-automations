# Agents — Guia de Navegação

> Estrutura **flat** (achatada 2026-06-20). Agentes vivem na **raiz** de cada `*-system/` ou em `core/` — sem categorias numeradas (`00-core`/`02-domain-experts`/`04-infrastructure`) e sem wrappers `00-SYSTEM-PROMPTS/`.
>
> **Resolver canônico de roteamento = [[04-SYSTEM/AGENTS]].** Este guia diz *onde as coisas ficam*; o roster roteável e os triggers vivem em AGENTS.md.

## Estrutura

```
04-SYSTEM/
├── AGENTS.md              ← resolver/firmware (no diretório pai, não em agents/)
└── agents/
    ├── core/              ← firmware do vault SO (quality gates, segurança, infra)
    ├── _index/            ← navegação: este README, ai-agents-index, moc-*
    ├── memory/            ← memória cross-session por agente
    ├── <11 *-system/>     ← times de domínio (prompts na raiz)
    └── *.md (raiz)        ← docs de referência (agent-patterns, agentic-reasoning, …) + nexus
```

### Infraestrutura

| Pasta | Conteúdo |
|-------|----------|
| `core/` | Firmware: `guard` `hill` `review` `spec` `extend` `verify` `ingest-report` + `audit-agentes-mensal` `cluster-agent` `vault-audit` + `claude-hermes-proxy` (proxy HTTP) |
| `_index/` | `ai-agents-index` (registro mestre) · `moc-agentes` · `moc-skills` · este README |
| `memory/` | 1 arquivo por agente (`nexus`, `hill`, `maestro`, `stratum`, …) + `_template` |

### Times de domínio (`*-system/`, prompts na raiz)

| Time | Foco |
|------|------|
| `nexus-agent-system/` | Orquestração central — Nexus (entry) + Scout/Forge/Shield/Pixel/Herald/Ledger + ingest/triagem/report/reconcile |
| `fullstack-agent-system/` | Engenharia sênior — orchestrator + backend/frontend/infra/data-ai/security/probe/forge |
| `knowledge-system/` | Conhecimento — kore, sigma, farol, pena, bussola, brainstorm |
| `edu-system/` | Educação — mestre, tutor, stack, trilha, sintese, babel, banca |
| `concurso-coach-system/` | Prep fiscal — tutor-mor + simulador + corretor-redacao + 15 coaches por disciplina |
| `finance-system/` | Finanças — nexo, fluxo, valor, macro, quant, cripto, contador, desafiante, … |
| `marketing-system/` | Marca pessoal — signal, frame, folio, lens, vox, anchor, canvas, prism |
| `productivity-system/` | GTD/produtividade — pulso, eixo, norte, eco |
| `travel-system/` | Viagem — caca, rota, rumo, ajuste |
| `tjam-institutional-system/` | Institucional TJAM — assistente-de-chefia, analista-de-dados + 3 assessores (jurídico, PCA, PLS) |
| `hobby-system/` | Hobby — mtg-arena-coach |

Cada `*-system/` pode ter `docs/` (constitution, standards, progress) e `skills/` — **não contam como agentes**.

## Como acionar

- Tudo começa por `@nexus`. O roteamento canônico (trigger → agente) está em [[04-SYSTEM/AGENTS]] §Regras de Roteamento.
- Firmware: `@guard` `@verify` `@review` `@spec [feature]` `@extend [slug]` `@hill [slug]`.
- `claude-hermes-proxy` sobe sozinho em `127.0.0.1:8080` (OpenAI-compat).

## Adicionar agente

1. Criar `.md` (kebab-case) na **raiz** do `*-system/` correto — ou em `core/` se for firmware. Sem subpasta de categoria.
2. Registrar no resolver: [[04-SYSTEM/AGENTS]] (tabela do time + Regras de Roteamento) e em `ai-agents-index`.
3. Validar: skill `check-resolvable` (detecta agente fantasma / dead link / trigger órfão).

## Referências

- [[04-SYSTEM/AGENTS]] — resolver/firmware
- [[04-SYSTEM/agents/_index/ai-agents-index]] — índice mestre
- [[04-SYSTEM/wiki/hot]] — hot cache
- [[03-RESOURCES/wiki-index]] — home do vault

---
**Achatado em 2026-06-20** (era: `00-core` / `00-mocs` / `02-domain-experts` / `04-infrastructure` + 11× `00-SYSTEM-PROMPTS/`). Histórico do flatten: [[04-SYSTEM/wiki/errors]].
