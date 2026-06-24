---
title: "The AI Agent Complexity Ratchet: Why 90% Test Coverage Is Required"
type: source
source_file: Clippings/The AI Agent Complexity Ratchet Why 90% Test Coverage Is Required.md
origin: post no X (série "Building with AI" #7)
author: "@garrytan"
published: 2026-05-12
ingested: 2026-05-14
tags: [test-coverage, complexity-ratchet, agent-testing, gbrain, gstack, ai-coding, quality]
triagem_score: 8
---

# The AI Agent Complexity Ratchet: Why 90% Test Coverage Is Required

> [!key-insight] Core insight
> A "complexity ratchet" é o mecanismo que torna AI coding sustentável: cada sessão com um agente adiciona testes + documentação + evals ao codebase, criando um chão de qualidade que só sobe. O unlock: AI agents escrevem os últimos 20% de testes (onde humanos desistem) sem custo de esforço.

## Sections

### O Mecanismo: Ratchet de Complexidade

Cada sessão de coding com AI agent adiciona ao codebase:
1. **Testes** que encodificam o que "correto" significa
2. **Documentação** que registra o raciocínio por trás de decisões
3. **Resultados de evaluation** que estabelecem thresholds de qualidade

Na próxima sessão, o agente carrega os três no context window — não pode regredir abaixo do test suite. **Movimento em uma única direção.**

### Por Que 90% (Não 70%)

- **Capers Jones** (10k+ projetos): abaixo de 70% cobertura → DRE 65-75%; a 85-95% → DRE 92-97%
- **Curva não-linear**: a queda em defeitos escapados de 70% → 90% é uma ordem de magnitude, não 30%
- **DO-178C** (FAA, software de aviação): MC/DC coverage para Level A → >99% DRE — mandatório porque dados mostram que abaixo de certos thresholds defeitos críticos escapam a taxas incompatíveis com segurança

**O unlock de 2026**: humanos desistiam em 70-80% porque os últimos 20% custavam esforço desproporcional. AI agents não experenciam esforço — escrevem o 14º teste de edge case com o mesmo entusiasmo do 1º.

> "Getting to 90% used to be a heroic effort. Now it's a Tuesday."

### "Vibecoding" Sem Ratchet = Projeto Hauntado

Projetos que pulam testes: sem ratchet → agente adiciona complexidade mas nada previne regressão → por v0.5 cada mudança quebra algo inesperado → dev escreve post "AI coding não funciona". "They just didn't build the ratchet."

### Tudo Harnessável É Testável

O test surface vai além de unit tests:

| Camada | O que testar | Exemplo |
|--------|-------------|---------|
| OS | Tabelas de migration, cron jobs, processos | DB schema correto após migration |
| Terminal/TTY | Comportamento interativo do agent | Agent fez pergunta antes de finalizar? (TTY harness) |
| Browser | Renderização, formulários, navegação | Page rendered, form filled |
| API | Schema de resposta JSON | Model retornou JSON válido |
| Comportamental | Agent seguiu protocolo | Parou quando pedido para parar? |

**Caso real**: GStack PR #1354 — TTY harness que spawna Claude Code em pseudo-terminal e verifica se o agente faz pergunta interativa antes de encerrar. "You can't unit test 'did the AI have a conversation.' No traditional testing framework covers this."

### Testes como Memória Institucional

"// DO NOT CHANGE THIS — ask Dave" (e Dave saiu há 3 anos) é o problema. Tests + docs encoded na test suite = conhecimento durável. Context window do agente não sai da empresa.

### Números do GStack/GBrain

- GStack: 93K GitHub stars, 701K LOC, 46 skills, 665 test files; 15 sessões Conductor simultâneas
- GBrain: v0.31.0-v0.31.2 em dias; each release com mais testes que a anterior
- 14 PRs mergeados em 72h; ~29k linhas novas; cada release melhor testada que a anterior

### "Everything Harnessable Is Testable"

O princípio: se o computador pode observar, pode assertar. Se pode assertar, pode ratchet.

## Conexões

- [[03-RESOURCES/entities/Garry-Tan]] — autor; atualizar com ratchet concept e GBrain v0.31.x
- [[03-RESOURCES/entities/Claude Code]] — principal harness usado
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — harness é o que possibilita o ratchet
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — 15 sessions Conductor simultâneas
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — context window carrega tests+docs+evals
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — GStack tem 46 skills

## Por que o ratchet é um fenômeno de qualidade composta

A metáfora do ratchet captura algo que métricas de cobertura de teste sozinhas não capturam: a irreversibilidade progressiva. Em engenharia de software convencional, test coverage pode subir e descer ao longo do tempo — testes são deletados quando inconvenientes, desativados quando falham por razões obscuras, ou ignorados quando o prazo pressiona. O ratchet do agente é estruturalmente diferente porque o agente *lê* os testes antes de escrever qualquer código na sessão seguinte. Regredir abaixo do test suite seria explicitamente contra as instruções que o agente recebeu.

Isso cria um mecanismo de qualidade que não depende de disciplina humana para ser mantido — o próprio agente é o guardião do threshold. A comparação com DO-178C (aviação) é apropriada: em domínios onde falha tem custo alto, thresholds de qualidade são enforçados por processo externo, não por boa vontade. O ratchet faz o mesmo para software de agente.

## O TTY harness como fronteira do testável

O caso do TTY harness (GStack PR #1354) merece destaque porque representa a fronteira do que pode ser testado automaticamente. Verificar que um agente de IA *fez uma pergunta interativa antes de encerrar* requer um ambiente de teste que capture comportamento conversacional — não apenas inputs e outputs de funções. A observação de Garry Tan de que "nenhum framework de teste tradicional cobre isso" é correta.

O TTY harness que spawna Claude Code em pseudo-terminal e monitora se o agente solicita confirmação humana antes de encerrar é um exemplo de teste comportamental de nível de harness. Esse tipo de teste verifica o protocolo de interação, não o código produzido — e é exatamente o tipo de cobertura que falta em projetos de "vibecoding" sem ratchet. A falha de protocolo (agente encerrando sem perguntar quando deveria) é tão custosa quanto um bug de runtime, mas invisível para suites de teste convencionais.
