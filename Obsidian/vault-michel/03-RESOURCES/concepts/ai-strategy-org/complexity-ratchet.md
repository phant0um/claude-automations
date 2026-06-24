---
title: Complexity Ratchet
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [testing, ai-coding, quality, gbrain, gstack, garry-tan, agent-testing, 90-percent-coverage]
---

# Complexity Ratchet

Mecanismo que torna AI coding sustentável: cada sessão com um agente de código adiciona testes + documentação + evaluation results ao codebase, criando um chão de qualidade que só sobe. "Forward-only motion."

## O Mecanismo

```
Sessão de coding → Testes que encodificam "correto"
                 → Docs que registram raciocínio
                 → Evals que estabelecem thresholds
                 ↓
Próxima sessão carrega os 3 no context window
→ Não pode regredir abaixo do test suite
→ Qualidade só sobe
```

## Por Que 90% de Cobertura

- Capers Jones (10k+ projetos): curva não-linear — 70% → 65-75% DRE; 85-95% → 92-97% DRE
- A queda de defeitos de 70% → 90% é uma **ordem de magnitude**, não 30%
- DO-178C (FAA): exige MC/DC coverage para Level A (>99% DRE) por razão baseada em dados
- **O unlock de 2026**: AI agents escrevem o 14º edge-case test com o mesmo entusiasmo do 1º — o "custo de esforço" que fazia humanos parar em 70-80% não existe para agents

> "Getting to 90% used to be a heroic effort. Now it's a Tuesday." — Garry Tan

## "Everything Harnessable Is Testable"

Test surface além de unit tests:

| Camada | Testável |
|--------|---------|
| OS | Tabelas de migration, cron, processos |
| TTY | Comportamento interativo do agent (TTY harness) |
| Browser | Renderização, formulários |
| API | Schema de resposta JSON |
| Comportamental | Agent seguiu protocolo, perguntou antes de agir |

**Exemplo**: GStack PR #1354 — TTY harness que spawna Claude Code em pseudo-terminal e verifica se o agente faz pergunta interativa antes de encerrar. Não é unit test — é teste de contrato comportamental.

## Sem Ratchet = Projeto Hauntado

Vibecoding sem testes: agente adiciona complexidade mas nada previne regressão → cada mudança quebra algo em v0.5 → dev conclui que AI coding não funciona. O problema não é a AI — é a ausência do ratchet.

## Testes como Memória Institucional

Test suite + docs = conhecimento durável. Substitui o sênior que saiu há 3 anos. Para projeto solo: é a única memória institucional existente.

## Evidência Empírica

Garry Tan: GStack (701K LOC, 46 skills, 665 test files) + GBrain. 14 PRs em 72h, ~29k linhas novas, cada release com mais testes que a anterior. 15 sessões Conductor simultâneas.

## Sources

- [[03-RESOURCES/sources/ai-agents-harness/agent-complexity-ratchet-garrytan]] — post Garry Tan (série #7)

## Related

- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — harness é o que possibilita o ratchet
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — context window carrega tests+docs+evals como input
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — 15 sessões paralelas no caso GStack
- [[03-RESOURCES/entities/Garry-Tan]] — criador do conceito
