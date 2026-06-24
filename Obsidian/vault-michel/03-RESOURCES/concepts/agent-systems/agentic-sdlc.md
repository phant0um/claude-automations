---
title: Agentic SDLC
type: concept
status: developing
created: 2026-05-29
updated: 2026-05-29
tags: [agents, sdlc, engineering, productivity, salesforce, claude-code]
---

# Agentic SDLC

Software Development Lifecycle (SDLC) onde agentes autônomos dirigem a maior parte da execução — escrevendo código, revisando PRs, gerando testes, atualizando documentação, gerenciando deploys — em vez de apenas assistir desenvolvedores humanos. Representa a evolução além do "AI como copiloto" para "AI como motor do SDLC".

## Diferença do "AI-assisted development"

| Aspecto | AI-assisted | Agentic SDLC |
|---|---|---|
| AI escreve código | Sim (sugestões) | Sim (autônomo) |
| AI revisa PRs | Com humano acionando | Agente faz autonomamente |
| AI gera testes | Humano solicita | Agente inclui na entrega |
| Fluxo de trabalho | Humano com AI plugada | Agente orquestra, humano supervisiona |
| Context-switch | Humano entre sistemas | Agente entre subagentes especializados |
| Unit of execution | Scrum team (5-10 pessoas) | Em experimentação: 1-3 pessoas |

## Componentes chave

- **Claude Code skills** — capabilities empacotadas e reutilizáveis que codificam contexto de time, convenções de naming, e padrões de workflow. São o novo artefato de engenharia.
- **Subagents e agent teams** — workstreams paralelas gerenciadas por agentes especializados dentro de uma task maior
- **CLAUDE.md files** — configurações de contexto persistente que orientam Claude ao codebase, convenções e constraints. Qualidade varia muito entre times e tem impacto direto em output.
- **Rule-based frameworks** — markdown files + reference implementations que padronizam migrations e tarefas repetitivas, com PR feedback incorporado de volta ao rule set
- **Agentic loops autônomos** — build → fix → validate sem intervenção manual

## Métricas do caso Salesforce (2026)

| Métrica | Resultado YoY |
|---|---|
| Work items por dev | +50.8% |
| PRs merged por dev | +79% |
| Effective Output Score (ML) | +151.3% |
| Total incidents | -5% (com muito mais PRs) |
| Migração 33 endpoints | 18x mais rápido |

**Insight chave:** qualidade e velocidade não são tradeoff quando guardrails estão embutidos estruturalmente no workflow agêntico.

## Questões abertas

**Junior engineer problem:** Com agentes absorvendo o execution layer, como juniores crescem para seniores quando AI absorve grande parte do trabalho de entrada? Questão sem resposta consolidada em 2026.

**Security model diferente:** Quando agentes podem *agir* em sistemas (não apenas sugerir), o blast radius de um tool misconfigured é maior. Requer modelo de segurança fundamentalmente diferente.

**Decomposição de problemas como nova skill:** A skill de engenharia mais importante hoje não é escrever código, mas saber estruturar problemas para sistemas agênticos, quando delegar vs. ficar no loop, e como construir padrões reutilizáveis.

## Prerequisitos organizacionais

1. Adoção real de AI (não apenas nominal) — Salesforce cruzou 90%+ antes da transformação agêntica
2. Remoção de fricção — token limits, approval gates desnecessários
3. Padronização de tools — todos usando a mesma plataforma agêntica
4. Institucionalização de skills — biblioteca compartilhada de capabilities (não cada time reinventando)
5. Medição de outcome real — não apenas volume de PRs, mas Effective Output

## Evidência empírica do gargalo (MIT/Wharton, 2026)

Estudo com >100k devs do GitHub + telemetria Microsoft confirma quantitativamente o "humano como bottleneck": async agents geram +71.8% de PRs mas 0% de releases autônomos; sync agents geram +741% de LoC e +65% de PRs, mas só +20% de releases. O efeito de atenuação cresce conforme o código se aproxima do release — revisão/merge, não geração, é o limitador real.

## Fontes

- [[03-RESOURCES/sources/ai-agents-harness/salesforce-agentic-shift-engineering]]
- [[03-RESOURCES/sources/why-human-developers-still-bottleneck-ai-coding]]
- [[03-RESOURCES/entities/Salesforce]]
- [[03-RESOURCES/entities/Claude Code]]

## Evidências
- **[2026-06-19]** O harness de Claude Code tunado ao longo de meses não é ciência de garagem que precede o trabalho real — é a superfície de controle do trabalho real, incluindo automação de GTM (não só código) — [[gtm-engineering-chapter-two]]
